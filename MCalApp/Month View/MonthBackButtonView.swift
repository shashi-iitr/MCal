//
//  MonthBackButtonView.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class MonthBackButtonView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 24, y: 0, width: 80, height: 44))
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    func setupViews() -> Void {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "leftArrow"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 10, width: 18, height: 24)
        button.backgroundColor = .clear
        addSubview(button)
        addSubview(titleLabel)
    }
    
    func configureTitle(_ title: String) -> Void {
        titleLabel.text = title
    }
}
