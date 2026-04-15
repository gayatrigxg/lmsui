import SwiftUI

struct AddressProofView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDocument: AddressDocumentType?
    @State private var uploadState: AddressUploadState = .empty
    @State private var isUploadHighlighted = false
    @State private var goToIncomeScreen = false

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        progressSection
                            .padding(.top, AppSpacing.md)

                        mainCard
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, 120)
                }

                bottomCTA
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToIncomeScreen) {
            IncomeDetailsView()
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
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.secondaryBlue)
            }
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .top, spacing: 8) {
                progressStep(title: "Identity", state: .completed)
                progressConnector(isActive: true)
                progressStep(title: "Address", state: .current)
                progressConnector(isActive: false)
                progressStep(title: "Income", state: .upcoming)
            }

            Text("Step 2 of 3")
                .font(AppFont.bodyMedium())
                .foregroundStyle(Color.textSecondary)
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    private var mainCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Upload Address Proof")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.secondaryBlue)

                Text("Upload a document that shows your current residential address.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AddressDocumentType.allCases, id: \.self) { type in
                    documentChip(for: type)
                }
            }

            uploadStateView

            Text("Ensure your name and address are clearly visible and match your profile details.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    @ViewBuilder
    private var uploadStateView: some View {
        switch uploadState {
        case .empty:
            VStack(spacing: 12) {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isUploadHighlighted = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isUploadHighlighted = false
                            uploadState = .uploaded
                        }
                    }
                } label: {
                    VStack(spacing: 14) {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundStyle(Color.primaryBlue)

                        Text("Upload from Files")
                            .font(AppFont.bodyMedium())
                            .foregroundStyle(Color.secondaryBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 168)
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
                .disabled(selectedDocument == nil)
                .opacity(selectedDocument == nil ? 0.55 : 1)

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        uploadState = .uploaded
                    }
                } label: {
                    Text("Take Photo")
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
                .disabled(selectedDocument == nil)
                .opacity(selectedDocument == nil ? 0.55 : 1)
            }

        case .uploaded:
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryBlue.opacity(0.18), Color.secondaryBlue.opacity(0.10)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 76, height: 96)
                        .overlay(
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.primaryBlue)
                        )

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.primaryBlue)

                            Text("Address proof uploaded")
                                .font(AppFont.bodyMedium())
                                .foregroundStyle(Color.secondaryBlue)
                        }

                        Text(selectedDocument?.rawValue ?? "Document selected")
                            .font(AppFont.body())
                            .foregroundStyle(Color.textPrimary)

                        Text("Preview ready. You can continue to the next step.")
                            .font(AppFont.caption())
                            .foregroundStyle(Color.textSecondary)
                    }

                    Spacer()
                }

                Button("Replace Document") {
                    withAnimation(.easeOut(duration: 0.2)) {
                        uploadState = .empty
                    }
                }
                .font(AppFont.bodyMedium())
                .foregroundStyle(Color.primaryBlue)
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
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.accentRed)

                    Text("Document unclear or missing address")
                        .font(AppFont.bodyMedium())
                        .foregroundStyle(Color.accentRed)
                }

                Text("Please upload a clearer document with your full address visible.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
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
                goToIncomeScreen = true
            } label: {
                Text("Continue")
            }
            .buttonStyle(PrimaryCTAButtonStyle())
            .disabled(!(selectedDocument != nil && uploadState == .uploaded))
            .opacity((selectedDocument != nil && uploadState == .uploaded) ? 1 : 0.55)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
        .background(Color.appBackground)
    }

    private func documentChip(for type: AddressDocumentType) -> some View {
        let isSelected = selectedDocument == type

        return Button {
            withAnimation(.easeOut(duration: 0.2)) {
                selectedDocument = type
            }
        } label: {
            Text(type.rawValue)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(isSelected ? Color.white : Color.secondaryBlue)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.primaryBlue : Color.appBackground)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(type.rawValue)
    }

    private func progressStep(title: String, state: AddressStepState) -> some View {
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

private enum AddressUploadState {
    case empty
    case uploaded
    case error
}

private enum AddressStepState {
    case completed
    case current
    case upcoming
}

private enum AddressDocumentType: String, CaseIterable {
    case aadhaarCard = "Aadhaar Card"
    case utilityBill = "Utility Bill"
    case bankStatement = "Bank Statement"
    case rentalAgreement = "Rental Agreement"
}

#Preview {
    NavigationStack {
        AddressProofView()
    }
}
