//
//  TRkbsIconView.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/10.
//

import UIKit

class TRkbsIconView: UIView {
    var currentIcon: String
    var iconSelectBlock: ((String, IndexPath)->Void)?
    var collection: UICollectionView!
    var iconList: [String] = []
    let left: CGFloat = 20
    let padding: CGFloat = 10
    let cellW: CGFloat = (UIScreen.width - 10 * 6 - 20 * 2 - 1) / 7
    
    init(frame: CGRect, icons: [String]) {
        currentIcon = icons.first ?? ""
        iconList = icons
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TRkbsIconView {
    func setupView() {
        
        //
        let titIconImgV = UIImageView()
        titIconImgV.image("habit_icon")
            .adhere(toSuperview: self)
        titIconImgV.snp.makeConstraints {
            $0.left.equalTo(14)
            $0.top.equalToSuperview().offset(4)
            $0.width.height.equalTo(52/2)
        }
        let titleNameLabel = UILabel()
        titleNameLabel.fontName(14, "AppleSDGothicNeo-SemiBold")
            .color(UIColor.white)
            .text("挑选图标".localized())
            .adhere(toSuperview: self)
        titleNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(titIconImgV.snp.centerY)
            $0.left.equalTo(titIconImgV.snp.right).offset(10)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
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
            $0.top.equalToSuperview().offset(38)
            $0.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: TRkbsIconCell.self)
    }
    
    
}

extension TRkbsIconView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TRkbsIconCell.self, for: indexPath)
        let item = iconList[indexPath.item]
        cell.contentImgV.image(item)
//            .backgroundColor(.darkGray)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds()
        if currentIcon == item {
            cell.contentView.backgroundColor(UIColor.white.withAlphaComponent(0.35))
        } else {
            cell.contentView.backgroundColor(UIColor.white.withAlphaComponent(0.2))
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TRkbsIconView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellW, height: cellW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = 20
        return UIEdgeInsets(top: 0, left: left, bottom: 0, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 10
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let padding: CGFloat = 10
        return padding
    }
    
}

extension TRkbsIconView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = iconList[indexPath.item]
        currentIcon = item
        collectionView.reloadData()
        iconSelectBlock?(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class TRkbsIconCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectV = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        //
        
        selectV.backgroundColor(.clear)
//            .image("editor_selected_color")
        //        selectV.layer.borderColor = UIColor(hexString: "#D0C56A")?.cgColor
        //        selectV.layer.borderWidth = 3
        selectV.adhere(toSuperview: contentView)
        selectV.snp.makeConstraints {
            $0.left.top.bottom.right.equalToSuperview()
        }
//        selectV.layer.borderWidth = 1
//        selectV.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
    }
}

