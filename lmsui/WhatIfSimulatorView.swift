import SwiftUI
import Combine

class WhatIfViewModel: ObservableObject {
    @Published var extraEmiAmount: Double = 2000
    
    let currentEmi: Double = 14200
    
    var newTotalEmi: Double {
        currentEmi + extraEmiAmount
    }
    
    var monthsSaved: Int {
        // Simplified dummy calculation
        Int(extraEmiAmount / 1500)
    }
    
    var totalInterestSaved: Double {
        // Simplified dummy calculation
        Double(monthsSaved) * 4500
    }
}

struct WhatIfSimulatorView: View {
    @StateObject var viewModel = WhatIfViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("What-If Simulator")
                        .font(.largeTitle).bold()
                    Text("What if you increased your monthly EMI?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Extra EMI Input
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Add to Monthly EMI")
                            .font(.headline)
                        Spacer()
                        Text("+ ₹\(viewModel.extraEmiAmount.formatted(.number.grouping(.automatic)))")
                            .font(.title2).bold()
                            .foregroundColor(.secondaryBlue)
                    }
                    
                    Slider(value: $viewModel.extraEmiAmount, in: 500...10000, step: 500)
                        .accentColor(.secondaryBlue)
                    
                    HStack {
                        Text("Current: ₹\(viewModel.currentEmi.formatted(.number.grouping(.automatic)))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("New: ₹\(viewModel.newTotalEmi.formatted(.number.grouping(.automatic)))")
                            .font(.subheadline).bold()
                            .foregroundColor(.mainBlue)
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // Results Graph/Card
                VStack(spacing: 20) {
                    Text("By increasing your EMI, you will...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("Save")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.monthsSaved)")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.mainBlue)
                            Text("Months")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        VStack(spacing: 8) {
                            Text("Save")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("₹\(viewModel.totalInterestSaved.formatted(.number.notation(.compactName)))")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(Color(hex: "#00C48C"))
                            Text("Interest")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
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

#Preview {
    WhatIfSimulatorView()
}
