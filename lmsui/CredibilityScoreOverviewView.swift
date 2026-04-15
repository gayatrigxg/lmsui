import SwiftUI

struct CredibilityScoreOverviewView: View {
    @EnvironmentObject var router: Router
    let score: Int = 724
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Credibility Score")
                        .font(.largeTitle).bold()
                    Text("Your financial health snapshot.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Huge Gauge Card
                VStack(spacing: 20) {
                    ZStack {
                        // Background Track
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(Color.lightBlue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(135))
                        
                        // Score Track
                        Circle()
                            .trim(from: 0, to: CGFloat(score) / 900 * 0.75)
                            .stroke(Color.secondaryBlue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(135))
                        
                        VStack(spacing: 4) {
                            Text("\(score)")
                                .font(.system(size: 56, weight: .bold))
                                .foregroundColor(.mainBlue)
                            Text("Good")
                                .font(.headline)
                                .foregroundColor(.secondaryBlue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.lightBlue)
                                .clipShape(Capsule())
                        }
                        .offset(y: -10)
                    }
                    .padding(.top, 20)
                    
                    Text("Your score is looking great! Just 26 more points to unlock Excellent tier benefits.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
                .padding(.horizontal, 20)
                
                // Navigation Tiles
                VStack(spacing: 16) {
                    ScoreActionTile(icon: "list.clipboard.fill", title: "Score Breakdown & Tips", subtitle: "See what is affecting your score") {
                        router.push(.scoreBreakdown)
                    }
                    ScoreActionTile(icon: "chart.xyaxis.line", title: "Score History", subtitle: "Track your progress over time") {
                        router.push(.scoreHistory)
                    }
                    ScoreActionTile(icon: "gift.fill", title: "Benefits Unlocked", subtitle: "View your tier rewards", iconColor: Color(hex: "#00C48C")) {
                        router.push(.benefitsUnlocked)
                    }
                }
                .padding(.horizontal, 20)
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ScoreActionTile: View {
    let icon: String
    let title: String
    let subtitle: String
    var iconColor: Color = .mainBlue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 48, height: 48)
                    .background(iconColor.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
    }
}
