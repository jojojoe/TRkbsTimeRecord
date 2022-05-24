//
//  TRkbsHabitVC.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import UIKit
import ZKProgressHUD
import Alertift
import NoticeObserveKit

class TRkbsHabitVC: UIViewController {

    let backBtn = UIButton()
    let iconBgV = UIView()
    let iconImgV = UIImageView()
    let textFiled = UITextField()
    let colorView = TRkbsColorView(frame: .zero, colors: DataManagerTool.default.colorList)
    let iconView = TRkbsIconView(frame: .zero, icons: DataManagerTool.default.iconList)
    let tagV = TRkbsTagView()
    let deleteBtn = UIButton()
    let bgTapBtn = UIButton()
    var didlayoutOnce: Once = Once()
    var currentHabitPreviewItem: TRkHabitPreviewItem?
    
    var currentIconStr: String = DataManagerTool.default.iconList[0]
    var currentBgColorStr: String = DataManagerTool.default.colorList[0]
    var currentTimeTypeTagStr: String = DataManagerTool.default.timeTypeTagList[0]
    var currentHaibtName: String = ""
    
    
    init(editingHabitItem: TRkHabitPreviewItem? = nil) {
        self.currentHabitPreviewItem = editingHabitItem
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        didlayoutOnce.run {
            if let habitItem = currentHabitPreviewItem {
                currentIconStr = habitItem.iconStr
                currentBgColorStr = habitItem.bgColorStr
                currentTimeTypeTagStr = habitItem.timeTypeTagStr
                currentHaibtName = habitItem.nameStr
                deleteBtn.isHidden = false
            } else {
                deleteBtn.isHidden = true
            }
            updateContentUIStatus()
        }
    }

}

extension TRkbsHabitVC {
    func updateContentUIStatus() {
        updateIconImg(iconStr: currentIconStr)
        updateBgColor(bgColorStr: currentBgColorStr)
        updateTimeTypeTag(tagStr: currentTimeTypeTagStr)
        textFiled.text = currentHaibtName
    }
    
    func updateIconImg(iconStr: String) {
        currentIconStr = iconStr
        iconImgV.image(iconStr)
        iconView.currentIcon = iconStr
        iconView.collection.reloadData()
    }
    
    func updateBgColor(bgColorStr: String) {
        currentBgColorStr = bgColorStr
        iconBgV.backgroundColor(UIColor(hexString: bgColorStr) ?? UIColor.white)
        colorView.currentColor = bgColorStr
        colorView.collection.reloadData()
    }
    
    func updateTimeTypeTag(tagStr: String) {
        currentTimeTypeTagStr = tagStr
        tagV.tagCollection.currentTitleType = tagStr
        tagV.tagCollection.collection.reloadData()
    }
    
    
}

extension TRkbsHabitVC {
    func setupView() {
        //#1C1C1D
        view.backgroundColor(UIColor(hexString: "#1C1C1D")!)
            .clipsToBounds()
        //
        let topBanner = UIView()
        topBanner.adhere(toSuperview: view)
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.height.equalTo(44)
        }
         
        //
        
        backBtn.adhere(toSuperview: topBanner)
            .image(UIImage(named: "i_back"))
            .backgroundColor(.clear)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let doneBtn = UIButton()
        doneBtn.adhere(toSuperview: topBanner)
            .image(UIImage(named: "i_done"))
            .backgroundColor(.clear)
        doneBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        doneBtn.addTarget(self, action: #selector(doneBtnClick(sender: )), for: .touchUpInside)
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel.adhere(toSuperview: topBanner)
            .text("新的习惯".localized())
            .textAlignment(.center)
            .color(.white)
            .fontName(16, "AppleSDGothicNeo-SemiBold")
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let contentScrollV = UIScrollView()
        contentScrollV.adhere(toSuperview: view)
        contentScrollV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        contentScrollV.contentSize = CGSize(width: UIScreen.width, height: 780)
        //
        let contentBgV = UIView()
        contentBgV.adhere(toSuperview: contentScrollV)
        contentBgV.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 1200)
        
        
        //

        iconBgV.adhere(toSuperview: contentBgV)
        iconBgV.backgroundColor(UIColor(hexString: currentBgColorStr)!)
        iconBgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
            $0.width.height.equalTo(54)
        }
        iconBgV.layer.cornerRadius = 54/2
        iconBgV.layer.borderColor = UIColor(hexString: currentBgColorStr)?.withAlphaComponent(0.7).cgColor
        iconBgV.layer.borderWidth = 0.5
        //
        
        iconImgV.adhere(toSuperview: iconBgV)
            .image("")
        iconImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        //
        textFiled.attributedPlaceholder = NSAttributedString(string: "填入习惯名称".localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#D7D7D7")!, NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!])
        
        textFiled.backgroundColor(UIColor.white.withAlphaComponent(0.3))
        textFiled.delegate = self
        textFiled.text = ""
        textFiled.textAlignment = .center
        textFiled.leftViewMode = .always
        textFiled.rightViewMode = .always
        textFiled.returnKeyType = .done
        textFiled.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textFiled.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textFiled.adhere(toSuperview: contentBgV)
        textFiled.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.top.equalTo(iconBgV.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
        textFiled.tintColor(UIColor(hexString: "#F6DAC0")!)
        textFiled.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        textFiled.textColor = UIColor.white
        textFiled.layer.cornerRadius = 4
        textFiled.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        textFiled.layer.borderWidth = 1
        
        //
        
        colorView.adhere(toSuperview: contentBgV)
        colorView.snp.makeConstraints {
            $0.top.equalTo(textFiled.snp.bottom).offset(22)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(colorView.cellW * 2 + colorView.padding + 45)
        }
        colorView.colorSelectBlock = {
            [weak self] colorStr, colorIndexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateBgColor(bgColorStr: colorStr)
            }
        }
        
        //
        iconView.adhere(toSuperview: contentBgV)
        iconView.snp.makeConstraints {
            $0.top.equalTo(colorView.snp.bottom).offset(22)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(colorView.cellW * 4 + colorView.padding * 3 + 45)
        }
        iconView.iconSelectBlock = {
            [weak self] iconStr, iconIndexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateIconImg(iconStr: iconStr)
            }
        }
        
        //
        
        tagV.adhere(toSuperview: view)
        tagV.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(22)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(30 + 45)
        }
        tagV.tagCollection.selectItemBlock = {
            [weak self] tagitem, _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateTimeTypeTag(tagStr: tagitem)
            }
        }
        
        //
        deleteBtn.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#E5463A")!)
            .title("删除这个习惯".localized())
            .titleColor(.white)
            .font(20, "AppleSDGothicNeo-SemiBold")
        deleteBtn.layer.cornerRadius = 6
        deleteBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tagV.snp.bottom).offset(40)
            $0.left.equalTo(40)
            $0.height.equalTo(44)
        }
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
        
        //
        bgTapBtn.isHidden = true
        bgTapBtn.adhere(toSuperview: view)
        bgTapBtn.addTarget(self, action: #selector(bgTapBtnClick(sender: )), for: .touchUpInside)
        bgTapBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc func deleteBtnClick(sender: UIButton) {
        
        Alertift.alert(title: "确定要删除该习惯吗".localized(), message: "这将删除掉所有该习惯下的记录".localized())
            .action(.cancel("取消".localized()))
            .action(.default("确定".localized()), handler: {[weak self] _, _, _ in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.deleteHaibtPreview()
                }
            })
            .show(on: self, completion: nil)
    }
}



extension TRkbsHabitVC {
    func deleteHaibtPreview() {
        if let habitItem = currentHabitPreviewItem {
            TRkbsDBManager.default.deleteHabitBound(habitId: habitItem.habitId) {
                debugPrint("delete habit preview success")
                Notice.Center.default.post(name: .updateDayRecordList, with: nil)
                Notice.Center.default.post(name: .updateHabitList, with: nil)
                
                ZKProgressHUD.showSuccess("删除成功!".localized(), maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                    [weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        self.backBtnClick(sender: self.backBtn)
                    }
                }
            }
        }
    }
}

extension TRkbsHabitVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doneBtnClick(sender: UIButton) {
        if textFiled.text == nil || textFiled.text == "" || currentHaibtName == "" {
            ZKProgressHUD.showMessage("请输入习惯名称".localized())
            return
        }
        if let historyItem = currentHabitPreviewItem {
            if historyItem.nameStr == currentHaibtName && historyItem.bgColorStr == currentBgColorStr && historyItem.timeTypeTagStr == currentTimeTypeTagStr && historyItem.iconStr == currentIconStr {
                backBtnClick(sender: self.backBtn)
                return
            } else {
                let item = TRkHabitPreviewItem(habitId: historyItem.habitId, iconStr: currentIconStr, bgColorStr: currentBgColorStr, nameStr: currentHaibtName, timeTypeTagStr: currentTimeTypeTagStr, timeCount: 0)
                TRkbsDBManager.default.updateHabitBound(model: item) {
                    debugPrint("update habit preview success")
                    
                    Notice.Center.default.post(name: .updateHabitList, with: nil)

                    DispatchQueue.main.async {
                        self.backBtnClick(sender: self.backBtn)
                    }
                }
            }
        } else {
            if TRkbsPurchaseManager.default.coinCount >= 1 {
                // add new
                let item = TRkHabitPreviewItem(habitId: "nil", iconStr: currentIconStr, bgColorStr: currentBgColorStr, nameStr: currentHaibtName, timeTypeTagStr: currentTimeTypeTagStr, timeCount: 0)
                
                TRkbsDBManager.default.addHabitBound(model: item) {
                    debugPrint("add habit preview success")
                    
                    Notice.Center.default.post(name: .updateHabitList, with: nil)
                    DispatchQueue.main.async {
                        self.backBtnClick(sender: self.backBtn)
                        TRkbsPurchaseManager.default.consumeCoin()
                    }
                }
            } else {
                ZKProgressHUD.showMessage("抱歉金币不足，请先购买金币再进行操作".localized(), maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 1) {
                    [weak self] in
                    guard let `self` = self else {return}
                    DispatchQueue.main.async {
                        self.present(TRkbsSettingVC(), animated: true)
                    }
                }
                
            }
            
        }
    }
    
    @objc func bgTapBtnClick(sender: UIButton) {
        textFiled.resignFirstResponder()
        currentHaibtName = textFiled.text ?? ""
        bgTapBtn.isHidden = true
    }
    
}

extension TRkbsHabitVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bgTapBtn.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debugPrint("return end")
        textField.resignFirstResponder()
        currentHaibtName = textField.text ?? ""
        bgTapBtn.isHidden = true
        return true
    }
    
    
}



