import Foundation
import UIKit
import AsyncDisplayKit

private let motionAmount: CGFloat = 32.0

public class ChatBackgroundNode: ASDisplayNode {
    
    public let contentNode: ASDisplayNode
    
    public var imageContentMode: UIView.ContentMode {
        didSet {
            self.contentNode.contentMode = self.contentMode
        }
    }
    
    public var motionEnabled: Bool = false {
        didSet {
            if oldValue != self.motionEnabled {
                if self.motionEnabled {
                    let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
                    horizontal.minimumRelativeValue = motionAmount
                    horizontal.maximumRelativeValue = -motionAmount
                    
                    let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
                    vertical.minimumRelativeValue = motionAmount
                    vertical.maximumRelativeValue = -motionAmount
                    
                    let group = UIMotionEffectGroup()
                    group.motionEffects = [horizontal, vertical]
                    self.contentNode.view.addMotionEffect(group)
                } else {
                    for effect in self.contentNode.view.motionEffects {
                        self.contentNode.view.removeMotionEffect(effect)
                    }
                }
                if !self.frame.isEmpty {
                    self.updateScale()
                }
            }
        }
    }
    
    public var rotation: CGFloat = 0.0 {
        didSet {
            var fromValue: CGFloat = 0.0
            if let value = (self.layer.value(forKeyPath: "transform.rotation.z") as? NSNumber)?.floatValue {
                fromValue = CGFloat(value)
            }
            self.contentNode.layer.transform = CATransform3DMakeRotation(self.rotation, 0.0, 0.0, 1.0)
            self.contentNode.layer.animateRotation(from: fromValue, to: self.rotation, duration: 0.3)
        }
    }
    
    public override init() {
        self.contentNode = ASDisplayNode()
        self.imageContentMode = .scaleAspectFill
        
        super.init()
        
        self.clipsToBounds = true
        self.contentNode.frame = self.bounds
        self.contentNode.contentMode = self.self.contentMode
        self.addSubnode(self.contentNode)
    }
    
    func updateScale() {
        if self.motionEnabled {
            let scale = (self.frame.width + motionAmount * 2.0) / self.frame.width
            self.contentNode.transform = CATransform3DMakeScale(scale, scale, 1.0)
        } else {
            self.contentNode.transform = CATransform3DIdentity
        }
    }
    
    public func updateLayout(size: CGSize, transition: ContainedViewLayoutTransition) {
        let isFirstLayout = self.contentNode.frame.isEmpty
        transition.updatePosition(node: self.contentNode, position: CGPoint(x: size.width / 2.0, y: size.height / 2.0))
        transition.updateBounds(node: self.contentNode, bounds: CGRect(origin: CGPoint(), size: size))
        
        if isFirstLayout && !self.frame.isEmpty {
            self.updateScale()
        }
    }
}

public class WallpaperBackgroundNode: ChatBackgroundNode {
        
    public var image: UIImage? {
        didSet {
            self.contentNode.contents = self.image?.cgImage
        }
    }
}

public class GradientBackgroundNode: ChatBackgroundNode {
    
    public var animationDuration: TimeInterval = 1.0
    public var animationOptions: CurveAnimationOptions = .init(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .easeInOut)
    public var colors: [String] = [] {
        didSet {
            self.updateColors(colors: self.colors.map({ UIColor(hexString: $0) ?? .white }))
        }
    }
    
    lazy var gradientLayers = [
        self.createGradientLayer(containerSize: self.frame.size, controlPoint: self.controlPoints[0], color: .green),
        self.createGradientLayer(containerSize: self.frame.size, controlPoint: self.controlPoints[1], color: .blue),
        self.createGradientLayer(containerSize: self.frame.size, controlPoint: self.controlPoints[2], color: .orange),
        self.createGradientLayer(containerSize: self.frame.size, controlPoint: self.controlPoints[3], color: .cyan),
    ]
    
    private let blurEffectView: UIVisualEffectView
    
    private let controlPoints: [CGPoint] = [
        CGPoint(x: 0.8, y: 0.15),
        CGPoint(x: 0.3, y: 0.3),
        CGPoint(x: 0.2, y: 0.85),
        CGPoint(x: 0.7, y: 0.7),
    ]

    private func createGradientLayer(containerSize: CGSize, controlPoint: CGPoint, color: UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [color.cgColor, UIColor.clear.cgColor]
        gradientLayer.bounds.size = CGSize(width: containerSize.width * 2, height: containerSize.height * 2)
        gradientLayer.position = CGPoint(x: containerSize.width * controlPoint.x, y: containerSize.height * controlPoint.y)
        return gradientLayer
    }
    
    public func updateColors(colors: [UIColor]) {
        for (layer, color) in zip(self.gradientLayers, colors) {
            layer.colors = [color.cgColor, UIColor.clear.cgColor]
        }
    }
    
    func updateGradientLayers(animated: Bool) {
        for (layer, controlPoint) in zip(self.gradientLayers, self.controlPoints) {
            
            let fromSize = layer.bounds.size
            let fromPosition = layer.position
            
            let toSize = CGSize(width: self.frame.width * 2, height: self.frame.height * 2)
            let toPosition = CGPoint(x: self.frame.size.width * controlPoint.x, y: self.frame.size.height * controlPoint.y)
            
            layer.bounds.size = toSize
            layer.position = toPosition
            
            if animated {
                layer.animatePosition(
                    from: fromPosition,
                    to: toPosition,
                    duration: self.animationDuration * self.animationOptions.relativeDuration,
                    delay: self.animationDuration * self.animationOptions.relativeDelay,
                    timingFunction: self.animationOptions.transitionCurve.timingFunction,
                    mediaTimingFunction: self.animationOptions.transitionCurve.mediaTimingFunction
                )
            }
        }
    }
    
    public override init() {
        let effectView: UIVisualEffectView
        if #available(iOS 13.0, *) {
            effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight))
        } else if #available(iOS 10.0, *) {
            effectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        } else {
            effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        }
        self.blurEffectView = effectView
        
        super.init()
        
        self.gradientLayers.forEach(self.contentNode.layer.addSublayer)
        self.contentNode.view.addSubview(self.blurEffectView)
    }
    
    public func animateGradientTransition() {
        self.gradientLayers.insert(self.gradientLayers.removeLast(), at: 0)
        self.updateGradientLayers(animated: true)
    }
    
    public override func updateLayout(size: CGSize, transition: ContainedViewLayoutTransition) {
        super.updateLayout(size: size, transition: transition)
        
        self.updateGradientLayers(animated: false)
        self.blurEffectView.frame = self.contentNode.bounds
    }
}

