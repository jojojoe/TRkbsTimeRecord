//
//  TRkbsMainVC.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import UIKit
import SnapKit

class TRkbsMainVC: UIViewController {

    let topDetailLabel = UILabel()
    let addNewBtn = UIButton()
    let titleIndexView = TRkbsTitleIndexView()
    let contentListV = TRkbsContentListView()
    let gradientMaskV = UIView()
    var didlayoutOnce: Once = Once()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        didlayoutOnce.run {
            self.gradientMaskV.gradientBackground(UIColor.clear, UIColor(hexString: "#1C1C1D")!)
        }
        
        
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateHabitList), name: .updateHabitList, object: nil)
    }
    
    @objc func updateHabitList() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.contentListV.loadData()
        }
    }

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
        let settingBtn = UIButton()
        settingBtn.adhere(toSuperview: topBanner)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        settingBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender: )), for: .touchUpInside)
        
        //
        let userBtn = UIButton()
        userBtn.adhere(toSuperview: topBanner)
            .image(UIImage(named: ""))
            .backgroundColor(.lightGray)
        userBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        userBtn.addTarget(self, action: #selector(userBtnClick(sender: )), for: .touchUpInside)
        
        //
        let topTitleLabel = UILabel()
        topTitleLabel.adhere(toSuperview: topBanner)
            .text("小时间")
            .textAlignment(.center)
            .color(.white)
            .fontName(20, "AppleSDGothicNeo-SemiBold")
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-6)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        
        topDetailLabel.adhere(toSuperview: topBanner)
            .text("至今已经专注20天04小时30分")
            .textAlignment(.center)
            .color(.white)
            .fontName(12, "AppleSDGothicNeo-Regular")
        topDetailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topTitleLabel.snp.bottom).offset(1)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        
        //
        
        titleIndexView.adhere(toSuperview: view)
        titleIndexView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topBanner.snp.bottom).offset(5)
            $0.height.equalTo(40)
        }
        titleIndexView.selectItemBlock = {
            [weak self] _ , indexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.titleIndexViewSelectAction(indexPath: indexP)
            }
        }
        //
        contentListV.adhere(toSuperview: view)
        contentListV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titleIndexView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        contentListV.scrollCollectionBlock = {
            [weak self] scrollIndexP in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateTopTitleViewStatus(indexPath: scrollIndexP)
            }
        }
        contentListV.selectItemBlock = {
            [weak self] habitItem in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.clickContentItem(habitItem: habitItem)
            }
        }
        //
        
        gradientMaskV.adhere(toSuperview: view)
        gradientMaskV.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
        }
        
        
        //
        addNewBtn.adhere(toSuperview: view)
            .backgroundColor(UIColor(hexString: "#CDC6C2")!)
            .title("添加习惯")
            .image(UIImage(named: ""))
            .font(15, "AppleSDGothicNeo-SemiBold")
            .titleColor(UIColor(hexString: "#A24B2C")!)
        addNewBtn.layer.borderColor = UIColor(hexString: "#1C1C1D")!.cgColor
        addNewBtn.layer.borderWidth = 1.5
        addNewBtn.layer.cornerRadius = 22
        addNewBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
        addNewBtn.addTarget(self, action: #selector(addNewBtnClick(sender: )), for: .touchUpInside)
        
        //
        
        
    }

}

extension TRkbsMainVC {
    func updateTopTitleViewStatus(indexPath: IndexPath) {
        titleIndexView.currentTitleType = DataManagerTool.default.timeTypeTagList[indexPath.item]
        titleIndexView.collection.reloadData()
    }
    
    func clickContentItem(habitItem: TRkHabitPreviewItem) {
        showRecordHabitVC(habitItem: habitItem)
    }
    
    func titleIndexViewSelectAction(indexPath: IndexPath) {
        if indexPath.item < contentListV.contentBoundList.count {
            contentListV.collection.scrollToItem(at: IndexPath(item: 0, section: indexPath.item), at: .top, animated: true)
        }
    }
}

extension TRkbsMainVC {
    @objc func settingBtnClick(sender: UIButton) {
        
    }
    
    @objc func userBtnClick(sender: UIButton) {
        
    }
    
    @objc func addNewBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(TRkbsHabitVC(), animated: true)
    }
    
    
}

extension TRkbsMainVC {
    func updateTopDetailTime() {
        topDetailLabel
            .text("至今已经专注20天04小时30分")
    }
    
}

extension TRkbsMainVC {
    func showRecordHabitVC(habitItem: TRkHabitPreviewItem) {
        let recordHabitVC = TRkbsRecordPageVC(editingHabitItem: habitItem)
        self.addChild(recordHabitVC)
        view.addSubview(recordHabitVC.view)
        recordHabitVC.view.alpha = 0
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            recordHabitVC.view.alpha = 1
        }
        recordHabitVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        recordHabitVC.cancelClickActionBlock = {
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                recordHabitVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    recordHabitVC.removeViewAndControllerFromParentViewController()
                }
            }
        }
    }
}