//
//  MonthCell.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class MonthCell: UICollectionViewCell {
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Color.darkText.value
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func configureWithMonth(_ month: String) -> Void {
        monthLabel.text = month
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }

}
