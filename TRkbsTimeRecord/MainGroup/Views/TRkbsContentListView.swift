//
//  TRkbsContentListView.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import UIKit



class TRkbsContentListView: UIView {

    var collection: UICollectionView!
    var contentBoundList: [TRkPreviewBounld] = []
    var scrollCollectionBlock: ((IndexPath)->Void)?
    var selectItemBlock: ((TRkHabitPreviewItem)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TRkbsContentListView {
    func loadData() {
        // test
        let item1 = TRkHabitPreviewItem(habitId: "12334556", iconStr: "", bgColorStr: "#F2D0B1", nameStr: "看书", timeTypeTagStr: "任意", timeCount: 360000)
        let item2 = TRkHabitPreviewItem(habitId: "12334557", iconStr: "", bgColorStr: "#F6DAC0", nameStr: "坚持阅读", timeTypeTagStr: "早晨", timeCount: 260000)
        let item3 = TRkHabitPreviewItem(habitId: "12334558", iconStr: "", bgColorStr: "#D9D9E8", nameStr: "绘画", timeTypeTagStr: "早晨", timeCount: 660000)
        let bounld1 = TRkPreviewBounld(timeTypeStr: "任意", previewItems: [item1])
        let bounld2 = TRkPreviewBounld(timeTypeStr: "早晨", previewItems: [item2, item3])
        
        contentBoundList = [bounld1, bounld2]
    }
    
    func setupView() {
        
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
        collection.register(cellWithClass: TRkbsContentListCell.self)
        collection.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: TRkbsContentListHeader.self)
    }
}

extension TRkbsContentListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TRkbsContentListCell.self, for: indexPath)
        let bounld = contentBoundList[indexPath.section]
        let item = bounld.previewItems[indexPath.item]
        cell.iconImgV.image = UIImage(named: item.iconStr)
        cell.contentBgV.backgroundColor(UIColor(hexString: item.bgColorStr) ?? UIColor.white)
        cell.nameLabel.text(item.nameStr)
        let timeStr = DataManagerTool.default.formatDate(second: item.timeCount)
        cell.timeCountLabel.text(timeStr)
        cell.contentBgV.layer.borderWidth = 1
        cell.contentBgV.layer.borderColor = UIColor(hexString: item.bgColorStr)?.withAlphaComponent(0.7).cgColor
        cell.contentBgV.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: TRkbsContentListHeader.self, for: indexPath)
            let bounld = contentBoundList[indexPath.section]
            view.nameLabel.text = bounld.timeTypeStr
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let bounld = contentBoundList[section]
        return bounld.previewItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentBoundList.count
    }
    
}

extension TRkbsContentListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (UIScreen.width - 12 * 2)
        return CGSize(width: width, height: 66)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.width, height: 34)
    }
    
    
}

extension TRkbsContentListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bundle = contentBoundList[indexPath.section]
        let item = bundle.previewItems[indexPath.item]
        selectItemBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collection {
            
            let x = scrollView.contentOffset.x
            
            if let currentIndexP = collection.indexPathForItem(at: CGPoint(x: x, y: 30)) {
                
                let index = IndexPath(item: currentIndexP.section, section: 0)
                scrollCollectionBlock?(index)
                 
            }
        }
    }
    
}


class TRkbsContentListCell: UICollectionViewCell {
    let contentBgV = UIView()
    let iconImgV = UIImageView()
    let nameLabel = UILabel()
    let timeCountLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentBgV.adhere(toSuperview: contentView)
        contentBgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        iconImgV.adhere(toSuperview: contentBgV)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(44)
        }
        
        //
        nameLabel.adhere(toSuperview: contentBgV)
            .fontName(16, "AppleSDGothicNeo-SemiBold")
            .color(UIColor.black)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImgV.snp.right).offset(20)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        
        //
        timeCountLabel.adhere(toSuperview: contentBgV)
            .fontName(16, "AppleSDGothicNeo-Bold")
            .color(UIColor.black)
        timeCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentBgV.snp.centerY)
            $0.right.equalTo(contentBgV.snp.right).offset(-20)
            $0.width.height.greaterThanOrEqualTo(20)
        }
        
        //
        let infoLabel = UILabel()
        infoLabel
            .adhere(toSuperview: contentBgV)
            .fontName(13, "AppleSDGothicNeo-Medium")
            .color(UIColor.darkGray)
            .text("共计坚持")
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(contentBgV.snp.centerY).offset(2)
            $0.right.equalTo(contentBgV.snp.right).offset(-20)
            $0.width.height.greaterThanOrEqualTo(20)
        }
    }
}

class TRkbsContentListHeader: UICollectionReusableView {
    
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.adhere(toSuperview: self)
            .fontName(12, "AppleSDGothicNeo-Light")
            .color(.lightGray)
            .textAlignment(.left)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(50)
            $0.height.greaterThanOrEqualTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
