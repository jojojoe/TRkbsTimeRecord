//
//  TRkbsRecordPageVC.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/13.
//

import UIKit

class TRkbsRecordPageVC: UIViewController {

    var currentHabitPreviewItem: TRkHabitPreviewItem
    var cancelClickActionBlock: (()->Void)?
    let topTitleBgV = UIView()
    let topIconImgV = UIImageView()
    let topTitleLabel = UILabel()
    let topDetailLabel = UILabel()
    let countPicker = UIPickerView()
    let danweiPicker = UIPickerView()
    let infoTextView = UITextView()
    init(editingHabitItem: TRkHabitPreviewItem) {
        self.currentHabitPreviewItem = editingHabitItem
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateContenStatus()
        
    }
    
}
extension TRkbsRecordPageVC {
    func updateContenStatus() {
        topTitleBgV.backgroundColor(UIColor(hexString: currentHabitPreviewItem.bgColorStr) ?? UIColor.white)
        topTitleLabel.text(currentHabitPreviewItem.nameStr)
        let timeStr = DataManagerTool.default.formatDate(second: currentHabitPreviewItem.timeCount)
        topDetailLabel.text("该习惯已经坚持:\(timeStr)")
        topIconImgV.image(currentHabitPreviewItem.iconStr)
        
    }
    
    
}
extension TRkbsRecordPageVC {
    func setupView() {
        view.backgroundColor(UIColor(hexString: "#000000")!.withAlphaComponent(0.3))
            .clipsToBounds()
        //
        let bgBtn = UIButton()
        bgBtn.adhere(toSuperview: view)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        bgBtn.addTarget(self, action: #selector(backBtnClick(sender: )), for: .touchUpInside)
        
        //
        let contentV = UIView()
        contentV.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#252525")!)
            .clipsToBounds()
        contentV.layer.cornerRadius = 8
        contentV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(410)
        }
        //
        
        topTitleBgV.adhere(toSuperview: contentV)
            .backgroundColor(UIColor.white)
        topTitleBgV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(72)
        }
        //

        topIconImgV.adhere(toSuperview: topTitleBgV)
            .contentMode(.scaleAspectFit)
            .backgroundColor(.lightGray)
        topIconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.width.height.equalTo(44)
        }
        
        //

        topTitleLabel.fontName(15, "AppleSDGothicNeo-SemiBold")
            .color(.black)
            .adhere(toSuperview: topTitleBgV)
        topTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(topTitleBgV.snp.centerY)
            $0.left.equalTo(topIconImgV.snp.right).offset(15)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //

        topDetailLabel.fontName(13, "AppleSDGothicNeo-Medium")
            .color(.darkText)
            .adhere(toSuperview: topTitleBgV)
        topDetailLabel.snp.makeConstraints {
            $0.top.equalTo(topTitleBgV.snp.centerY)
            $0.left.equalTo(topIconImgV.snp.right).offset(15)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        let reeditBtn = UIButton()
        reeditBtn.adhere(toSuperview: topTitleBgV)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        reeditBtn.addTarget(self, action: #selector(reeditBtnClick(sender:)), for: .touchUpInside)
        reeditBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(40)
        }
        
        //
        let recordTitleLabel = UILabel()
        recordTitleLabel.adhere(toSuperview: contentV)
            .fontName(16, "AppleSDGothicNeo-SemiBold")
            .color(.white)
            .text("记录本次时间")
        recordTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topTitleBgV.snp.bottom).offset(24)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        countPicker.dataSource = self
        countPicker.delegate = self
        countPicker.adhere(toSuperview: contentV)
        countPicker.snp.makeConstraints {
            $0.top.equalTo(recordTitleLabel.snp.bottom).offset(8)
            $0.right.equalTo(contentV.snp.centerX).offset(-5)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        countPicker.selectRow(9, inComponent: 0, animated: false)
        //
        
        danweiPicker.dataSource = self
        danweiPicker.delegate = self
        danweiPicker.adhere(toSuperview: contentV)
        danweiPicker.snp.makeConstraints {
            $0.top.equalTo(recordTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(contentV.snp.centerX).offset(5)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        //
        infoTextView.delegate = self
        infoTextView.backgroundColor(UIColor.white.withAlphaComponent(0.2))
            .adhere(toSuperview: contentV)
        infoTextView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
        infoTextView.textColor = UIColor.white
        infoTextView.layer.cornerRadius = 8
        infoTextView.placeholder = "记录些什么吧...\n\n想法💡"
        infoTextView.text = ""
        infoTextView.snp.makeConstraints {
            $0.left.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(countPicker.snp.bottom).offset(5)
            $0.height.equalTo(70)
        }
        
        //
        let dakaBtn = UIButton()
        dakaBtn.adhere(toSuperview: contentV)
                .backgroundColor(UIColor(hexString: "#CDC6C2")!)
                .title("打卡")
                .image(UIImage(named: ""))
                .font(15, "AppleSDGothicNeo-SemiBold")
                .titleColor(UIColor(hexString: "#A24B2C")!)
        dakaBtn.layer.borderColor = UIColor(hexString: "#1C1C1D")!.cgColor
        dakaBtn.layer.borderWidth = 1.5
        dakaBtn.layer.cornerRadius = 22
        dakaBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentV.snp.bottom).offset(-70)
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
        dakaBtn.addTarget(self, action: #selector(dakaBtnClick(sender:)), for: .touchUpInside)
        
        //
        let recordListBtn = UIButton()
        recordListBtn.adhere(toSuperview: contentV)
                .backgroundColor(UIColor(hexString: "#CDC6C2")!)
                .title("查看记录日志")
                .image(UIImage(named: ""))
                .font(15, "AppleSDGothicNeo-SemiBold")
                .titleColor(UIColor(hexString: "#A24B2C")!)
        recordListBtn.layer.borderColor = UIColor(hexString: "#1C1C1D")!.cgColor
        recordListBtn.layer.borderWidth = 1.5
        recordListBtn.layer.cornerRadius = 22
        recordListBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentV.snp.bottom).offset(-20)
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
        recordListBtn.addTarget(self, action: #selector(recordListBtnClick(sender:)), for: .touchUpInside)
        
    }
    
}

extension TRkbsRecordPageVC {
    @objc func dakaBtnClick(sender: UIButton) {
        
    }
    
    @objc func reeditBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(TRkbsHabitVC(editingHabitItem: currentHabitPreviewItem), animated: true)
    }
    
    @objc func recordListBtnClick(sender: UIButton) {
        
    }
    
    @objc func backBtnClick(sender: UIButton) {
        cancelClickActionBlock?()
    }
    
    
}

extension TRkbsRecordPageVC {
    func showEndKeybordView() {
        let maskKeyView = UIButton()
        maskKeyView.adhere(toSuperview: view)
        maskKeyView.addTarget(self, action: #selector(maskKeyViewClick(sender: )), for: .touchUpInside)
        maskKeyView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    @objc func maskKeyViewClick(sender: UIButton) {
        infoTextView.resignFirstResponder()
        sender.removeFromSuperview()
    }
}

extension TRkbsRecordPageVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countPicker {
            return DataManagerTool.default.countList.count
        }
        return DataManagerTool.default.minhourList.count

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18)
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.color(UIColor.white)
        }
        if pickerView == countPicker {
            pickerLabel?.text = DataManagerTool.default.countList[row]
        } else {
            pickerLabel?.text = DataManagerTool.default.minhourList[row]
        }
        
        
        return pickerLabel!
    }
}

extension TRkbsRecordPageVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        showEndKeybordView()
        debugPrint("textViewShouldBeginEditing")
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}
