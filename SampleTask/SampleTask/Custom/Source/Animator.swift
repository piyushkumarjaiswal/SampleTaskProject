/// Copyright (c) 2020 Piyush Jaiswal
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

//
//  Animator.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation
import UIKit

/// Clouser for animation with Tableview cell
typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

/// Animation Functions for TableView cells

enum AnimationFactory {
  /**
  Moving up animation with bounce
  - Parameters:
      - rowHeight: Cell height
      - duration: Animation duration
      - delayFactor: Delay duration for animation
  - Returns: Animation Instance
  */
  static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
    return { cell, indexPath, tableView in
      cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
      UIView.animate(
        withDuration: duration,
        delay: delayFactor * Double(indexPath.row),
        usingSpringWithDamping: 0.4,
        initialSpringVelocity: 0.1,
        options: [.curveEaseInOut],
        animations: {
          cell.transform = CGAffineTransform(translationX: 0, y: 0)
      })
    }
  }
}

/// Final class Animator
final class Animator {
  /// Flag for identifying animated cell scope
  private var hasAnimatedAllCells = false
  /// animation instance
  private let animation: Animation
  /**
   Custom initialization with accepting parameter
   - Parameters:
       - animation: A clouser instance
   */
  init(animation: @escaping Animation) {
    self.animation = animation
  }
  /**
  Animate tableview cell with indexpath in tableview
  - Parameters:
      - cell: Tableview cell to animate
      - indexPath: Index path for cell
      - tableView: Tableview instance
  */
  func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
    guard !hasAnimatedAllCells else {
      return
    }
    animation(cell, indexPath, tableView)
    hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
  }
}
