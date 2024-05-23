//
//  Color.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    
    static let rcMain = UIColor(hexCode: "#916AFF") //메인색 (임시) #9775FA
    static let rcGray000 = UIColor(hexCode: "#ECEFF7") //grey00
    static let rcGray100 = UIColor(hexCode: "#F5F6FA") //bg
    static let rcGray300 = UIColor(hexCode: "#BEC4C6")
    static let rcGray400 = UIColor(hexCode: "#85888A")
    
}
