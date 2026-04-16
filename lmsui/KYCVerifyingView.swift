import SwiftUI

struct KYCVerifyingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var contentVisible = false
    @State private var showSuccessScreen = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.blue)
                    .scaleEffect(1.25)
                    .frame(width: 64, height: 64)
                    .accessibilityLabel("Verification in progress")

                VStack(spacing: 10) {
                    Text("Verifying your documents")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("This usually takes a few seconds. Please don’t close the app.")
                        .font(.system(size: 17))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Your documents are securely encrypted")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.blue)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
            .opacity(contentVisible ? 1 : 0)
            .offset(y: contentVisible ? 0 : 10)

            Spacer()
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showSuccessScreen) {
            KYCVerificationSuccessView {
                showSuccessScreen = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
            }
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
