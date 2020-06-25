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
//  SpinnerLayer.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/// Class for managing the layer with spinning button
internal class SpinnerLayer: CAShapeLayer {
  /// layer color defined by user
  internal var color: CGColor? = ApplicationColor.whiteColor.cgColor {
    willSet {
      strokeColor = newValue
    }
  }
  /// Required initalization function
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  /// Default initalization function
  init(frame: CGRect) {
    super.init()
    setUp(frame: frame)
  }
}

// MARK: - Setup
internal extension SpinnerLayer {
  /**
   Prepare UI setup for frame of layer
  - parameters:
     - frame: A frame segment of layer
  */
  func setUp(frame: CGRect) {
    self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
    let center = CGPoint(x: frame.height/2, y: frame.height/2)
    let circlePath = UIBezierPath(arcCenter: center, radius: 10, startAngle: 0,
                                  endAngle: CGFloat(2*Double.pi), clockwise: true)
    path = circlePath.cgPath
    lineWidth = 2.0
    strokeColor = color
    fillColor = ApplicationColor.clearColor.cgColor
    self.isHidden = true
  }
}

// MARK: - Animation Methods
internal extension SpinnerLayer {
  /// Start layer animation
  func startAnimation() {
    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.fromValue = -0.5
    strokeStartAnimation.toValue = 1.0
    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.fromValue = 0.0
    strokeEndAnimation.toValue = 1.0
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 1
    animationGroup.repeatCount = .infinity
    animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
    add(animationGroup, forKey: nil)
  }
  /// Stop layer animation
  func stopAnimation() {
    removeAllAnimations()
  }
}
