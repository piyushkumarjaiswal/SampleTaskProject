//
//  SceneDelegate.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  /// UIApplication window instance
  var window: UIWindow?
  /// Scene delegate for connecting the scene to device app
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = getRootViewController()
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}

