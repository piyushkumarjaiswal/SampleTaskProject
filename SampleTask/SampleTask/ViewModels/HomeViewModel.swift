//
//  HomeViewModel.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// View Model for HomeViewController Screen
class HomeViewModel: NSObject {
  /// Country detail object receive from API
  private var countryDetail: CountryDetail?
  /// Network manger for API call
  private var manager: NetworkManager?
  /// Overrding Initailization function
  override init() {
    super.init()
    manager = NetworkManager()
  }
  /// Viewmodel binding handler
  var viewModelBinding :((_ status: CountryDetail?, _ error: String?) -> Void) = { _, _  in  }
  // Getting Row Detail For According to index of cell
  /**
  Retriving Cell Detail for index
  - Parameters:
     - index: Cell index
  - Returns: Row detail as an optional value
  */
  func getRowDetailFor(index: Int) -> Row? {
    return getFilteredRows()?[index]
  }
  /**
  Retriving Count Of Cells
  - Returns: Number of rows
  */
  func getRowsCount() -> Int {
    return getFilteredRows()?.count ?? 0
  }
  /**
  Returning Filtered rows data
  - Returns: Array for filtered data of Row type
  */
  func getFilteredRows() -> [Row]? {
    return countryDetail?.rows?.filter { row in
      return (row.title != nil) }
  }
  /**
  Getting country details from API and responding to viewmodel handler
  - Precondition: Checking Network Connection
  */
  func getCountryDetailFromApi() {
    if Reachability.isConnectedToNetwork() == false {
      viewModelBinding(nil, Message.networkNotReachable.value)
      return
    }
    manager?.getCountryDetail(completion: {[weak self] (detail, message) in
      guard let getSelf = self else { return }
      if detail != nil {
        getSelf.countryDetail = detail
        getSelf.viewModelBinding(detail, nil)
      } else {
        getSelf.viewModelBinding(nil, message)
      }
    })
  }
}
