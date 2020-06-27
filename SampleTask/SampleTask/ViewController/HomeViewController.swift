//
//  HomeViewController.swift
//  SampleTask
//
//  Created by Piyush on 25/06/20.
//  Copyright © 2020 Piyush. All rights reserved.
//

import UIKit

/// HomeView Controller is main root controller For Displaying Content

class HomeViewController: UIViewController {
  /// View model
  private var viewModel: HomeViewModel?
  /// Tableview instance
  private let tableView = UITableView()
  /// Loading Flag
  private var shouldAnimatedLoading = true
  /// loading indicator button instance
  private let progressIndicator = SpinnerButton()
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareSetUp()
  }
  // MARK: General Functions
  /**
   Preparing the UI at first launch of the HomeViewController
   Initializing tableview, loadingIndicator and viewmodel and view model setup
   */
  private func prepareSetUp() {
    view.addSubview(tableView)
    // Prepare TableView
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    tableView.dataSource = self
    tableView.delegate = self
    tableView.refreshControl = UIRefreshControl()
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    tableView.showsVerticalScrollIndicator = false
    tableView.refreshControl?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.homeCell)
    tableView.refreshControl?.tintColor = ApplicationColor.borderColor
    navigationItem.title = Message.sampleTask.value
    view.addSubview(progressIndicator)
    progressIndicator.frame = CGRect(x: Dimensions.loaderXPosition ,
                                 y: Dimensions.loaderYPosition ,
                                 width: Dimensions.loaderWidth,
                                 height: Dimensions.loadderHeight)
    progressIndicator.center = view.center
    progressIndicator.animate(animation: .collapse)
    view.bringSubviewToFront(progressIndicator)
    prepareViewModel()
  }
  /**
   Initializing viewmodel and attaching the handler with instance
   */
  private func prepareViewModel() {
    viewModel =  HomeViewModel()
    viewModel?.viewModelBinding = { [weak self] detail, error in
      guard let getSelf = self else { return }
      DispatchQueue.main.async {
        if error != nil {
          getSelf.showAlert(message: error, delay: 0.3)
        } else if error == nil, detail != nil {
          getSelf.navigationItem.title = detail?.title ?? Message.sampleTask.value
          getSelf.tableView.reloadData()
        }
        getSelf.tableView.refreshControl?.endRefreshing()
        getSelf.shouldAnimate(status: false)
        getSelf.showLoader(status: false)
      }
    }
    viewModel?.getCountryDetailFromApi()
  }
  /**
   Showing the custom loading view on first launch
   - Parameters:
      - status: Boolean for show and hide the loading view
   */
  private func showLoader(status: Bool) {
    progressIndicator.isHidden = !status
    progressIndicator.animate(animation: (status == true) ? .collapse : .expand)
  }
  // MARK: ACTIONS
  /// Fetch the country list form the API call
  @objc private func refreshAction() {
    viewModel?.getCountryDetailFromApi()
    shouldAnimate(status: true, delay: 0.3)
  }
  /**
   Setting the status for showing loading indicator
   - Parameters:
      - status: Boolean for setting indicator status
      - delay:  Animation delay time
   */
  private func shouldAnimate(status: Bool, delay: Double = 1.0) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
      self.shouldAnimatedLoading = status
    }
  }
}
// MARK: DataSource Extensions
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.getRowsCount() ?? 0
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier:
      CellIdentifiers.homeCell,
                                                   for: indexPath) as? HomeTableViewCell
      else { return UITableViewCell() }
    if let item = viewModel?.getRowDetailFor(index: indexPath.row) {
      cell.setUpCellDetail(detail: item)
    }
    return cell
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                 forRowAt indexPath: IndexPath) {
    if shouldAnimatedLoading == false { return }
    let animation = AnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height - 20,
                                                          duration: 1.2,
                                                          delayFactor: 0.05)
    let animator = Animator(animation: animation)
    animator.animate(cell: cell, at: indexPath, in: tableView)
  }
}

// MARK: TableView Datasource
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? HomeTableViewCell {
      cell.setUpImageViewer()
    }
  }
}
