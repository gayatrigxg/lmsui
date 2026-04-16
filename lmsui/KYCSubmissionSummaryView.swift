import SwiftUI

struct KYCSubmissionSummaryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var isDeclarationAccepted = false
    @State private var showIncompleteError = false
    @State private var showVerifyingScreen = false

    private let isIdentityComplete = true
    private let isAddressComplete = true
    private let isIncomeComplete = true

    private var isFormComplete: Bool {
        isIdentityComplete && isAddressComplete && isIncomeComplete
    }

    private var canSubmit: Bool {
        isFormComplete && isDeclarationAccepted
    }

    var body: some View {
        List {
            Section {
                progressOverview
                    .listRowInsets(
                        EdgeInsets(
                            top: 16,
                            leading: 16,
                            bottom: 16,
                            trailing: 16
                        )
                    )
            }

            Section {
                reviewRow(
                    title: "Identity Proof",
                    value: "Aadhaar Card",
                    detail: "Fetched and verified",
                    icon: "person.text.rectangle",
                    isComplete: isIdentityComplete
                )

                reviewRow(
                    title: "Address Proof",
                    value: "Bank Statement",
                    detail: "1 document added",
                    icon: "house",
                    isComplete: isAddressComplete
                )

                reviewRow(
                    title: "Income Proof",
                    value: "Salary Slip",
                    detail: "3 files uploaded",
                    icon: "indianrupeesign.circle",
                    isComplete: isIncomeComplete
                )
            } header: {
                Text("Documents")
            } footer: {
                if showIncompleteError && !isFormComplete {
                    Text("Please complete all sections before submitting.")
                        .foregroundStyle(Color.red)
                }
            }

            Section {
                Toggle(isOn: $isDeclarationAccepted) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Information is accurate")
                            .font(.body)

                        Text("I confirm these documents belong to me and can be used for verification.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                .tint(Color.blue)
            } footer: {
                Text("Your documents are encrypted and used only for verification.")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Review & Submit")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showVerifyingScreen) {
            KYCVerifyingView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }
                .accessibilityLabel("Back")
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomSubmitArea
        }
    }

    private var progressOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Ready to submit")
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("Review your details before we send them for verification.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                progressStep(title: "Identity")
                progressLine
                progressStep(title: "Address")
                progressLine
                progressStep(title: "Income")
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("All verification steps are complete")
        }
    }

    private func progressStep(title: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color.blue)

            Text(title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(width: 64)
    }

    private var progressLine: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.35))
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
    }

    private func reviewRow(
        title: String,
        value: String,
        detail: String,
        icon: String,
        isComplete: Bool
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.body)
                        .foregroundStyle(.primary)

                    if isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Color.blue)
                            .accessibilityLabel("Complete")
                    }
                }

                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(Color.blue)

                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(
                        isComplete
                        ? Color(uiColor: .secondaryLabel)
                        : Color.red
                    )
            }

            Spacer(minLength: 12)

            Button("Edit") {
                dismiss()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.blue)
        }
        .padding(.vertical, 6)
    }

    private var bottomSubmitArea: some View {
        VStack(spacing: 8) {
            Button {
                guard isFormComplete else {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showIncompleteError = true
                    }
                    return
                }

                showIncompleteError = false
                showVerifyingScreen = true
            } label: {
                Text("Submit Verification")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 12))
            .tint(Color.blue)
            .disabled(!canSubmit)

            if !canSubmit {
                Text(
                    isDeclarationAccepted
                    ? "Complete all sections to continue."
                    : "Confirm the declaration to continue."
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(.regularMaterial)
    }
}

#Preview {
    NavigationStack {
        KYCSubmissionSummaryView()
    }
}
