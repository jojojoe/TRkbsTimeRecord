//
//  TEkbsRecordEditVC.swift
//  TRkbsTimeRecord
//
//  Created by Joe on 2022/5/15.
//

import UIKit
import Alertift
import ZKProgressHUD
import NoticeObserveKit

class TEkbsRecordEditVC: UIViewController {
    var recordItem: TRkDayRecordItem
    let countPicker = UIPickerView()
    let danweiPicker = UIPickerView()
    let infoTextView = UITextView()
    var currentCountIndex: Int = 0
    var currentDanweiIndex: Int = 0
    let backBtn = UIButton()
    
    init(recordItem: TRkDayRecordItem) {
        self.recordItem = recordItem
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    
    func setupView() {
        
        view.backgroundColor(UIColor(hexString: "#1C1C1D")!)
            .clipsToBounds()
        
        //
        let topBanner = UIView()
        topBanner.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#252525")!)
        topBanner.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(44)
        }
        
        
       //
       
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
        let contentV = UIView()
        contentV.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#252525")!)
            .clipsToBounds()
        contentV.layer.cornerRadius = 5
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(30)
            $0.width.equalTo(320)
            $0.height.equalTo(410 - 72)
        }
        //
        let date = DataManagerTool.default.convertDateStrToDate( dateStr: recordItem.recordDate)
        let dateStr = DataManagerTool.default.formatDate(formatStr: "yyyy年MM月dd日", date: date)
        let itemInfo = recordItem.infoStr
        
        let countStr = DataManagerTool.default.formatDate(second: recordItem.timeCount)
        let countDanwei: String = String(countStr.suffix(2))
        let countIntIndex = countStr.replacingOccurrences(of: countDanwei, with: "").int ?? 1
        
        var countDanweiIndex: Int = 0
        
        if countDanwei == "分钟" {
            countDanweiIndex = 0
        } else {
            countDanweiIndex = 1
        }
        currentDanweiIndex = countDanweiIndex
        //
        let recordTitleLabel = UILabel()
        recordTitleLabel.adhere(toSuperview: topBanner)
            .fontName(16, "AppleSDGothicNeo-SemiBold")
            .color(.white)
            .text(dateStr)
        recordTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        countPicker.dataSource = self
        countPicker.delegate = self
        countPicker.adhere(toSuperview: contentV)
        countPicker.snp.makeConstraints {
            $0.top.equalTo(contentV.snp.top).offset(28)
            $0.right.equalTo(contentV.snp.centerX).offset(-5)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        countPicker.selectRow(countIntIndex - 1, inComponent: 0, animated: false)
        currentCountIndex = countIntIndex - 1
        //
        
        danweiPicker.dataSource = self
        danweiPicker.delegate = self
        danweiPicker.adhere(toSuperview: contentV)
        danweiPicker.snp.makeConstraints {
            $0.top.equalTo(countPicker.snp.top)
            $0.left.equalTo(contentV.snp.centerX).offset(5)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        danweiPicker.selectRow(countDanweiIndex, inComponent: 0, animated: false)
        
        //
        infoTextView.delegate = self
        infoTextView.backgroundColor(UIColor.white.withAlphaComponent(0.2))
            .adhere(toSuperview: contentV)
        infoTextView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)
        infoTextView.textColor = UIColor.white
        infoTextView.layer.cornerRadius = 5
        infoTextView.placeholder = "记录些什么吧...\n\n想法💡"
        infoTextView.text = itemInfo
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
                .title("修改")
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
        let deleteBtn = UIButton()
        deleteBtn.adhere(toSuperview: contentV)
            .backgroundColor(UIColor(hexString: "#A24B2C")!, .normal)
//            .backgroundColor(UIColor(hexString: "#CDC6C2")!, .normal)
                .title("删除")
                .image(UIImage(named: ""))
                .font(15, "AppleSDGothicNeo-SemiBold")
                .titleColor(UIColor(hexString: "#A24B2C")!, .selected)
//                .titleColor(UIColor(hexString: "#CDC6C2")!, .selected)
        deleteBtn.layer.borderColor = UIColor(hexString: "#1C1C1D")!.cgColor
        deleteBtn.layer.borderWidth = 1.5
        deleteBtn.layer.cornerRadius = 22
        deleteBtn.clipsToBounds()
        deleteBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentV.snp.bottom).offset(-20)
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchUpInside)
        
        
    }

    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dakaBtnClick(sender: UIButton) {
        
        let countStr = DataManagerTool.default.countList[currentCountIndex]
        var countValue: Double = 0
        if currentDanweiIndex == 0 {
            countValue = (countStr.double() ?? 0) * 60
        } else {
            countValue = (countStr.double() ?? 0) * 60 * 60
        }
        
        let dayRecordItem = TRkDayRecordItem(recordDate: recordItem.recordDate, habitId: recordItem.habitId, timeCount: countValue, infoStr: infoTextView.text)
        
        TRkbsDBManager.default.addHabitDayRecord(model: dayRecordItem) {
            debugPrint("add habit day record success")
            Notice.Center.default.post(name: .updateDayRecordList, with: nil)
            Notice.Center.default.post(name: .updateHabitList, with: nil)

            ZKProgressHUD.showSuccess("修改成功!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.backBtnClick(sender: self.backBtn)
                }
            }
        }
    }
    
    @objc func deleteBtnClick(sender: UIButton) {
        
        Alertift.alert(title: "确定要删除这条时间记录吗？", message: "")
            .action(.cancel("取消"))
            .action(.default("确定"), handler: {[weak self] _, _, _ in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.deleteDayRecordItem()
                }
            })
            .show(on: self, completion: nil)
    }
    
    @objc func maskKeyViewClick(sender: UIButton) {
        infoTextView.resignFirstResponder()
        sender.removeFromSuperview()
    }
    
    
    
    func showEndKeybordView() {
        let maskKeyView = UIButton()
        maskKeyView.adhere(toSuperview: view)
        maskKeyView.addTarget(self, action: #selector(maskKeyViewClick(sender: )), for: .touchUpInside)
        maskKeyView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
}

extension TEkbsRecordEditVC {
    func deleteDayRecordItem() {
        TRkbsDBManager.default.deleteHabitDayRecordList(recordDateId: recordItem.recordDate) {
            debugPrint("delete day record success")
            Notice.Center.default.post(name: .updateDayRecordList, with: nil)
            Notice.Center.default.post(name: .updateHabitList, with: nil)

            ZKProgressHUD.showSuccess("删除成功!", maskStyle: .none, onlyOnceFont: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16), autoDismissDelay: 0.8) {
                [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    self.backBtnClick(sender: self.backBtn)
                }
            }
        }
    }
}


extension TEkbsRecordEditVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    
    
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if pickerView == countPicker {
           currentCountIndex = row
       } else {
           currentDanweiIndex = row
       }
   }
   
    
}

extension TEkbsRecordEditVC: UITextViewDelegate {
    
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
