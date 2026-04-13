import UIKit
import UserNotifications
import FirebaseAuth
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        requestNotificationPermission()
        configureNavigationBarAppearance()
        return true
    }

    private func configureNavigationBarAppearance() {
        let white = UIColor.white
        UINavigationBar.appearance().tintColor = white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: white]
    }
    
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("Notification permission denied")
                }
            }
    }
    
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("deviceToken :\(deviceToken)")
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        print("APNs token registered")
    }
    
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNs registration failed:", error.localizedDescription)
    }
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        completionHandler(.newData)
    }
}
