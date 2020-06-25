//
//  HomeTableViewCell.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/// Tableview Cell class

class HomeTableViewCell: UITableViewCell {
  /// Property View Container for all child element
  private let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true // this will make sure its children do not go out of the boundary
    view.layer.borderWidth = 1.0
    view.layer.cornerRadius = 4.0
    view.layer.borderColor = ApplicationColor.borderColor.cgColor
    return view
  }()
  /// Property ImageView for image
  private let imageViewPicture: UIImageView = {
    let img = UIImageView.init(image: UIImage(named: "placeholder"))
    img.contentMode = .scaleToFill // image will never be strecthed vertially or horizontally
    img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
    return img
  }()
  /// Property For Title Label
  private let labelTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textColor = ApplicationColor.descriptionTextColor
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  /// Property Description Label
  private let labelDescription: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor =  ApplicationColor.titleTextColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  /**
    Setting Up Cell Detail With Row
   - Parameters:
      - detail: Detail for cell item
  */
  func setUpCellDetail(detail: Row) {
    labelTitle.text = detail.title
    labelDescription.text = detail.rowDescription
    if let imagePath = detail.imageHref?.rectifyUrlPath() {
      imageViewPicture.setImage(from: imagePath)
    } else {
      imageViewPicture.image = UIImage(named: "placeholder")
    }
  }
  /// Presenting imageViewer with initializing the imagepickercontroller
  func setUpImageViewer() {
    let imageInfo   = ImageInfo(image: imageViewPicture.image ?? UIImage(), imageMode: .aspectFit)
    let transitionInfo = TransitionInfo(fromView: imageViewPicture)
    let imageViewer = ImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
    imageViewer.dismissCompletion = {}
    if let viewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
      viewController.present(imageViewer, animated: true, completion: nil)
    }
  }
  /// TableViewCell initailization
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    containerView.addSubview(imageViewPicture)
    containerView.addSubview(labelTitle)
    containerView.addSubview(labelDescription)
    contentView.addSubview(containerView)
    selectionStyle = .none
    containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
    containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
    containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    imageViewPicture.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
    imageViewPicture.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
    imageViewPicture.heightAnchor.constraint(equalToConstant: 50).isActive = true
    imageViewPicture.widthAnchor.constraint(equalToConstant: 50).isActive = true
    labelTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
    labelTitle.leadingAnchor.constraint(equalTo: imageViewPicture.trailingAnchor, constant: 10).isActive = true
    labelTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5).isActive = true
    labelDescription.leadingAnchor.constraint(equalTo: imageViewPicture.trailingAnchor, constant: 10).isActive = true
    labelDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
    labelDescription.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
  }
  /// Required initialization
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
