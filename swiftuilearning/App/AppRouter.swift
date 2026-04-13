
import SwiftUI

struct AppRouter: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        switch appState.flow {
        case .tutorial:
            TutorialView()
        case .login:
            LoginView()
        case .home:
            NavigationStack {
                HomeView()
            }
        }
    }
}
