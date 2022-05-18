//
//  TRkbsPurchaseManager.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/18.
//

import Foundation
import SwiftyStoreKit
import StoreKit
import NoticeObserveKit
import Alamofire
import ZKProgressHUD

extension Notice.Names {
    static let pi_noti_coinChange = Notice.Name<Any?>(name: "tr_noti_coinChange")
    static let pi_noti_priceFetch = Notice.Name<Any?>(name: "tr_noti_priceFetch")
//    Notice.Center.default.post(name: .pi_noti_coinChange, with: nil)
}

class TRkCoinItem {
    var coin: Int  = 0
    var price: String = ""
    var localPrice: String?
    var id: Int = 0
    var iapId: String = ""
    
    //    var
    init(id: Int, iapId: String, coin: Int, price: String) {
        self.id = id
        self.iapId = iapId
        self.coin = coin
        self.price = price
        
    }
}

class TRkbsPurchaseManager: NSObject {
    var coinCount: Int = 0
    var coinIpaItemList: [TRkCoinItem] = []
    let coinFirst: Int = 2
    let coinCostCount: Int = 1
    let k_localizedPriceList = "TRkCoinItem.localizedPriceList"
    var currentBuyModel: TRkCoinItem?
    
    var purchaseCompletion: ((Bool, String?)->Void)?
    static let `default` = TRkbsPurchaseManager()
    
    
    func loadIapList() -> [TRkCoinItem] {
        let iapItem = TRkCoinItem.init(id: 0, iapId: "com.collagemaker.verpro.packcookies", coin: 10, price: "0.99")
        return [iapItem]
    }
    
    deinit {
        removeObserver()
    }
    
    override init() {
        // coin count
        super.init()
        addObserver()
        loadDefaultData()
    }
    
    
    func costCoin(coin: Int) {
        coinCount -= coin
        saveCoinCountToKeychain(coinCount: coinCount)
    }
    
    func addCoin(coin: Int) {
        coinCount += coin
        saveCoinCountToKeychain(coinCount: coinCount)
    }
    
    func saveCoinCountToKeychain(coinCount: Int) {
        TRkbsKeychainSaveManager.saveCoinToKeychain(iconNumber: "\(coinCount)")
        
        Notice.Center.default.post(name: .pi_noti_coinChange, with: nil)
        
    }
    
    
    func loadDefaultData() {
        
#if DEBUG
        TRkbsKeychainSaveManager.removeKeychainCoins()
#endif
        
        if TRkbsKeychainSaveManager.isFirstSendCoin() {
            coinCount = coinFirst
        } else {
            coinCount = TRkbsKeychainSaveManager.readCoinFromKeychain()
        }
        
        // iap items list
        
        coinIpaItemList = loadIapList()
        currentBuyModel = coinIpaItemList.first
        //[iapItem0, iapItem1, iapItem2, iapItem3, iapItem4, iapItem5, iapItem6, iapItem7]
        
        loadCachePrice()
        fetchPrice()
    }
    
    func storeKitBuyCoin(item: TRkCoinItem) {
        let netManager = NetworkReachabilityManager()
        netManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable :
                self.netWorkError()
                break
            case .unknown :
                self.netWorkError()
                break
            case .reachable(_):
                
                ZKProgressHUD.show()
                self.currentBuyModel = item
                self.validateIsCanBought(iapID: item.iapId)
                break
            }
        })
    }
    
    
    
    /*
     func track(_ event: String?, price: Double? = nil, currencyCode: String? = nil) {
     Adjust.appDidLaunch(ADJConfig(appToken: AdjustKey.AdjustKeyAppToken.rawValue, environment: ADJEnvironmentProduction))
     guard let event = event else { return }
     let adjEvent = ADJEvent(eventToken: event)
     if let price = price {
     adjEvent?.setRevenue(price, currency: currencyCode ?? "USD")
     }
     Adjust.trackEvent(adjEvent)
     }
     */
    
    func netWorkError() {
        
//        ZKProgressHUD.showError("The network is not reachable. Please reconnect to continue using the app.")
        ZKProgressHUD.showSuccess("网络貌似除了故障!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
            }
        }
        
    }
    
    func fetchPrice() {
        
        let iapList = coinIpaItemList.compactMap { $0.iapId }
        SwiftyStoreKit.retrieveProductsInfo(Set(iapList)) { [weak self] result in
            guard let `self` = self else { return }
            let priceList = result.retrievedProducts.compactMap { $0 }
            var localizedPriceList: [String: String] = [:]
            
            for (index, item) in self.coinIpaItemList.enumerated() {
                let model = priceList.filter { $0.productIdentifier == item.iapId }.first
                if let price = model?.localizedPrice {
                    self.coinIpaItemList[index].localPrice = price
                    localizedPriceList[item.iapId] = price
                }
            }
            
            //TODO: 保存 iap -> 本地price
            UserDefaults.standard.set(localizedPriceList, forKey: self.k_localizedPriceList)
            
            Notice.Center.default.post(name: .pi_noti_priceFetch, with: nil)
        }
    }
    
    func purchaseIapId(item: TRkCoinItem, completion: @escaping ((Bool, String?)->Void)) {
        self.purchaseCompletion = completion
        storeKitBuyCoin(item: item)
        
        
    }
    
    func loadCachePrice() {
        
        if let localizedPriceDict = UserDefaults.standard.object(forKey: k_localizedPriceList) as?  [String: String] {
            for item in self.coinIpaItemList {
                if let price = localizedPriceDict[item.iapId] {
                    item.localPrice = price
                }
            }
        }
    }
    
}


// Products StoreKit
extension TRkbsPurchaseManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    func addObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func removeObserver() {
        SKPaymentQueue.default().remove(self)
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let productsArr = response.products
        
        if productsArr.count == 0 {
            
            DispatchQueue.main.async {
                ZKProgressHUD.dismiss()
                ZKProgressHUD.showError("购买失败，请重试!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                    [weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        
                    }
                }
//                ZKProgressHUD.showError("The purchase was unsuccessful, please try again.")
            }
            
            return
        }
        
        let payment = SKPayment.init(product: productsArr[0])
        SKPaymentQueue.default().add(payment)
    }
    
    func validateIsCanBought(iapID: String) {
        if SKPaymentQueue.canMakePayments() {
            buyProductInfo(iapID: iapID)
        } else {
            ZKProgressHUD.dismiss()
//            ZKProgressHUD.showError("The purchase was unsuccessful, please try again.")
            ZKProgressHUD.showError("购买失败，请重试!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    func buyProductInfo(iapID: String) {
        let result = SKProductsRequest.init(productIdentifiers: [iapID])
        result.delegate = self
        result.start()
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        DispatchQueue.main.async {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    print("💩💩💩💩purchased")
                    ZKProgressHUD.dismiss()
                    // 购买成功
                    SKPaymentQueue.default().finishTransaction(transaction)
                    if let item = self.currentBuyModel {
                        
                        TRkbsPurchaseManager.default.addCoin(coin: item.coin)
                        
                    }
                    self.purchaseCompletion?(true, nil)
                    break
                    
                case .purchasing:
                    print("💩💩💩💩purchasing")
                    break
                    
                case .restored:
                    print("💩💩💩💩restored")
                    ZKProgressHUD.dismiss()
                    ZKProgressHUD.showError(transaction.error?.localizedDescription)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    break
                    
                case .failed:
                    print("💩💩💩💩failed")
                    //交易失败
                    ZKProgressHUD.dismiss()
                    //                    ZKProgressHUD.showError(transaction.error?.localizedDescription)
                    SKPaymentQueue.default().finishTransaction(transaction)
                    self.purchaseCompletion?(false, transaction.error?.localizedDescription)
                    break
                default:
                    break
                }
            }
        }
    }
}
