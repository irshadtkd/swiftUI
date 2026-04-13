
import SwiftUI
import SafariServices
@preconcurrency import WebKit

/// In-app WebView that loads only the provided URL (e.g. Word of the Day source URL).
struct InAppWebView: UIViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(initialURL: url)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let initialURL: URL
        
        init(initialURL: URL) {
            self.initialURL = initialURL
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let requestURL = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            if requestURL == initialURL {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.iconName)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Text(message)
                .font(AppFonts.definition)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .background(type.backgroundColor)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(), value: message)
    }
}

enum ToastType {
    case error
    case success
    case info
    
    var backgroundColor: Color {
        switch self {
        case .error: return .red
        case .success: return .green
        case .info: return .blue
        }
    }
    
    var iconName: String {
        switch self {
        case .error: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

struct ToastModifier: ViewModifier {
    @Binding var text: String?
    let type: ToastType
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if let message = text {
                ToastView(message: message, type: type)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.text = nil
                            }
                        }
                    }
                    .zIndex(1)
            }
        }
    }
}

extension View {
    func toast(text: Binding<String?>, type: ToastType = .error) -> some View {
        self.modifier(ToastModifier(text: text, type: type))
    }
}
