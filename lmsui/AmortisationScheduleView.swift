import SwiftUI
import Charts
import Combine // <-- This fixes the ObservableObject error!

struct AmortisationMonth: Identifiable {
    let id = UUID()
    let monthIndex: Int
    let principalPaid: Double
    let interestPaid: Double
    let balance: Double
}

class AmortisationViewModel: ObservableObject {
    @Published var schedule: [AmortisationMonth] = []
    
    init() { generateDummySchedule() }
    
    func generateDummySchedule() {
        var bal = 312000.0
        let emi = 14200.0
        var temp: [AmortisationMonth] = []
        
        for i in 1...18 {
            let interest = bal * (10.5 / 12 / 100)
            let principal = emi - interest
            bal -= principal
            if bal < 0 { bal = 0 }
            
            temp.append(AmortisationMonth(monthIndex: i, principalPaid: principal, interestPaid: interest, balance: bal))
        }
        self.schedule = temp
    }
}

struct AmortisationScheduleView: View {
    @StateObject var viewModel = AmortisationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amortisation Schedule")
                        .font(.title2).bold()
                    Text("Your projected payoff timeline over the next 18 months.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Visual Chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Balance Over Time")
                        .font(.headline)
                    
                    Chart {
                        ForEach(viewModel.schedule) { item in
                            AreaMark(
                                x: .value("Month", item.monthIndex),
                                y: .value("Balance", item.balance)
                            )
                            .foregroundStyle(LinearGradient(colors: [.mainBlue.opacity(0.5), .lightBlue.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                            
                            LineMark(
                                x: .value("Month", item.monthIndex),
                                y: .value("Balance", item.balance)
                            )
                            .foregroundStyle(Color.mainBlue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                        }
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 6))
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // Detailed Table Header
                HStack {
                    Text("Month").frame(width: 50, alignment: .leading)
                    Spacer()
                    Text("Principal").frame(width: 80, alignment: .trailing)
                    Spacer()
                    Text("Interest").frame(width: 70, alignment: .trailing)
                    Spacer()
                    Text("Balance").frame(width: 90, alignment: .trailing)
                }
                .font(.caption).bold()
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                
                // Table Rows
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.schedule) { month in
                        HStack {
                            Text("M\(month.monthIndex)")
                                .font(.subheadline).bold()
                                .foregroundColor(.mainBlue)
                                .frame(width: 50, alignment: .leading)
                            Spacer()
                            Text("₹\(month.principalPaid.formatted(.number.notation(.compactName)))")
                                .frame(width: 80, alignment: .trailing)
                            Spacer()
                            Text("₹\(month.interestPaid.formatted(.number.notation(.compactName)))")
                                .foregroundColor(.alertRed)
                                .frame(width: 70, alignment: .trailing)
                            Spacer()
                            Text("₹\(month.balance.formatted(.number.notation(.compactName)))")
                                .fontWeight(.semibold)
                                .frame(width: 90, alignment: .trailing)
                        }
                        .font(.subheadline)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        
                        Divider().padding(.leading, 20)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AmortisationScheduleView()
}
