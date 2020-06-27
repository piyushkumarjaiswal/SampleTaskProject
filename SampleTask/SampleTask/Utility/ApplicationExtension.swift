//
//  ApplicationExtension.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/// Image cache container for image caching
let imageCache = NSCache<AnyObject, AnyObject>()

/// String Extensions
extension String {
  /**
   Update the url path string http with https
   - Returns: Modified url with https in url prefix
   */
  func rectifyUrlPath() -> String? {
    if contains("https") {
      return self
    } else if contains("http") {
      let updatedString = replacingOccurrences(of: "http", with: "https")
      return updatedString
    }
    return self
  }
}

/// ImageView Extension
extension UIImageView {
  /**
   Loading imade on imageView from either from url or cache
   - Parameters: Url string for image loading
   */
  func setImage(from urlString: String) {
    image = UIImage(named: "placeholder")
    if let url = NSURL(string: urlString) {
      if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
        image = imageFromCache as? UIImage
        return
      }
      DispatchQueue.global(qos: .default).async {
        if let data = NSData(contentsOf: url as URL) {
          DispatchQueue.main.async {
            if let image = UIImage(data: data as Data) {
              self.image = image
              imageCache.setObject(image, forKey: url as AnyObject)
            }
          }
        }
      }
    }
  }
}

/// Tableview Extensions
extension UITableView {
  /**
   Identifying weather the given index path is last visible indexpath
   - Parameters:
       - indexPath: Indexpath for cell
   - Returns: Boolean value for last indexpath detection
   
   */
  func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
    guard let lastIndexPath = indexPathsForVisibleRows?.last else {
      return false
    }
    return lastIndexPath == indexPath
  }
}

/// UIViewController Extension

extension UIViewController {
  /**
   Showing alert inside the application using UIAlertController
   - Parameters:
      - message: Message inside alert
      - title: Title in header of alert
   */
  func showAlert(message: String?, title: String = Message.header.value, delay: Double = 0.0) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
      let alertController = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(OKAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
