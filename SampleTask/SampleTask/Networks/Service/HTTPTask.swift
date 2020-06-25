//
//  HTTPTask.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation
typealias HTTPHeaders = [String: String]

/// Returns the task for each requet

enum HTTPTask {
  /// Initializen request without any input parameter
  case request
  /// Request with body and url paramter encoding
  case requestParameters(bodyParameters: Parameters?,
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?)
  /// Request with body, url and header for encoding
  case requestParametersAndHeaders(bodyParameters: Parameters?,
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?,
    additionHeaders: HTTPHeaders?)
}
