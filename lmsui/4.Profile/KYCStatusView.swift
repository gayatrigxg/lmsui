import SwiftUI

struct KYCStatusView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Status Banner
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "#00C48C"))
                    
                    Text("KYC Verified")
                        .font(.title2).bold()
                    Text("Your identity has been fully verified. You are eligible for instant loan disbursals.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Documents History
                VStack(alignment: .leading, spacing: 16) {
                    Text("Verified Documents")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 0) {
                        KYCDocRow(title: "PAN Card", docID: "ABCDE1234F", date: "Verified on 12 Jan 2025")
                        Divider().padding(.leading, 20)
                        KYCDocRow(title: "Aadhaar Card", docID: "XXXX XXXX 1234", date: "Verified on 12 Jan 2025")
                        Divider().padding(.leading, 20)
                        KYCDocRow(title: "Bank Account", docID: "HDFC Bank •••• 4567", date: "Verified on 14 Jan 2025")
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                    .padding(.horizontal, 20)
                }
                
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("KYC Status")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct KYCDocRow: View {
    let title: String
    let docID: String
    let date: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "doc.text.viewfinder")
                .font(.title2)
                .foregroundColor(.mainBlue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(docID).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: "checkmark.circle.fill").foregroundColor(Color(hex: "#00C48C"))
                Text("Verified").font(.caption2).bold().foregroundColor(Color(hex: "#00C48C"))
            }
        }
        .padding(16)
    }
}
