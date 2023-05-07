//
//  CircularScoreBar.swift
//  NetflixClone
//
//  Created by Adlan Nourindiaz on 03/05/23.
//

import Foundation
import UIKit

class CircularScoreBar: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var percentageLabel = UILabel()
    
    var percentage: CGFloat = 0 {
        didSet {
            percentageLabel.text = "\(Int(percentage * 100))%"
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        let lineWidth = radius * 0.2
        
        // Draw track layer
        let trackPath = UIBezierPath(arcCenter: center, radius: radius - lineWidth/2, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
        
        // Draw progress layer
        let progressPath = UIBezierPath(arcCenter: center, radius: radius - lineWidth/2, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi * percentage - CGFloat.pi/2, clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemRed.cgColor
        layer.addSublayer(progressLayer)
        
        // Add percentage label
        percentageLabel.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        percentageLabel.center = center
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.boldSystemFont(ofSize: radius * 0.4)
        addSubview(percentageLabel)
    }
    
}