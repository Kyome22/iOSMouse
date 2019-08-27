//
//  MouseButton.swift
//  iOSMouseKid
//
//  Created by Takuto Nakamura on 2019/08/27.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import UIKit

class MouseButton: UIButton {
    
    private var side: Bool = false
    private var fillColor = UIColor(hex: "5B5C61")
    private var w: CGFloat {
        return self.bounds.width
    }
    private var h: CGFloat {
        return self.bounds.height
    }
    private let maskLayer = CAShapeLayer()
    private let borderLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.mask = maskLayer
        self.layer.insertSublayer(borderLayer, at: 0)
    }
    
    public func setSide(side: Bool) {
        self.side = side
    }
    
    override func draw(_ rect: CGRect) {
        let path = createPath()
        maskLayer.path = path.cgPath
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = 1.5
        borderLayer.fillColor = fillColor.cgColor
        borderLayer.strokeColor = UIColor.clear.cgColor
    }
    
    public func changeState(_ flag: Bool) {
        if flag {
            fillColor = UIColor(hex: "505050")
        } else {
            fillColor = UIColor(hex: "5B5C61")
        }
        self.setNeedsDisplay()
    }
    
    private func createPath() -> UIBezierPath {
        let r1: CGFloat = 0.7 * min(w, h)
        let d: CGFloat = 4.0
        let j: CGFloat = CGFloat.pi / 180.0
        let path = UIBezierPath()
        if side { //right
            path.move(to: CGPoint(x: 0.5 * d, y: d))
            path.addLine(to: CGPoint(x: 0.5 * d, y: 0.5 * h - r1 - d))
            path.addArc(withCenter: CGPoint(x: 0, y: 0.5 * h), radius: r1 + d,
                        startAngle: -0.5 * CGFloat.pi + j, endAngle: 0.5 * CGFloat.pi - j, clockwise: true)
            path.addLine(to: CGPoint(x: 0.5 * d, y: h - d))
            path.addLine(to: CGPoint(x: w - d, y: h - d))
            path.addLine(to: CGPoint(x: w - d, y: d))
            path.close()
        } else { //left
            path.move(to: CGPoint(x: d, y: d))
            path.addLine(to: CGPoint(x: d, y: h - d))
            path.addLine(to: CGPoint(x: w - 0.5 * d, y: h - d))
            path.addLine(to: CGPoint(x: w - 0.5 * d, y: 0.5 * h + r1 + d))
            path.addArc(withCenter: CGPoint(x: w, y: 0.5 * h), radius: r1 + d,
                        startAngle: 0.5 * CGFloat.pi + j, endAngle: 1.5 * CGFloat.pi - j, clockwise: true)
            path.addLine(to: CGPoint(x: w - 0.5 * d, y: d))
            path.close()
            path.reversing()
        }
        return path
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if createPath().contains(point) {
            return super.hitTest(point, with: event)
        } else {
            return nil
        }
    }

}

