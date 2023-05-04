//
//  SuberyApp.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture
@main
struct YourAppName: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {}
  }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    sceneConfiguration.delegateClass = SceneDelegate.self
    return sceneConfiguration
  }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      let rootView = ContentView(store: Store(
        initialState: AppState.State(),
        reducer: AppState()
      ))
      let hostingController = StatusBarHostingController(rootView: rootView, lightStatusBar: true)
      window.rootViewController = hostingController
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
