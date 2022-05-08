//
//  UIExtensions.swift
//  DirectoryApp
//
//  Created by Geethika on 07/05/22.
//

import UIKit
extension UIColor {
    
    class func colorFrom(hex: String) -> UIColor {
        var hexColor: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexColor.hasPrefix("#") { hexColor.remove(at: hexColor.startIndex) }
        if hexColor.count != 6 { return UIColor.gray }

        var rgbValue: UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&rgbValue)
        
        let color = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: CGFloat(1.0)
        )
        return color
    }
}
