//
//  YearCellHeaderView.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class YearCellHeaderView: UICollectionReusableView {
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        label.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        self.addSubview(yearLabel)
        yearLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        yearLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
        
        self.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func configureViewWithYear(_ year: Int) -> Void {
        yearLabel.text = "\(year)"
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }
    
    class func viewHeight() -> CGFloat {
        return 50
    }
        
}
