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
//  SpinnerButton.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

enum AnimationType {
  /// Collapse animation will make the button round and show the spinner
  case collapse
  /// Expand animation will make the button go back to the defaults, use after button is "collapsed"
  case expand
  /// Shake animation will shake the button
  case shake
}

/// Initialize gradient layer
extension CAGradientLayer {
  convenience init(frame: CGRect) {
    self.init()
    self.frame = frame
  }
}

/// Button with ibdesignable type property
@IBDesignable
open class SpinnerButton: UIButton {
  // MARK: - Properties
  /// Title for button
  internal var storedTitle: String?
  /// Animation duration for button
  internal var animationDuration: CFTimeInterval = 0.1
  /// Sets the button corner radius
  @IBInspectable var cornerRadius: CGFloat = 0 {
    willSet {
      layer.cornerRadius = newValue
    }
  }
  /// Sets the duration of the animations
  @IBInspectable var duration: Double = 0.2 {
    willSet {
      animationDuration = newValue
    }
  }
  /// Layer for spinner button
  internal lazy var spinner: SpinnerLayer = {
    let spiner = SpinnerLayer(frame: self.frame)
    self.layer.addSublayer(spiner)
    return spiner
  }()
  /// gradient layer for button
  internal lazy var gradientLayer: CAGradientLayer = {
    let gradient = CAGradientLayer(frame: self.frame)
    gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    layer.insertSublayer(gradient, at: 0)
    return gradient
  }()
  /// Sets the spinner color
  var spinnerColor: CGColor? {
    willSet {
      spinner.color = newValue
    }
  }
  /// Sets the colors for the gradient backgorund
  var gradientColors: [CGColor]? {
    willSet {
      gradientLayer.colors = newValue
    }
  }
  /// Sets the button title for its normal state
  var title: String? {
    get {
      return self.title(for: .normal)
    }
    set {
      self.setTitle(newValue, for: .normal)
    }
  }
  /// Sets the button title color.
  var titleColor: UIColor? {
    get {
      return self.titleColor(for: .normal)
    }
    set {
      self.setTitleColor(newValue, for: .normal)
    }
  }
  // MARK: - Initializers
  /// Intializer for Button of required type
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    setUp()
  }

  /// Overriding for init methode
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }
   /**
     Custom initialization function for button init
    - Parameters:
       - title: Title for button
   */
  init(title: String) {
    super.init(frame: .zero)
    setTitle(title, for: .normal)
    setUp()
  }
  /// layouting the subviews
  override open func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = self.bounds
    clipsToBounds = true
  }
}

// MARK: - Setup
internal extension SpinnerButton {

/// Preparing UI setup for button
  func setUp() {
    self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    self.backgroundColor = .emLightBlue
    self.titleColor = .white
  }
}

// MARK: - Animation Methods
internal extension SpinnerButton {
  /// Button collapse animation
  func collapseAnimation() {
    storedTitle = title
    title = ""
    isUserInteractionEnabled = false
    let animaton = CABasicAnimation(keyPath: "bounds.size.width")
    animaton.fromValue = frame.width
    animaton.toValue =  frame.height
    animaton.duration = animationDuration
    animaton.fillMode = CAMediaTimingFillMode.forwards
    animaton.isRemovedOnCompletion = false
    layer.add(animaton, forKey: animaton.keyPath)
    spinner.isHidden = false
    spinner.startAnimation()
  }
  /// Restoring the to inital position
  func backToDefaults() {
    spinner.stopAnimation()
    setTitle(storedTitle, for: .normal)
    isUserInteractionEnabled = true
    let animaton = CABasicAnimation(keyPath: "bounds.size.width")
    animaton.fromValue = frame.height
    animaton.toValue = frame.width
    animaton.duration = animationDuration
    animaton.fillMode = CAMediaTimingFillMode.forwards
    animaton.isRemovedOnCompletion = false
    layer.add(animaton, forKey: animaton.keyPath)
    spinner.isHidden = true
  }
  /// Perform shake animation
  func shakeAnimation() {
    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
        let transform = CGAffineTransform(translationX: 10, y: 0)
        self.transform = transform
      })
      UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
        let transform = CGAffineTransform(translationX: -7, y: 0)
        self.transform = transform
      })
      UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: {
        let transform = CGAffineTransform(translationX: 5, y: 0)
        self.transform = transform
      })
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1, animations: {
        let transform = CGAffineTransform(translationX: -3, y: 0)
        self.transform = transform
      })
      UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1, animations: {
        let transform = CGAffineTransform(translationX: 2, y: 0)
        self.transform = transform
      })
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
        let transform = CGAffineTransform(translationX: -1, y: 0)
        self.transform = transform
      })
    })
  }
}

// MARK: - Methods
extension SpinnerButton {
  /**
   Animates the the button with the given animation
   - parameter animation: Type of animation that will be executed
   */
  func animate(animation: AnimationType) {
    switch animation {
    case .collapse:
      UIView.animate(withDuration: 0.1, animations: {
        self.layer.cornerRadius = self.frame.height/2
      }, completion: { (_) in
        self.collapseAnimation()
      })
    case .expand:
      UIView.animate(withDuration: 0.1, animations: {
        self.layer.cornerRadius = self.cornerRadius
      }, completion: { (_) in
        self.backToDefaults()
      })
    case .shake:
      shakeAnimation()
    }
  }
}

// MARK: - Custom Colors
extension UIColor {
  /// Blue color style
  static let emLightBlue = UIColor().lightBlueColor()
  /// Light blue color
  private func lightBlueColor() -> UIColor {
    return UIColor(red: 255/255, green: 85/255, blue: 33/255, alpha: 1.0)
  }
}
