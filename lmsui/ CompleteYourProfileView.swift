import SwiftUI

struct CompleteYourProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateProgress = false
    @State private var isPrimaryPressed = false

    private let steps: [ProfileStep] = [
        .init(title: "Identity Proof", icon: "person.text.rectangle", status: "Not Started"),
        .init(title: "Address Proof", icon: "house", status: "Not Started"),
        .init(title: "Income Details", icon: "chart.bar.doc.horizontal", status: "Not Started")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            headerSection
                            illustrationCard
                            progressSection
                            infoCard
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 140)
                    }

                    bottomCTASection
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.appPrimary)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Back")
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                animateProgress = true
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Complete Your Profile")
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundStyle(Color.appTextPrimary)
                .accessibilityAddTraits(.isHeader)

            Text("To apply for a loan, we need to verify your identity.\nThis will only take 3-5 minutes.")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.appTextSecondary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var illustrationCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color.appCardBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary.opacity(0.12))
                        .frame(width: 84, height: 84)

                    Image(systemName: "checklist.checked")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(Color.appPrimary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("Secure identity check", systemImage: "checkmark.shield")
                    Label("Simple document upload", systemImage: "doc.text")
                    Label("Protected application flow", systemImage: "lock")
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.appTextPrimary)
                .labelStyle(LeadingIconLabelStyle())
            }
            .padding(22)
        }
        .frame(height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 10) {
                Text("0 of 3 steps completed")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.appTrack)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.appPrimary.opacity(0.85), Color.appPrimary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: animateProgress ? 10 : 0)
                    }
                }
                .frame(height: 10)
            }

            VStack(spacing: 12) {
                ForEach(steps) { step in
                    StepRow(step: step)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Why is this required?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.appTextPrimary)

            BenefitRow(text: "Ensure secure and verified applications")
            BenefitRow(text: "Faster loan approval")
            BenefitRow(text: "Protect against fraud")
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
    }

    private var bottomCTASection: some View {
        VStack(spacing: 12) {
            Button {
                // Hook this to your next KYC screen later.
            } label: {
                Text("Start Verification")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.appPrimary)
                    )
            }
            .buttonStyle(PrimaryPressButtonStyle())

            Button {
                // Hook this to save draft / exit later.
            } label: {
                Text("Save & complete later")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.appPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(.ultraThinMaterial)
    }
}

private struct StepRow: View {
    let step: ProfileStep

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.appPrimary.opacity(0.10))
                    .frame(width: 48, height: 48)

                Image(systemName: step.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.appPrimary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.appTextPrimary)

                Text(step.status)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.appChevron)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.appStepBackground)
        )
    }
}

private struct BenefitRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.appPrimary)
                .padding(.top, 2)

            Text(text)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.appTextPrimary)

            Spacer(minLength: 0)
        }
    }
}

private struct LeadingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .foregroundStyle(Color.appPrimary)
                .frame(width: 18)

            configuration.title
        }
    }
}

private struct PrimaryPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .shadow(
                color: Color.appPrimary.opacity(configuration.isPressed ? 0.12 : 0.22),
                radius: configuration.isPressed ? 6 : 14,
                x: 0,
                y: configuration.isPressed ? 3 : 8
            )
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

private struct ProfileStep: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let status: String
}

private extension Color {
    static let appBackground = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let appPrimary = Color(red: 0.17, green: 0.25, blue: 0.68)
    static let appCardBlue = Color(red: 0.92, green: 0.95, blue: 1.00)
    static let appTextPrimary = Color(red: 0.10, green: 0.12, blue: 0.18)
    static let appTextSecondary = Color(red: 0.40, green: 0.45, blue: 0.54)
    static let appTrack = Color(red: 0.87, green: 0.89, blue: 0.93)
    static let appStepBackground = Color(red: 0.98, green: 0.99, blue: 1.00)
    static let appChevron = Color(red: 0.64, green: 0.68, blue: 0.75)
}

#Preview {
    CompleteYourProfileView()
}
