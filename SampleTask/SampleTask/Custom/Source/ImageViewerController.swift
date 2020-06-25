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
//  ImageViewerController.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/// Image Details
struct ImageInfo {
  enum ImageMode: Int {
    /// aspect fit
    case aspectFit  = 1
    /// aspect fill
    case aspectFill = 2
  }
  /// Image Instance
  let image: UIImage
  /// Image mode for content mode
  let imageMode: ImageMode
  /// Image Url
  var imageHD: URL?
  /// Content mode of image
  var contentMode: UIView.ContentMode {
    return UIView.ContentMode(rawValue: imageMode.rawValue)!
  }
  /**
  Initializing Picker with image and content mode
  - Parameters:
     - image: Image will use for initialize
     - imageMode: content mode for image
  */
  init(image: UIImage, imageMode: ImageMode) {
    self.image     = image
    self.imageMode = imageMode
  }
  /**
   Initializing Picker with image and content mode
   - Parameters:
      - image: Image will use for initialize
      - imageMode: content mode for image
      - imageHD: Image Url for showing image
   */
  init(image: UIImage, imageMode: ImageMode, imageHD: URL?) {
    self.init(image: image, imageMode: imageMode)
    self.imageHD = imageHD
  }
  /**
  Calculating the frame for image according to height, width and position
  - Parameters:
     - rect: Frame of the image
     - origin: Position of image
     - imageMode: Image content mode
  - Returns: Frame of image
  */
  func calculate(rect: CGRect, origin: CGPoint? = nil, imageMode: ImageMode? = nil) -> CGRect {
    switch imageMode ?? self.imageMode {
    case .aspectFit:
      return rect
    case .aspectFill:
      let ratio = max(rect.size.width / image.size.width, rect.size.height / image.size.height)
      let width = image.size.width * ratio
      let height = image.size.height * ratio
      return CGRect(
        x: origin?.x ?? rect.origin.x - (width - rect.width) / 2,
        y: origin?.y ?? rect.origin.y - (height - rect.height) / 2,
        width: width,
        height: height
      )
    }
  }
  /**
  Calculating zoom scale according to image size
  - Parameters:
     - size: Size of image
  - Returns: Zoom scale
  */
  func calculateMaximumZoomScale(_ size: CGSize) -> CGFloat {
    return max(2, max(
      image.size.width  / size.width,
      image.size.height / size.height
    ))
  }
}
/// Transition details
class TransitionInfo {
  /// Duration of animation
  var duration: TimeInterval = 0.35
  /// Flag for identifying swap feature
  var canSwipe: Bool = true
  /**
  Initialization of transition detail with view
  - Parameters:
     - fromView: Initializing with view
   */
  init(fromView: UIView) {
    self.fromView = fromView
  }
  /**
  Initialization of transition detail with frame
  - Parameters:
     - fromView: Initializing with view
   */
  init(fromRect: CGRect) {
    self.convertedRect = fromRect
  }
  /// View container for image
  weak var fromView: UIView?
  /// Starting frame for transition
  var fromRect: CGRect!
  /// Final frame for transition
  var convertedRect: CGRect!
}

/// Controller for showing image with zoom mode
class ImageViewerController: UIViewController {
  /// Imageview for zooming
  let imageView  = UIImageView()
  /// ScrollView as Container
  let scrollView = UIScrollView()
  /// Image Details
  let imageInfo: ImageInfo
  /// Transition detail
  var transitionInfo: TransitionInfo?
  /// Clouser for dismiss completion
  var dismissCompletion: (() -> Void)?
  /// View background color
  var backgroundColor: UIColor = .black {
    didSet {
      view.backgroundColor = backgroundColor
    }
  }
  /// Urlsession instance for downloading and caching machenism
  lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
  }()
  // MARK: Initialization
  /**
   Initialization of controller with Image detail
   - Parameters:
      - imageInfo: Image detail for intialization
    */
  init(imageInfo: ImageInfo) {
    self.imageInfo = imageInfo
    super.init(nibName: nil, bundle: nil)
  }
  /**
    Initialization of controller with Image detail and transition detail
    - Parameters:
       - imageInfo: Image detail for intialization
       - transitionInfo: transition detail for intialization
     */
  convenience init(imageInfo: ImageInfo, transitionInfo: TransitionInfo) {
    self.init(imageInfo: imageInfo)
    self.transitionInfo = transitionInfo
    if let fromView = transitionInfo.fromView, let referenceView = fromView.superview {
      transitionInfo.fromRect = referenceView.convert(fromView.frame, to: nil)
      if fromView.contentMode != imageInfo.contentMode {
        transitionInfo.convertedRect = imageInfo.calculate(
          rect: transitionInfo.fromRect!,
          imageMode: ImageInfo.ImageMode(rawValue: fromView.contentMode.rawValue)
        )
      } else {
        transitionInfo.convertedRect = transitionInfo.fromRect
      }
    }
    if transitionInfo.convertedRect != nil {
      self.transitioningDelegate = self
      self.modalPresentationStyle = .overFullScreen
    }
  }
  /**
     Initialization of controller with Image detail , transition detail , imageUrl, and source view
     - Parameters:
        - imageInfo: Image detail for intialization
        - transitionInfo: transition detail for intialization
        - imageHD: Image url
        - fromView: source view
      */
  convenience init(image: UIImage, imageMode: UIView.ContentMode, imageHD: URL?, fromView: UIView?) {
    let imageInfo = ImageInfo(image: image,
                              imageMode: ImageInfo.ImageMode(rawValue: imageMode.rawValue)!,
                              imageHD: imageHD)
    if let fromView = fromView {
      self.init(imageInfo: imageInfo, transitionInfo: TransitionInfo(fromView: fromView))
    } else {
      self.init(imageInfo: imageInfo)
    }
  }
 /// Required Initialization
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override open func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupScrollView()
    setupImageView()
    setupGesture()
    setupImageHD()
    edgesForExtendedLayout = UIRectEdge()
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    imageView.frame = imageInfo.calculate(rect: view.bounds, origin: .zero)
    scrollView.frame = view.bounds
    scrollView.contentSize = imageView.bounds.size
    scrollView.maximumZoomScale = imageInfo.calculateMaximumZoomScale(scrollView.bounds.size)
  }
  /// Preparing UI
  fileprivate func setupView() {
    view.backgroundColor = backgroundColor
  }
  /// Preparing scrollview
  fileprivate func setupScrollView() {
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    view.addSubview(scrollView)
  }
  /// Preparing imageView
  fileprivate func setupImageView() {
    imageView.image = imageInfo.image
    imageView.contentMode = .scaleAspectFit
    scrollView.addSubview(imageView)
  }
  /// Preparing gestures
  fileprivate func setupGesture() {
    let single = UITapGestureRecognizer(target: self, action: #selector(singleTap))
    let double = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
    double.numberOfTapsRequired = 2
    single.require(toFail: double)
    scrollView.addGestureRecognizer(single)
    scrollView.addGestureRecognizer(double)
    if transitionInfo?.canSwipe == true {
      let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
      pan.delegate = self
      scrollView.addGestureRecognizer(pan)
    }
  }
  /// Preparing imageUrl for download
  fileprivate func setupImageHD() {
    guard let imageHD = imageInfo.imageHD else { return }
    let request = URLRequest(url: imageHD, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
    let task = session.dataTask(with: request, completionHandler: { (data, _, _) -> Void in
      guard let data = data else { return }
      guard let image = UIImage(data: data) else { return }
      self.imageView.image = image
      self.view.layoutIfNeeded()
    })
    task.resume()
  }
  // MARK: Gesture
  /// Gesture action on single tap
  @objc fileprivate func singleTap() {
    if navigationController == nil || (presentingViewController != nil &&
      navigationController!.viewControllers.count <= 1) {
      dismiss(animated: true, completion: dismissCompletion)
    }
  }
  /**
  Gesture action on double tap
  - Parameters:
     - gesture: Gesture recognizer instance
  */
  @objc fileprivate func doubleTap(_ gesture: UITapGestureRecognizer) {
    let point = gesture.location(in: scrollView)
    if scrollView.zoomScale == 1.0 {
      scrollView.zoom(to: CGRect(x: point.x-40, y: point.y-40, width: 80, height: 80), animated: true)
    } else {
      scrollView.setZoomScale(1.0, animated: true)
    }
  }
  /// Panview point
  fileprivate var panViewOrigin: CGPoint?
  /// Panview alpha
  var panViewAlpha: CGFloat = 1
  /// Pangesture action
  @objc fileprivate func pan(_ gesture: UIPanGestureRecognizer) {
    func getProgress() -> CGFloat {
      let origin = panViewOrigin!
      let changeX = abs(scrollView.center.x - origin.x)
      let changeY = abs(scrollView.center.y - origin.y)
      let progressX = changeX / view.bounds.width
      let progressY = changeY / view.bounds.height
      return max(progressX, progressY)
    }
    /**
    Point change during pan action
    - Returns: Point change during pan
    */
    func getChanged() -> CGPoint {
      let origin = scrollView.center
      let change = gesture.translation(in: view)
      return CGPoint(x: origin.x + change.x, y: origin.y + change.y)
    }
    /**
    Getting velocity during pan
    - Returns: Velocity return in term of float point
    */
    func getVelocity() -> CGFloat {
      let vel = gesture.velocity(in: scrollView)
      return sqrt(vel.x*vel.x + vel.y*vel.y)
    }
    switch gesture.state {
    case .began:
      panViewOrigin = scrollView.center
    case .changed:
      scrollView.center = getChanged()
      panViewAlpha = 1 - getProgress()
      view.backgroundColor = backgroundColor.withAlphaComponent(panViewAlpha)
      gesture.setTranslation(CGPoint.zero, in: nil)
    case .ended:
      if getProgress() > 0.25 || getVelocity() > 1000 {
        dismiss(animated: true, completion: dismissCompletion)
      } else {
        fallthrough
      }
    default:
      UIView.animate(withDuration: 0.3,
                     animations: {
                      self.scrollView.center = self.panViewOrigin!
                      self.view.backgroundColor = self.backgroundColor
      },
                     completion: { _ in
                      self.panViewOrigin = nil
                      self.panViewAlpha  = 1.0
      }
      )
    }
  }
}
// MARK: - ScrollView Delegate
extension ImageViewerController: UIScrollViewDelegate {
  /**
  Getting velocity during pan
   - Parameters:
      - scrollView: Scrollview instance
  - Returns: A view instance will return
  */
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    imageView.frame = imageInfo.calculate(rect: CGRect(origin: .zero, size: scrollView.contentSize), origin: .zero)
  }
}
