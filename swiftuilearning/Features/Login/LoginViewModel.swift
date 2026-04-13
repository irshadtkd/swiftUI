//
//  LoginViewModel.swift
//  swiftuilearning
//
//  Created by Irshadali M T on 22/01/26.
//

import SwiftUI
import FirebaseAuth

final class LoginViewModel: ObservableObject {
    
    enum LoginStep {
        case enterMobile
        case enterOTP
    }
    
    // MARK: - Published
    @Published var step: LoginStep = .enterMobile
    @Published var mobileNumber: String = ""
    @Published var otpDigits: [String] = Array(repeating: "", count: 6)
    var verificationID: String = ""
    @Published var resendTimer = 28
    
    private var timer: Timer?
    
    // MARK: - Actions
    func sendOTP() {
        // Mock API call
        //        step = .enterOTP
        //        startResendTimer()
        let phoneNumber = "+919633636776"
        PhoneAuthProvider.provider().verifyPhoneNumber(
            phoneNumber, uiDelegate: nil
        ) { [self] verificationID, error in
            DispatchQueue.main.async { [self] in
                print(verificationID ?? "")
                if let error = error as NSError? {
                    print("Firebase Phone Auth Error")
                    print("Description:", error.localizedDescription)
                    print("Domain:", error.domain)
                    print("Code:", error.code)
                    print("UserInfo:", error.userInfo)
                    // Firebase-specific error handling
                    if let authError = AuthErrorCode(rawValue: error.code) {
                        print("Firebase Auth Error Code:", authError)
                    }
                    return
                }
                
                self.verificationID = verificationID ?? ""
                self.step = .enterOTP
                startResendTimer()
            }
        }
    }
    
    func verifyOTP(appState: AppState) {
        if self.verificationID == "" { return }
        
        let otpCode = "123456"//otpDigits.joined()
        
        let credential = PhoneAuthProvider.provider()
            .credential(
                withVerificationID: verificationID,
                verificationCode: otpCode
            )
        
        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            UserDefaultsManager.shared.isLoggedIn = true
            appState.flow = .home
        }
    }
    
    // MARK: - Timer
    private func startResendTimer() {
        resendTimer = 28
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.resendTimer > 0 {
                self.resendTimer -= 1
            }
        }
    }
}
