//
//  URLParameterEncoding.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// URL parameter encoading for data task request
struct URLParameterEncoder: ParameterEncoder {
  /**
  Encoding request with requested parameter
  - Parameters:
     - urlRequest: URLRequest instance
     - parameters: Requesting parameters for URL
  - Throws: Error during encoding failure
  */
  func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    guard let url = urlRequest.url else { throw NetworkError.missingURL }
    if var urlComponents = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false), !parameters.isEmpty {
      urlComponents.queryItems = [URLQueryItem]()
      for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key,
                                     value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        urlComponents.queryItems?.append(queryItem)
      }
      urlRequest.url = urlComponents.url
    }
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
  }
}
