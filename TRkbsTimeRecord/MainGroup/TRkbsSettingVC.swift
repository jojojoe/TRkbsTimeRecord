//
//  TRkbsSettingVC.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import UIKit
import MessageUI
import Neon
import DeviceKit
import NoticeObserveKit
import ZKProgressHUD
class TRkbsSettingVC: UIViewController {
    
    private var pool = Notice.ObserverPool()
    
    let topBanner = UIView()
    var didlayoutOnce = Once()
    let userCoinLabel = UILabel()
    let purchaseBanner = UIView()
    let coinCountLabel = UILabel()
    let priceLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updateBuyCoinStatus()
        addNotificationObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        didlayoutOnce.run {
            
            let bottomBgV = UIView(frame: CGRect(x: 0, y: purchaseBanner.frame.maxY + 10, width: UIScreen.width, height: 258))
            bottomBgV.adhere(toSuperview: view)
            let privaAttr = NSAttributedString(string: "隐私政策", attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#A24B2C")!])
            let termofAttr = NSAttributedString(string: "用户协议", attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#A24B2C")!])
            let feedAttr = NSAttributedString(string: "联系我们", attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#A24B2C")!])
            let privacyBtn = UIButton()
            privacyBtn.contentHorizontalAlignment = .left
            privacyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
            privacyBtn.setAttributedTitle(privaAttr, for: .normal)
            privacyBtn
                .backgroundColor(UIColor(hexString: "#CDC6C2")!)
                .adhere(toSuperview: bottomBgV)
            privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender: )), for: .touchUpInside)
            privacyBtn.layer.cornerRadius = 10
            //
            let feedbackBtn = UIButton()
            feedbackBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
            feedbackBtn.contentHorizontalAlignment = .left
            feedbackBtn.setAttributedTitle(feedAttr, for: .normal)
            feedbackBtn
                .backgroundColor(UIColor(hexString: "#CDC6C2")!)
                .adhere(toSuperview: bottomBgV)
            feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender: )), for: .touchUpInside)
            feedbackBtn.layer.cornerRadius = 10
            //
            let termBtn = UIButton()
            termBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
            termBtn.contentHorizontalAlignment = .left
            termBtn.setAttributedTitle(termofAttr, for: .normal)
            termBtn
                .backgroundColor(UIColor(hexString: "#CDC6C2")!)
                .adhere(toSuperview: bottomBgV)
            termBtn.addTarget(self, action: #selector(termsTBtnClick(sender: )), for: .touchUpInside)
            termBtn.layer.cornerRadius = 10
            
            
            bottomBgV.groupAndFill(group: .vertical, views: [termBtn, feedbackBtn, privacyBtn], padding: 24)
            
            //
            let arrow1 = UIImageView()
            arrow1.image("arrow_r")
                .adhere(toSuperview: termBtn)
            arrow1.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalTo(-35)
                $0.width.equalTo(20/2)
                $0.height.equalTo(32/2)
            }
            //
            let arrow2 = UIImageView()
            arrow2.image("arrow_r")
                .adhere(toSuperview: feedbackBtn)
            arrow2.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalTo(-35)
                $0.width.equalTo(20/2)
                $0.height.equalTo(32/2)
            }
            //
            let arrow3 = UIImageView()
            arrow3.image("arrow_r")
                .adhere(toSuperview: privacyBtn)
            arrow3.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalTo(-35)
                $0.width.equalTo(20/2)
                $0.height.equalTo(32/2)
            }
        }
    }
    

    
    func setupView() {
        view.backgroundColor(UIColor(hexString: "#1C1C1D")!)
            .clipsToBounds()
        
        //
        
        topBanner.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#252525")!)
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        
        
       //
       let backBtn = UIButton()
        backBtn.adhere(toSuperview: topBanner)
           .image(UIImage(named: "i_downback"))
           .backgroundColor(.clear)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.snp.makeConstraints {
           $0.bottom.equalToSuperview()
           $0.right.equalToSuperview().offset(-20)
           $0.width.height.equalTo(40)
       }
        
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel.adhere(toSuperview: topBanner)
            .text("个人中心")
            .textAlignment(.center)
            .color(.white)
            .fontName(16, "AppleSDGothicNeo-SemiBold")
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        
        purchaseBanner.adhere(toSuperview: view)
            .clipsToBounds()
            .backgroundColor(UIColor(hexString: "#A24B2C")!)
        purchaseBanner.layer.cornerRadius = 10
        purchaseBanner.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(topBanner.snp.bottom).offset(24)
            $0.height.equalTo(130)
        }
        
        //
        
        let purchaseTopV = UIView()
        purchaseTopV.adhere(toSuperview: purchaseBanner)
            .backgroundColor(UIColor(hexString: "#CDC6C2")!)
        purchaseTopV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(44)
        }
        userCoinLabel.adhere(toSuperview: purchaseTopV)
            .text("您的金币数: \(TRkbsPurchaseManager.default.coinCount)")
            .textAlignment(.center)
            .color(UIColor(hexString: "#A24B2C")!)
            .fontName(14, "AppleSDGothicNeo-SemiBold")
        userCoinLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let topCoinImgV = UIImageView()
        topCoinImgV
            .image("coin_s")
            .adhere(toSuperview: purchaseTopV)
        topCoinImgV.snp.makeConstraints {
            $0.centerY.equalTo(userCoinLabel.snp.centerY)
            $0.left.equalTo(userCoinLabel.snp.right).offset(8)
            $0.height.width.greaterThanOrEqualTo(20)
        }
        
        //
        let purchaseBottomV = UIView()
        purchaseBottomV.adhere(toSuperview: purchaseBanner)
        purchaseBottomV.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(purchaseTopV.snp.bottom)
        }
        //
        let coinImgV = UIImageView()
        coinImgV
            .image("coin_b")
            .adhere(toSuperview: purchaseBottomV)
        coinImgV.snp.makeConstraints {
            $0.centerY.equalTo(purchaseBottomV.snp.centerY)
            $0.left.equalTo(purchaseBottomV.snp.left).offset(14)
            $0.height.width.greaterThanOrEqualTo(50)
        }
        //
        
        coinCountLabel.adhere(toSuperview: purchaseBottomV)
            .textAlignment(.left)
            .color(.white)
            .fontName(18, "AppleSDGothicNeo-SemiBold")
        coinCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(coinImgV.snp.centerY)
            $0.left.equalTo(coinImgV.snp.right).offset(10)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        let priceBgImgV = UIImageView()
        priceBgImgV.adhere(toSuperview: purchaseBottomV)
            .backgroundColor(UIColor(hexString: "#CDC6C2")!)

        priceLabel.adhere(toSuperview: purchaseBottomV)
            .textAlignment(.right)
            .color(UIColor(hexString: "#A24B2C")!)
            .fontName(18, "AppleSDGothicNeo-Bold")
        priceLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-40)
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        priceBgImgV.layer.cornerRadius = 40/2
        priceBgImgV.snp.makeConstraints {
            $0.center.equalTo(priceLabel.snp.center)
            $0.height.equalTo(40)
            $0.left.equalTo(priceLabel.snp.left).offset(-15)
        }
        //
        let purchaseBtn = UIButton()
        purchaseBtn.adhere(toSuperview: purchaseBanner)
        purchaseBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        purchaseBtn.addTarget(self, action: #selector(purchaseBtnClick(sender: )), for: .touchUpInside)
        
    }
    
    @objc func purchaseBtnClick(sender: UIButton) {
        if let item = TRkbsPurchaseManager.default.currentBuyModel {
            selectCoinItem(item: item)
        }
        
    }
    
    func selectCoinItem(item: TRkCoinItem) {
        // core
        
        TRkbsPurchaseManager.default.purchaseIapId(item: item) { (success, errorString) in
            if success {
                ZKProgressHUD.showSuccess("购买成功!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                    [weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        
                    }
                }
            } else {
                ZKProgressHUD.showSuccess("购买失败，请重试!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                    [weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        }
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateCoinChange()
            }
        }
        .invalidated(by: pool)
        //
        NotificationCenter.default.nok.observe(name: .pi_noti_priceFetch) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateBuyCoinStatus()
            }
        }
        .invalidated(by: pool)
        
    }
    
    func updateCoinChange() {
        userCoinLabel
            .text("您的金币数: \(TRkbsPurchaseManager.default.coinCount)")
    }
    
    func updateBuyCoinStatus() {
        
        if let item = TRkbsPurchaseManager.default.currentBuyModel {
            coinCountLabel.text("x \(item.coin)")
            if let localPrice = item.localPrice {
                priceLabel.text(localPrice)
            } else {
                priceLabel.text("¥\(item.price)")
            }
        }
        
    }
    
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func privacyBtnClick(sender: UIButton) {
        if let url = URL(string: PrivacyPolicyURLStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func termsTBtnClick(sender: UIButton) {
        if let url = URL(string: TermsofuseURLStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    
}

extension TRkbsSettingVC: MFMailComposeViewControllerDelegate {
  func feedback() {
      //首先要判断设备具不具备发送邮件功能
      if MFMailComposeViewController.canSendMail(){
          //获取系统版本号
          let systemVersion = UIDevice.current.systemVersion
          let modelName = UIDevice.current.modelName
          
          let infoDic = Bundle.main.infoDictionary
          // 获取App的版本号
          let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
          // 获取App的名称
          let appName = "\(AppName)"

          
          let controller = MFMailComposeViewController()
          //设置代理
          controller.mailComposeDelegate = self
          //设置主题
          controller.setSubject("\(appName) Feedback")
          //设置收件人
          // FIXME: feed back email
          controller.setToRecipients([feedbackEmail])
          //设置邮件正文内容（支持html）
       controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
          
          //打开界面
       self.present(controller, animated: true, completion: nil)
      }else{
          HUD.error("The device doesn't support email")
      }
  }
  
  //发送邮件代理方法
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
  }
}
