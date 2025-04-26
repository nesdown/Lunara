import Foundation
import Speech
import SwiftUI
import AVFoundation

class SpeechRecognizer: ObservableObject {
    static let shared = SpeechRecognizer()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var errorMessage: String?
    @Published var recordingState: RecordingState = .idle
    
    // Visual feedback states
    enum RecordingState {
        case idle
        case listening
        case processing
        case success
        case error
    }
    
    var onTranscriptionUpdate: ((String) -> Void)?
    var onTranscriptionComplete: ((String) -> Void)?
    
    private var stopCompletion: (() -> Void)?
    
    private init() {
        // Initialize the speech recognizer
        print("SpeechRecognizer initialized with locale: \(Locale(identifier: "en-US").identifier)")
    }
    
    private func checkPermissions(completion: @escaping (Bool) -> Void) {
        // Check speech recognition permission
        SFSpeechRecognizer.requestAuthorization { status in
            let speechAuthorized = status == .authorized
            print("Speech recognition authorization status: \(status.rawValue)")
            
            // Check microphone permission
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { micAuthorized in
                    DispatchQueue.main.async {
                        print("Microphone permission: \(micAuthorized)")
                        
                        // Both permissions are needed
                        if !speechAuthorized {
                            self.errorMessage = "Please allow speech recognition in Settings to use voice input."
                            self.recordingState = .error
                        } else if !micAuthorized {
                            self.errorMessage = "Please allow microphone access in Settings to use voice input."
                            self.recordingState = .error
                        }
                        
                        // Return result
                        completion(speechAuthorized && micAuthorized)
                    }
                }
            } else {
                // For iOS versions prior to 17.0
                AVAudioSession.sharedInstance().requestRecordPermission { micAuthorized in
                    DispatchQueue.main.async {
                        print("Microphone permission: \(micAuthorized)")
                        
                        // Both permissions are needed
                        if !speechAuthorized {
                            self.errorMessage = "Please allow speech recognition in Settings to use voice input."
                            self.recordingState = .error
                        } else if !micAuthorized {
                            self.errorMessage = "Please allow microphone access in Settings to use voice input."
                            self.recordingState = .error
                        }
                        
                        // Return result
                        completion(speechAuthorized && micAuthorized)
                    }
                }
            }
        }
    }
    
    func startRecording() {
        // Reset any previous state
        transcribedText = ""
        errorMessage = nil
        recordingState = .processing
        
        print("Starting speech recognition process...")
        
        // Check permissions first
        checkPermissions { [weak self] authorized in
            guard let self = self, authorized else { 
                print("Permission check failed")
                self?.recordingState = .error
                return 
            }
            self.startRecordingSession()
        }
    }
    
    private func startRecordingSession() {
        // Cancel any ongoing recognition task
        cleanupRecognition()
        
        // Configure the audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            // Use playAndRecord with defaultToSpeaker option for better audio capture
            try audioSession.setCategory(.playAndRecord, 
                                         mode: .spokenAudio, 
                                         options: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            print("Audio session configured successfully")
            
            // Create a recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let recognitionRequest = recognitionRequest,
                  let speechRecognizer = speechRecognizer else {
                errorMessage = "Speech recognizer initialization failed"
                recordingState = .error
                print("Speech recognizer initialization failed")
                return
            }
            
            // Check for availability
            if !speechRecognizer.isAvailable {
                errorMessage = "Speech recognition is currently unavailable on this device"
                recordingState = .error
                print("Speech recognizer is unavailable")
                return
            }
            
            print("Speech recognizer is available: \(speechRecognizer.isAvailable)")
            
            // Configure request for real-time transcription
            recognitionRequest.shouldReportPartialResults = true
            
            // Enhanced task setup with better error handling
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                // Process transcription updates
                if let result = result {
                    let transcription = result.bestTranscription.formattedString
                    
                    if !transcription.isEmpty {
                        print("Transcription update: \(transcription)")
                        
                        // Update UI on main thread
                        DispatchQueue.main.async {
                            self.transcribedText = transcription
                            // Update UI with each transcription update
                            self.onTranscriptionUpdate?(transcription)
                            
                            // Show the listening state while actively transcribing
                            if self.recordingState != .success {
                                self.recordingState = .listening
                            }
                        }
                    }
                    
                    // Process final result
                    if result.isFinal {
                        print("Final transcription: \(transcription)")
                        DispatchQueue.main.async {
                            // Only call completion if we have text
                            if !transcription.isEmpty {
                                self.recordingState = .success
                                self.onTranscriptionComplete?(transcription)
                            }
                        }
                    }
                }
                
                // Handle errors
                if let error = error as NSError? {
                    print("Speech recognition error: \(error.domain), code: \(error.code)")
                    print("Error description: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        // Only show error if we haven't successfully captured any speech
                        if self.transcribedText.isEmpty {
                            self.recordingState = .error
                            
                            // Show user-friendly error message
                            if error.domain == "kAFAssistantErrorDomain" && (error.code == 1101 || error.code == 1110) {
                                self.errorMessage = "Speech not recognized. Please try speaking more clearly."
                            } else {
                                self.errorMessage = "Recognition failed: \(error.localizedDescription)"
                            }
                        } else if self.isRecording {
                            // We have text, so consider it a success despite error
                            self.recordingState = .success
                        }
                    }
                }
            }
            
            // Use the input format from the microphone for better compatibility
            let recordingFormat = audioEngine.inputNode.inputFormat(forBus: 0)
            print("Recording format: \(recordingFormat)")
            
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            // Prepare and start with a slight delay to ensure proper initialization
            audioEngine.prepare()
            
            try audioEngine.start()
            print("Audio engine started successfully")
            
            // Update state
            DispatchQueue.main.async {
                self.isRecording = true
                self.recordingState = .listening
                
                // Add haptic feedback
                HapticManager.shared.light()
            }
            
        } catch {
            print("Audio session setup error: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Could not start recording: \(error.localizedDescription)"
                self.recordingState = .error
            }
        }
    }
    
    func stopRecording(completion: (() -> Void)? = nil) {
        print("Stopping speech recognition")
        
        // Update UI state immediately
        DispatchQueue.main.async {
            self.isRecording = false
            
            // If we have transcribed text, consider it a success
            if !self.transcribedText.isEmpty {
                self.recordingState = .success
                // Call the completion handler with the current transcribed text
                self.onTranscriptionComplete?(self.transcribedText)
            } else {
                self.recordingState = .idle
            }
            
            // Add haptic feedback
            HapticManager.shared.medium()
        }
        
        // Save the completion handler
        self.stopCompletion = completion
        
        // Clean up resources
        cleanupRecognition()
    }
    
    private func cleanupRecognition() {
        // Stop and remove audio engine components
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // End the recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        // Cancel the recognition task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Reset audio session
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            print("Audio session deactivated")
            
            // Call completion after cleanup
            if let completion = stopCompletion {
                DispatchQueue.main.async {
                    completion()
                    self.stopCompletion = nil
                }
            }
        } catch {
            print("Error resetting audio session: \(error)")
            errorMessage = "Error resetting audio session: \(error.localizedDescription)"
        }
    }
}

// SwiftUI view for the microphone button with improved user feedback
struct VoiceInputButton: View {
    @ObservedObject private var speechRecognizer = SpeechRecognizer.shared
    @State private var pulseEffect = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var transcriptionText = ""
    
    let color: Color
    let onTextUpdate: (String) -> Void
    
    init(color: Color = .blue, onTextUpdate: @escaping (String) -> Void) {
        self.color = color
        self.onTextUpdate = onTextUpdate
    }
    
    var body: some View {
        VStack {
            Button(action: {
                if speechRecognizer.isRecording {
                    // Store the current text before stopping
                    let currentText = speechRecognizer.transcribedText
                    
                    speechRecognizer.stopRecording {
                        // Apply the text after the recording has fully stopped
                        if !currentText.isEmpty {
                            onTextUpdate(currentText)
                        }
                    }
                } else {
                    speechRecognizer.onTranscriptionUpdate = { text in
                        // Update our local state for animation purposes
                        transcriptionText = text
                    }
                    
                    speechRecognizer.startRecording()
                }
            }) {
                ZStack {
                    // Background circle with dynamic coloring
                    Circle()
                        .fill(getBackgroundColor())
                        .frame(width: 48, height: 48)
                        .scaleEffect(buttonScale)
                    
                    // Pulse effect for listening state
                    if pulseEffect {
                        Circle()
                            .stroke(getStrokeColor(), lineWidth: 2)
                            .frame(width: 60, height: 60)
                            .scaleEffect(pulseEffect ? 1.2 : 1.0)
                            .opacity(pulseEffect ? 0 : 0.7)
                    }
                    
                    // Icon changes based on state
                    Image(systemName: getButtonIcon())
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(getIconColor())
                }
                .overlay(
                    Circle()
                        .strokeBorder(getStrokeColor(), lineWidth: 2)
                )
                .shadow(color: getStrokeColor().opacity(0.3), radius: 5, x: 0, y: 2)
                .animation(.spring(response: 0.3), value: speechRecognizer.isRecording)
                .animation(.spring(response: 0.3), value: buttonScale)
            }
            
            // Show a small transcript preview if we have text
            if !transcriptionText.isEmpty && speechRecognizer.isRecording {
                Text(transcriptionText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.1))
                    )
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Reset state when view appears
            transcriptionText = ""
        }
        .onChange(of: speechRecognizer.recordingState) { _, newState in
            updateAnimationState(for: newState)
        }
        .alert(isPresented: .init(
            get: { return speechRecognizer.errorMessage != nil },
            set: { if !$0 { speechRecognizer.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Voice Input"),
                message: Text(speechRecognizer.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Helper functions to change appearance based on state
    private func getBackgroundColor() -> Color {
        switch speechRecognizer.recordingState {
        case .listening:
            return Color.red.opacity(0.15)
        case .success:
            return Color.green.opacity(0.15)
        case .error:
            return Color.orange.opacity(0.15)
        case .processing:
            return color.opacity(0.25)
        case .idle:
            return color.opacity(0.15)
        }
    }
    
    private func getStrokeColor() -> Color {
        switch speechRecognizer.recordingState {
        case .listening:
            return Color.red.opacity(0.6)
        case .success:
            return Color.green.opacity(0.6)
        case .error:
            return Color.orange.opacity(0.6)
        case .processing, .idle:
            return color.opacity(0.6)
        }
    }
    
    private func getIconColor() -> Color {
        switch speechRecognizer.recordingState {
        case .listening:
            return .red
        case .success:
            return .green
        case .error:
            return .orange
        case .processing, .idle:
            return color
        }
    }
    
    private func getButtonIcon() -> String {
        switch speechRecognizer.recordingState {
        case .listening:
            return "waveform"
        case .success:
            return "checkmark"
        case .error:
            return "exclamationmark.triangle"
        case .processing:
            return "mic.fill"
        case .idle:
            return "mic.fill"
        }
    }
    
    private func updateAnimationState(for state: SpeechRecognizer.RecordingState) {
        // Reset animations
        withAnimation {
            pulseEffect = false
            buttonScale = 1.0
        }
        
        // Apply specific animations for each state
        switch state {
        case .listening:
            // Pulsing animation for listening state
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                pulseEffect = true
            }
        case .success:
            // Success animation - quick pulse
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) {
                    buttonScale = 1.0
                }
            }
        case .error:
            // Error animation - shake
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                buttonScale = 0.95
            }
        case .processing:
            // Processing animation - subtle pulse
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                buttonScale = 1.05
            }
        case .idle:
            // Reset to normal
            withAnimation {
                buttonScale = 1.0
            }
        }
    }
} 