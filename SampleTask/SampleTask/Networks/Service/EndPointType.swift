//
//  EndPointType.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Protocol for end points requirement

protocol EndPointType {
  /// Base url for end point communication
  var baseURL: URL { get }
  /// Path extension for access specific methode of API
  var path: String { get }
  /// Type of methode for accessing rest API
  var httpMethod: HTTPMethod { get }
  /// Http task for accessing API
  var task: HTTPTask { get }
  /// Http headers for API access
  var headers: HTTPHeaders? { get }
}
