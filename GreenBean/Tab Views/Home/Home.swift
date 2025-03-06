import SwiftUI

struct Home: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // First Block: Green Bean Special (Navigates to Search)
                NavigationLink(destination: Search()) { // Link to Search screen
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                        
                        VStack(spacing: 10) {
                            // Load shopping basket image
                            AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/3142/3142740.png")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                } else if phase.error != nil {
                                    Image(systemName: "exclamationmark.triangle")
                                } else {
                                    ProgressView()
                                }
                            }
                            
                            Text("Green Bean Special")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                    .frame(height: 180)
                }
                .buttonStyle(PlainButtonStyle()) // Removes default NavigationLink styling
                
                // Second Block: Medicine Tracker (No navigation for now)
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    
                    VStack(spacing: 10) {
                        // Load medicine icon
                        AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/4599/4599153.png")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            } else if phase.error != nil {
                                Image(systemName: "exclamationmark.triangle")
                            } else {
                                ProgressView()
                            }
                        }
                        
                        Text("Medicine Tracker")
                            .font(.headline)
                    }
                    .padding()
                }
                .frame(height: 180)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    Home()
}
