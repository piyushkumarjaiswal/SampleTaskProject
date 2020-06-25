//
//  ServiceEndPoint.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Basic Building Environments
enum NetworkEnvironment {
  /// QA release
  case qaEnv
  /// Production release
  case production
  /// Staging release
  case staging
}

/// Servies Api request types
enum ServiceApi {
  /// Getting country Detail
  case getCountryDetail
}

extension ServiceApi: EndPointType {
  /// Enviroment base url
  var environmentBaseURL: String {
    switch NetworkManager.environment {
      /// production base url
    case .production: return "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl"
      /// qa base url
    case .qaEnv: return "qa"
      /// staging base url
    case .staging: return "staging"
    }
  }
  /// Base Url for connection
  var baseURL: URL {
    guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
    return url
  }
  /// Path Extenstion function
  var path: String {
    switch self {
      /// Retriving country detail
    case .getCountryDetail:
      return "facts.json"
    }
  }
   /// Rest API methode type
  var httpMethod: HTTPMethod {
    switch self {
      /// For getting country detail should be get type
    case .getCountryDetail:
      return .get
    }
  }
  /// Returning task
  var task: HTTPTask {
    switch self {
      /// initialize and returns the task based on parameter
    case .getCountryDetail:
      return .request
    }
  }
  /// Returning header configuration
  var headers: HTTPHeaders? {
    return nil
  }
}
