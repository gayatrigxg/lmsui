import SwiftUI

struct CompleteProfileView: View {
    @State private var goToProfileDetails = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            VStack(spacing: 34) {
                heroSection
                detailsSection
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)

            bottomBar
        }
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $goToProfileDetails) {
            BorrowerPersonalDetailsView()
        }
    }

    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.lightBlue)
                    .frame(width: 70, height: 70)

                Image(systemName: "person.crop.circle")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(Color.mainBlue)
            }

            VStack(spacing: 8) {
                Text("Complete your profile")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                Text("Add your basic details before we verify your documents.")
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("We’ll ask for")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                detailsRow(
                    icon: "person.text.rectangle",
                    title: "Personal details",
                    subtitle: "Name, date of birth, and gender"
                )

                divider

                detailsRow(
                    icon: "house",
                    title: "Current address",
                    subtitle: "Address, city, state, and pincode"
                )

                divider

                detailsRow(
                    icon: "indianrupeesign.circle",
                    title: "Income details",
                    subtitle: "Employment type and monthly income"
                )
            }
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private var divider: some View {
        Divider()
            .padding(.leading, 64)
    }

    private func detailsRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.lightBlue)
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.mainBlue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var bottomBar: some View {
        VStack(spacing: 10) {
            Button {
                goToProfileDetails = true
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
            .tint(Color.mainBlue)

            Button("Not now") {
            }
            .font(.system(size: 17))
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 12)
        .background(Color(uiColor: .systemBackground))
    }
}

struct CompleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CompleteProfileView()
        }
    }
}
