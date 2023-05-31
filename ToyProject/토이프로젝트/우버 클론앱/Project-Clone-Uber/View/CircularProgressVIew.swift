//
//  CircularProgressVIew.swift
//  Project-Clone-Uber
//
//  Created by 정덕호 on 2022/03/25.
//

import Foundation
import UIKit

class CircularProgressVIew: UIView {
    
    //MARK: -  속성
    var progressLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var pulsationgLayer: CAShapeLayer!
    
    //MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCirlceLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 도움메서드
    
    private func configureCirlceLayers() {
        pulsationgLayer = circlShapeLayer(strokeColor: .clear, fillColor: .darkGray)
        layer.addSublayer(pulsationgLayer)
        
        trackLayer = circlShapeLayer(strokeColor: .clear, fillColor: .clear)
        
        layer.addSublayer(trackLayer)
        trackLayer.strokeEnd = 1
        
        progressLayer = circlShapeLayer(strokeColor: .white, fillColor: .clear)
        layer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 1
    }
    
    private func circlShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        let center = CGPoint(x: 0, y: 32)
        let circularPath = UIBezierPath(arcCenter: center, radius: self.frame.width / 2.5, startAngle: -(.pi / 2), endAngle: 1.5 * .pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 12
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = self.center
        
        return layer
    }
    
    func animatePulsatringLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.2
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsationgLayer.add(animation, forKey: "pulsing")
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float, completion: @escaping() -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateProgress")
        
        CATransaction.commit()
    }
}
