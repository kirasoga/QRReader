//
//  DashedBorderAroundView.swift
//  QRReader
//
//  Created by KiraSoga on 2022/08/19.
//

import UIKit

final class DashedBorderAroundView: UIView {
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if self.dashedBorderLayer.superlayer == nil {
            self.dashedBorderLayer.mask = self.dashedBorderMaskLayer
            self.layer.addSublayer(self.dashedBorderLayer)
            self.layer.cornerRadius = 10
        }
    }
    
    private lazy var dashedBorderLayer: CAShapeLayer = { [unowned self] in
        
        let rect = self.bounds
        let cornerRadius: CGFloat = 10
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY - cornerRadius)) // 1
//        path.addLine(to: CGPoint(x: 0, y: cornerRadius)) // 2
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), // 3
                    radius: cornerRadius,
                    startAngle: CGFloat(Double.pi),
                    endAngle: -CGFloat(Double.pi / 2),
                    clockwise: true)
//        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: 0)) // 4
        path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: cornerRadius), // 5
                    radius: cornerRadius,
                    startAngle: -CGFloat(Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius)) // 6
        path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), // 7
                    radius: cornerRadius,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)
//        path.addLine(to: CGPoint(x: cornerRadius, y: rect.maxY)) // 8
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: rect.maxY - cornerRadius), // 9
                    radius: cornerRadius,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }()
    
    private lazy var dashedBorderMaskLayer: CAShapeLayer = { [unowned self] in
        
        let rect = self.bounds
        let cornerRadius: CGFloat = 10
        
        let path = UIBezierPath()
        
//        path.move(to: CGPoint(x: 0, y: rect.maxY - cornerRadius)) // 1
//        path.addLine(to: CGPoint(x: 0, y: cornerRadius)) // 2
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), // 3
                    radius: 30,
                    startAngle: 270.0,
                    endAngle: 90.0,
                    clockwise: false)
        
//        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: 0)) // 4
        path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: cornerRadius), // 5
                    radius: 30,
                    startAngle: 90.0,
                    endAngle: 360.0,
                    clockwise: true)
        
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius)) // 6
        path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius), // 7
                    radius: 30,
                    startAngle: 90.0,
                    endAngle: 180.0,
                    clockwise: true)
        
//        path.addLine(to: CGPoint(x: cornerRadius, y: rect.maxY)) // 8
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: rect.maxY - cornerRadius), // 9
                    radius: 30,
                    startAngle: 180.0,
                    endAngle: 0.0,
                    clockwise: false)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 10
        
        return shapeLayer
    }()
}
