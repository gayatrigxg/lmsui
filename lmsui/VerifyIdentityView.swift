import SwiftUI

struct VerifyIdentityView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedState: IdentityUploadState = .empty
    @State private var isUploadHighlighted = false
    @State private var showReviewScreen = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        progressSection
                            .padding(.top, AppSpacing.md)

                        uploadCard
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, 120)
                }

                bottomCTA
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showReviewScreen) {
            ReviewDocumentView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
                Text("Verify Your Identity")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.secondaryBlue)
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

    private var uploadCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Upload Identity Proof")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.secondaryBlue)

                Text("Upload a valid government ID to verify your identity.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 12) {
                acceptedDocumentRow(text: "Aadhaar Card")
                acceptedDocumentRow(text: "PAN Card")
                acceptedDocumentRow(text: "Passport")
            }

            uploadStateView

            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    selectedState = .uploaded
                }
            } label: {
                Text("Use Camera")
                    .font(AppFont.button())
                    .foregroundStyle(Color.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous)
                            .stroke(Color.primaryBlue, lineWidth: 1.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.button, style: .continuous))
            }
            .accessibilityLabel("Use Camera")
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    @ViewBuilder
    private var uploadStateView: some View {
        switch selectedState {
        case .empty:
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    isUploadHighlighted = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isUploadHighlighted = false
                        selectedState = .uploaded
                    }
                }
            } label: {
                VStack(spacing: 14) {
                    Image(systemName: "doc.badge.plus")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(Color.primaryBlue)

                    Text("Tap to upload or scan document")
                        .font(AppFont.bodyMedium())
                        .foregroundStyle(Color.secondaryBlue)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.primaryBlue.opacity(isUploadHighlighted ? 0.10 : 0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            isUploadHighlighted ? Color.secondaryBlue : Color.primaryBlue.opacity(0.55),
                            style: StrokeStyle(lineWidth: 1.5, dash: [8, 6])
                        )
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Tap to upload or scan document")

        case .uploaded:
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.primaryBlue.opacity(0.18),
                                    Color.secondaryBlue.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 76, height: 96)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.primaryBlue)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.primaryBlue.opacity(0.25))
                                    .frame(width: 34, height: 6)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.primaryBlue.opacity(0.15))
                                    .frame(width: 24, height: 6)
                            }
                        )

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.primaryBlue)

                            Text("Document uploaded")
                                .font(AppFont.bodyMedium())
                                .foregroundStyle(Color.secondaryBlue)
                        }

                        Text("identity-proof.pdf")
                            .font(AppFont.body())
                            .foregroundStyle(Color.textPrimary)

                        Text("Looks good. You can continue to review it.")
                            .font(AppFont.caption())
                            .foregroundStyle(Color.textSecondary)
                    }

                    Spacer()
                }

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedState = .empty
                    }
                } label: {
                    Text("Replace Document")
                        .font(AppFont.bodyMedium())
                        .foregroundStyle(Color.primaryBlue)
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.primaryBlue.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.primaryBlue.opacity(0.18), lineWidth: 1)
            )

        case .error:
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.accentRed)

                    Text("Image not clear enough")
                        .font(AppFont.bodyMedium())
                        .foregroundStyle(Color.accentRed)
                }

                Text("Please upload a sharper image or scan the document again.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedState = .empty
                    }
                } label: {
                    Text("Try Again")
                        .font(AppFont.bodyMedium())
                        .foregroundStyle(Color.accentRed)
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.accentRed.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.accentRed.opacity(0.28), lineWidth: 1)
            )
        }
    }

    private var bottomCTA: some View {
        VStack(spacing: AppSpacing.sm) {
            Divider()
                .overlay(Color.dividerLight)

            Button {
                showReviewScreen = true
            } label: {
                Text("Continue")
            }
            .buttonStyle(PrimaryCTAButtonStyle())
            .disabled(selectedState != .uploaded)
            .opacity(selectedState == .uploaded ? 1 : 0.55)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
        .background(Color.appBackground)
    }

    private func acceptedDocumentRow(text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.primaryBlue)

            Text(text)
                .font(AppFont.body())
                .foregroundStyle(Color.textPrimary)
        }
    }

    private func progressStep(title: String, state: KYCStepVisualState) -> some View {
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

private enum IdentityUploadState {
    case empty
    case uploaded
    case error
}

private enum KYCStepVisualState {
    case completed
    case current
    case upcoming
}

#Preview {
    NavigationStack {
        VerifyIdentityView()
    }
}
