//
//  GenericExtension.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

enum Color {
    
    case theme
    case border
    case shadow
    
    case darkBackground
    case lightBackground
    case intermidiateBackground
    
    case darkText
    case lightText
    case intermidiateText
    
    case affirmation
    case negation
    // 1
    case custom(hexString: String, alpha: Double)
    // 2
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension Color {
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            instanceColor = UIColor(hexString: "#333333")
        case .theme:
            instanceColor = UIColor(hexString: "#ffcc00")
        case .shadow:
            instanceColor = UIColor(hexString: "#cccccc")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#999966")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#cccc66")
        case .intermidiateBackground:
            instanceColor = UIColor(hexString: "#cccc99")
        case .darkText:
            instanceColor = UIColor(hexString: "#333333")
        case .intermidiateText:
            instanceColor = UIColor(hexString: "#999999")
        case .lightText:
            instanceColor = UIColor(hexString: "#cccccc")
        case .affirmation:
            instanceColor = UIColor(hexString: "#00ff66")
        case .negation:
            instanceColor = UIColor(hexString: "#ff3300")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}

