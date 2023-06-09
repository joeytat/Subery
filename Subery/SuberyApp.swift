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
    UINavigationBar.appearance().backgroundColor = UIColor(named: "neutral")
    UINavigationBar.appearance().isTranslucent = false
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
        initialState: TracksFeature.State(
          tracks: [
            .init(
              id: UUID(),
              name: "Github Copilot",
              category: "AI",
              price: "9.99",
              startAtDate: Date(),
              endAtDate: Date(),
              renewalFrequency: .monthly
            ),
            .init(
              id: UUID(),
              name: "Midjourney",
              category: "AI",
              price: "9.99",
              startAtDate: Date(),
              endAtDate: Date(),
              renewalFrequency: .yearly
            ),
            .init(
              id: UUID(),
              name: "Netflix",
              category: "Video Streaming",
              price: "9.99",
              startAtDate: Date(),
              endAtDate: Date(),
              renewalFrequency: .yearly
            )
          ]
        ),
        reducer: TracksFeature()
      ))
      let hostingController = StatusBarHostingController(rootView: rootView, lightStatusBar: true)
      window.rootViewController = hostingController
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
