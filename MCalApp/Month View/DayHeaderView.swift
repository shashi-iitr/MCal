//
//  DayHeaderView.swift
//  MCalApp
//
//  Created by shashi kumar on 27/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class DayHeaderView: UICollectionReusableView {
    let dayHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white// UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(dayHeaderStackView)
        dayHeaderStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dayHeaderStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dayHeaderStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dayHeaderStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        for _ in 0..<7 {
            let label = UILabel()
            label.text = ""
            label.textAlignment = .center
            label.textColor = Color.darkText.value
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            dayHeaderStackView.addArrangedSubview(label)
        }
    }
    
    func configureViewWithMonth(_ month: String, index: Int) -> Void {
        for i in 0..<dayHeaderStackView.arrangedSubviews.count {
            if let label = dayHeaderStackView.arrangedSubviews[i] as? UILabel {
                if i == index {
                    label.text = month
                } else {
                    label.text = ""
                }
            }
        }
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }
    
    class func viewHeight() -> CGFloat {
        return 50
    }
}
