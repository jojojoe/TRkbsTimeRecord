//
//  TRkbsHabitVC.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import UIKit

class TRkbsHabitVC: UIViewController {

    let iconBgV = UIView()
    let iconImgV = UIImageView()
    let textFiled = UITextField()
    let colorView = TRkbsColorView(frame: .zero, colors: DataManagerTool.default.colorList)
    let iconView = TRkbsIconView(frame: .zero, icons: DataManagerTool.default.iconList)
    let tagV = TRkbsTagView()
    let deleteBtn = UIButton()
    var didlayoutOnce: Once = Once()
    var currentHabitPreviewItem: TRkHabitPreviewItem?
    
    var currentIconStr: String = DataManagerTool.default.iconList[0]
    var currentBgColorStr: String = DataManagerTool.default.colorList[0]
    var currentTimeTypeTagStr: String = DataManagerTool.default.timeTypeTagList[0]
    
    
    
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
        let backBtn = UIButton()
        backBtn.adhere(toSuperview: topBanner)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let doneBtn = UIButton()
        doneBtn.adhere(toSuperview: topBanner)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        doneBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        doneBtn.addTarget(self, action: #selector(doneBtnClick(sender: )), for: .touchUpInside)
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel.adhere(toSuperview: topBanner)
            .text("新的习惯")
            .textAlignment(.center)
            .color(.white)
            .fontName(20, "AppleSDGothicNeo-SemiBold")
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
        contentScrollV.contentSize = CGSize(width: UIScreen.width, height: 1200)
        //
        let contentBgV = UIView()
        contentBgV.adhere(toSuperview: contentScrollV)
        contentBgV.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 1200)
        //
        let bgTapBtn = UIButton()
        bgTapBtn.adhere(toSuperview: contentBgV)
        bgTapBtn.addTarget(self, action: #selector(bgTapBtnClick(sender: )), for: .touchUpInside)
        bgTapBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
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
        textFiled.attributedPlaceholder = NSAttributedString(string: "填入习惯名称", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#D7D7D7")!, NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!])
        
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
            $0.height.equalTo(colorView.cellW * 2 + colorView.padding + 35)
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
            $0.height.equalTo(colorView.cellW * 4 + colorView.padding * 3 + 35)
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
            $0.height.equalTo(30 + 35)
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
            .title("删除这个习惯")
            .titleColor(.white)
            .font(20, "AppleSDGothicNeo-SemiBold")
        deleteBtn.layer.cornerRadius = 6
        deleteBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tagV.snp.bottom).offset(40)
            $0.left.equalTo(40)
            $0.height.equalTo(44)
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
        
    }
    @objc func bgTapBtnClick(sender: UIButton) {
        textFiled.resignFirstResponder()
    }
    
    
}

extension TRkbsHabitVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debugPrint("return end")
        textField.resignFirstResponder()
        return true
    }
    
    
}



