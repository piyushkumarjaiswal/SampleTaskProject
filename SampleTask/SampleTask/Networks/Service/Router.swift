//
//  Router.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Preparing Complete Request With Routing Mechanism

/// clouser for network completion
typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

/// Network router for access api with endpoints
protocol NetworkRouter: class {
  /// defines the end point Type
  associatedtype EndPoint: EndPointType
  /**
   Preparing the request with endpoints
   - Parameters:
      - route: End points detail
   - Parameters:
       - completion: A networkrouter clouser
   */
  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
  func cancel()
}

/// Router with Implemeting the Network Router
class Router<EndPoint: EndPointType>: NetworkRouter {
  /// task instance for invoke API call
  private var task: URLSessionTask?
  /**
    Preparing the request with endpoints
    - Parameters:
       - route: End points detail
    - Parameters:
        - completion: A networkrouter clouser
    */
  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try self.buildRequest(from: route)
      NetworkLogger.log(request: request)
      task = session.dataTask(with: request, completionHandler: { data, response, error in
        completion(data, response, error)
      })
    } catch {
      completion(nil, nil, error)
    }
    self.task?.resume()
  }
/// Canceling the task request
  func cancel() {
    self.task?.cancel()
  }
  /**
    Building the request with Initializing the URLRequest
    - Parameters:
       - route: End points detail
    - Throws:
        - URLRequest Instance
    */
  fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
    var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 10.0)
    request.httpMethod = route.httpMethod.rawValue
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .requestParameters(let bodyParameters,
                              let bodyEncoding,
                              let urlParameters):
        try self.configureParameters(bodyParameters: bodyParameters,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)
      case .requestParametersAndHeaders(let bodyParameters,
                                        let bodyEncoding,
                                        let urlParameters,
                                        let additionalHeaders):
        self.addAdditionalHeaders(additionalHeaders, request: &request)
        try self.configureParameters(bodyParameters: bodyParameters,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)
      }
      return request
    } catch {
      throw error
    }
  }
  /**
  Encoding request with given parameter
  - Parameters:
     - bodyParameters: body Parameters for request preparation
     - bodyEncoding:   paramters for encoding
     - urlParameters:  url paramters for request preparation
  - Throws:
      - Error during API call and response parsing
  */
  fileprivate func configureParameters(bodyParameters: Parameters?,
                                       bodyEncoding: ParameterEncoding,
                                       urlParameters: Parameters?,
                                       request: inout URLRequest) throws {
    do {
      try bodyEncoding.encode(urlRequest: &request,
                              bodyParameters: bodyParameters, urlParameters: urlParameters)
    } catch {
      throw error
    }
  }
  /**
    Attaching the headers with request
   - Parameters:
      - additionalHeaders: Headers paramter
      - request:   Urlrequeust for attaching headers
  */
  fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
    guard let headers = additionalHeaders else { return }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
  }
}
