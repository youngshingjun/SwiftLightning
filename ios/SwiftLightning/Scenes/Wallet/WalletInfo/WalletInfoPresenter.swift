//
//  WalletInfoPresenter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-13.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WalletInfoPresentationLogic {
  func presentRefresh(response: WalletInfo.Refresh.Response)
}


class WalletInfoPresenter: WalletInfoPresentationLogic {
  weak var viewController: WalletInfoDisplayLogic?
  
  // MARK: Refresh
  
  func presentRefresh(response: WalletInfo.Refresh.Response) {
    
    switch response.result {
    case .success(let info):
      let bestHdrDate = Date(timeIntervalSince1970: TimeInterval(info.bestHeaderTimestamp))
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale.current
      dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy HH:mm:ss ZZZZ")
      let bestHdrTimestamp = dateFormatter.string(from: bestHdrDate)
      
      var syncedToChain = "Wallet is "
      syncedToChain += info.syncedToChain ? "" : "not "
      syncedToChain += "synced to "
      syncedToChain += info.testnet ? "testnet of " : "mainnet of "
      syncedToChain += info.chains.joined(separator: ", ")
      
      var numNodesString: String?
      var numChannelsString: String?
      
      if let networkInfo = response.networkInfo {
        numNodesString = "\(networkInfo.numNodes)"
        numChannelsString = "\(networkInfo.numChannels)"
      }
      
      let viewModel = WalletInfo.Refresh.ViewModel(idPubKey: info.identityPubkey,
                                                   alias: info.alias,
                                                   pendingChs: "\(info.numPendingChannels)",
                                                   activeChs: "\(info.numActiveChannels)",
                                                   numPeers: "\(info.numPeers)",
                                                   numNodes: numNodesString,
                                                   numChannels: numChannelsString,
                                                   blockHeight: "\(info.blockHeight)",
                                                   blockHash: "\(info.blockHash)",
                                                   bestHdrTimestamp: bestHdrTimestamp,
                                                   syncedChain: "\(syncedToChain)")
      viewController?.displayRefresh(viewModel: viewModel)
      
    case .failure(let error):
      let viewModel = WalletInfo.ErrorVM(errTitle: "Info Error",
                                         errMsg: error.localizedDescription)
      viewController?.displayError(viewModel: viewModel)
    }
  }
}
