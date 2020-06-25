//
//  HTTPMethod.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Methode types for accessing Apis
enum HTTPMethod: String {
  /// Get methode
  case get     = "GET"
  /// Post methode
  case post    = "POST"
  /// Put methode
  case put     = "PUT"
  ///Patch methode
  case patch   = "PATCH"
  ///Delete methode
  case delete  = "DELETE"
}
