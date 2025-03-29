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
    
    var onTranscriptionUpdate: ((String) -> Void)?
    var onTranscriptionComplete: ((String) -> Void)?
    
    private init() {
        // We'll request permission when needed
    }
    
    private func checkPermissions(completion: @escaping (Bool) -> Void) {
        // Check speech recognition permission
        SFSpeechRecognizer.requestAuthorization { status in
            let speechAuthorized = status == .authorized
            
            // Check microphone permission
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { micAuthorized in
                    DispatchQueue.main.async {
                        // Both permissions are needed
                        if !speechAuthorized {
                            self.errorMessage = "Please allow speech recognition in Settings to use voice input."
                        } else if !micAuthorized {
                            self.errorMessage = "Please allow microphone access in Settings to use voice input."
                        }
                        
                        // Return result
                        completion(speechAuthorized && micAuthorized)
                    }
                }
            } else {
                // For iOS versions prior to 17.0
                AVAudioSession.sharedInstance().requestRecordPermission { micAuthorized in
                    DispatchQueue.main.async {
                        // Both permissions are needed
                        if !speechAuthorized {
                            self.errorMessage = "Please allow speech recognition in Settings to use voice input."
                        } else if !micAuthorized {
                            self.errorMessage = "Please allow microphone access in Settings to use voice input."
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
        
        // Check permissions first
        checkPermissions { [weak self] authorized in
            guard let self = self, authorized else { return }
            self.startRecordingSession()
        }
    }
    
    private func startRecordingSession() {
        // Cancel any ongoing recognition task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure the audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Create a recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let recognitionRequest = recognitionRequest,
                  let speechRecognizer = speechRecognizer,
                  speechRecognizer.isAvailable else {
                errorMessage = "Speech recognizer is unavailable"
                return
            }
            
            // Configure request for real-time transcription
            recognitionRequest.shouldReportPartialResults = true
            
            // Start the recognition task
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.stopRecording()
                        if let transcription = result?.bestTranscription.formattedString, !transcription.isEmpty {
                            self.transcribedText = transcription
                            self.onTranscriptionComplete?(transcription)
                        } else {
                            self.errorMessage = "Error during recognition: \(error.localizedDescription)"
                        }
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    let transcription = result?.bestTranscription.formattedString ?? ""
                    self.transcribedText = transcription
                    self.onTranscriptionUpdate?(transcription)
                    
                    // Check for final result
                    if result?.isFinal == true {
                        self.stopRecording()
                        self.onTranscriptionComplete?(transcription)
                    }
                }
            }
            
            // Start audio recording
            let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            // Update state
            isRecording = true
            
            // Add haptic feedback
            HapticManager.shared.light()
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Could not start recording: \(error.localizedDescription)"
            }
        }
    }
    
    func stopRecording() {
        // Stop recording and clean up
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Update state
        isRecording = false
        
        // Add haptic feedback
        HapticManager.shared.medium()
        
        // Reset audio session
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Error resetting audio session: \(error.localizedDescription)"
        }
    }
}

// SwiftUI view for the microphone button
struct VoiceInputButton: View {
    @ObservedObject private var speechRecognizer = SpeechRecognizer.shared
    @State private var showingAlert = false
    let color: Color
    let onTextUpdate: (String) -> Void
    
    init(color: Color = .blue, onTextUpdate: @escaping (String) -> Void) {
        self.color = color
        self.onTextUpdate = onTextUpdate
    }
    
    var body: some View {
        Button(action: {
            if speechRecognizer.isRecording {
                speechRecognizer.stopRecording()
            } else {
                speechRecognizer.onTranscriptionComplete = { text in
                    if !text.isEmpty {
                        onTextUpdate(text)
                    }
                }
                speechRecognizer.startRecording()
            }
        }) {
            ZStack {
                Circle()
                    .fill(speechRecognizer.isRecording ? Color.red.opacity(0.15) : color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: speechRecognizer.isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(speechRecognizer.isRecording ? .red : color)
            }
            .overlay(
                Circle()
                    .strokeBorder(
                        speechRecognizer.isRecording ? Color.red.opacity(0.6) : color.opacity(0.6),
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(speechRecognizer.isRecording ? 1.1 : 1.0)
            .shadow(color: speechRecognizer.isRecording ? Color.red.opacity(0.3) : color.opacity(0.3), radius: 4, x: 0, y: 2)
            .animation(.spring(response: 0.3), value: speechRecognizer.isRecording)
        }
        .alert(isPresented: .init(
            get: { return speechRecognizer.errorMessage != nil },
            set: { if !$0 { speechRecognizer.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Speech Recognition Error"),
                message: Text(speechRecognizer.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
} 