import SwiftUI

struct RepaymentsListView: View {
    @State var selectedTab: Int // 0 = Upcoming, 1 = History
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Segmented Picker
            HStack(spacing: 0) {
                SegmentButton(title: "Upcoming", isSelected: selectedTab == 0) { selectedTab = 0 }
                SegmentButton(title: "History", isSelected: selectedTab == 1) { selectedTab = 1 }
            }
            .padding(4)
            .background(Color(UIColor.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            ScrollView {
                VStack(spacing: 12) {
                    if selectedTab == 0 {
                        // Upcoming List
                        EMIListItem(month: "May", date: "20 May 2026", amount: 14200, status: .upcoming)
                        EMIListItem(month: "Jun", date: "20 Jun 2026", amount: 14200, status: .upcoming)
                        EMIListItem(month: "Jul", date: "20 Jul 2026", amount: 14200, status: .upcoming)
                        EMIListItem(month: "Aug", date: "20 Aug 2026", amount: 14200, status: .upcoming)
                    } else {
                        // History List
                        EMIListItem(month: "Mar", date: "18 Mar 2026", amount: 14200, status: .paid)
                        EMIListItem(month: "Feb", date: "19 Feb 2026", amount: 14200, status: .paid)
                        EMIListItem(month: "Jan", date: "20 Jan 2026", amount: 14200, status: .paid)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

enum EMIStatus { case upcoming, paid, overdue }

struct EMIListItem: View {
    let month: String
    let date: String
    let amount: Double
    let status: EMIStatus
    
    var body: some View {
        HStack(spacing: 16) {
            // Month Icon
            VStack {
                Text(month.uppercased())
                    .font(.caption2).bold()
                    .foregroundColor(status == .paid ? .white : .mainBlue)
            }
            .frame(width: 48, height: 48)
            .background(status == .paid ? Color(hex: "#00C48C") : Color.lightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(date)
                    .font(.headline)
                Text(status == .paid ? "Payment Successful" : "Scheduled EMI")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("₹\(amount.formatted(.number.grouping(.automatic)))")
                    .font(.subheadline).bold()
                
                if status == .paid {
                    Text("Paid")
                        .font(.caption2).bold()
                        .foregroundColor(Color(hex: "#00C48C"))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color(hex: "#00C48C").opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline).bold()
                .foregroundColor(isSelected ? .mainBlue : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color.white : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: isSelected ? .black.opacity(0.05) : .clear, radius: 4, x: 0, y: 2)
        }
    }
}
