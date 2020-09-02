//
//  IAPManager.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 2/9/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

class IAPManager {
    enum PurchaseType: String {
        case nonConsumable
    }
    
    var inAppPurchases: [InAppPurchase] = []
    
    private let bundleID = Bundle.main.bundleIdentifier!
    private var isIAPManagerStarted = false
    
    static var shared = IAPManager()
    private init() { }
    
    // MARK: - Public methods
    /// Start IAPManager
    func start() {
        isIAPManagerStarted = true
        setupInAppPurchases()
        fetchInAppPurchases()
    }
    
    /// Purchase a product
    func purchase(_ suffix: String, completion: @escaping (Bool) -> Void) {
        if !isIAPManagerStarted {
            print("⚠️ IAPManager is not started! Please add 'IAPManager.shared.start()' to your 'application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)' in AppDelegate.swift")
            return
        }
        
        SwiftyStoreKit.purchaseProduct(bundleID + "." + suffix, atomically: true) { [weak self] (result) in
            self?.logForPurchaseResult(result)
            
            switch result {
            case .success(purchase: _):
                completion(true)
            case .error(error: let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
    /// Restore a product
    func restorePurchases(completion: @escaping(Bool?) -> Void) {
        if !isIAPManagerStarted {
            print("⚠️ IAPManager is not started! Please add 'IAPManager.shared.start()' to your 'application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)' in AppDelegate.swift")
            return
        }
        
        SwiftyStoreKit.restorePurchases(atomically: true) { [weak self] (results) in
            self?.logForRestorePurchases(results)
            
            if !results.restoreFailedPurchases.isEmpty {
                completion(false)
            } else if !results.restoredPurchases.isEmpty {
                completion(true)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Private methods
    /// Setup in app purchases on initial launch
    private func setupInAppPurchases() {
        if Self.isDebugMode {
            print("Completing transactions...")
        }
        
        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
        
    }
    
    /// Fetch all the available in app purchases
    private func fetchInAppPurchases() {
        if !isIAPManagerStarted {
            print("⚠️ IAPManager is not started! Please add 'IAPManager.shared.start()' to your 'application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)' in AppDelegate.swift")
            return
        }
        
        if Self.isDebugMode {
            print("Fetching registed in-app purchases...")
        }
        
        for registeredPurchase in Self.registeredPurchases {
            getInfo(registeredPurchase.suffix) { [self] (product) in
                guard
                    let product = product,
                    let price = product.localizedPrice
                else { return }
                
                let id = bundleID + "." + registeredPurchase.suffix
                let title = product.localizedTitle
                let description = product.localizedDescription
                let iap = InAppPurchase(
                    id: id,
                    registeredPurchase: registeredPurchase,
                    title: title,
                    description: description,
                    price: price
                )
                
                inAppPurchases.append(iap)
            }
        }
        
    }
    
    private func getInfo(_ suffix: String, completion: @escaping (SKProduct?) -> Void) {
        if !isIAPManagerStarted {
            print("⚠️ IAPManager is not started! Please add 'IAPManager.shared.start()' to your 'application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)' in AppDelegate.swift")
            return
        }
        
        SwiftyStoreKit.retrieveProductsInfo([bundleID + "." + suffix]) { [self] (result) in
            logForProductRetrievalInfo(result)
            
            if let product = result.retrievedProducts.first {
                completion(product)
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - Debug logging
extension IAPManager {
    private func logForProductRetrievalInfo(_ result: RetrieveResults) {
        if !Self.isDebugMode { return }
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            print("\(product.localizedTitle) ~> \(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            print("Could not retrieve product info ~> Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            print("Could not retrieve product info ~> \(errorString)")
        }
    }
    
    private func logForPurchaseResult(_ result: PurchaseResult) {
        if !Self.isDebugMode { return }
        switch result {
        case .success(let purchase):
            print("Purchase Success ~> \(purchase.productId)")
        case .error(let error):
            print("Purchase Failed ~> \(error)")
            switch error.code {
            case .unknown:
                print("Purchase failed ~> \(error.localizedDescription)")
            case .clientInvalid: // client is not allowed to issue the request, etc.
                print("Purchase failed ~> Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                print("Purchase failed ~> Payment canceled")
            case .paymentInvalid: // purchase identifier was invalid, etc.
                print("Purchase failed ~> The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                print("Purchase failed ~> The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                print("Purchase failed ~> The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                print("Purchase failed ~> Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                print("Purchase failed ~> Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                print("Purchase failed ~> Cloud service was revoked")
                
            default:
                print("Purchase failed ~> \((error as NSError).localizedDescription)")
            }
        }
    }
    
    private func logForRestorePurchases(_ results: RestoreResults) {
        if !Self.isDebugMode { return }
        if !results.restoreFailedPurchases.isEmpty {
            print("Restore Failed: \(results.restoreFailedPurchases)")
        } else if !results.restoredPurchases.isEmpty {
            print("Restore Success: \(results.restoredPurchases)")
        } else {
            print("Nothing to Restore")
        }
    }
    
    private func logForVerifyReceipt(_ result: VerifyReceiptResult) {
        if !Self.isDebugMode { return }
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            print("Receipt verified ~> Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                print("Receipt verification ~> No receipt data. Try again.")
            case .networkError(let error):
                print("Receipt verification ~> Network error while verifying receipt: \(error)")
            default:
                print("Receipt verification ~> Receipt verification failed: \(error)")
            }
        }
    }
    
    private func logForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) {
        if !Self.isDebugMode { return }
        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate) - \(items)")
            print("Product is purchased ~> Product is valid until \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate) - \(items)")
            print("Product expired ~> Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            print("Not purchased ~> This product has never been purchased")
        }
    }
    
    private func logForVerifyPurchase(_ result: VerifyPurchaseResult, productId: String) {
        if !Self.isDebugMode { return }
        switch result {
        case .purchased:
            print("\(productId) is purchased ~> Product will not expire")
        case .notPurchased:
            print("\(productId) has never been purchased")
        }
    }
}

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}
