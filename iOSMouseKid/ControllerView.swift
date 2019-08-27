//
//  ControllerView.swift
//  iOSMouseKid
//
//  Created by Takuto Nakamura on 2019/08/27.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import UIKit

class ControllerView: UIView {
    
    private var w: CGFloat {
        return self.bounds.width
    }
    private var h: CGFloat {
        return self.bounds.height
    }
    private var point = CGPoint.zero
    private var len: CGFloat {
        return sqrt(pow(point.x - 0.5 * w, 2.0) + pow(point.y - 0.5 * h, 2.0))
    }
    private var theta: CGFloat {
        return atan2(point.y - 0.5 * h, point.x - 0.5 * w)
    }
    
    override func draw(_ rect: CGRect) {
        let r1: CGFloat = 0.35 * min(w, h)
        var path = UIBezierPath(ovalIn: CGRect(x: 0.5 * w - r1, y: 0.5 * h - r1,
                                               width: 2.0 * r1, height: 2.0 * r1))
        path.lineWidth = 1.5
        UIColor(hex: "B0BEC5").setFill()
        path.fill()
        UIColor(hex: "607D8B").setStroke()
        path.stroke()
        
        let r2: CGFloat = 0.18 * min(w, h)
        if len > 15 {
            path = UIBezierPath(ovalIn: CGRect(x: 0.5 * w + (r1 - r2) * cos(theta) - r2,
                                               y: 0.5 * h + (r1 - r2) * sin(theta) - r2,
                                               width: 2.0 * r2, height: 2.0 * r2))
            UIColor(hex: "5B5C61").setFill()
            path.fill()
            path = UIBezierPath(ovalIn: CGRect(x: 0.5 * w + (r1 - r2) * cos(theta) - 0.8 * r2,
                                               y: 0.5 * h + (r1 - r2) * sin(theta) - 0.8 * r2,
                                               width: 1.6 * r2, height: 1.6 * r2))
            UIColor(hex: "80848C").setFill()
            path.fill()
        } else {
            path = UIBezierPath(ovalIn: CGRect(x: 0.5 * w - r2, y: 0.5 * h - r2,
                                               width: 2.0 * r2, height: 2.0 * r2))
            UIColor(hex: "5B5C61").setFill()
            path.fill()
            path = UIBezierPath(ovalIn: CGRect(x: 0.5 * w - 0.8 * r2, y: 0.5 * h - 0.8 * r2,
                                               width: 1.6 * r2, height: 1.6 * r2))
            UIColor(hex: "80848C").setFill()
            path.fill()
        }
    }
    
    public func updatePoint(point: CGPoint) -> Int? {
        self.point = point
        self.setNeedsDisplay()
        if len > 15 {
            return Int(theta * 180 / CGFloat.pi)
        } else {
            return nil
        }
    }
    
    public func fingerUp() {
        self.point = CGPoint(x: 0.5 * w, y: 0.5 * h)
        self.setNeedsDisplay()
    }
    
}

