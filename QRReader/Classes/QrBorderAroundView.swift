//
//  QrBorderAroundView.swift
//  QRReader
//
//  Created by KiraSoga on 2022/08/19.
//

import UIKit

class QrBorderAroundView: UIView {
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let rect = self.bounds
        let cornerRadius: CGFloat = 10
        
        let upperLeft = self.getQrBorderLayer()
        upperLeft.mask = self.getBorderMaskLayer(.init(x: cornerRadius,
                                                       y: cornerRadius))
        self.layer.addSublayer(upperLeft)
        
        let upperRight = self.getQrBorderLayer()
        upperRight.mask = self.getBorderMaskLayer(.init(x: rect.maxX - cornerRadius,
                                                        y: cornerRadius))
        self.layer.addSublayer(upperRight)
        
        let bottomRight = self.getQrBorderLayer()
        bottomRight.mask = self.getBorderMaskLayer(.init(x: rect.maxX - cornerRadius,
                                                         y: rect.maxY - cornerRadius))
        self.layer.addSublayer(bottomRight)
        
        let bottomLeft = self.getQrBorderLayer()
        bottomLeft.mask = self.getBorderMaskLayer(.init(x: cornerRadius,
                                                        y: rect.maxY - cornerRadius))
        self.layer.addSublayer(bottomLeft)
        
        self.layer.cornerRadius = 10
    }
    
    private func getQrBorderLayer() -> CAShapeLayer {
        let rect = self.bounds
        let cornerRadius: CGFloat = 10
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY - cornerRadius))
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat(Double.pi),
                    endAngle: -CGFloat(Double.pi / 2),
                    clockwise: true)
        path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: -CGFloat(Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        path.addArc(withCenter: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)
        path.addArc(withCenter: CGPoint(x: cornerRadius, y: rect.maxY - cornerRadius),
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
    }
    
    private func getBorderMaskLayer(_ cgPoint: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath()
        
        path.addArc(withCenter: cgPoint,
                    radius: 30,
                    startAngle: 0,
                    endAngle: Double.pi * 2,
                    clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 10
        
        return shapeLayer
    }
}
