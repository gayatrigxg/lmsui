import SwiftUI
import Combine

// MARK: - View Model
class LoanComparisonViewModel: ObservableObject {
    @Published var loanAmount: Double = 500000
    @Published var tenureMonths: Double = 60
    
    // Example Rates based on the selected loan
    let fixedRate: Double = 10.5
    let floatingRate: Double = 9.5 // Floating starts lower but carries market risk
    
    func calculateEMI(rate: Double) -> Double {
        let r = (rate / 12) / 100
        let n = tenureMonths
        return (loanAmount * r * pow(1 + r, n)) / (pow(1 + r, n) - 1)
    }
    
    func calculateTotalInterest(rate: Double) -> Double {
        let emi = calculateEMI(rate: rate)
        return (emi * tenureMonths) - loanAmount
    }
}

// MARK: - Main View
struct LoanComparisonView: View {
    let loan: LoanProduct
    @StateObject var viewModel = LoanComparisonViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Compare Rates")
                        .font(.largeTitle).bold()
                    Text("Fixed vs. Floating rates for \(loan.title).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Interactive Controls
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Loan Amount")
                                .font(.subheadline).foregroundColor(.secondary)
                            Spacer()
                            Text("₹\(viewModel.loanAmount.formatted(.number.grouping(.automatic)))")
                                .font(.headline).bold()
                        }
                        Slider(value: $viewModel.loanAmount, in: 50000...loan.maxAmount, step: 10000)
                            .accentColor(.mainBlue)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Tenure")
                                .font(.subheadline).foregroundColor(.secondary)
                            Spacer()
                            Text("\(Int(viewModel.tenureMonths)) Months")
                                .font(.headline).bold()
                        }
                        Slider(value: $viewModel.tenureMonths, in: Double(loan.minTenure)...Double(loan.maxTenure), step: 6)
                            .accentColor(.secondaryBlue)
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // Side-by-Side Comparison
                HStack(spacing: 16) {
                    // Fixed Rate Column
                    ComparisonCard(
                        title: "Fixed Rate",
                        rate: viewModel.fixedRate,
                        emi: viewModel.calculateEMI(rate: viewModel.fixedRate),
                        totalInterest: viewModel.calculateTotalInterest(rate: viewModel.fixedRate),
                        color: .mainBlue,
                        description: "EMI remains constant throughout the tenure. Safe from market hikes."
                    )
                    
                    // Floating Rate Column
                    ComparisonCard(
                        title: "Floating Rate",
                        rate: viewModel.floatingRate,
                        emi: viewModel.calculateEMI(rate: viewModel.floatingRate),
                        totalInterest: viewModel.calculateTotalInterest(rate: viewModel.floatingRate),
                        color: Color(hex: "#00C48C"),
                        description: "Starts lower. EMI fluctuates based on RBI repo rate changes."
                    )
                }
                .padding(.horizontal, 20)
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subcomponents
struct ComparisonCard: View {
    let title: String
    let rate: Double
    let emi: Double
    let totalInterest: Double
    let color: Color
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Interest Rate")
                    .font(.caption).foregroundColor(.secondary)
                Text(String(format: "%.1f%% p.a.", rate))
                    .font(.title3).bold()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Estimated EMI")
                    .font(.caption).foregroundColor(.secondary)
                Text("₹\(emi.formatted(.number.grouping(.automatic).precision(.fractionLength(0))))")
                    .font(.headline).bold()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Total Interest")
                    .font(.caption).foregroundColor(.secondary)
                Text("₹\(totalInterest.formatted(.number.grouping(.automatic).precision(.fractionLength(0))))")
                    .font(.headline).bold()
            }
            
            Divider()
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(4)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.3), lineWidth: 1.5))
    }
}

#Preview {
    NavigationStack {
        LoanComparisonView(loan: LoanProduct(title: "Personal Loan", icon: "person", maxAmount: 500000, interestRate: "10.5%", minTenure: 6, maxTenure: 60, tags: []))
    }
}
