import SwiftUI

struct FlagView: View {
    let countryCode: String
    
    var body: some View {
        AsyncImage(url: URL(string: "https://flagsapi.com/\(countryCode)/flat/64.png")) { phase in
            switch phase {
            case .empty:
                EmptyView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .cornerRadius(12)
            case .failure:
                EmptyView()
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    FlagView(countryCode: "BE")
}
