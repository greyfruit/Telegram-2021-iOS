import UIKit
import Display
import AsyncDisplayKit
import SwiftSignalKit

extension ContainedViewLayoutTransitionCurve {
    
    var x1: Float {
        switch self {
        case .custom(let x1, _, _, _):
            return x1
        default:
            return 0.0
        }
    }
    
    var x2: Float {
        switch self {
        case .custom(_, _, let x2, _):
            return x2
        default:
            return 0.0
        }
    }
}

public enum AnimationType {
    
    case textMessage
    case singleEmoji
    case sticker
    case voiceMessage
    case videoMessage
    case background
    
    var description: String {
        switch self {
        case .textMessage:
            return "Text Message"
        case .singleEmoji:
            return "Single Emoji"
        case .sticker:
            return "Sticker"
        case .voiceMessage:
            return "Voice Message"
        case .videoMessage:
            return "Video Message"
        case .background:
            return "Background"
        }
    }
}

public enum AnimationDuration: CaseIterable {
    
    case f60
    case f45
    case f30
    case f15
    
    public var duration: TimeInterval {
        switch self {
        case .f60:
            return 60/60
        case .f45:
            return 45/60
        case .f30:
            return 30/60
        case .f15:
            return 15/60
        }
    }
    
    public var description: String {
        switch self {
        case .f60:
            return "60f (1 sec)"
        case .f45:
            return "45f"
        case .f30:
            return "30f"
        case .f15:
            return "15f"
        }
    }
}

public class AnimationSettingsProvider {
    
    public static let shared = AnimationSettingsProvider()
    
    public var textMessageAnimationSettings: TextMessageAnimationSettings = .default
    public var singleEmojiAnimationSettings: SingleEmojiAnimationSettings = .default
    public var stickerAnimationSettings: StickerAnimationSettings = .default
    public var voiceMessageAnimationSettings: VoiceMessageAnimationSettings = .default
    public var videoMessageAnimationSettings: VideoMessageAnimationSettings = .default
    public var backgroundAnimationSettings: BackgroundAnimationSettings = .default {
        didSet {
            self.backgroundAnimationSettingsDidChange.set(.single(self.backgroundAnimationSettings))
        }
    }
    
    public lazy var backgroundAnimationSettingsDidChange: Promise<BackgroundAnimationSettings> = Promise(self.backgroundAnimationSettings)
}

public class TextMessageAnimationSettings {
    
    public let duration: AnimationDuration
    public let positionY: CurveAnimationOptions
    public let positionX: CurveAnimationOptions
    public let bubbleShape: CurveAnimationOptions
    public let colorChange: CurveAnimationOptions
    public let timeAppears: CurveAnimationOptions
    
    public init(duration: AnimationDuration, positionY: CurveAnimationOptions, positionX: CurveAnimationOptions, bubbleShape: CurveAnimationOptions, colorChange: CurveAnimationOptions, timeAppears: CurveAnimationOptions) {
        self.duration = duration
        self.positionY = positionY
        self.positionX = positionX
        self.bubbleShape = bubbleShape
        self.colorChange = colorChange
        self.timeAppears = timeAppears
    }
    
    public static var `default`: TextMessageAnimationSettings {
        return TextMessageAnimationSettings(
            duration: .f60,
            positionY: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            positionX: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            bubbleShape: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            colorChange: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            timeAppears: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0))
        )
    }
}

public class SingleEmojiAnimationSettings {
    
    public let duration: AnimationDuration
    public let positionY: CurveAnimationOptions
    public let positionX: CurveAnimationOptions
    public let emojiScale: CurveAnimationOptions
    public let timeAppears: CurveAnimationOptions
    
    public init(duration: AnimationDuration, positionY: CurveAnimationOptions, positionX: CurveAnimationOptions, emojiScale: CurveAnimationOptions, timeAppears: CurveAnimationOptions) {
        self.duration = duration
        self.positionY = positionY
        self.positionX = positionX
        self.emojiScale = emojiScale
        self.timeAppears = timeAppears
    }
    
    public static var `default`: SingleEmojiAnimationSettings {
        return SingleEmojiAnimationSettings(
            duration: .f60,
            positionY: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            positionX: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 0.8, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            emojiScale: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            timeAppears: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0))
        )
    }
}

public class StickerAnimationSettings {
    
    public let duration: AnimationDuration
    public let positionY: CurveAnimationOptions
    public let positionX: CurveAnimationOptions
    public let stickerScale: CurveAnimationOptions
    public let timeAppears: CurveAnimationOptions
    
    public init(duration: AnimationDuration, positionY: CurveAnimationOptions, positionX: CurveAnimationOptions, stickerScale: CurveAnimationOptions, timeAppears: CurveAnimationOptions) {
        self.duration = duration
        self.positionY = positionY
        self.positionX = positionX
        self.stickerScale = stickerScale
        self.timeAppears = timeAppears
    }
    
    public static var `default`: StickerAnimationSettings {
        return StickerAnimationSettings(
            duration: .f60,
            positionY: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            positionX: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 0.5, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            stickerScale: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            timeAppears: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0))
        )
    }
}

public class VoiceMessageAnimationSettings {
    
    public let duration: AnimationDuration
    public let positionY: CurveAnimationOptions
    public let positionX: CurveAnimationOptions
    
    public init(duration: AnimationDuration, positionY: CurveAnimationOptions, positionX: CurveAnimationOptions) {
        self.duration = duration
        self.positionY = positionY
        self.positionX = positionX
    }
    
    public static var `default`: VoiceMessageAnimationSettings {
        return VoiceMessageAnimationSettings(
            duration: .f60,
            positionY: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            positionX: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0))
        )
    }
}

public class VideoMessageAnimationSettings {
    
    public let duration: AnimationDuration
    public let positionY: CurveAnimationOptions
    public let positionX: CurveAnimationOptions
    public let timeAppears: CurveAnimationOptions
    
    public init(duration: AnimationDuration, positionY: CurveAnimationOptions, positionX: CurveAnimationOptions, timeAppears: CurveAnimationOptions) {
        self.duration = duration
        self.positionY = positionY
        self.positionX = positionX
        self.timeAppears = timeAppears
    }
    
    public static var `default`: VideoMessageAnimationSettings {
        return VideoMessageAnimationSettings(
            duration: .f60,
            positionY: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 0.7, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            positionX: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            timeAppears: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0))
        )
    }
}

public class BackgroundAnimationSettings {
    
    public let duration: AnimationDuration
    public let position: CurveAnimationOptions
    public let colors: [String]
    
    public init(duration: AnimationDuration, position: CurveAnimationOptions, colors: [String]) {
        self.duration = duration
        self.position = position
        self.colors = colors
    }
    
    public static var `default`: BackgroundAnimationSettings {
        return BackgroundAnimationSettings(
            duration: .f60,
            position: CurveAnimationOptions(relativeDelay: 0.0, relativeDuration: 1.0, transitionCurve: .custom(0.33, 0.0, 0.0, 1.0)),
            colors: ["#FFF6BF", "#76A076", "#F6E477", "#316B4D"]
        )
    }
}

class SelectionTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        self.titleLabel.textAlignment = .left
        self.titleLabel.textColor = UIColor.black
        self.contentView.addSubview(self.titleLabel)
        
        self.descriptionLabel.textAlignment = .right
        self.descriptionLabel.textColor = UIColor.systemGray
        self.contentView.addSubview(self.descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        let availableSize = self.contentView.bounds.size
        
        self.titleLabel.frame = CGRect(
            x: insets.left,
            y: 0.0,
            width: availableSize.width * 0.5,
            height: availableSize.height
        )
        
        self.descriptionLabel.frame = CGRect(
            x: availableSize.width * 0.5,
            y: 0.0,
            width: (availableSize.width * 0.5) - insets.right,
            height: availableSize.height
        )
    }
}

class AnimationCurveTableViewCell: UITableViewCell {
    
    class Slider: UIView {
        
        class DottedSlider: UISlider {
            
            let dotSize: CGFloat = 15.0
            let leftDotLayer = CAShapeLayer()
            let rightDotLayer = CAShapeLayer()
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                
//                [self.leftDotLayer, self.rightDotLayer].forEach {
//                    $0.cornerRadius = dotSize/2
//                    $0.borderWidth = 2.0
//                    $0.borderColor = UIColor.white.cgColor
//                    $0.backgroundColor = UIColor.systemYellow.cgColor
//                    $0.zPosition = -1
//                    self.layer.addSublayer($0)
//                }
            }
            
            override func layoutSublayers(of layer: CALayer) {
                super.layoutSublayers(of: layer)
                
//                self.leftDotLayer.frame = CGRect(
//                    x: dotSize/2,
//                    y: self.bounds.midY - dotSize/2,
//                    width: dotSize,
//                    height: dotSize
//                )
//
//                self.rightDotLayer.frame = CGRect(
//                    x: self.bounds.width - dotSize*1.5,
//                    y: self.bounds.midY - dotSize/2,
//                    width: dotSize,
//                    height: dotSize
//                )
            }
            
            override func layoutSubviews() {
                super.layoutSubviews()
                
                self.subviews.first?.subviews.filter({ ($0 is UIImageView) == false }).forEach({
                    $0.alpha = 0.0
                })
            }
        }
        
        var onSliderValueChanged: ((Float) -> Void)? = nil
        
        let label = UILabel()
        let slider = DottedSlider()
        
        var sliderImageView: UIView? {
            return self.slider.subviews.first?.subviews.first(where: { $0 is UIImageView })
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.label.textColor = UIColor.systemBlue
            self.label.font = UIFont.systemFont(ofSize: 14.0)
            self.addSubview(self.label)
            
            self.slider.value = 1.0
            self.slider.minimumValue = 0.0
            self.slider.maximumValue = 1.0
            self.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            self.addSubview(self.slider)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            self.slider.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: self.bounds.width,
                height: self.bounds.height
            )
            
            if let sliderImageView = self.sliderImageView {
                self.label.sizeToFit()
                self.label.frame.origin.y = sliderImageView.frame.minY - self.label.frame.height
                self.label.frame.origin.x = sliderImageView.frame.midX - self.label.frame.width/2
            }
        }
        
        func updateLabelText() {
            self.label.text = String(format: "%.0f", self.slider.value * 100) + "%"
        }
        
        func mirrorHorizontaly() {
            self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            self.label.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        @objc func sliderValueChanged(_ sender: UISlider) {
            self.onSliderValueChanged?(sender.value)
            self.updateLabelText()
            self.setNeedsLayout()
        }
    }
    
    class Limiter: UIView {
        
        enum TextPosition {
            case left
            case right
        }
        
        var textPosition: TextPosition = .right
        
        let pullView = UIView()
        let titleLabel = UILabel()
        let topDotLayer = CAShapeLayer()
        let bottomDotLayer = CAShapeLayer()
        let dashLineLayer = CAShapeLayer()
        
        let dotSize: CGFloat = 15.0
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.dashLineLayer.lineDashPattern = [0, 10]
            self.dashLineLayer.lineWidth = 4.0
            self.dashLineLayer.strokeColor = UIColor.systemYellow.cgColor
            self.dashLineLayer.lineCap = .round
            self.layer.addSublayer(self.dashLineLayer)
            
            [self.topDotLayer, self.bottomDotLayer].forEach {
                $0.cornerRadius = dotSize/2
                $0.borderWidth = 2.0
                $0.borderColor = UIColor.white.cgColor
                $0.backgroundColor = UIColor.systemYellow.cgColor
                self.layer.addSublayer($0)
            }
            
            self.pullView.backgroundColor = UIColor.white
            self.pullView.layer.cornerRadius = 10.0
            self.pullView.layer.shadowOpacity = 1.0
            self.pullView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            self.pullView.layer.shadowOffset = .zero
            self.pullView.layer.shadowRadius = 5.0
            self.addSubview(self.pullView)
            
            self.titleLabel.text = "test"
            self.titleLabel.textColor = UIColor.systemYellow
            self.titleLabel.font = UIFont.systemFont(ofSize: 14.0)
            self.addSubview(self.titleLabel)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let pullViewSize = CGSize(width: self.frame.width * 0.7, height: 40.0)
            
            self.pullView.frame = CGRect(
                x: self.bounds.midX - pullViewSize.width/2,
                y: self.bounds.midY - pullViewSize.height/2,
                width: pullViewSize.width,
                height: pullViewSize.height
            )
            
            self.topDotLayer.frame = CGRect(
                x: self.bounds.midX - dotSize/2,
                y: self.bounds.minY,
                width: dotSize,
                height: dotSize
            )
            
            self.bottomDotLayer.frame = CGRect(
                x: self.bounds.midX - dotSize/2,
                y: self.bounds.maxY - dotSize,
                width: dotSize,
                height: dotSize
            )
            
            let path = UIBezierPath()
            path.move(to: self.topDotLayer.position)
            path.addLine(to: self.bottomDotLayer.position)
            self.dashLineLayer.path = path.cgPath
            
            self.titleLabel.sizeToFit()
            switch self.textPosition {
            case .right:
                self.titleLabel.frame.origin = CGPoint(
                    x: self.pullView.frame.maxX + 5.0,
                    y: self.pullView.frame.midY - self.titleLabel.frame.height/2
                )
            case .left:
                self.titleLabel.frame.origin = CGPoint(
                    x: self.pullView.frame.minX - self.titleLabel.frame.width - 5.0,
                    y: self.pullView.frame.midY - self.titleLabel.frame.height/2
                )
            }
        }
    }
    
    let topSlider = Slider()
    let topSliderProgressView = UIView()
    let topSliderBackgroundView = UIView()
    
    let bottomSlider = Slider()
    let bottomSliderProgressView = UIView()
    let bottomSliderBackgroundView = UIView()
    
    let leftLimiter = Limiter()
    let rightLimiter = Limiter()
    
    let timelineShapeLayer = CAShapeLayer()
    
    var viewModel: AnimationCurveViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.topSliderBackgroundView.layer.cornerRadius = 2.0
        self.topSliderBackgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.addSubview(self.topSliderBackgroundView)
        
        self.bottomSliderBackgroundView.layer.cornerRadius = 2.0
        self.bottomSliderBackgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.addSubview(self.bottomSliderBackgroundView)
        
        self.timelineShapeLayer.fillColor = nil
        self.timelineShapeLayer.lineWidth = 4.0
        self.timelineShapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        self.layer.addSublayer(self.timelineShapeLayer)
        
        self.topSliderProgressView.backgroundColor = UIColor.systemBlue
        self.addSubview(self.topSliderProgressView)
        
        self.bottomSliderProgressView.backgroundColor = UIColor.systemBlue
        self.addSubview(self.bottomSliderProgressView)
        
        self.leftLimiter.textPosition = .right
        self.leftLimiter.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(limiterValueChanged)))
        self.contentView.addSubview(self.leftLimiter)
        
        self.rightLimiter.textPosition = .left
        self.rightLimiter.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(limiterValueChanged)))
        self.contentView.addSubview(self.rightLimiter)
        
        self.topSlider.mirrorHorizontaly()
        self.topSlider.onSliderValueChanged = { value in
            self.viewModel.topSlider = value
            self.updateTimeline()
        }
        self.contentView.addSubview(self.topSlider)
        
        self.bottomSlider.onSliderValueChanged = { value in
            self.viewModel.bottomSlider = value
            self.updateTimeline()
        }
        self.contentView.addSubview(self.bottomSlider)
    }
    
    let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var topSliderOriginalFrame: CGRect {
        return CGRect(
            x: self.insets.left,
            y: self.insets.right,
            width: self.bounds.width - self.insets.left - self.insets.right,
            height: 70.0
        )
    }
    
    var bottomSliderOriginalFrame: CGRect {
        return CGRect(
            x: self.insets.left,
            y: self.bounds.height - self.insets.bottom - 70.0,
            width: self.bounds.width - self.insets.left - self.insets.right,
            height: 70.0
        )
    }
    
    var leftLimiterOriginalFrame: CGRect {
        return CGRect(
            x: self.insets.left,
            y: self.topSliderOriginalFrame.midY - self.leftLimiter.dotSize/2,
            width: 30.0,
            height: self.bottomSliderOriginalFrame.midY - self.topSliderOriginalFrame.midY + self.leftLimiter.dotSize
        )
    }
    
    var rightLimiterOriginalFrame: CGRect {
        return CGRect(
            x: self.bounds.width - self.insets.right - 30.0,
            y: self.leftLimiterOriginalFrame.origin.y,
            width: 30.0,
            height: self.leftLimiterOriginalFrame.height
        )
    }
    
    @objc func limiterValueChanged(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.view {
        case self.rightLimiter:
            self.viewModel.setRightLimiter(Double(gesture.location(in: self).x.convert(fromRange: self.leftLimiterOriginalFrame.origin.x...self.rightLimiterOriginalFrame.origin.x, toRange: 0...1)))
        case self.leftLimiter:
            self.viewModel.setLeftLimiter(Double(gesture.location(in: self).x.convert(fromRange: self.leftLimiterOriginalFrame.origin.x...self.rightLimiterOriginalFrame.origin.x, toRange: 0...1)))
        default:
            break
        }
        
        self.setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.leftLimiter.titleLabel.text = self.viewModel.leftLimiterTime
        self.leftLimiter.titleLabel.sizeToFit()
        self.leftLimiter.frame = CGRect(
            x: CGFloat(self.viewModel.leftLimiter).convert(fromRange: 0...1, toRange: self.leftLimiterOriginalFrame.origin.x...self.rightLimiterOriginalFrame.origin.x),
            y: self.leftLimiterOriginalFrame.origin.y,
            width: self.leftLimiterOriginalFrame.width,
            height: self.leftLimiterOriginalFrame.height
        )
        
        self.rightLimiter.titleLabel.text = self.viewModel.rightLimiterTime
        self.rightLimiter.titleLabel.sizeToFit()
        self.rightLimiter.frame = CGRect(
            x: CGFloat(self.viewModel.rightLimiter).convert(fromRange: 0...1, toRange: self.leftLimiterOriginalFrame.origin.x...self.rightLimiterOriginalFrame.origin.x),
            y: self.rightLimiterOriginalFrame.origin.y,
            width: self.rightLimiterOriginalFrame.width,
            height: self.rightLimiterOriginalFrame.height
        )

        self.topSlider.frame = CGRect(
            x: self.leftLimiter.frame.minX,
            y: self.topSliderOriginalFrame.origin.y,
            width: self.rightLimiter.frame.maxX - self.leftLimiter.frame.minX,
            height: self.topSliderOriginalFrame.height
        )
        
        self.bottomSlider.frame = CGRect(
            x: self.leftLimiter.frame.minX,
            y: self.bottomSliderOriginalFrame.origin.y,
            width: self.rightLimiter.frame.maxX - self.leftLimiter.frame.minX,
            height: self.bottomSliderOriginalFrame.height
        )
        
        self.topSliderBackgroundView.frame = CGRect(
            x: self.topSliderOriginalFrame.minX + 10.0,
            y: self.topSliderOriginalFrame.midY - 2.0,
            width: self.topSliderOriginalFrame.width - 20.0,
            height: 4.0
        )
        
        self.bottomSliderBackgroundView.frame = CGRect(
            x: self.bottomSliderOriginalFrame.minX + 10.0,
            y: self.bottomSliderOriginalFrame.midY - 2.0,
            width: self.bottomSliderOriginalFrame.width - 20.0,
            height: 4.0
        )
        
        self.updateTimeline()
    }
    
    func updateTimeline() {
        
        if let topSliderImageView = self.topSlider.sliderImageView {
            self.topSliderProgressView.frame = CGRect(
                x: topSliderImageView.convert(topSliderImageView.bounds, to: self).midX,
                y: self.topSliderOriginalFrame.midY - 2.0,
                width: self.rightLimiter.frame.midX - topSliderImageView.convert(topSliderImageView.bounds, to: self).midX,
                height: 4.0
            )
        }
        
        if let bottomSliderImageView = self.bottomSlider.sliderImageView {
            self.bottomSliderProgressView.frame = CGRect(
                x: self.leftLimiter.frame.midX,
                y: self.bottomSliderOriginalFrame.midY - 2.0,
                width: bottomSliderImageView.convert(bottomSliderImageView.bounds, to: self).midX - self.leftLimiter.frame.midX,
                height: 4.0
            )
        }
        
        let path = UIBezierPath()
        
        if let bottomSliderImageView = self.bottomSlider.sliderImageView, let topSliderImageView = self.topSlider.sliderImageView {
            
            let fromFrame = bottomSliderImageView.layer.convert(bottomSliderImageView.layer.bounds, to: self.layer)
            let toFrame = topSliderImageView.layer.convert(topSliderImageView.layer.bounds, to: self.layer)
            
            let fromPosition = CGPoint(
                x: self.leftLimiter.frame.midX,
                y: self.bottomSlider.frame.midY
            )
            
            let toPosition = CGPoint(
                x: self.rightLimiter.frame.midX,
                y: self.topSlider.frame.midY
            )
            
            path.move(to: fromPosition)
            path.addCurve(
                to: toPosition,
                controlPoint1: CGPoint(x: fromFrame.midX, y: fromFrame.midY),
                controlPoint2: CGPoint(x: toFrame.midX, y: toFrame.midY)
            )
        }
        
        self.timelineShapeLayer.path = path.cgPath
    }
}

class GradientTableViewCell: UITableViewCell {
    
    var disposables: [Disposable] = []
    var viewModel: GradientViewModel! {
        didSet {
            self.disposables = self.viewModel.colors.map({
                $0.colorObservable.get().start(next: { [weak self] _ in
                    if let self = self {
                        self.gradientBackgroundNode.updateColors(colors: self.viewModel.colors.map(\.color).map({ UIColor(hexString: $0) ?? .white }))
                    }
                })
            })
        }
    }
    
    let gradientBackgroundNode = GradientBackgroundNode()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.contentView.addSubnode(self.gradientBackgroundNode)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientBackgroundNode.frame = self.contentView.bounds
        self.gradientBackgroundNode.updateLayout(size: self.gradientBackgroundNode.frame.size, transition: .immediate)
    }
}

class ColorTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let titleLabel = UILabel()
    let colorTextField = UITextField()
    let colorBackgroundView = UIView()
    
    var disposables: [Disposable] = []
    var viewModel: ColorViewModel! {
        didSet {
            
            self.disposables.forEach({ $0.dispose() })
            
            self.titleLabel.text = self.viewModel.title
            
            self.disposables = [
                self.viewModel.colorObservable.get().start(next: { [weak self] color in
                    self?.colorTextField.text = "#" + color.replacingOccurrences(of: "#", with: "").uppercased()
                    self?.colorBackgroundView.backgroundColor = UIColor(hexString: color) ?? .white
                })
            ]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none

        self.titleLabel.textColor = UIColor.black
        self.contentView.addSubview(self.titleLabel)
        
        self.colorBackgroundView.layer.cornerRadius = 4.0
        self.contentView.addSubview(self.colorBackgroundView)
        
        self.colorTextField.delegate = self
        self.colorTextField.textColor = UIColor.black
        self.colorTextField.autocorrectionType = .no
        self.colorTextField.autocapitalizationType = .allCharacters
        self.colorBackgroundView.addSubview(self.colorTextField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        
        self.titleLabel.frame = CGRect(
            x: insets.left,
            y: insets.top,
            width: (self.bounds.width/2) - insets.left,
            height: self.bounds.height - insets.top - insets.bottom
        )
        
        let colorViewWidth: CGFloat = 94.0
        self.colorBackgroundView.frame = CGRect(
            x: self.bounds.width - insets.right - colorViewWidth,
            y: insets.top,
            width: colorViewWidth,
            height: self.bounds.height - insets.top - insets.bottom
        )
        
        self.colorTextField.frame = self.colorBackgroundView.bounds.insetBy(dx: 5.0, dy: 5.0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, let range = Range(range, in: text) else {
            return true
        }
        
        let replacementText = text.replacingCharacters(in: range, with: string)
        
//        if replacementText.isEmpty {
//            textField.text = "#"
//            return false
//        }
        
        if replacementText.count <= 7 {
            self.viewModel.color = replacementText
//            self.colorBackgroundView.backgroundColor = UIColor(hexString: replacementText) ?? .white
        }
        
        return false
    }
}

class AnimationCurveViewModel {
    
    let duration: () -> Double
    var topSlider: Float
    var bottomSlider: Float
    var leftLimiter: Double
    var rightLimiter: Double
    
    var leftLimiterTime: String {
        return String(format: "%.0ff", (self.duration() * 60.0) * self.leftLimiter)
    }
    
    var rightLimiterTime: String {
        return String(format: "%.0ff", (self.duration() * 60.0) * self.rightLimiter)
    }
    
    init(duration: @escaping () -> Double, curveAnimationOptions: CurveAnimationOptions) {
        self.duration = duration
        self.topSlider = 1.0 - curveAnimationOptions.transitionCurve.x2
        self.bottomSlider = curveAnimationOptions.transitionCurve.x1
        self.leftLimiter = curveAnimationOptions.relativeDelay
        self.rightLimiter = curveAnimationOptions.relativeDelay + curveAnimationOptions.relativeDuration
    }
    
    func setRightLimiter(_ value: Double) {
        if (value - 0.2) > self.leftLimiter {
            self.rightLimiter = min(value, 1.0)
        } else {
            self.rightLimiter = self.leftLimiter + 0.2
        }
    }
    
    func setLeftLimiter(_ value: Double)  {
        if (value + 0.2) < self.rightLimiter {
            self.leftLimiter = max(value, 0.0)
        } else {
            self.leftLimiter = self.rightLimiter - 0.2
        }
    }
    
    func toAnimationOptions() -> CurveAnimationOptions {
        
        let relativeDelay = self.leftLimiter
        let relativeDuration = self.rightLimiter - relativeDelay
        let transitionCurve = ContainedViewLayoutTransitionCurve.custom(self.bottomSlider, 0.0, 1.0 - self.topSlider, 1.0)
        
        return CurveAnimationOptions(
            relativeDelay: relativeDelay,
            relativeDuration: relativeDuration,
            transitionCurve: transitionCurve
        )
    }
}

class GradientViewModel {
    
    let colors: [ColorViewModel]
    
    init(colors: [ColorViewModel]) {
        self.colors = colors
    }
}

class ColorViewModel {
    
    let title: String
    
    let colorObservable: Promise<String>
    var color: String {
        didSet {
            self.didChange?(self)
            self.colorObservable.set(.single(self.color))
        }
    }
    
    var didChange: ((ColorViewModel) -> Void)? = nil
    
    init(title: String, color: String) {
        self.title = title
        self.color = color
        self.colorObservable = Promise(color)
    }
}

class AnimationSettingsViewModel {
    
    let animationType: AnimationType
    var animationDuration: AnimationDuration
    var sections: [Section] = []
    
    init(animationType: AnimationType, animationDuration: AnimationDuration) {
        self.animationType = animationType
        self.animationDuration = animationDuration
    }
    
    static func from(_ settings: TextMessageAnimationSettings) -> (AnimationSettingsViewModel, () -> TextMessageAnimationSettings) {
        
        let animationSettings = AnimationSettingsViewModel(
            animationType: .textMessage,
            animationDuration: settings.duration
        )
        
        let duration: () -> Double = {
            return animationSettings.animationDuration.duration
        }
        
        let positionY = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionY)
        let positionX = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionX)
        let bubbleShape = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.bubbleShape)
        let colorChange = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.colorChange)
        let timeAppears = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.timeAppears)
        
        animationSettings.sections = [
            Section(id: "position y", rows: [.transitionCurve(viewModel: positionY)]),
            Section(id: "position x", rows: [.transitionCurve(viewModel: positionX)]),
//            Section(id: "bubble shape", rows: [.transitionCurve(viewModel: bubbleShape)]),
            Section(id: "color change", rows: [.transitionCurve(viewModel: colorChange)]),
            Section(id: "time appears", rows: [.transitionCurve(viewModel: timeAppears)]),
        ]
        
        return (animationSettings, {
            return TextMessageAnimationSettings(
                duration: animationSettings.animationDuration,
                positionY: positionY.toAnimationOptions(),
                positionX: positionX.toAnimationOptions(),
                bubbleShape: bubbleShape.toAnimationOptions(),
                colorChange: colorChange.toAnimationOptions(),
                timeAppears: timeAppears.toAnimationOptions()
            )
        })
    }
    
    static func from(_ settings: SingleEmojiAnimationSettings) -> (AnimationSettingsViewModel, () -> SingleEmojiAnimationSettings) {
        
        let animationSettings = AnimationSettingsViewModel(
            animationType: .singleEmoji,
            animationDuration: settings.duration
        )
        
        let duration: () -> Double = {
            return animationSettings.animationDuration.duration
        }
        
        let positionY = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionY)
        let positionX = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionX)
        
        animationSettings.sections = [
            Section(id: "position y", rows: [.transitionCurve(viewModel: positionY)]),
            Section(id: "position x", rows: [.transitionCurve(viewModel: positionX)]),
        ]
        
        return (animationSettings, {
            return SingleEmojiAnimationSettings(
                duration: animationSettings.animationDuration,
                positionY: positionY.toAnimationOptions(),
                positionX: positionX.toAnimationOptions(),
                emojiScale: positionX.toAnimationOptions(),
                timeAppears: positionX.toAnimationOptions()
            )
        })
    }
    
    static func from(_ settings: StickerAnimationSettings) -> (AnimationSettingsViewModel, () -> StickerAnimationSettings) {
        
        let animationSettings = AnimationSettingsViewModel(
            animationType: .sticker,
            animationDuration: settings.duration
        )
        
        let duration: () -> Double = {
            return animationSettings.animationDuration.duration
        }
        
        let positionY = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionY)
        let positionX = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionX)
        
        animationSettings.sections = [
            Section(id: "position y", rows: [.transitionCurve(viewModel: positionY)]),
            Section(id: "position x", rows: [.transitionCurve(viewModel: positionX)]),
        ]
        
        return (animationSettings, {
            return StickerAnimationSettings(
                duration: animationSettings.animationDuration,
                positionY: positionY.toAnimationOptions(),
                positionX: positionX.toAnimationOptions(),
                stickerScale: positionY.toAnimationOptions(),
                timeAppears: positionY.toAnimationOptions()
            )
        })
    }
    
    static func from(_ settings: VoiceMessageAnimationSettings) -> (AnimationSettingsViewModel, () -> VoiceMessageAnimationSettings) {
        
        let animationSettings = AnimationSettingsViewModel(
            animationType: .voiceMessage,
            animationDuration: settings.duration
        )
        
        let duration: () -> Double = {
            return animationSettings.animationDuration.duration
        }
        
        let positionY = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionY)
        let positionX = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionX)
        
        animationSettings.sections = [
            Section(id: "position y", rows: [.transitionCurve(viewModel: positionY)]),
            Section(id: "position x", rows: [.transitionCurve(viewModel: positionX)]),
        ]
        
        return (animationSettings, {
            return VoiceMessageAnimationSettings(
                duration: animationSettings.animationDuration,
                positionY: positionY.toAnimationOptions(),
                positionX: positionX.toAnimationOptions()
            )
        })
    }
    
    static func from(_ settings: VideoMessageAnimationSettings) -> (AnimationSettingsViewModel, () -> VideoMessageAnimationSettings) {
        
        let animationSettings = AnimationSettingsViewModel(
            animationType: .videoMessage,
            animationDuration: settings.duration
        )
        
        let duration: () -> Double = {
            return animationSettings.animationDuration.duration
        }
        
        let positionY = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionY)
        let positionX = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.positionX)
        let timeAppears = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.timeAppears)
        
        animationSettings.sections = [
            Section(id: "position y", rows: [.transitionCurve(viewModel: positionY)]),
            Section(id: "position x", rows: [.transitionCurve(viewModel: positionX)]),
            Section(id: "time appears", rows: [.transitionCurve(viewModel: timeAppears)]),
        ]
        
        return (animationSettings, {
            return VideoMessageAnimationSettings(
                duration: animationSettings.animationDuration,
                positionY: positionY.toAnimationOptions(),
                positionX: positionX.toAnimationOptions(),
                timeAppears: timeAppears.toAnimationOptions()
            )
        })
    }
    
    static func from(_ settings: BackgroundAnimationSettings, controller: AnimationSettingsController) -> (AnimationSettingsViewModel, () -> BackgroundAnimationSettings) {
        
        let animationSettings = AnimationSettingsViewModel(
            animationType: .background,
            animationDuration: settings.duration
        )
        
        let duration: () -> Double = {
            return animationSettings.animationDuration.duration
        }
        
        let position = AnimationCurveViewModel(duration: duration, curveAnimationOptions: settings.position)
        let colors = settings.colors.enumerated().map({ index, color in
            ColorViewModel(title: "Color \(index + 1)", color: color)
        })
        
        animationSettings.sections = [
            Section(id: "position", rows: [.transitionCurve(viewModel: position)]),
            Section(id: "background preview", rows: [.gradientPreview(viewModel: GradientViewModel(colors: colors)), .action(title: "Open Full Screen", action: {
                controller.presentGradientBackgroundPreview(
                    BackgroundAnimationSettings(
                        duration: animationSettings.animationDuration,
                        position: position.toAnimationOptions(),
                        colors: colors.map(\.color)
                    )
                )
            })]),
            Section(id: "colors", rows: colors.map { .color(viewModel: $0) } + [.action(title: "Randomize Colors", action: {
                colors.forEach {
                    $0.color = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0).hexString
                }
            })])
        ]
        
        return (animationSettings, {
            return BackgroundAnimationSettings(
                duration: animationSettings.animationDuration,
                position: position.toAnimationOptions(),
                colors: colors.map(\.color)
            )
        })
    }
}

enum Row {
    case selection(title: String, description: String, action: () -> Void)
    case action(title: String, action: () -> Void)
    case transitionCurve(viewModel: AnimationCurveViewModel)
    case gradientPreview(viewModel: GradientViewModel)
    case color(viewModel: ColorViewModel)
}

struct Section {
    let id: String
    let rows: [Row]
}

public class AnimationSettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static var selectedAnimationType: AnimationType = .textMessage
    
    var selectedAnimationType: AnimationType {
        get { Self.selectedAnimationType }
        set { Self.selectedAnimationType = newValue }
    }
    
    let animationSettingsProvider = AnimationSettingsProvider.shared
    
    private var applyTextMessageSettingsModel: (() -> Void)?
    private lazy var textMessageSettingsModel: AnimationSettingsViewModel = {
        
        let (settingsModel, applySettings) = AnimationSettingsViewModel.from(self.animationSettingsProvider.textMessageAnimationSettings)
        
        self.applyTextMessageSettingsModel = {
            self.animationSettingsProvider.textMessageAnimationSettings = applySettings()
        }
        
        return settingsModel
    }()
    
    private var applySingleEmojiSettingsModel: (() -> Void)?
    private lazy var singleEmojiSettingsModel: AnimationSettingsViewModel = {
        
        let (settingsModel, applySettings) = AnimationSettingsViewModel.from(self.animationSettingsProvider.singleEmojiAnimationSettings)
        
        self.applyTextMessageSettingsModel = {
            self.animationSettingsProvider.singleEmojiAnimationSettings = applySettings()
        }
        
        return settingsModel
    }()
    
    private var applyStickerSettingsModel: (() -> Void)?
    private lazy var stickerSettingsModel: AnimationSettingsViewModel = {
        
        let (settingsModel, applySettings) = AnimationSettingsViewModel.from(self.animationSettingsProvider.stickerAnimationSettings)
        
        self.applyTextMessageSettingsModel = {
            self.animationSettingsProvider.stickerAnimationSettings = applySettings()
        }
        
        return settingsModel
    }()
    
    private var applyVoiceMessageSettingsModel: (() -> Void)?
    private lazy var voiceMessageSettingsModel: AnimationSettingsViewModel = {
        
        let (settingsModel, applySettings) = AnimationSettingsViewModel.from(self.animationSettingsProvider.voiceMessageAnimationSettings)
        
        self.applyTextMessageSettingsModel = {
            self.animationSettingsProvider.voiceMessageAnimationSettings = applySettings()
        }
        
        return settingsModel
    }()
    
    private var applyVideoMessageSettingsModel: (() -> Void)?
    private lazy var videoMessageSettingsModel: AnimationSettingsViewModel = {
        
        let (settingsModel, applySettings) = AnimationSettingsViewModel.from(self.animationSettingsProvider.videoMessageAnimationSettings)
        
        self.applyTextMessageSettingsModel = {
            self.animationSettingsProvider.videoMessageAnimationSettings = applySettings()
        }
        
        return settingsModel
    }()
    
    private var applyBackgroundSettingsModel: (() -> Void)?
    private lazy var backgroundSettingsModel: AnimationSettingsViewModel = {
        
        let (settingsModel, applySettings) = AnimationSettingsViewModel.from(self.animationSettingsProvider.backgroundAnimationSettings, controller: self)
        
        self.applyTextMessageSettingsModel = {
            self.animationSettingsProvider.backgroundAnimationSettings = applySettings()
        }
        
        return settingsModel
    }()
    
    var selectedAnimationSettings: AnimationSettingsViewModel {
        switch self.selectedAnimationType {
        case .textMessage:
            return self.textMessageSettingsModel
        case .singleEmoji:
            return self.singleEmojiSettingsModel
        case .sticker:
            return self.stickerSettingsModel
        case .voiceMessage:
            return self.voiceMessageSettingsModel
        case .videoMessage:
            return self.videoMessageSettingsModel
        case .background:
            return self.backgroundSettingsModel
        }
    }
    
    var staticSections: [Section] {
        return [
            Section(
                id: "",
                rows: [
                    .selection(title: "Animation Type", description: self.selectedAnimationSettings.animationType.description, action: { [weak self] in
                        self?.presentAnimationTypePicker {
                            self?.selectedAnimationType = $0
                            UIView.performWithoutAnimation {
                                self?.tableView.reloadData()
                                self?.tableView.beginUpdates()
                                self?.tableView.endUpdates()
                                self?.tableView.setNeedsLayout()
                            }
                        }
                    }),
                    .selection(title: "Duration", description: self.selectedAnimationSettings.animationDuration.description, action: { [weak self] in
                        self?.presentAnimationDurationPicker {
                            self?.selectedAnimationSettings.animationDuration = $0
                            self?.tableView.reloadData()
                            self?.tableView.setNeedsLayout()
                        }
                    }),
                    .action(title: "Readme", action: {
                        let message = """
I'm glad to take part in this contest. Task's was interesting and the challenge that gave this contest was incredible.

Sadly, but I ran out of time and did not fix some issues and bugs. But I tried very hard and I hope you appreciate my efforts!
"""
                        let alertController = UIAlertController(title: "Hello!", message: message, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    })
                ]
            )
        ]
    }
    
    var sections: [Section] {
        return self.staticSections + self.selectedAnimationSettings.sections
    }
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Animation Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(applyButtonAction))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        self.tableView.register(SelectionTableViewCell.self, forCellReuseIdentifier: SelectionTableViewCell.reuseIdentifier)
        self.tableView.register(AnimationCurveTableViewCell.self, forCellReuseIdentifier: AnimationCurveTableViewCell.reuseIdentifier)
        self.tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: ColorTableViewCell.reuseIdentifier)
        self.tableView.register(GradientTableViewCell.self, forCellReuseIdentifier: GradientTableViewCell.reuseIdentifier)
        self.view.addSubview(self.tableView)
        
        self.subscribeForKeyboardNotifications()
    }
    
    func subscribeForKeyboardNotifications() {
        
        let keyboardNotifications = [
            UIViewController.keyboardWillHideNotification,
            UIViewController.keyboardWillShowNotification,
            UIViewController.keyboardWillChangeFrameNotification
        ]
        
        keyboardNotifications.forEach {
            NotificationCenter.default.addObserver(self, selector: #selector(updateTableView(withNotification:)), name: $0, object: nil)
        }
    }
    
    var tableViewContentInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )
    }
    
    @objc func updateTableView(withNotification notification: Notification?) {
        
        let keyboardFrame: (Notification) -> CGRect? = {
            return $0.name == UIViewController.keyboardWillHideNotification ? .zero : $0.userInfo
                .flatMap { $0[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue }
        }
        
        if let keyboardFrame = notification.flatMap(keyboardFrame) {
            self.tableView.frame.origin.y = -keyboardFrame.height
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
    func presentGradientBackgroundPreview(_ settings: BackgroundAnimationSettings) {
        let viewController = GradientBackgroundPreviewController()
        viewController.settings = settings
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentAnimationTypePicker(_ completion: @escaping (AnimationType) -> Void) {
        let animationTypesController = AnimationTypesController()
        animationTypesController.onSelectAnimationType = {
            completion($0)
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(animationTypesController, animated: true)
    }
    
    func presentAnimationDurationPicker(_ completion: @escaping (AnimationDuration) -> Void) {
        let alertController = UIAlertController(title: "Duration", message: nil, preferredStyle: .actionSheet)
        let actions = AnimationDuration.allCases.map { duration in
            UIAlertAction(title: duration.description, style: .default, handler: { action in
                completion(duration)
            })
        }
        actions.forEach(alertController.addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func applyButtonAction(_ sender: UIBarButtonItem) {
        
        self.applyTextMessageSettingsModel?()
        self.applySingleEmojiSettingsModel?()
        self.applyStickerSettingsModel?()
        self.applyVoiceMessageSettingsModel?()
        self.applyVideoMessageSettingsModel?()
        self.applyBackgroundSettingsModel?()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.sections[indexPath.section].rows[indexPath.row] {
        case .selection, .action, .color:
            return 52.0
        case .gradientPreview:
            return 200.0
        case .transitionCurve:
            return 250.0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.sections[indexPath.section].rows[indexPath.row] {
        case .selection(let title, let description, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.reuseIdentifier, for: indexPath) as! SelectionTableViewCell
            cell.titleLabel.text = title
            cell.descriptionLabel.text = description
            return cell
        case .transitionCurve(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: AnimationCurveTableViewCell.reuseIdentifier, for: indexPath) as! AnimationCurveTableViewCell
            cell.viewModel = viewModel
            cell.topSlider.slider.value = viewModel.topSlider
            cell.topSlider.updateLabelText()
            cell.bottomSlider.slider.value = viewModel.bottomSlider
            cell.bottomSlider.updateLabelText()
            cell.setNeedsLayout()
            cell.setNeedsDisplay()
            return cell
        case .color(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.reuseIdentifier, for: indexPath) as! ColorTableViewCell
            cell.viewModel = viewModel
            return cell
        case .gradientPreview(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: GradientTableViewCell.reuseIdentifier, for: indexPath) as! GradientTableViewCell
            cell.viewModel = viewModel
            return cell
        case .action(let title, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = title
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        switch self.sections[indexPath.section].rows[indexPath.row] {
        case .selection(_, _, let action):
            action()
        case .action(_, let action):
            action()
        default:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].id
    }
}

class AnimationTypesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var onSelectAnimationType: ((AnimationType) -> Void)?
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    struct Section {
        let title: String
        let rows: [AnimationType]
    }
    
    let sections: [Section] = [
        Section(
            title: "Messages",
            rows: [
                .textMessage,
                .singleEmoji,
                .sticker,
                .videoMessage,
                .voiceMessage
            ]
        ),
        Section(
            title: "Other",
            rows: [
                .background
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Animation Type"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        self.view.addSubview(self.tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.sections[indexPath.section].rows[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSelectAnimationType?(self.sections[indexPath.section].rows[indexPath.row])
    }
}

class GradientBackgroundPreviewController: UIViewController {
    
    let gradientBackgroundNode = GradientBackgroundNode()
    
    var settings: BackgroundAnimationSettings!
    
    var triggerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Preview"
        
        self.gradientBackgroundNode.animationDuration = self.settings.duration.duration
        self.gradientBackgroundNode.animationOptions = self.settings.position
        self.gradientBackgroundNode.colors = self.settings.colors
        
        self.triggerButton.setTitle("Animate", for: [])
        self.triggerButton.setTitleColor(UIColor.systemBlue, for: [])
        self.triggerButton.backgroundColor = .white
        self.triggerButton.addTarget(self, action: #selector(triggerButtonAction(_:)), for: .touchUpInside)
        
        self.view.addSubnode(self.gradientBackgroundNode)
        self.view.addSubview(self.triggerButton)
    }
    
    @objc func triggerButtonAction(_ sender: UIButton) {
        self.gradientBackgroundNode.animateGradientTransition()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientBackgroundNode.frame = self.view.bounds
        self.gradientBackgroundNode.frame.size.height -= 50.0
        self.gradientBackgroundNode.updateLayout(size: self.gradientBackgroundNode.frame.size, transition: .immediate)
        
        self.triggerButton.frame = CGRect(x: 0.0, y: self.view.frame.height - 50.0, width: self.view.frame.width, height: 50.0)
    }
}

public class AnimationQueue {
    
    let completion: () -> Void
    var members: Int = 0 {
        didSet {
            if self.members == 0 {
                self.completion()
            }
        }
    }
    
    public init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    public func enter() {
        self.members += 1
    }
    
    public func leave() {
        self.members -= 1
    }
    
    public func commit() {
        if self.members == 0 {
            self.completion()
        }
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension CGFloat {
    func convert(fromRange: ClosedRange<CGFloat>, toRange: ClosedRange<CGFloat>) -> CGFloat {
        return ((self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)) * (toRange.upperBound - toRange.lowerBound) + toRange.lowerBound
    }
}
