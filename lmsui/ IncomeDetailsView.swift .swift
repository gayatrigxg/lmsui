import SwiftUI

struct IncomeDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDocument: IncomeDocumentType?
    @State private var uploadState: IncomeUploadState = .empty
    @State private var isUploadHighlighted = false
    @State private var uploadedFiles: [IncomeFileItem] = []
    @State private var showReviewSummary = false

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
        .navigationDestination(isPresented: $showReviewSummary) {
            KYCSubmissionSummaryView()
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
                progressStep(title: "Address", state: .completed)
                progressConnector(isActive: true)
                progressStep(title: "Income", state: .current)
            }

            Text("Step 3 of 3")
                .font(AppFont.bodyMedium())
                .foregroundStyle(Color.textSecondary)
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    private var mainCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Upload Income Proof")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.secondaryBlue)

                Text("Provide documents that verify your income to assess your repayment capacity.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            documentTypeChips

            if let helperText {
                Text(helperText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondaryBlue)
                    .padding(.horizontal, 2)
            }

            uploadStateView

            Text("Make sure your name and income details are clearly visible.")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    private var documentTypeChips: some View {
        HStack(spacing: 10) {
            ForEach(IncomeDocumentType.allCases, id: \.self) { type in
                incomeChip(for: type)
            }
        }
    }

    @ViewBuilder
    private var uploadStateView: some View {
        switch uploadState {
        case .empty, .partial:
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    handleMockUpload()
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
                    handleMockUpload()
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

                if selectedDocument == .salarySlip {
                    uploadProgressCard
                    uploadedFilesStrip
                } else if !uploadedFiles.isEmpty {
                    uploadedFilesStrip
                }
            }

        case .uploaded:
            VStack(alignment: .leading, spacing: 12) {
                uploadedFilesStrip

                Button("Replace Document") {
                    withAnimation(.easeOut(duration: 0.2)) {
                        uploadedFiles = []
                        uploadState = .empty
                    }
                }
                .font(AppFont.bodyMedium())
                .foregroundStyle(Color.primaryBlue)
            }

        case .error:
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.accentRed)

                    Text("Incomplete or unclear income proof")
                        .font(AppFont.bodyMedium())
                        .foregroundStyle(Color.accentRed)
                }

                Text("Please upload a clearer or complete income document.")
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

    private var uploadProgressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(uploadedFiles.count)/3 files uploaded")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.secondaryBlue)

            ProgressView(value: Double(uploadedFiles.count), total: 3)
                .tint(Color.primaryBlue)
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.primaryBlue.opacity(0.05))
        )
    }

    private var uploadedFilesStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(uploadedFiles) { file in
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.primaryBlue.opacity(0.18), Color.secondaryBlue.opacity(0.10)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 110, height: 82)
                            .overlay(
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.primaryBlue)
                            )

                        Text(file.name)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(1)
                    }
                    .frame(width: 110)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.primaryBlue.opacity(0.12), lineWidth: 1)
                    )
                }
            }
        }
    }

    private var bottomCTA: some View {
        VStack(spacing: AppSpacing.sm) {
            Divider()
                .overlay(Color.dividerLight)

            Button {
                showReviewSummary = true
            } label: {
                Text("Continue")
            }
            .buttonStyle(PrimaryCTAButtonStyle())
            .disabled(!canContinue)
            .opacity(canContinue ? 1 : 0.55)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
        .background(Color.appBackground)
    }

    private func incomeChip(for type: IncomeDocumentType) -> some View {
        let isSelected = selectedDocument == type

        return Button {
            withAnimation(.easeOut(duration: 0.2)) {
                selectedDocument = type
                uploadedFiles = []
                uploadState = .empty
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

    private func progressStep(title: String, state: IncomeStepState) -> some View {
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

    private func handleMockUpload() {
        guard let selectedDocument else { return }

        withAnimation(.easeOut(duration: 0.2)) {
            isUploadHighlighted = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.2)) {
                isUploadHighlighted = false

                switch selectedDocument {
                case .salarySlip:
                    let nextIndex = uploadedFiles.count + 1
                    guard nextIndex <= 3 else { return }

                    uploadedFiles.append(
                        IncomeFileItem(name: "Salary Slip \(nextIndex)")
                    )

                    uploadState = uploadedFiles.count == 3 ? .uploaded : .partial

                case .bankStatement:
                    uploadedFiles = [IncomeFileItem(name: "Bank Statement")]
                    uploadState = .uploaded

                case .itr:
                    uploadedFiles = [IncomeFileItem(name: "Latest ITR")]
                    uploadState = .uploaded
                }
            }
        }
    }

    private var helperText: String? {
        switch selectedDocument {
        case .salarySlip:
            return "Upload last 3 months' salary slips"
        case .bankStatement:
            return "Upload last 6 months' bank statement"
        case .itr:
            return "Upload latest filed ITR document"
        case .none:
            return nil
        }
    }

    private var canContinue: Bool {
        guard selectedDocument != nil else { return false }

        switch selectedDocument {
        case .salarySlip:
            return uploadedFiles.count == 3
        case .bankStatement, .itr:
            return !uploadedFiles.isEmpty
        case .none:
            return false
        }
    }
}

private enum IncomeDocumentType: String, CaseIterable {
    case salarySlip = "Salary Slip"
    case bankStatement = "Bank Statement"
    case itr = "ITR"
}

private enum IncomeUploadState {
    case empty
    case partial
    case uploaded
    case error
}

private enum IncomeStepState {
    case completed
    case current
}

private struct IncomeFileItem: Identifiable {
    let id = UUID()
    let name: String
}

#Preview {
    NavigationStack {
        IncomeDetailsView()
    }
}
