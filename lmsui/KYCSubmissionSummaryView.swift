import SwiftUI

struct KYCSubmissionSummaryView: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("KYC Summary")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.secondaryBlue)

                Text("Next screen placeholder")
                    .font(AppFont.body())
                    .foregroundStyle(Color.textSecondary)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        KYCSubmissionSummaryView()
    }
}
