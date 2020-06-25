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
//  ImageViewerExtension.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Transition Delegate
extension ImageViewerController: UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ImageViewerTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .present)
  }
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ImageViewerTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .dismiss)
  }
}
/// ImageView Transion for supporting transitions
class ImageViewerTransition: NSObject, UIViewControllerAnimatedTransitioning {
  /// Image detail
  let imageInfo: ImageInfo
  /// transion detail for animation
  let transitionInfo: TransitionInfo
  /// transition mode for present and dismiss transition
  var transitionMode: TransitionMode
  enum TransitionMode {
    case present
    case dismiss
  }
  /**
   ImageViewer Initalization with image, transition details
    - Parameters:
       - imageInfo: Image detail for viewer
       - transitionInfo: Transtion detail for animation
       - transitionMode: Transition mode detail for animation
   */
  init(imageInfo: ImageInfo, transitionInfo: TransitionInfo, transitionMode: TransitionMode) {
    self.imageInfo = imageInfo
    self.transitionInfo = transitionInfo
    self.transitionMode = transitionMode
    super.init()
  }
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return transitionInfo.duration
  }
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let tempBackground = UIView()
    tempBackground.backgroundColor = ApplicationColor.blackColor
    let tempMask = UIView()
    tempMask.backgroundColor = .black
    tempMask.layer.cornerRadius = transitionInfo.fromView?.layer.cornerRadius ?? 0
    tempMask.layer.masksToBounds = transitionInfo.fromView?.layer.masksToBounds ?? false
    let tempImage = UIImageView(image: imageInfo.image)
    tempImage.contentMode = imageInfo.contentMode
    tempImage.mask = tempMask
    containerView.addSubview(tempBackground)
    containerView.addSubview(tempImage)
    if transitionMode == .present {
      if let imageViewer = transitionContext.viewController(forKey:
        UITransitionContextViewControllerKey.to) as? ImageViewerController {
      imageViewer.view.layoutIfNeeded()
      tempBackground.alpha = 0
      tempBackground.frame = imageViewer.view.bounds
      tempImage.frame = transitionInfo.convertedRect
      tempMask.frame = tempImage.convert(transitionInfo.fromRect, from: nil)
      transitionInfo.fromView?.alpha = 0
      UIView.animate(withDuration: transitionInfo.duration, animations: {
        tempBackground.alpha  = 1
        tempImage.frame = imageViewer.imageView.frame
        tempMask.frame = tempImage.bounds
      }, completion: { _ in
        tempBackground.removeFromSuperview()
        tempImage.removeFromSuperview()
        containerView.addSubview(imageViewer.view)
        transitionContext.completeTransition(true)
      })
     }
    } else if transitionMode == .dismiss {
      if let imageViewer = transitionContext.viewController(forKey:
        UITransitionContextViewControllerKey.from) as? ImageViewerController {
      imageViewer.view.removeFromSuperview()
      tempBackground.alpha = imageViewer.panViewAlpha
      tempBackground.frame = imageViewer.view.bounds
      if imageViewer.scrollView.zoomScale == 1 && imageInfo.imageMode == .aspectFit {
        tempImage.frame = imageViewer.scrollView.frame
      } else {
        tempImage.frame = CGRect(x: imageViewer.scrollView.contentOffset.x * -1,
                                 y: imageViewer.scrollView.contentOffset.y * -1,
                                 width: imageViewer.scrollView.contentSize.width,
                                 height: imageViewer.scrollView.contentSize.height)
      }
      tempMask.frame = tempImage.bounds
      UIView.animate(withDuration: transitionInfo.duration, animations: {
        tempBackground.alpha = 0
        tempImage.frame = self.transitionInfo.convertedRect
        tempMask.frame = tempImage.convert(self.transitionInfo.fromRect, from: nil)
      }, completion: { _ in
        tempBackground.removeFromSuperview()
        tempImage.removeFromSuperview()
        imageViewer.view.removeFromSuperview()
        self.transitionInfo.fromView?.alpha = 1
        transitionContext.completeTransition(true)
      })
     }
    }
  }
}
// MARK: - Gesture Delegate
extension ImageViewerController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let pan = gestureRecognizer as? UIPanGestureRecognizer {
      if scrollView.zoomScale != 1.0 {
        return false
      }
      if imageInfo.imageMode == .aspectFill && (scrollView.contentOffset.x > 0 || pan.translation(in: view).x <= 0) {
        return false
      }
    }
    return true
  }
}
