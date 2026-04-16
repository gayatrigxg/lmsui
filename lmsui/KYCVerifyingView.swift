import SwiftUI

struct KYCVerifyingView: View {
    @State private var contentVisible = false
    @State private var showSuccessScreen = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.primaryBlue)
                    .scaleEffect(1.35)
                    .frame(width: 72, height: 72)
                    .accessibilityLabel("Verification in progress")

                VStack(spacing: 12) {
                    Text("Verifying your documents")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(Color.secondaryBlue)
                        .multilineTextAlignment(.center)

                    Text("This usually takes a few seconds. Please don’t close the app.")
                        .font(AppFont.body())
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Your documents are securely encrypted")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.primaryBlue.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
            .opacity(contentVisible ? 1 : 0)
            .offset(y: contentVisible ? 0 : 10)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showSuccessScreen) {
            KYCVerificationSuccessView()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.35)) {
                contentVisible = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                showSuccessScreen = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        KYCVerifyingView()
    }
}
