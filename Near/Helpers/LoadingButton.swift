import Foundation
import UIKit

class LoadingButton: UIButton {
    
    // MARK: - Subviews
    
    private let dotsAnimationView = ButtonLoadingAnimation(dotSize: .init(width: 12, height: 12), dotColor: .black, animationTime: 0.9)
    
    // MARK: - Properties
    
    private var buttonTitle: String?
    
    // MARK: - Initializers
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        buttonTitle = title(for: .normal)
        setupUI()
    }
    
    // MARK: - Setup Functions
    //Function used to setup the UI for all the dots in the animation.
    func setupUI() {
        clipsToBounds = true
        
        addSubview(dotsAnimationView)
        dotsAnimationView.translatesAutoresizingMaskIntoConstraints = false
        dotsAnimationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dotsAnimationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dotsAnimationView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dotsAnimationView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dotsAnimationView.isHidden = true
    }
    
    // MARK: - Public Functions
    //Function used to start the animation inside of the button.
    func startAnimation() {
        setTitle(nil, for: .normal)
        dotsAnimationView.isHidden = false
        dotsAnimationView.startAnimation()
    }
    
    //Function used to stop the animation inside of the button.
    func stopAnimation() {
        dotsAnimationView.stopAnimation()
        dotsAnimationView.isHidden = true
        setTitle(buttonTitle, for: .normal)
    }
}
