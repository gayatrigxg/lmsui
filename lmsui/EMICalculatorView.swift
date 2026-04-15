import SwiftUI
import Combine

class EMICalculatorViewModel: ObservableObject {
    @Published var loanAmount: Double = 150000
    @Published var tenureMonths: Double = 24
    @Published var interestRate: Double = 10.5
    
    var estimatedEMI: Double {
        let r = (interestRate / 12) / 100
        let n = tenureMonths
        return (loanAmount * r * pow(1 + r, n)) / (pow(1 + r, n) - 1)
    }
    
    var totalInterest: Double {
        (estimatedEMI * tenureMonths) - loanAmount
    }
}

struct EMICalculatorView: View {
    @StateObject var viewModel = EMICalculatorViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("EMI Calculator")
                        .font(.largeTitle).bold()
                    Text("Plan your loan by adjusting the parameters below.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 1. Amount Slider
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Loan Amount")
                            .font(.headline)
                        Spacer()
                        Text("₹\(viewModel.loanAmount.formatted(.number.grouping(.automatic)))")
                            .font(.title2).bold()
                            .foregroundColor(.mainBlue)
                    }
                    Slider(value: $viewModel.loanAmount, in: 10000...1000000, step: 10000)
                        .accentColor(.mainBlue)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // 2. Tenure Slider
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Tenure (Months)")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(viewModel.tenureMonths)) Mos")
                            .font(.title2).bold()
                            .foregroundColor(.secondaryBlue)
                    }
                    Slider(value: $viewModel.tenureMonths, in: 6...60, step: 3)
                        .accentColor(.secondaryBlue)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // 3. Interest Rate Slider
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Interest Rate")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.1f%% p.a.", viewModel.interestRate))
                            .font(.title2).bold()
                            .foregroundColor(.alertRed)
                    }
                    Slider(value: $viewModel.interestRate, in: 8.0...18.0, step: 0.5)
                        .accentColor(.alertRed)
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // 4. Results Card
                VStack(spacing: 16) {
                    Text("Your Monthly EMI")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("₹\(viewModel.estimatedEMI.formatted(.number.grouping(.automatic)))")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.mainBlue)
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Principal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("₹\(viewModel.loanAmount.formatted(.number.grouping(.automatic)))")
                                .font(.subheadline).bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Total Interest")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("₹\(viewModel.totalInterest.formatted(.number.grouping(.automatic)))")
                                .font(.subheadline).bold()
                        }
                    }
                }
                .padding(24)
                .background(Color.lightBlue.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.mainBlue.opacity(0.2), lineWidth: 1))
                .padding(.horizontal, 20)
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EMICalculatorView()
}
