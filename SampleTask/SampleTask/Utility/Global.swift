//
//  Global.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/**
 Initializing HomeViewController as a root controller
 - Returns: An instance of navigation controller with home as a rootviewcontroller.
 */
func getRootViewController() -> UINavigationController {
  let navigationController = UINavigationController(rootViewController: HomeViewController())
  navigationController.navigationBar.isHidden = false
  navigationController.navigationBar.barTintColor = ApplicationColor.navigationBgColor
  navigationController.navigationBar.titleTextAttributes = [.foregroundColor: ApplicationColor.whiteColor]
  return navigationController
}
