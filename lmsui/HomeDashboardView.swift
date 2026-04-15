import SwiftUI
import Combine

// MARK: - Main Home View
struct HomeDashboardView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = HomeDashboardViewModel()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {

                // ── 1. HEADER ──────────────────────────────────
                HeaderView(userName: viewModel.userName)

                // ── 2. LOAN SUMMARY CARD ────────
                Button {
                    router.push(.activeLoanDetails)
                } label: {
                    LoanSummaryCardView(loan: viewModel.activeLoan)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.top, 24)

                // ── 3. NEXT EMI BANNER ─────────────────────────
                NextEMIBannerView(emi: viewModel.nextEMI)
                    .padding(.horizontal, 20)
                    .padding(.top, 18)

                // ── 4. ALERTS ──────────────────────────────────
                if !viewModel.alerts.isEmpty {
                    AlertsRowView(alerts: viewModel.alerts)
                        .padding(.top, 18)
                }

                // ── 5. QUICK ACTIONS ───────────────────────────
                QuickActionsGridView(actions: viewModel.quickActions)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                // ── 6. CREDIBILITY SCORE ───────
                Button {
                    router.push(.credibilityOverview)
                } label: {
                    CredibilityScoreCardView(score: viewModel.credibilityScore)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.lightBlue.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - 1. Header
struct HeaderView: View {
    let userName: String
    @EnvironmentObject var router: Router // Added to access navigation

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.mainBlue, .secondaryBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(edges: .top)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Good Morning,")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.80))
                    Text(userName)
                        .font(.title).bold()
                        .foregroundColor(.white)
                }
                Spacer()

                // WIRED: Notification Bell
                Button(action: {
                    router.push(.notifications)
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill").font(.title2).foregroundColor(.white)
                        Circle().fill(Color.alertRed).frame(width: 10, height: 10).offset(x: 3, y: -3)
                    }
                }

                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 48, height: 48)
                    .overlay(Text(userName.prefix(1)).font(.title3).bold().foregroundColor(.white))
                    .padding(.leading, 16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 22)
        }
        .frame(height: 130)
    }
}

// MARK: - 2. Loan Summary Card (Unchanged)
struct LoanSummaryCardView: View {
    let loan: LoanSummary

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Active Loan")
                    .font(.subheadline).bold()
                    .foregroundColor(.secondaryBlue)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.lightBlue)
                    .clipShape(Capsule())
                Spacer()
                Text("Manage →").font(.subheadline).foregroundColor(.mainBlue)
            }
            .padding(.bottom, 18)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Outstanding Balance").font(.subheadline).foregroundColor(.secondary)
                    Text("₹\(loan.outstandingBalance, specifier: "%.0f")").font(.system(size: 34, weight: .bold)).foregroundColor(.mainBlue)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total Loan").font(.subheadline).foregroundColor(.secondary)
                    Text("₹\(loan.totalAmount, specifier: "%.0f")").font(.title3).bold().foregroundColor(.primary)
                }
            }
            .padding(.bottom, 18)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6).fill(Color.lightBlue).frame(height: 12)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(LinearGradient(colors: [.mainBlue, .secondaryBlue], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * loan.repaidFraction, height: 12)
                }
            }
            .frame(height: 12)
            .padding(.bottom, 10)

            HStack {
                Text("\(Int(loan.repaidFraction * 100))% repaid").font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text("\(loan.remainingEMIs) EMIs left").font(.subheadline).foregroundColor(.secondary)
            }
        }
        .padding(22)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 5)
    }
}

// MARK: - 3. Next EMI Banner (Unchanged)
struct NextEMIBannerView: View {
    let emi: NextEMIInfo
    @EnvironmentObject var router: Router

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(emi.isUrgent ? Color.alertRed.opacity(0.12) : Color.mainBlue.opacity(0.10))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: emi.isUrgent ? "exclamationmark.circle.fill" : "calendar.badge.clock").font(.body).foregroundColor(emi.isUrgent ? .alertRed : .mainBlue))

            VStack(alignment: .leading, spacing: 2) {
                Text("Next EMI").font(.caption).foregroundColor(.secondary).lineLimit(1)
                Text(emi.dueDate).font(.subheadline).bold().foregroundColor(emi.isUrgent ? .alertRed : .primary).lineLimit(1).minimumScaleFactor(0.8)
            }
            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 2) {
                Text("₹\(emi.amount.formatted(.number.grouping(.automatic)))").font(.subheadline).bold().foregroundColor(.mainBlue).lineLimit(1).minimumScaleFactor(0.8).fixedSize(horizontal: true, vertical: false)
                Text(emi.daysLeft).font(.caption2).foregroundColor(emi.isUrgent ? .alertRed : .secondary).lineLimit(1)
            }

            Button {
                router.push(.paymentCheckout(amount: emi.amount))
            } label: {
                Text("Pay Now").font(.caption).bold().foregroundColor(.white).padding(.horizontal, 12).padding(.vertical, 8).background(Color.mainBlue).clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(emi.isUrgent ? Color.alertRed.opacity(0.4) : Color.clear, lineWidth: 1.5))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

// MARK: - 4. Alerts Row (Unchanged)
struct AlertsRowView: View {
    let alerts: [AlertItem]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Alerts & Reminders").font(.headline).foregroundColor(.secondary).padding(.horizontal, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(alerts) { alert in AlertChipView(alert: alert) }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct AlertChipView: View {
    let alert: AlertItem
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: alert.icon).font(.subheadline).foregroundColor(alert.isWarning ? .alertRed : .mainBlue)
            Text(alert.message).font(.subheadline).foregroundColor(.primary).lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(alert.isWarning ? Color.alertRed.opacity(0.08) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(alert.isWarning ? Color.alertRed.opacity(0.35) : Color.secondaryBlue.opacity(0.25), lineWidth: 1.2))
    }
}

// MARK: - 5. Quick Actions Grid
struct QuickActionsGridView: View {
    let actions: [QuickAction]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions").font(.title3).bold().foregroundColor(.primary)
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(actions) { action in QuickActionItemView(action: action) }
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

struct QuickActionItemView: View {
    let action: QuickAction
    @EnvironmentObject var router: Router

    var body: some View {
        Button {
            // ALL BUTTONS ARE NOW WIRED! 🎉
            if action.label == "Pay EMI" {
                router.push(.repaymentDashboard)
            } else if action.label == "History" {
                router.push(.repaymentsList(initialTab: 1))
            } else if action.label == "Statement" {
                router.push(.statementDownload)
            } else if action.label == "Support" {
                router.push(.chatList)
            } else if action.label == "Schedule" {
                router.push(.amortisationSchedule)
            } else if action.label == "Foreclose" {
                router.push(.outstandingBalance)
            } else if action.label == "Reminders" {
                router.push(.notifications)
            } else if action.label == "Analytics" {
                router.push(.costBreakdown)
            }
        } label: {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 16).fill(Color.lightBlue).frame(width: 64, height: 64)
                    .overlay(Image(systemName: action.icon).font(.title2).foregroundColor(.mainBlue))
                Text(action.label).font(.caption).multilineTextAlignment(.center).foregroundColor(.primary).lineLimit(2)
            }
        }
    }
}

// MARK: - 6. Credibility Score Card (Unchanged)
struct CredibilityScoreCardView: View {
    let score: Int
    private var scoreColor: Color {
        switch score { case 750...: return Color(hex: "#00C48C"); case 600..<750: return Color.secondaryBlue; default: return Color.alertRed }
    }
    private var scoreLabel: String {
        switch score { case 750...: return "Excellent"; case 650..<750: return "Good"; case 500..<650: return "Fair"; default: return "Poor" }
    }
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle().stroke(Color.lightBlue, lineWidth: 10).frame(width: 90, height: 90)
                Circle().trim(from: 0, to: CGFloat(score) / 900).stroke(scoreColor, style: StrokeStyle(lineWidth: 10, lineCap: .round)).frame(width: 90, height: 90).rotationEffect(.degrees(-90))
                VStack(spacing: 1) {
                    Text("\(score)").font(.title3).bold().foregroundColor(scoreColor)
                    Text("/ 900").font(.caption).foregroundColor(.secondary)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Credibility Score").font(.headline).foregroundColor(.primary)
                Text(scoreLabel).font(.subheadline).bold().foregroundColor(scoreColor).padding(.horizontal, 12).padding(.vertical, 5).background(scoreColor.opacity(0.12)).clipShape(Capsule())
                Text("Updated today").font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.title3).foregroundColor(.secondary)
        }
        .padding(22)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 5)
    }
}

// MARK: - Models & ViewModel
struct LoanSummary { let totalAmount: Double; let outstandingBalance: Double; var repaidFraction: Double { 1 - (outstandingBalance / totalAmount) }; let remainingEMIs: Int }
struct NextEMIInfo { let amount: Double; let dueDate: String; let daysLeft: String; let isUrgent: Bool }
struct AlertItem: Identifiable { let id = UUID(); let icon: String; let message: String; let isWarning: Bool }
struct QuickAction: Identifiable { let id = UUID(); let icon: String; let label: String }

class HomeDashboardViewModel: ObservableObject {
    let userName = "Akshita Panda"
    let activeLoan = LoanSummary(totalAmount: 500000, outstandingBalance: 312000, remainingEMIs: 18)
    let nextEMI = NextEMIInfo(amount: 14200, dueDate: "20 Apr 2026", daysLeft: "6 days left", isUrgent: true)
    let credibilityScore = 724
    let alerts: [AlertItem] = [
        AlertItem(icon: "exclamationmark.triangle.fill", message: "EMI due in 6 days", isWarning: true),
        AlertItem(icon: "doc.text.fill", message: "Statement ready", isWarning: false)
    ]
    let quickActions: [QuickAction] = [
        QuickAction(icon: "indianrupeesign.circle.fill", label: "Pay EMI"),
        QuickAction(icon: "clock.arrow.circlepath", label: "History"),
        QuickAction(icon: "doc.plaintext.fill", label: "Statement"),
        QuickAction(icon: "headset", label: "Support"),
        QuickAction(icon: "calendar", label: "Schedule"),
        QuickAction(icon: "arrow.left.arrow.right", label: "Foreclose"),
        QuickAction(icon: "bell.badge.fill", label: "Reminders"),
        QuickAction(icon: "chart.bar.fill", label: "Analytics")
    ]
}

#Preview {
    TabView {
        HomeDashboardView()
            .environmentObject(Router())
            .tabItem { Image(systemName: "house.fill"); Text("Home") }
    }
    .accentColor(Color.mainBlue)
}
