import UIKit

class ButtonLoadingAnimation: UIView {
   
   // MARK: - Subviews
   
   private lazy var dot1View = UIView()
   private lazy var dot2View = UIView()
   private lazy var dot3View = UIView()
   
   // MARK: - Animations
   
   private let dot1Animation = CABasicAnimation(keyPath: "transform.scale")
   private let dot2Animation = CABasicAnimation(keyPath: "transform.scale")
   private let dot3Animation = CABasicAnimation(keyPath: "transform.scale")
   
   // MARK: - Properties
   
   private var dotSize: CGSize
   private var dotColor: UIColor
   private var animationTime: TimeInterval
   
   // MARK: - Initializer
   
   init(frame: CGRect = .zero, dotSize: CGSize, dotColor: UIColor, animationTime: TimeInterval) {
      self.dotSize = dotSize
      self.dotColor = dotColor
      self.animationTime = animationTime
      super.init(frame: frame)
      
      setupUI()
      setupAnimation()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: - Setup Functions
   //Function used to setup all the UI components and constraints for the dots.
   func setupUI() {
      addSubview(dot1View)
      addSubview(dot2View)
      addSubview(dot3View)
      
      [dot1View, dot2View, dot3View].forEach {
         $0.backgroundColor = dotColor
         $0.anchor(width: dotSize.width, height: dotSize.height)
         $0.translatesAutoresizingMaskIntoConstraints = false
         $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
         $0.clipsToBounds = true
         $0.layer.cornerRadius = dotSize.width / 2
      }
      
      dot2View.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      dot1View.anchor(right: dot2View.leftAnchor, paddingRight: 15)
      dot3View.anchor(left: dot2View.rightAnchor, paddingLeft: 15)
   }
   
   //Function used to setup all the animation components for the animation to play.
   func setupAnimation() {
      [dot1Animation, dot2Animation, dot3Animation].forEach {
         $0.autoreverses = true
         $0.duration = animationTime
         $0.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
         $0.isRemovedOnCompletion = false
         $0.toValue = 1.5
         $0.repeatCount = Float.infinity
      }
   }
   
   // MARK: - Public Functions
   //Function used to start the animation in the button.
   public func startAnimation() {
      dot2Animation.beginTime = CACurrentMediaTime() + 0.25
      dot3Animation.beginTime = CACurrentMediaTime() + 0.5
      
      dot1View.layer.add(dot1Animation, forKey: "ScaleDot1Animation")
      dot2View.layer.add(dot2Animation, forKey: "ScaleDot2Animation")
      dot3View.layer.add(dot3Animation, forKey: "ScaleDot3Animation")
   }
   
   //Function used to stop all the animations in the button.
   public func stopAnimation() {
      [dot1View, dot2View, dot3View].forEach {
         $0.layer.removeAllAnimations()
      }
   }
}
