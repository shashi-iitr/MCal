//
//  DayCell.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Color.darkText.value
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.lightText.value
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        self.contentView.addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: 26).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true


        self.contentView.addSubview(dotView)
        dotView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5).isActive = true
        dotView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dotView.widthAnchor.constraint(equalToConstant: 4).isActive = true
        dotView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        dotView.layer.masksToBounds = true
        dotView.layer.cornerRadius = 2
        
        dayLabel.layer.masksToBounds = true
        dayLabel.layer.cornerRadius = 13
    }
    
    func configureWithDay(_ day: String, isAgendaTagged: Bool) -> Void {
        dayLabel.text = day
        dotView.alpha = isAgendaTagged == true ? 1 : 0
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }

}
