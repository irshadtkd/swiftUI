
import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var profileImage: UIImage?
    @Binding var isNotificationsOn: Bool
    let userName: String
    let appVersion: String
    let onLogout: () -> Void
    
    @State private var showImagePicker = false
    
    var body: some View {
        ZStack {
            if isShowing {
                // Dimmed background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                
                // Menu Content
                HStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // User Profile Section
                        VStack(spacing: 12) {
                            ZStack(alignment: .bottomTrailing) {
                                if let image = profileImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                }
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .background(AppColors.primary)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                }
                            }
                            Text(userName)
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        // Menu Items
                        VStack(alignment: .leading, spacing: 20) {
                            // Notifications Toggle
                            Toggle(isOn: $isNotificationsOn) {
                                HStack(spacing: 12) {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(AppColors.textPrimary)
                                    Text("Notifications")
                                        .foregroundColor(AppColors.textPrimary)
                                }
                            }
                            .tint(AppColors.accent)
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                            
                            // Logout
                            Button(action: {
                                onLogout()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.red.opacity(0.9))
                                    Text("Logout")
                                        .foregroundColor(.red.opacity(0.9))
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // App Version
                        VStack(spacing: 4) {
                            Text("Version \(appVersion)")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom)
                    }
                    .frame(width: 280) // Fixed width for sidebar
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.secondary, AppColors.gradientEnd]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(radius: 5)
                }
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut, value: isShowing)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage)
        }
    }
}
