//
//  TRkbsColorView.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/10.
//

import UIKit

class TRkbsColorView: UIView {
    var currentColor: String
    var colorSelectBlock: ((String, IndexPath)->Void)?
    var collection: UICollectionView!
    var colorList: [String] = []
    let left: CGFloat = 20
    let padding: CGFloat = 10
    let cellW: CGFloat = (UIScreen.width - 10 * 6 - 20 * 2 - 1) / 7
    
    init(frame: CGRect, colors: [String]) {
        currentColor = colors.first ?? "#FFFFFF"
        colorList = colors
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TRkbsColorView {
    func setupView() {
        
        //
        let titIconImgV = UIImageView()
        titIconImgV.image("habit_color")
            .adhere(toSuperview: self)
        titIconImgV.snp.makeConstraints {
            $0.left.equalTo(14)
            $0.top.equalToSuperview().offset(4)
            $0.width.height.equalTo(52/2)
        }
        let titleNameLabel = UILabel()
        titleNameLabel.fontName(14, "AppleSDGothicNeo-SemiBold")
            .color(UIColor.white)
            .text("挑选背景颜色")
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
        collection.register(cellWithClass: TRkbsColorCell.self)
    }
    
    
}

extension TRkbsColorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TRkbsColorCell.self, for: indexPath)
        let item = colorList[indexPath.item]
        if item.contains("#") {
            cell.contentImgV.backgroundColor(UIColor(hexString: item)!)
            cell.contentImgV.image = nil
        } else {
            cell.contentImgV.image(item)
        }
 
        cell.layer.cornerRadius = cell.bounds.width / 2
        cell.contentImgV.layer.cornerRadius = cell.bounds.width / 2
        cell.selectV.layer.cornerRadius = cell.bounds.width / 2
        if currentColor == item {
            cell.selectV.isHidden = false
        } else {
            cell.selectV.isHidden = true
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TRkbsColorView: UICollectionViewDelegateFlowLayout {
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

extension TRkbsColorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = colorList[indexPath.item]
        currentColor = item
        collectionView.reloadData()
        colorSelectBlock?(item, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


class TRkbsColorCell: UICollectionViewCell {
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
        contentImgV.contentMode = .scaleAspectFill
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
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
        selectV.layer.borderWidth = 3
        selectV.layer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        
    }
}

