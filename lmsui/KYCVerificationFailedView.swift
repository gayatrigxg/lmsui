import SwiftUI

struct KYCVerificationFailedView: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.accentRed.opacity(0.12))
                        .frame(width: 96, height: 96)

                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 56, weight: .semibold))
                        .foregroundStyle(Color.accentRed)
                }

                VStack(spacing: 12) {
                    Text("Verification Failed")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(Color.accentRed)
                        .multilineTextAlignment(.center)

                    Text("Document was unclear or incomplete")
                        .font(AppFont.body())
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button {
                    print("Re-upload Documents tapped")
                } label: {
                    Text("Re-upload Documents")
                }
                .buttonStyle(PrimaryCTAButtonStyle())
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
    }
}

struct KYCVerificationFailedView_Previews: PreviewProvider {
    static var previews: some View {
        KYCVerificationFailedView()
    }
}
