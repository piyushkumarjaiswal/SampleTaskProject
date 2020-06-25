//
//  SampleTaskTests.swift
//  SampleTaskTests
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit
import Foundation
import XCTest
@testable import SampleTask
/// Test cases class for executing test cases
class SampleTaskTests: XCTestCase {
  var manager: NetworkManager!
  /// Initialization of instances
  override func setUp() {
    manager = NetworkManager()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  /// Tear down methode invoked after the code executes
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    manager = nil
  }
  /// Verifying api call getting Valid data
  func testApiResponse() {
    let expectations = expectation(description: "Api Response")
    manager.getCountryDetail(completion: {(detail, _) in
      XCTAssert(detail != nil, "Data is not receiving from server")
      expectations.fulfill()
    })
    waitForExpectations(timeout: 30) { error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  /// Verifying a valid rootcontroller is initalized
  func testValidRootControllerInitialization() {
    if #available(iOS 13, *) {
      let window =  UIApplication.shared.windows.first { $0.isKeyWindow }
      XCTAssert(window?.rootViewController != nil, "Window having the root controller")
    } else {
      let window =  UIApplication.shared.keyWindow
      XCTAssert(window?.rootViewController != nil, "Window having the root controller")
    }
  }
  /// Verifying that storage data of sample.json file is in correct formate
  func testLocalDataWithValidFormate() {
    if let url = Bundle.main.url(forResource: "sample", withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let dataModel = try? JSONDecoder().decode(CountryDetail.self, from: data)
        XCTAssert(dataModel != nil, "Data is incompatible with model object")
      } catch {
        print("error:\(error)")
      }
    }
  }
}
