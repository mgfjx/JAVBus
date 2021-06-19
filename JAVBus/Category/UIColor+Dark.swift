//
//  UIColor+Dark.swift
//  JAVBus
//
//  Created by mgfjx on 2021/3/5.
//  Copyright © 2021 mgfjx. All rights reserved.
//

import Foundation
import UIKit

@objc
extension UIColor {
    class func dynamicProvider(darkColor: UIColor, lightColor: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (collection) -> UIColor in
                if collection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        }else {
            return lightColor
        }
    }
    
    class func dynamicProvider(darkStr: String, lightStr: String) -> UIColor {
        return UIColor.dynamicProvider(darkColor: UIColor.init(hexString: darkStr), lightColor: UIColor.init(hexString: lightStr))
    }
    
}
