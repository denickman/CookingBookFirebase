//
//  CookBookApp.swift
//  CookBook
//
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // FirebaseApp.configure()
    return true
  }
}

@main
struct CookBookApp: App {
    
    @State var sessionManager = SessionManager() // session manager creates itself way before of appdelegate so we have crash here
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            switch sessionManager.sessionState {
            case .loggedIn:
                HomeView()
                    .environment(sessionManager)
            case .loggedOut:
                LoginView()
                    .environment(sessionManager)
            }
        }
    }
}
