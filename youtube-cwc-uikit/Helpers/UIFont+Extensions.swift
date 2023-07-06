//
//  UIFont+Extensions.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 04/07/23.
//

import UIKit

extension UIFont {
    
    class func preferredFont(forTextStyle style: UIFont.TextStyle, weight: Weight? = nil, size: CGFloat? = nil) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let defaultSize = descriptor.pointSize
        let fontToScale: UIFont
        
        if let weight {
            fontToScale = .systemFont(ofSize: size ?? defaultSize, weight: weight)
        } else {
            fontToScale = .systemFont(ofSize: size ?? defaultSize)
        }
        
        return metrics.scaledFont(for: fontToScale)
    }
    
}
