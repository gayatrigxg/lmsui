import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var router: Router
    let userName = "Akshita Panda"
    let userPhone = "+91 98765 43210"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Profile Header
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.mainBlue.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(Text(userName.prefix(1)).font(.system(size: 40, weight: .bold)).foregroundColor(.mainBlue))
                        
                        Circle()
                            .fill(Color.mainBlue)
                            .frame(width: 32, height: 32)
                            .overlay(Image(systemName: "camera.fill").font(.caption).foregroundColor(.white))
                            .offset(x: -4, y: -4)
                    }
                    
                    VStack(spacing: 4) {
                        Text(userName).font(.title2).bold()
                        Text(userPhone).font(.subheadline).foregroundColor(.secondary)
                    }
                    
                    Button {
                        router.push(.editProfile)
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline).bold()
                            .foregroundColor(.mainBlue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.lightBlue)
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 20)
                
                // Menu Options
                VStack(spacing: 0) {
                    ProfileMenuRow(icon: "checkmark.shield.fill", title: "KYC Status", value: "Verified", valueColor: Color(hex: "#00C48C")) { router.push(.kycStatus) }
                    Divider().padding(.leading, 56)
                    ProfileMenuRow(icon: "clock.arrow.circlepath", title: "Loan History") { router.push(.loanHistory) }
                    Divider().padding(.leading, 56)
                    ProfileMenuRow(icon: "gearshape.fill", title: "Settings") { router.push(.settings) }
                    Divider().padding(.leading, 56)
                    ProfileMenuRow(icon: "questionmark.circle.fill", title: "Help & Support") { router.push(.chatList) }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 20)
                
                // Logout
                Button {
                    // Handle Logout Action
                } label: {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.alertRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    var value: String? = nil
    var valueColor: Color = .secondary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.mainBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let val = value {
                    Text(val)
                        .font(.subheadline).bold()
                        .foregroundColor(valueColor)
                }
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(16)
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @EnvironmentObject var router: Router
    @State private var name = "Akshita Panda"
    @State private var email = "akshita@example.com"
    @State private var phone = "+91 98765 43210"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name").font(.caption).foregroundColor(.secondary)
                        TextField("Name", text: $name)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address").font(.caption).foregroundColor(.secondary)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number").font(.caption).foregroundColor(.secondary)
                        TextField("Phone", text: $phone)
                            .keyboardType(.phonePad)
                            .disabled(true) // Phone usually requires OTP to change
                            .padding()
                            .background(Color.secondary.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text("Phone number can only be changed via Support.").font(.caption2).foregroundColor(.secondary)
                    }
                }
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Button {
                    router.pop()
                } label: {
                    Text("Save Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.mainBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
