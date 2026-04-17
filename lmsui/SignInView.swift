import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var emailOrPhone = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var goToCompleteProfile = false
    @State private var goToSignUp = false

    private var isFormValid: Bool {
        !emailOrPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    topBar
                    brandSection
                    headerSection
                    formSection
                    forgotPasswordButton
                    primaryAction
                    secondaryAction
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
        .navigationDestination(isPresented: $goToSignUp) {
            SignUpView()
        }
    }

    private var topBar: some View {
        Button {
            dismiss()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .shadow(color: Color.shadowColor, radius: 6, x: 0, y: 2)

                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.secondaryBlue)
            }
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
        .padding(.top, 4)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome back")
                .font(.system(size: 38, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text("Sign in to continue your application and manage your loan journey.")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var formSection: some View {
        VStack(spacing: 14) {
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
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
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

    private var forgotPasswordButton: some View {
        Button {
        } label: {
            Text("Forgot Password?")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.primaryBlue)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var primaryAction: some View {
        Button {
            goToCompleteProfile = true
        } label: {
            HStack(spacing: 10) {
                Text("Sign In")

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
            Text("Don’t have an account?")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.textSecondary)

            Button {
                goToSignUp = true
            } label: {
                Text("Create One")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.primaryBlue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInView()
        }
    }
}
