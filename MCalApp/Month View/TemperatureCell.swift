//
//  TemperatureCell.swift
//  MCalApp
//
//  Created by shashi kumar on 31/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TemperatureCell: UITableViewCell {

    let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Color.darkText.value
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Color.darkText.value
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        self.contentView.addSubview(summaryLabel)
        self.contentView.addSubview(temperatureLabel)
        
        summaryLabel.backgroundColor = .white
        summaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        summaryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        summaryLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        summaryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        temperatureLabel.backgroundColor = .white
        temperatureLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 5).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        temperatureLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        temperatureLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
    func configureWithSummary(_ summary: String, tempStr: String) -> Void {
        if summary == "" && tempStr == "" {
            summaryLabel.text = "No temperature predictions found"
            temperatureLabel.text = "Try changing days"
        } else {
            summaryLabel.text = summary
            temperatureLabel.text = tempStr
        }
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }
    
    class func cellHeight() -> CGFloat {
        return 55
    }
}
