//
//  ActivityIndicator.swift
//  Near
//
//  Created by Bhushan Mahajan on 29/09/21.
//

import UIKit

class ActivityIndicator: UIView {
    
    //MARK: - Properties/Variables
    
    let circle1 = UIView()
    let circle2 = UIView()
    let circle3 = UIView()
    var circleArray: [UIView] = []
    
    //MARK: - Init Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Functions
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        circleArray = [circle1, circle2, circle3]
        
        for circle in circleArray {
            circle.frame = CGRect(x: -20, y: 5, width: 20, height: 20)
            circle.layer.cornerRadius = 10
            circle.backgroundColor = .link
            circle.alpha = 0
            addSubview(circle)
        }
    }
    
    func animate() {
        var delay: Double = 0
        for circle in circleArray {
            animateCircle(circle, delay: delay)
            delay += 0.55
        }
    }
    
    func animateCircle(_ circle: UIView, delay: Double) {
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveLinear) {
            circle.alpha = 1
            circle.frame = CGRect(x: 35, y: 5, width: 20, height: 20)
        } completion: { completed in
            UIView.animate(withDuration: 1.3, delay: 0, options: .curveLinear) {
                circle.frame = CGRect(x: 85, y: 5, width: 20, height: 20)
            } completion: { completed in
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
                    circle.alpha = 0
                    circle.frame = CGRect(x: 140, y: 5, width: 20, height: 20)
                } completion: { completed in
                    circle.frame = CGRect(x: -20, y: 5, width: 20, height: 20)
                    self.animateCircle(circle, delay: 0)
                }
            }
        }
    }
}
