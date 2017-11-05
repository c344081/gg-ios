//
//  UIImage+Extension.swift
//  gg-iOS
//
//  Created by chenhao on 2017/11/5.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit

extension UIImage {
    public static func resizableRoundCorner(with color: UIColor, radius: CGFloat) -> UIImage? {
        let width = radius * 2
        let height = radius * 2
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: width, height: height))
        path.fill()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        let resultImage = image.resizableImage(withCapInsets: UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius), resizingMode: .stretch)
        return resultImage
    }
}
