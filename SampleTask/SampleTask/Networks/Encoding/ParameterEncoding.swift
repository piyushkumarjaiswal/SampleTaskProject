//
//  ParameterEncoding.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Parameter Encoading for data task request
typealias Parameters = [String: Any]

/// Encode Protocol
protocol ParameterEncoder {
  /**
   Protocol for encoding
   - Parameters:
      - urlRequest: URLRequest instance
      - parameters: Requesting parameters
   - Throws: Error during encoding failure
   */
  func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum ParameterEncoding {
  ///  Url encoding
  case urlEncoding
  ///  json encoding
  case jsonEncoding
  ///  Url encoding
  case urlAndJsonEncoding
  /**
  Encoding request with requested parameter
  - Parameters:
     - urlRequest: URLRequest instance
     - bodyParameters: Requesting parameters for body
     - urlParameters: Requesting parameters for URL
  - Throws: Error during encoding failure
  */
  func encode(urlRequest: inout URLRequest,
              bodyParameters: Parameters?,
              urlParameters: Parameters?) throws {
    do {
      switch self {
      case .urlEncoding:
        guard let urlParameters = urlParameters else { return }
        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
      case .jsonEncoding:
        guard let bodyParameters = bodyParameters else { return }
        try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
      case .urlAndJsonEncoding:
        guard let bodyParameters = bodyParameters,
          let urlParameters = urlParameters else { return }
        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
        try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
      }
    } catch {
      throw error
    }
  }
}

/// Errors during API Call and handling
enum NetworkError: String, Error {
  /// Paramter found nil
  case parametersNil = "Parameters were nil."
  /// Parameter encoding failed
  case encodingFailed = "Parameter encoding failed."
  /// Url is missing
  case missingURL = "URL is nil."
}
