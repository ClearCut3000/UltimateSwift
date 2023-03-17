//
//  UnlockManager.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 17.03.2023.
//

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {

  // MARK: - Properties
  enum RequestState {
    case loading
    case loaded
    case failed
    case purchased
    case deferred
  }
  @Published var requestState = RequestState.loading
  // to store a reference to DataController so we can mark a purchase as completed
  private let dataController: DataController
  // responsible for fetching available products from App Store Connect
  private let request: SKProductsRequest
  // to store the list of products that were sent back
  private var loadedProducts = [SKProduct]()

  // MARK: - Init
  init(dataController: DataController) {
      // Store the data controller we were sent.
      self.dataController = dataController
      // Prepare to look for our unlock product.
      let productIDs = Set(["com.example.UltimateSwift.unlock"])
      request = SKProductsRequest(productIdentifiers: productIDs)
      // This is required because we inherit from NSObject.
      super.init()
      // Start watching the payment queue.
      SKPaymentQueue.default().add(self)
      // Set ourselves up to be notified when the product request completes.
      request.delegate = self
      // Start the request
      request.start()
  }

  // MARK: - Deinit
  deinit {
      SKPaymentQueue.default().remove(self)
  }

  // MARK: - Methods
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

  }

  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    
  }
}
