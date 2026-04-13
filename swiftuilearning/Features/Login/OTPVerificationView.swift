import SwiftUI

struct OTPVerificationView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    let onVerify: () -> Void
    
    @FocusState private var focusedIndex: Int?
    
    var body: some View {
        VStack(spacing: AppTheme.padding) {
            Spacer()
            Image(systemName: "checkmark.shield")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text(AppStrings.Login.verifyTitle)
                .font(AppFonts.tutorialTitle)
                .foregroundColor(.white)
            Text("\(AppStrings.Login.verifySubtitlePrefix) +1\(viewModel.mobileNumber)")
                .font(AppFonts.tutorialSubtitle)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    otpTextField(at: index)
                }
            }
            Text("\(AppStrings.Login.resendOTP) \(viewModel.resendTimer)s")
                .font(AppFonts.navigationAction)
                .foregroundColor(.white.opacity(0.8))
            Button("Verify") {
                onVerify()
            }
            .font(AppFonts.primaryButton)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.buttonBackground)
            .foregroundColor(AppColors.buttonText)
            .cornerRadius(14)
            
            Spacer()
        }
        .padding()
        .onAppear {
            focusedIndex = 0
        }
    }
    
    // MARK: - OTP TextField
    private func otpTextField(at index: Int) -> some View {
        TextField("", text: $viewModel.otpDigits[index])
            .frame(width: 44, height: 50)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .foregroundColor(.white)
            .focused($focusedIndex, equals: index)
            .onChange(of: viewModel.otpDigits[index]) { _, newValue in
                handleOTPInput(newValue, at: index)
            }
    }
    
    // MARK: - Input Logic
    private func handleOTPInput(_ value: String, at index: Int) {
        
        // Allow only digits
        let filtered = value.filter { $0.isNumber }
        
        // Restrict to single character
        if filtered.count > 1 {
            viewModel.otpDigits[index] = String(filtered.last!)
            focusedIndex = min(index + 1, 5)
            return
        }
        
        viewModel.otpDigits[index] = filtered
        
        // Move to next field
        if filtered.count == 1 {
            focusedIndex = min(index + 1, 5)
        }
        
        // Move to previous field on delete
        if filtered.isEmpty {
            focusedIndex = max(index - 1, 0)
        }
    }
}
