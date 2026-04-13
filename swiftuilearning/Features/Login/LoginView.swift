//
//  LoginView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            switch viewModel.step {
            case .enterMobile:
                MobileEntryView(viewModel: viewModel)
                
            case .enterOTP:
                OTPVerificationView(viewModel: viewModel) {
                    viewModel.verifyOTP(appState: appState)
                }
            }
        }
    }
}
