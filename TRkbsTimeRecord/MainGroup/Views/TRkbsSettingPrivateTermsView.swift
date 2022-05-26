//
//  TRkbsSettingPrivateTermsView.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/25.
//

import UIKit

class TRkbsSettingPrivateTermsView: UIView {

    var backBtnClickBlock: (()->Void)?
    var termsBtnClickBlock: (()->Void)?
    var privateBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .adhere(toSuperview: self)
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let contentV = UIView()
            .backgroundColor(UIColor(hexString: "#1C1C1D")!)
            .adhere(toSuperview: self)
            .clipsToBounds()
        contentV.layer.cornerRadius = 12
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.equalTo(300)
            $0.height.equalTo(450)
            
        }
        //
        let iconImgV = UIImageView()
        iconImgV.adhere(toSuperview: contentV)
            .contentMode(.scaleAspectFit)
            .image("appicon")
            .clipsToBounds()
        iconImgV.layer.cornerRadius = 6
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(32)
        }
        //
        let versionStr = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
        let versionLabel = UILabel()
        versionLabel.fontName(14, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("\(AppName.localized())-\("掌控每一分钟".localized())\n\("版本号".localized()):\(versionStr)")
            .textAlignment(.center)
            .adhere(toSuperview: contentV)
            .numberOfLines()
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(30)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        let contentInfoLabel = UILabel()
        contentInfoLabel.fontName(15, "AppleSDGothicNeo-Bold")
            .color(.white)
            .text("请阅读并理解我们的".localized())
            .adhere(toSuperview: contentV)
        contentInfoLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(versionLabel.snp.bottom).offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        let termsBtn = UIButton()
        termsBtn.adhere(toSuperview: contentV)
        termsBtn.snp.makeConstraints {
            $0.top.equalTo(contentInfoLabel.snp.bottom).offset(4)
            $0.left.equalTo(contentInfoLabel.snp.left)
            $0.width.greaterThanOrEqualTo(40)
            $0.height.greaterThanOrEqualTo(10)
        }
        
        let privateBtn = UIButton()
        privateBtn.adhere(toSuperview: contentV)
        privateBtn.snp.makeConstraints {
            $0.top.equalTo(termsBtn.snp.bottom).offset(0)
            $0.left.equalTo(termsBtn.snp.left)
            $0.width.greaterThanOrEqualTo(40)
            $0.height.greaterThanOrEqualTo(10)
        }
        //
        let termofAttr = NSAttributedString(string: "用户服务协议".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#A24B2C")!, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor : UIColor(hexString: "#A24B2C")!])
        //
        let privateAttr = NSAttributedString(string: "隐私政策".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : UIColor(hexString: "#A24B2C")!, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor : UIColor(hexString: "#A24B2C")!])
        
        termsBtn.setAttributedTitle(termofAttr, for: .normal)
        privateBtn.setAttributedTitle(privateAttr, for: .normal)
        
        //
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender: )), for: .touchUpInside)
        privateBtn.addTarget(self, action: #selector(privateBtnClick(sender: )), for: .touchUpInside)
        //
        
        let contentStr = "隐私信息描述".localized()
         
        let contentLabel = UITextView()
        contentLabel.backgroundColor(.clear)
        contentLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        contentLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        contentLabel.text = contentStr
        contentLabel.adhere(toSuperview: contentV)
        contentLabel.isEditable = false
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(privateBtn.snp.left).offset(-4)
            $0.top.equalTo(privateBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-70)
        }
        //
        let agreebtn = UIButton()
        agreebtn.adhere(toSuperview: contentV)
            .font(15, "AppleSDGothicNeo-Bold")
            .titleColor(UIColor(hexString: "#A24B2C")!)
            .backgroundColor(UIColor(hexString: "#CDC6C2")!)
            .title("确定".localized())
        agreebtn.layer.cornerRadius = 8
        agreebtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-24)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(60)
            $0.height.greaterThanOrEqualTo(36)
        }
        agreebtn.addTarget(self, action: #selector(agreebtnClick(sender: )), for: .touchUpInside)
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        termsBtnClickBlock?()
    }
    
    @objc func privateBtnClick(sender: UIButton) {
        privateBtnClickBlock?()
    }
    
    @objc func agreebtnClick(sender: UIButton) {
        backBtnClickBlock?()
    }
    
    
}
