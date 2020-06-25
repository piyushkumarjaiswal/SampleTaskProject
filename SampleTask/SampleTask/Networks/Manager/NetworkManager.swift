//
//  NetworkManager.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Network response message collection

enum NetworkResponse: String {
  /// success status
  case success
  /// User is not authenticated
  case authenticationError = "You need to be authenticated first."
  /// Request is not in valid formate
  case badRequest = "Bad request"
  /// Request failed due to network issue
  case failed = "Network request failed."
  /// Response is with blank data
  case noData = "Response returned with no data to decode."
  /// Unable to parse data
  case unableToDecode = "We could not decode the response."
}

/// Result for Generic Response Handling
enum Result<String> {
  /// Success in response
  case success
  /// Failure
  case failure(String)
}

/// Manager For Accessing Apis
struct NetworkManager {
  /// Network enviroment instance
  static let environment: NetworkEnvironment = .production
  /// Router instace for API access
  let router = Router<ServiceApi>()
  /**
  Fetching Detail of the country from the Api
  - Parameters:
     - completion: A clouser to call
  - Parameters:
      - country: country detail
      - error: error message
  */
  func getCountryDetail(completion: @escaping (_ country: CountryDetail?, _ error: String?) -> Void) {
    router.request(.getCountryDetail) { data, response, error in
      if error != nil {
        completion(nil, "Please check your network connection.")
      }
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          do {
            let jsonString = String(data: responseData, encoding: .ascii)
            guard let newData = jsonString?.data(using: .utf8, allowLossyConversion: true) else {
              return
            }
            let apiResponse = try JSONDecoder().decode(CountryDetail.self, from: newData)
            completion(apiResponse, nil)
          } catch {
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
  /**
  Network Response Handling For Status Code
  - Parameters:
     - response: HttpUrlResponse instance with detail
  - Returns: Result model of response type
  */
  fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    /// Success
    case 200...299: return .success
    /// UnAuthorized
    case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
    /// Bad Request
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    /// Uncertain Network Failure
    default: return .failure(NetworkResponse.failed.rawValue)
    }
  }
}
