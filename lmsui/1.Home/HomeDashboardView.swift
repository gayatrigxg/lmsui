import SwiftUI
import Combine

// MARK: - Main Home View
struct HomeDashboardView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel = HomeDashboardViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.lightBlue.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── 1. HEADER (Fixed Background) ───────────────
                    HeaderView(userName: viewModel.userName)

                    // ── 2. LOAN SUMMARY CARDS (Paging Scroll) ──────
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(viewModel.activeLoans) { loan in
                                Button {
                                    router.push(.activeLoanDetails)
                                } label: {
                                    LoanSummaryCardView(loan: loan)
                                        .frame(width: UIScreen.main.bounds.width * 0.85)
                                }
                                .buttonStyle(PlainButtonStyle())
        
                            }
                        }
                        .scrollTargetLayout() // Tells the scroll view to snap to these items
                    }
                    .scrollTargetBehavior(.viewAligned) // Standard iOS horizontal snapping
                    .safeAreaPadding(.horizontal, 20)
                    .padding(.top, 24)

                    // ── 3. NEXT EMI BANNER ─────────────────────────
                    NextEMIBannerView(emi: viewModel.nextEMI)
                        .padding(.horizontal, 20)
                        .padding(.top, 18)

                    // ── 4. QUICK ACTIONS ───────────────────────────
                    QuickActionsGridView(actions: viewModel.quickActions)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    // ── 5. CREDIBILITY SCORE (With Inner Buttons) ──
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
        }
        .navigationBarHidden(true)
    }
}

// MARK: - 1. Header
struct HeaderView: View {
    let userName: String
    @EnvironmentObject var router: Router

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 1) {
                Text("Good Morning,")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.80))
                Text(userName)
                    .font(.title).bold()
                    .foregroundColor(.white)
            }
            Spacer()

            // Notification Bell
            Button(action: {
                router.push(.notifications)
            }) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill").font(.title2).foregroundColor(.white)
                    Circle().fill(Color.alertRed).frame(width: 10, height: 10).offset(x: 3, y: -3)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 22)
        .padding(.top, 60) // Pushes content down safely from the dynamic island/notch
        .background(
            LinearGradient(colors: [.mainBlue, .secondaryBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top) // Bleeds perfectly into the bezel without overlapping cards
        )
    }
}

// MARK: - 2. Loan Summary Card
struct LoanSummaryCardView: View {
    let loan: LoanSummary

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(loan.title)
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
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.mainBlue.opacity(0.3), lineWidth: 1.5))
        .shadow(color: Color.mainBlue.opacity(0.15), radius: 15, x: 0, y: 8)
    }
}

// MARK: - 3. Next EMI Banner
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
                Text("₹\(emi.amount.formatted(.number.grouping(.automatic)))")
                    .font(.subheadline).bold()
                    .foregroundColor(.mainBlue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: true, vertical: false)
                Text(emi.daysLeft).font(.caption2).foregroundColor(emi.isUrgent ? .alertRed : .secondary).lineLimit(1)
            }
            .padding(.trailing, 8)

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

// MARK: - 4. Quick Actions Grid
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
            if action.label == "AutoPay" { router.push(.autoPaySetup) }
            else if action.label == "Pay EMI" { router.push(.repaymentDashboard) }
            else if action.label == "History" { router.push(.repaymentsList(initialTab: 1)) }
            else if action.label == "Support" { router.push(.chatList) }
            else if action.label == "Schedule" { router.push(.amortisationSchedule) }
            else if action.label == "Foreclose" { router.push(.outstandingBalance) }
            else if action.label == "Statement" { router.push(.statementDownload) }
            else if action.label == "Analytics" { router.push(.costBreakdown) }
        } label: {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 16).fill(Color.lightBlue).frame(width: 64, height: 64)
                    .overlay(Image(systemName: action.icon).font(.title2).foregroundColor(.mainBlue))
                Text(action.label).font(.caption).multilineTextAlignment(.center).foregroundColor(.primary).lineLimit(2)
            }
        }
    }
}

// MARK: - 5. Credibility Score Card
struct CredibilityScoreCardView: View {
    let score: Int
    @EnvironmentObject var router: Router
    
    private var scoreColor: Color {
        switch score { case 750...: return Color(hex: "#00C48C"); case 600..<750: return Color.secondaryBlue; default: return Color.alertRed }
    }
    private var scoreLabel: String {
        switch score { case 750...: return "Excellent"; case 650..<750: return "Good"; case 500..<650: return "Fair"; default: return "Poor" }
    }
    var body: some View {
        VStack(spacing: 20) {
            // Top Section: Score Info
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
            
            Divider()
            
            // Bottom Section: Inner Buttons
            HStack(spacing: 12) {
                Button {
                    router.push(.scoreBreakdown)
                } label: {
                    HStack {
                        Image(systemName: "list.clipboard.fill")
                        Text("Breakdown")
                    }
                    .font(.subheadline).bold()
                    .foregroundColor(.mainBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.lightBlue.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    router.push(.scoreHistory)
                } label: {
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                        Text("History")
                    }
                    .font(.subheadline).bold()
                    .foregroundColor(.mainBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.lightBlue.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(22)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 5)
    }
}

// MARK: - Models & ViewModel
struct LoanSummary: Identifiable {
    let id: String
    let title: String
    let totalAmount: Double
    let outstandingBalance: Double
    var repaidFraction: Double { 1 - (outstandingBalance / totalAmount) }
    let remainingEMIs: Int
}
struct NextEMIInfo { let amount: Double; let dueDate: String; let daysLeft: String; let isUrgent: Bool }
struct QuickAction: Identifiable { let id = UUID(); let icon: String; let label: String }

class HomeDashboardViewModel: ObservableObject {
    let userName = "Akshita Panda"
    
    let activeLoans: [LoanSummary] = [
        LoanSummary(id: "1", title: "Personal Loan", totalAmount: 500000, outstandingBalance: 312000, remainingEMIs: 18),
        LoanSummary(id: "2", title: "Auto Loan", totalAmount: 850000, outstandingBalance: 720000, remainingEMIs: 48)
    ]
    
    let nextEMI = NextEMIInfo(amount: 14200, dueDate: "20 Apr 2026", daysLeft: "6 days left", isUrgent: true)
    let credibilityScore = 724
    
    let quickActions: [QuickAction] = [
        QuickAction(icon: "arrow.triangle.2.circlepath", label: "AutoPay"),
        QuickAction(icon: "indianrupeesign.circle.fill", label: "Pay EMI"),
        QuickAction(icon: "clock.arrow.circlepath", label: "History"),
        QuickAction(icon: "headset", label: "Support"),
        QuickAction(icon: "calendar", label: "Schedule"),
        QuickAction(icon: "arrow.left.arrow.right", label: "Foreclose"),
        QuickAction(icon: "doc.plaintext.fill", label: "Statement"),
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
