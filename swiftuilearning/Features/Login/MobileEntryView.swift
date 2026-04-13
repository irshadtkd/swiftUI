//
//  MobileEntryView.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI

struct MobileEntryView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: AppTheme.padding) {
            
            Spacer()
            
            Image(systemName: "iphone")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text(AppStrings.Login.welcomeTitle)
                .font(AppFonts.tutorialTitle)
                .foregroundColor(.white)
            
            Text(AppStrings.Login.welcomeSubtitle)
                .font(AppFonts.tutorialSubtitle)
                .foregroundColor(.white.opacity(0.9))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppStrings.Login.mobileLabel)
                    .font(AppFonts.navigationAction)
                    .foregroundColor(.white)
                
                HStack {
                    Text("+91")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    TextField("1234567890", text: $viewModel.mobileNumber)
                        .keyboardType(.numberPad)
                        .foregroundColor(.white)
                        .onChange(of: viewModel.mobileNumber) { _, newValue in
                            // Limit to max 10 digits
                            if newValue.count > 10 {
                                viewModel.mobileNumber = String(newValue.prefix(10))
                            }
                        }
                }
                .frame(height: 50)
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
            }
            
            Button(AppStrings.Login.sendOTP) {
                viewModel.sendOTP()
            }
            .font(AppFonts.primaryButton)
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.mobileNumber.count == 10 ? AppColors.buttonBackground : Color.gray.opacity(0.5))
            .foregroundColor(AppColors.buttonText)
            .cornerRadius(14)
            .disabled(viewModel.mobileNumber.count != 10) // disable if not 10 digits
            
            Text(AppStrings.Login.termsText)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
