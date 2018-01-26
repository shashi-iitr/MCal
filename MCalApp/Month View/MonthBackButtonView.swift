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
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        label.text = ""
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.backgroundColor = .clear
        return label
    }()
    
    func setupViews() -> Void {
        addSubview(titleLabel)
    }
    
    func configureTitle(_ title: String) -> Void {
        titleLabel.text = title
    }
}
