//
//  AgendaCell.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AgendaCell: UITableViewCell {
    
    let upperTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10:30 AM"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Color.intermidiateText.withAlpha(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lowerTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2:19 PM"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Color.intermidiateText.withAlpha(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let agendaTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Standup: What's going on?"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = Color.darkText.value
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let agendaDescLabel: UILabel = {
        let label = UILabel()
        label.text = "Join from PC, Mac, Linux, iOS or Android"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Color.intermidiateText.withAlpha(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let verticleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.darkText.value
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(upperTimeLabel)
        self.contentView.addSubview(lowerTimeLabel)
        self.contentView.addSubview(verticleSeparatorView)
        self.contentView.addSubview(agendaTitleLabel)
        self.contentView.addSubview(agendaDescLabel)
        
        upperTimeLabel.backgroundColor = .white
        upperTimeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        upperTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        upperTimeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        upperTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true

        lowerTimeLabel.backgroundColor = .white
        lowerTimeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lowerTimeLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        lowerTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        lowerTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true

        verticleSeparatorView.backgroundColor = Color.darkText.value
        verticleSeparatorView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        verticleSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticleSeparatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        verticleSeparatorView.leftAnchor.constraint(equalTo: upperTimeLabel.rightAnchor, constant: 2).isActive = true
        
        agendaTitleLabel.backgroundColor = .white
        agendaTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        agendaTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        agendaTitleLabel.leftAnchor.constraint(equalTo: verticleSeparatorView.rightAnchor, constant: 2).isActive = true
        agendaTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true

        agendaDescLabel.backgroundColor = .white
        agendaDescLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        agendaDescLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        agendaDescLabel.leftAnchor.constraint(equalTo: verticleSeparatorView.rightAnchor, constant: 2).isActive = true
        agendaDescLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }
    
    class func cellHeight() -> CGFloat {
        return 50
    }

}
