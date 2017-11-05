//
//  UIView+Extension.swift
//  gg-iOS
//
//  Created by chenhao on 2017/11/5.
//  Copyright © 2017年 c344081. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.x = newValue
            frame = rect
        }
        get {
            return frame.origin.x
        }
    }
    var y: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.y = newValue
            frame = rect
        }
        get {
            return frame.origin.y
        }
    }
    var width: CGFloat {
        set {
            var rect: CGRect = frame
            rect.size.width = newValue
            frame = rect
        }
        get {
            return frame.size.width
        }
    }
    var height: CGFloat {
        set {
            var rect: CGRect = frame
            rect.size.height = newValue
            frame = rect
        }
        get {
            return frame.size.height
        }
    }
    
    var centerX: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.x = newValue - rect.width * 0.5
            frame = rect
        }
        get {
            return frame.midX
        }
    }
    
    var centerY: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.y = newValue - rect.height * 0.5
            frame = rect
        }
        get {
            return frame.midY
        }
    }
    
    var left: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.x = newValue
            frame = rect
        }
        get {
            return frame.origin.x
        }
    }
    
    var right: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.x = newValue - rect.size.width
            frame = rect
        }
        get {
            return frame.maxX
        }
    }
    
    var top: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.y = newValue
            frame = rect
        }
        get {
            return frame.minY
        }
    }
    
    var bottom: CGFloat {
        set {
            var rect: CGRect = frame
            rect.origin.y = newValue - rect.size.height
            frame = rect
        }
        get {
            return frame.maxY
        }
    }
    
}
