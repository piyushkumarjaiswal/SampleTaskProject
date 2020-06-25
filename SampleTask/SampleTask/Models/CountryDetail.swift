//
//  CountryDetail.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation

/// Root Structure For Api Response
// MARK: - Country Detail
struct CountryDetail: Codable {
  /// Country name title
  let title: String?
  /// List of coutry detail object
  let rows: [Row]?
}

// MARK: - Row
struct Row: Codable {
  /// Subdetail title
  let title: String?
  /// Description for country subdetail
  let rowDescription: String?
  /// Image url path
  let imageHref: String?
  /// Coding key with respect to response parsing string
  enum CodingKeys: String, CodingKey {
    case title
    case rowDescription = "description"
    case imageHref
  }
}
