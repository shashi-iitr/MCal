//
//  WeekDayView.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class WeekDayView: UIView {

    let weekDayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(weekDayStackView)
        weekDayStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weekDayStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekDayStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekDayStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        var weekDays = ["S", "M", "T", "W", "T", "F", "S"]
        
        for i in 0..<7 {
            let weekDayLabel = UILabel()
            weekDayLabel.text = weekDays[i]
            weekDayLabel.textAlignment = .center
            if i == 0 || i == 6 {
                weekDayLabel.textColor = Color.negation.value
            } else {
                weekDayLabel.textColor = Color.darkText.value
            }
            weekDayLabel.font = UIFont.systemFont(ofSize: 12)
            weekDayStackView.addArrangedSubview(weekDayLabel)
        }
    }
}
