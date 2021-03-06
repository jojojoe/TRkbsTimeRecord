//
//  TRkbsTagView.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/10.
//

import UIKit

class TRkbsTagView: UIView {
    
    let tagCollection = TRkbsTitleIndexView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
extension TRkbsTagView {
    func setupView() {
        //
        let titIconImgV = UIImageView()
        titIconImgV.image("habit_tag")
            .adhere(toSuperview: self)
        titIconImgV.snp.makeConstraints {
            $0.left.equalTo(14)
            $0.top.equalToSuperview().offset(4)
            $0.width.height.equalTo(52/2)
        }
        let titleNameLabel = UILabel()
        titleNameLabel.fontName(14, "AppleSDGothicNeo-SemiBold")
            .color(UIColor.white)
            .text("添加习惯标签".localized())
            .adhere(toSuperview: self)
        titleNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(titIconImgV.snp.centerY)
            $0.left.equalTo(titIconImgV.snp.right).offset(10)
            $0.width.height.greaterThanOrEqualTo(10)
        }
        //
        
        tagCollection.adhere(toSuperview: self)
        tagCollection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.bottom.right.left.equalToSuperview()
        }
    }
}
