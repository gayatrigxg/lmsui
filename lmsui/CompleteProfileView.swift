import SwiftUI

struct CompleteProfileView: View {
    @State private var goToIdentityScreen = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            VStack(spacing: 32) {
                heroSection
                documentsSection
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)

            bottomBar
        }
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $goToIdentityScreen) {
            VerifyIdentityView()
        }
    }

    private var heroSection: some View {
        VStack(spacing: 18) {
            Image(systemName: "checkmark.shield")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.blue)
                .frame(width: 72, height: 72)
                .background(Color.blue.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            VStack(spacing: 8) {
                Text("Verify your identity")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                Text("This usually takes about 3 minutes.")
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("You’ll need")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                documentRow(
                    icon: "person.text.rectangle",
                    title: "Government ID",
                    subtitle: "Aadhaar, PAN, or passport"
                )

                divider

                documentRow(
                    icon: "house",
                    title: "Address proof",
                    subtitle: "Utility bill or bank statement"
                )

                divider

                documentRow(
                    icon: "indianrupeesign.circle",
                    title: "Income proof",
                    subtitle: "Salary slips or ITR"
                )
            }
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    private var divider: some View {
        Divider()
            .padding(.leading, 60)
    }

    private func documentRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    private var bottomBar: some View {
        VStack(spacing: 10) {
            Button {
                goToIdentityScreen = true
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
            .tint(.blue)

            Button("Not now") {
            }
            .font(.system(size: 17))
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(Color(uiColor: .systemBackground))
    }
}

struct CompleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CompleteProfileView()
        }
    }
}
