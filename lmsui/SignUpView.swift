import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var emailOrPhone = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var goToCompleteProfile = false
    @State private var goToSignIn = false

    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password.count >= 6
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    brandSection
                    progressSection
                    headerSection
                    formSection
                    primaryAction
                    secondaryAction
                    trustSection
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, 20)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $goToCompleteProfile) {
            CompleteProfileView()
        }
        .navigationDestination(isPresented: $goToSignIn) {
            SignInView()
        }
    }

    private var brandSection: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.primaryBlue)
                    .frame(width: 44, height: 44)

                Image(systemName: "building.columns.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("LoanOS")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.textPrimary)

                Text("Borrower Portal")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.top, 8)
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.dividerLight)
                        .frame(height: 4)

                    Capsule()
                        .fill(Color.primaryBlue)
                        .frame(width: geometry.size.width * 0.25, height: 4)
                }
            }
            .frame(height: 4)

            Text("Step 1 of 4")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.textSecondary)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("New Account")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.primaryBlue)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.primaryBlue.opacity(0.10))
                .clipShape(Capsule())

            Text("Create your\nborrower account")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .lineSpacing(2)

            Text("Apply for loans, track repayments, and manage your finances.")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var formSection: some View {
        VStack(spacing: 14) {
            authField(
                icon: "person.fill",
                placeholder: "Full Name",
                text: $fullName
            )

            authField(
                icon: "envelope.fill",
                placeholder: "Email or Mobile Number",
                text: $emailOrPhone
            )

            passwordField
        }
    }

    private func authField(
        icon: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 18)

            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.dividerLight, lineWidth: 1)
        )
        .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 3)
    }

    private var passwordField: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 18)

            Group {
                if showPassword {
                    TextField("Create Password", text: $password)
                } else {
                    SecureField("Create Password", text: $password)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Color.textPrimary)

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.dividerLight, lineWidth: 1)
        )
        .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 3)
    }

    private var primaryAction: some View {
        Button {
            goToCompleteProfile = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 16, weight: .semibold))

                Text("Create Account")

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 18)
        }
        .buttonStyle(PrimaryCTAButtonStyle())
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1 : 0.5)
    }

    private var secondaryAction: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.textSecondary)

            Button {
                goToSignIn = true
            } label: {
                Text("Sign In")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.primaryBlue)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var trustSection: some View {
        HStack {
            trustItem(icon: "lock.shield", label: "256-bit SSL")
            Spacer()
            trustItem(icon: "checkmark.seal", label: "RBI Compliant")
            Spacer()
            trustItem(icon: "hand.raised", label: "No Spam")
        }
        .padding(.top, 8)
    }

    private func trustItem(icon: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.primaryBlue.opacity(0.75))

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
