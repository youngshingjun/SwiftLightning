//
//  PayMainRouter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-28.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol PayMainRoutingLogic {
  func routeToPayConfirm()
  func routeToWalletMain()
  func routeToCameraMain()
}


protocol PayMainDataPassing {
  var dataStore: PayMainDataStore? { get }
}


class PayMainRouter: NSObject, PayMainRoutingLogic, PayMainDataPassing {
  weak var viewController: PayMainViewController?
  var dataStore: PayMainDataStore?
  
  // MARK: Routing
  
  func routeToPayConfirm() {
    let storyboard = UIStoryboard(name: "PayConfirm", bundle: nil)
    let destinationVC = storyboard.instantiateViewController(withIdentifier: "PayConfirmViewController") as! PayConfirmViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToPayConfirm(source: dataStore!, destination: &destinationDS)
    navigateToPayConfirm(source: viewController!, destination: destinationVC)
  }

  func routeToCameraMain() {
    let storyboard = UIStoryboard(name: "CameraMain", bundle: nil)
    let destinationVC = storyboard.instantiateViewController(withIdentifier: "CameraMainViewController") as! CameraMainViewController
    var destinationDS = destinationVC.router!.dataStore!
    passDataToCameraMain(source: dataStore!, destination: &destinationDS)
    navigateToCameraMain(source: viewController!, destination: destinationVC)
  }
  
  func routeToWalletMain() {
//    let destinatoinVC = viewController! as! WalletMainViewController
//    let destinatoinDS = destinationVC.router!.dataStore!
//    passDataToWalletMain(source: dataStore!, destination: &destinationDS)
    navigateToWalletMain(source: viewController!)
  }
  
  
  // MARK: Navigation
  
  func navigateToPayConfirm(source: PayMainViewController, destination: PayConfirmViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    destination.setSlideTransition(presentTowards: .left, dismissIsInteractive: true)
    navigationController.delegate = destination
    navigationController.pushViewController(destination, animated: true)
  }
  
  func navigateToCameraMain(source: PayMainViewController, destination: CameraMainViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    destination.delegate = source
    destination.setPopTransition(dismissIsInteractive: true)
    navigationController.delegate = destination
    navigationController.pushViewController(destination, animated: true)
  }
  
  func navigateToWalletMain(source: PayMainViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    navigationController.popViewController(animated: true)
  }

  
  // MARK: Passing data

  func passDataToPayConfirm(source: PayMainDataStore, destination: inout PayConfirmDataStore) {
    destination.address = source.address
    destination.amount = source.amount
    destination.description = source.description
    destination.fee = source.fee
    destination.paymentType = source.paymentType
  }
  
  func passDataToCameraMain(source: PayMainDataStore, destination: inout CameraMainDataStore) {
    destination.cameraMode = .payment
  }
  
  func passDataToWalletMain(source: PayMainDataStore, destination: inout WalletMainDataStore) { }
}
