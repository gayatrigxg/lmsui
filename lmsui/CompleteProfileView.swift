import SwiftUI

struct CompleteProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var completedSteps: Int = 0
    @State private var progressValue: CGFloat = 0
    @State private var goToIdentityScreen = false

    private let steps: [ProfileStep] = [
        ProfileStep(title: "Identity Proof", icon: "person.text.rectangle"),
        ProfileStep(title: "Address Proof", icon: "house"),
        ProfileStep(title: "Income Details", icon: "indianrupeesign.circle")
    ]

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    topSection
                    progressSection
                    infoCard
                    actionSection
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xxl)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToIdentityScreen) {
            VerifyIdentityView()
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
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Back")
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7).delay(0.15)) {
                progressValue = 0
            }
        }
    }

    private var topSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Complete Your Profile")
                    .font(AppFont.largeTitle())
                    .foregroundStyle(Color.secondaryBlue)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text("To apply for a loan, we need to verify your identity.\nThis will only take 3-5 minutes.")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            profileIllustration
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
    }

    private var profileIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color.primaryBlue.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)

            Circle()
                .fill(Color.primaryBlue.opacity(0.08))
                .frame(width: 150, height: 150)
                .offset(x: 90, y: -30)

            Circle()
                .fill(Color.secondaryBlue.opacity(0.08))
                .frame(width: 100, height: 100)
                .offset(x: -110, y: 55)

            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.95))
                    .frame(width: 112, height: 138)
                    .overlay(
                        VStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.primaryBlue.opacity(0.12))
                                .frame(width: 52, height: 52)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundStyle(Color.primaryBlue)
                                }

                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.primaryBlue.opacity(0.14))
                                .frame(width: 68, height: 10)

                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.primaryBlue.opacity(0.08))
                                .frame(width: 52, height: 10)
                        }
                    )
                    .shadow(color: Color.primaryBlue.opacity(0.08), radius: 12, x: 0, y: 8)

                VStack(alignment: .leading, spacing: 14) {
                    illustrationBadge(
                        icon: "checkmark.shield",
                        text: "Secure verification"
                    )

                    illustrationBadge(
                        icon: "clock",
                        text: "3-5 min process"
                    )

                    illustrationBadge(
                        icon: "lock",
                        text: "Private & protected"
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func illustrationBadge(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.primaryBlue)
                .frame(width: 30, height: 30)
                .background(Color.primaryBlue.opacity(0.10))
                .clipShape(Circle())

            Text(text)
                .font(AppFont.caption())
                .foregroundStyle(Color.secondaryBlue)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            stepPill(
                                index: index,
                                icon: step.icon,
                                isActive: index == completedSteps
                            )

                            if index < steps.count - 1 {
                                progressConnector(isFilled: progressValue > CGFloat(index) / CGFloat(steps.count - 1))
                            }
                        }

                        Text(step.title)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(index == completedSteps ? Color.secondaryBlue : Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                }
            }

            Text("\(completedSteps) of 3 steps completed")
                .font(AppFont.bodyMedium())
                .foregroundStyle(Color.textSecondary)
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                progressValue = 0.12
            }
        }
    }

    private func stepPill(index: Int, icon: String, isActive: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isActive ? Color.white : Color.primaryBlue)

            Text("\(index + 1)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isActive ? Color.white : Color.primaryBlue)
        }
        .frame(height: 40)
        .padding(.horizontal, 14)
        .background(isActive ? Color.primaryBlue : Color.primaryBlue.opacity(0.10))
        .clipShape(Capsule())
    }

    private func progressConnector(isFilled: Bool) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.inactiveStep)
                    .frame(height: 6)

                Capsule()
                    .fill(Color.primaryBlue)
                    .frame(width: isFilled ? geometry.size.width : 0, height: 6)
                    .animation(.easeOut(duration: 0.6), value: isFilled)
            }
        }
        .frame(height: 6)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Why is this required?")
                .font(AppFont.title())
                .foregroundStyle(Color.secondaryBlue)

            VStack(alignment: .leading, spacing: 14) {
                infoRow(
                    icon: "checkmark.shield",
                    text: "Ensure secure and verified applications"
                )

                infoRow(
                    icon: "bolt.horizontal.circle",
                    text: "Faster loan approval"
                )

                infoRow(
                    icon: "lock.slash",
                    text: "Protect against fraud"
                )
            }
        }
        .padding(AppSpacing.lg)
        .appCardStyle()
    }

    private func infoRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.primaryBlue)
                .frame(width: 22)

            Text(text)
                .font(AppFont.body())
                .foregroundStyle(Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var actionSection: some View {
        VStack(spacing: AppSpacing.md) {
            Button {
                goToIdentityScreen = true
            } label: {
                Text("Start Verification")
            }
            .buttonStyle(PrimaryCTAButtonStyle())

            Button {
                print("Save & complete later tapped")
            } label: {
                Text("Save & complete later")
                    .font(AppFont.button())
                    .foregroundStyle(Color.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
        }
        .padding(.top, 4)
    }
}

private struct ProfileStep {
    let title: String
    let icon: String
}

#Preview {
    NavigationStack {
        CompleteProfileView()
    }
}
