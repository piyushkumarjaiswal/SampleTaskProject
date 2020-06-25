//
//  ApplicationConstant.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/// Dimensions for view position and size

struct Dimensions {
  /// X Position of any view
  static let loaderXPosition = 100
  /// Y Position of any view
  static let loaderYPosition = 200
  /// Width of any view
  static let loaderWidth = 40
  /// Height of any view
  static let loadderHeight = 40
}

/// Common Messages Strings

enum Message: String {
  /// Specific title for message
  case sampleTask
  /// Network unavailable message
  case networkNotReachable
  /// Title for message
  case header
  /// Returing string value for each case
  var value: String {
    switch self {
    case .sampleTask:
      return "SampleTask"
    case .networkNotReachable:
      return "Network Not Available, Please check your connection."
    case .header:
      return "Alert"
    }
  }
}

/// TableView Cell Identifiers
struct CellIdentifiers {
  /// Home page cell identifier
  static let homeCell = "HomeCell"
}

/// Common colors instances
struct ApplicationColor {
  /// View background color
  static let viewBackgroundColor = generateColor(red: 233, green: 35, blue: 100)
  /// Tableview cell background color
  static let cellBackgroundColor = generateColor(red: 233, green: 35, blue: 100)
  /// TableViewCell text color
  static let titleTextColor  = generateColor(red: 255, green: 85, blue: 33)
  /// TableViewCell description color
  static let descriptionTextColor   = generateColor(red: 255, green: 85, blue: 33)
  /// Border color for any view
  static let borderColor = generateColor(red: 255, green: 85, blue: 33)
  /// Navigation background color
  static let navigationBgColor = generateColor(red: 255, green: 85, blue: 33)
  /// White color from UIColor
  static let whiteColor = UIColor.white
  /// Black color from UIColor
  static let blackColor = UIColor.black
  /// Clear color from UIColor
  static let clearColor = UIColor.clear
}

/**
 Receiving the RGB seprate color value as CGFloat Type then convert and return UiColor instance
 - Parameters:
    - red:Red as CGFloat
    - green :Green as CGFloat
    - blue :Blue as CgFloat
 - Returns: UIColor instace from RGB values
 */

func generateColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
  return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
}
