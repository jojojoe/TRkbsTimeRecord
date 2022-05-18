//
//  TRkbsHabitRecordListView.swift
//  TRkbsTimeRecord
//
//  Created by Joe on 2022/5/14.
//

import UIKit

class TRkbsHabitRecordListView: UIView {
    var habitRecordItemClick: ((TRkDayRecordItem)->Void)?
    var dayRecordList: [TRkDayRecordItem] = []
    var collection: UICollectionView!
    var currentHaibtId: String?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     

}

extension TRkbsHabitRecordListView {
    func updateRecordData(habitId: String) {
//        let test1 = TRkDayRecordItem(recordDate: "1652505868", habitId: "1", timeCount: 3600, infoStr: "")
//        let test2 = TRkDayRecordItem(recordDate: "1652531778", habitId: "2", timeCount: 50 * 60, infoStr: "我今天特别努力")
//        let test3 = TRkDayRecordItem(recordDate: "1652532088", habitId: "3", timeCount: 60 * 60 * 4, infoStr: "我今天特别努力")
//        let test4 = TRkDayRecordItem(recordDate: "1652111088", habitId: "4", timeCount: 60 * 60 * 2, infoStr: "我今天特别努力")
//        let test5 = TRkDayRecordItem(recordDate: "1652111088", habitId: "4", timeCount: 60 * 60 * 4, infoStr: "我今天特别努力")
//        dayRecordList = [test1, test2, test3, test4, test5]
        currentHaibtId = habitId
        TRkbsDBManager.default.selectDayRecordItemList(habitId: habitId) {[weak self] daylist in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.dayRecordList = daylist
                self.collection.reloadData()
            }
        }
        
        collection.reloadData()
    }
    
    func setupView() {
        self.backgroundColor(UIColor(hexString: "#252525")!)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: TRkbsHabitDayRecordCell.self)
    }
}

extension TRkbsHabitRecordListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: TRkbsHabitDayRecordCell.self, for: indexPath)
        let item = dayRecordList[indexPath.item]
        
        let date = DataManagerTool.default.convertDateStrToDate(dateStr: item.recordDate)
        let dateStr = DataManagerTool.default.formatDate(date: date)
        cell.dateLabel.text(dateStr)
        cell.infoLabel.text(item.infoStr)
        let countStr = DataManagerTool.default.formatDate(second: item.timeCount)
        cell.timeCountLabel.text(countStr)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayRecordList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TRkbsHabitRecordListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TRkbsHabitRecordListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dayRecordList[indexPath.item]
        habitRecordItemClick?(item)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}



class TRkbsHabitDayRecordCell: UICollectionViewCell {
    let leftImgV = UIImageView()
    
    let dateLabel = UILabel()
    let timeCountLabel = UILabel()
    let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        leftImgV.adhere(toSuperview: contentView)
            .image("")
            .backgroundColor(.lightGray)
            .contentMode(.scaleAspectFit)
        leftImgV.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(24)
        }
        
        //
        
        dateLabel.fontName(14, "AppleSDGothicNeo-SemiBold")
            .color(.white)
            .textAlignment(.left)
            .adhere(toSuperview: contentView)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(leftImgV.snp.right).offset(20)
            $0.height.greaterThanOrEqualTo(20)
            $0.width.equalTo(40)
        }

        timeCountLabel.fontName(16, "AppleSDGothicNeo-SemiBold")
            .color(.white)
            .textAlignment(.right)
            .adhere(toSuperview: contentView)
        timeCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(contentView.snp.right).offset(-20)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        

        infoLabel.fontName(14, "AppleSDGothicNeo-Regular")
            .color(.white)
            .textAlignment(.left)
            .adhere(toSuperview: contentView)
        infoLabel.lineBreakMode = .byTruncatingTail
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(timeCountLabel.snp.left).offset(-20)
            $0.left.equalTo(dateLabel.snp.right).offset(20)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        
        
        
        
    }
}
