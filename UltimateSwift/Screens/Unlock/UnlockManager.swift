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
    case loaded(SKProduct)
    case failed(Error?)
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
  private enum StoreError: Error {
    case invalidIdentifiers, missingProduct
  }
  var canMakePayments: Bool {
    SKPaymentQueue.canMakePayments()
  }

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
    guard dataController.fullVersionUnlocked == false else { return }
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
    DispatchQueue.main.async { [self] in
      for transaction in transactions {
        switch transaction.transactionState {
        case .purchased, .restored:
          self.dataController.fullVersionUnlocked = true
          self.requestState = .purchased
          queue.finishTransaction(transaction)
        case .failed:
          if let product = loadedProducts.first {
            self.requestState = .loaded(product)
          } else {
            self.requestState = .failed(transaction.error)
          }
          queue.finishTransaction(transaction)
        case.deferred:
          self.requestState = .deferred
        default:
          break
        }
      }
    }
  }

  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    DispatchQueue.main.async {
      // Store the returned products for later, if we need them.
      self.loadedProducts = response.products
      guard let unlock = self.loadedProducts.first else {
        self.requestState = .failed(StoreError.missingProduct)
        return
      }
      if response.invalidProductIdentifiers.isEmpty == false {
        print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
        self.requestState = .failed(StoreError.invalidIdentifiers)
        return
      }
      self.requestState = .loaded(unlock)
    }
  }

  func buy(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  func restore() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}
