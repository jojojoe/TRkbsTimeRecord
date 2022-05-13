//
//  TRkbsTitleIndexView.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import UIKit

class TRkbsTitleIndexView: UIView {

    var collection: UICollectionView!
    var titleTypeList: [String] = []
    var currentTitleType: String?
    var selectItemBlock: ((String, IndexPath)->Void)?
    
    func udpateCollectionIndexPath(indexPath: IndexPath) {
        currentTitleType = titleTypeList[indexPath.item]
        collection.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        collection.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        setupView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.collection.reloadData()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        titleTypeList = DataManagerTool.default.timeTypeTagList
        currentTitleType = titleTypeList.first
    }
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
        collection.register(cellWithClass: TRkbsTypeCollectionCell.self)
    }

}

extension TRkbsTitleIndexView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: TRkbsTypeCollectionCell.self, for: indexPath)
        let name = titleTypeList[indexPath.item]
        cell.nameLabel
            .text(name)
        
        if currentTitleType == name {
            cell.updateSelectStatus(isSele: true)
        } else {
            cell.updateSelectStatus(isSele: false)
        }
        cell.clipsToBounds()
        cell.selectV.layer.cornerRadius = cell.selectV.bounds.height/2
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleTypeList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TRkbsTitleIndexView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 60
        let cellHeight: CGFloat = 40
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 60
        let allWidth: CGFloat = cellWidth * CGFloat(titleTypeList.count)
        if allWidth < self.bounds.width {
            let left = (self.bounds.width - allWidth) / 2
            return UIEdgeInsets(top: 0, left: left, bottom: 0, right: left)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TRkbsTitleIndexView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = titleTypeList[indexPath.item]
        currentTitleType = name
        collectionView.reloadData()
        selectItemBlock?(name, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class TRkbsTypeCollectionCell: UICollectionViewCell {
    let nameLabel = UILabel()
    let selectV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        selectV.adhere(toSuperview: contentView)
            .backgroundColor(.black)
        selectV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.equalTo(5)
            $0.top.equalTo(3)
        }
        nameLabel
            .color(UIColor.white)
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth()
            .fontName(14, "AppleSDGothicNeo-SemiBold")
            .adhere(toSuperview: contentView)
        nameLabel.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        
    }
    
    func updateSelectStatus(isSele: Bool) {
        if isSele {
            nameLabel
                .color(UIColor(hexString: "#F3A953")!)
                .fontName(14, "AppleSDGothicNeo-SemiBold")
            selectV.isHidden = false
            
        } else {
            nameLabel
                .color(UIColor.white)
                .fontName(14, "AppleSDGothicNeo-Bold")
            selectV.isHidden = true
        }
    }
}


