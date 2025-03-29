    private var overviewContent: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Quick Overview Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(primaryPurple)
                    Text("Quick Overview")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.quickOverview ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
            
            // Feelings Section
            VStack(spacing: 16) {
                Text("What were your feelings about the dream?")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 32) {
                    ForEach(0..<5) { index in
                        Button {
                            viewModel.feelingRating = index + 1
                        } label: {
                            Text(emojis[index])
                                .font(.system(size: 32))
                                .opacity(index + 1 == viewModel.feelingRating ? 1.0 : 0.5)
                                .scaleEffect(index + 1 == viewModel.feelingRating ? 1.2 : 1.0)
                        }
                        .buttonStyle(.plain)
                        .animation(.spring(response: 0.3), value: viewModel.feelingRating)
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
            )
            
            // Daily Life Connection Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundColor(primaryPurple)
                    Text("Daily Life Connection")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.dailyLifeConnection ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
        .padding(.horizontal, 12)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Dream Title with Icon
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(lightPurple)
                            .frame(width: 100, height: 100)
                        Image(systemName: dreamIcon)
                            .font(.system(size: 50))
                            .foregroundColor(primaryPurple)
                    }
                    
                    Text(viewModel.interpretation?.dreamName ?? "")
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(.top, 8)
                
                // Tab Selection
                Picker("View Selection", selection: $selectedTab) {
                    Text("Overview").tag(0)
                    Text("Details").tag(1)
                    Text("Insights").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 12)
                
                // Content based on selected tab
                Group {
                    if selectedTab == 0 {
                        overviewContent
                    } else if selectedTab == 1 {
                        detailsTab
                    } else {
                        insightsTab
                    }
                }
                .frame(minHeight: 450)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        viewModel.saveDreamToJournal()
                        showingSaveConfirmation = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Save to Journal")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(primaryPurple)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark")
                            Text("Close")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(Color(.systemGray))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
        }
        .alert("Dream Saved", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Your dream interpretation has been saved to your journal.")
        }
    }

    private var overviewTab: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Quick Overview Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(primaryPurple)
                    Text("Quick Overview")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.quickOverview ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
            
            // Feelings Section
            VStack(spacing: 16) {
                Text("What were your feelings about the dream?")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 32) {
                    ForEach(0..<5) { index in
                        Button {
                            viewModel.feelingRating = index + 1
                        } label: {
                            Text(emojis[index])
                                .font(.system(size: 32))
                                .opacity(index + 1 == viewModel.feelingRating ? 1.0 : 0.5)
                                .scaleEffect(index + 1 == viewModel.feelingRating ? 1.2 : 1.0)
                        }
                        .buttonStyle(.plain)
                        .animation(.spring(response: 0.3), value: viewModel.feelingRating)
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
            )
            
            // Daily Life Connection Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "figure.mind.and.body")
                        .foregroundColor(primaryPurple)
                    Text("Daily Life Connection")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.interpretation?.dailyLifeConnection ?? "")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
        .padding(.horizontal, 12)
    } 