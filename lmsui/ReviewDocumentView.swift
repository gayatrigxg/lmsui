import SwiftUI

struct ReviewDocumentView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showError = false
    @State private var showAddressScreen = false
    @State private var previewVisible = false
    @State private var shakeTrigger: CGFloat = 0

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        progressSection
                            .padding(.top, AppSpacing.md)

                        reviewCard
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, 120)
                }

                bottomActions
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showAddressScreen) {
            AddressProofView()
        }

        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.secondaryBlue)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Back")
            }

            ToolbarItem(placement: .principal) {
                Text("Review Document")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.secondaryBlue)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.45)) {
                previewVisible = true
            }
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .top, spacing: 8) {
                progressStep(title: "Identity", state: .current)
                progressConnector(isActive: false)
                progressStep(title: "Address", state: .upcoming)
                progressConnector(isActive: false)
                progressStep(title: "Income", state: .upcoming)
            }

            Text("Step 1 of 3")
                .font(AppFont.bodyMedium())
                .foregroundStyle(Color.textSecondary)
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    private var reviewCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Check your document")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.secondaryBlue)

                Text("Make sure all details are clearly visible and not blurred.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            documentPreview

            checklistSection

            if showError {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.accentRed)

                    Text("Image unclear. Please upload a clearer photo.")
                        .font(AppFont.body())
                        .foregroundStyle(Color.accentRed)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .transition(.opacity)
            }
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    private var documentPreview: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.primaryBlue.opacity(0.12),
                        Color.secondaryBlue.opacity(0.06)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .aspectRatio(1.58, contentMode: .fit)
            .overlay {
                VStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.94))
                        .frame(width: 210, height: 132)
                        .overlay {
                            HStack(spacing: 14) {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.primaryBlue.opacity(0.12))
                                    .frame(width: 60, height: 76)
                                    .overlay {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 22, weight: .medium))
                                            .foregroundStyle(Color.primaryBlue)
                                    }

                                VStack(alignment: .leading, spacing: 10) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.primaryBlue.opacity(0.22))
                                        .frame(width: 90, height: 10)

                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.primaryBlue.opacity(0.14))
                                        .frame(width: 72, height: 10)

                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.primaryBlue.opacity(0.14))
                                        .frame(width: 86, height: 10)

                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.primaryBlue.opacity(0.10))
                                        .frame(width: 58, height: 10)
                                }

                                Spacer(minLength: 0)
                            }
                            .padding(16)
                        }

                    Text("Preview of uploaded document")
                        .font(AppFont.caption())
                        .foregroundStyle(Color.secondaryBlue)
                }
                .padding(20)
                .opacity(previewVisible ? 1 : 0)
                .scaleEffect(previewVisible ? 1 : 0.96)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(showError ? Color.accentRed.opacity(0.45) : Color.clear, lineWidth: 1.5)
            )
            .modifier(ShakeEffect(animatableData: shakeTrigger))
            .accessibilityLabel("Uploaded identity document preview")
    }

    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            checklistRow(text: "All text is readable")
            checklistRow(text: "Document is not cropped")
            checklistRow(text: "Image is not blurry")
        }
    }

    private func checklistRow(text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primaryBlue)

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var bottomActions: some View {
        VStack(spacing: AppSpacing.md) {
            Divider()
                .overlay(Color.dividerLight)

            Button {
                if showError {
                    withAnimation(.easeOut(duration: 0.2)) {
                        shakeTrigger += 1
                    }
                    return
                }

                showAddressScreen = true
            } label: {
                Text("Looks Good")
            }
            .buttonStyle(PrimaryCTAButtonStyle())
            .disabled(showError)
            .opacity(showError ? 0.55 : 1)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)

            Button {
                dismiss()
            } label: {
                Text("Retake / Upload Again")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous)
                            .stroke(Color.primaryBlue, lineWidth: 1.5)
                    )
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.lg)
        }
        .background(Color.appBackground)
    }

    private func progressStep(title: String, state: StepState) -> some View {
        VStack(spacing: 8) {
            ZStack {
                switch state {
                case .completed:
                    Circle()
                        .fill(Color.primaryBlue)
                        .frame(width: 30, height: 30)

                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.white)

                case .current:
                    Circle()
                        .stroke(Color.primaryBlue, lineWidth: 2)
                        .frame(width: 30, height: 30)

                    Circle()
                        .fill(Color.primaryBlue.opacity(0.12))
                        .frame(width: 16, height: 16)

                case .upcoming:
                    Circle()
                        .fill(Color.inactiveStep)
                        .frame(width: 30, height: 30)
                }
            }

            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(state == .current ? Color.secondaryBlue : Color.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }

    private func progressConnector(isActive: Bool) -> some View {
        Capsule()
            .fill(isActive ? Color.primaryBlue : Color.inactiveStep)
            .frame(height: 4)
            .padding(.top, 13)
    }
}



private struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}

private enum StepState {
    case completed
    case current
    case upcoming
}

struct ReviewDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReviewDocumentView()
        }
    }
}
