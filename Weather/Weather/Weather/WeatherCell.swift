//
//  WeatherCell.swift
//  Weather
//
//  Created by David Martinez on 18/08/2017.
//  Copyright © 2017 atenea. All rights reserved.
//

import UIKit
import Macaw

class WeatherCell: UITableViewCell {
    
    fileprivate let animationDuration: TimeInterval = 0.2
    fileprivate let animationCurve = UIViewAnimationCurve.easeInOut
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconView: SVGView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sentenceLabel: UILabel!
    
    func show (weather: Weather.ViewModel.WeatherHourItem) {
        
        configure(weather: weather)
        
        hourLabel.text = weather.hour
        iconView.fileName = weather.iconName
        statusLabel.text = weather.status
        temperatureLabel.text = weather.temperature
        sentenceLabel.text = weather.sentence
    }
    
    private func configure(weather: Weather.ViewModel.WeatherHourItem) {
        
        if weather.isFirst {
            hourLabel.textColor = UIColor.white
        } else {
            hourLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetViewTransformations()
        
        hourLabel.text = nil
//        iconView.fileName = nil
        statusLabel.text = nil
        temperatureLabel.text = nil
        sentenceLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        temperatureLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        sentenceLabel.textColor = UIColor.white.withAlphaComponent(0.5)
    }
}

protocol OnScroll {
    func onScrollTo(offset: CGPoint, intoDisplay frame: CGRect, inset: UIEdgeInsets)
    func willDisplay(offset: CGPoint, intoDisplay frame: CGRect, inset: UIEdgeInsets)
}

extension WeatherCell: OnScroll {
    
    func onScrollTo(offset: CGPoint, intoDisplay frame: CGRect, inset: UIEdgeInsets) {
        
        let y = offset.y
        let h = frame.height
        let cellY = self.frame.origin.y
        let cellH = self.frame.height
        
        if y + inset.top >= cellY {
            // up cell
            let percentVisible = 1.0 - ((y + inset.top - cellY) / cellH)
            contentView.alpha = percentVisible
            iconView.transform = CGAffineTransform(scaleX: percentVisible, y: percentVisible)
            
            animateStatusBarFor(cellVisibility: percentVisible)
            animateTemperatureFor(cellVisibility: percentVisible)
            animateMessageFor(cellVisibility: percentVisible)
            animateHourFor(cellVisibility: percentVisible)
            
        } else if cellY > y + h - cellH {
            // down cell
            let percentVisible = (y + h - cellY) / cellH
            contentView.alpha = percentVisible
            iconView.transform = CGAffineTransform(scaleX: percentVisible, y: percentVisible)
            
        } else {
            resetViewTransformations()
        }
    }
    
    func willDisplay(offset: CGPoint, intoDisplay frame: CGRect, inset: UIEdgeInsets) {
        
        let cellY = self.frame.origin.y
        
        let cellWillAppearFromAbove = cellY + inset.top < offset.y
        
        if cellWillAppearFromAbove {
            
            hourLabel.alpha = 0.0
            statusLabel.alpha = 0.0
            temperatureLabel.alpha = 0.0
            sentenceLabel.alpha = 0.0
            
            hourLabel.transform = CGAffineTransform(translationX: -1 * self.frame.width, y: 0.0)
            statusLabel.transform = CGAffineTransform(translationX: self.frame.width, y: 0.0)
            temperatureLabel.transform = CGAffineTransform(translationX: self.frame.width, y: 0.0)
            sentenceLabel.transform = CGAffineTransform(translationX: self.frame.width, y: 0.0)
            
        } else {
            
            hourLabel.alpha = 1.0
            statusLabel.alpha = 1.0
            temperatureLabel.alpha = 1.0
            sentenceLabel.alpha = 1.0
            
            hourLabel.transform = CGAffineTransform.identity
            statusLabel.transform = CGAffineTransform.identity
            temperatureLabel.transform = CGAffineTransform.identity
            sentenceLabel.transform = CGAffineTransform.identity
            
        }
    }
}

extension WeatherCell {
    
    enum Direction {
        case toLeft
        case toRight
    }
    
    fileprivate func resetViewTransformations() {
        iconView.transform = CGAffineTransform.identity
        
        hourLabel.transform = CGAffineTransform.identity
        statusLabel.transform = CGAffineTransform.identity
        temperatureLabel.transform = CGAffineTransform.identity
        sentenceLabel.transform = CGAffineTransform.identity
        
        contentView.alpha = 1.0
        hourLabel.alpha = 1.0
        statusLabel.alpha = 1.0
        temperatureLabel.alpha = 1.0
        sentenceLabel.alpha = 1.0
    }
    
    fileprivate func animateHourFor(cellVisibility percent: CGFloat) {
        animate(hourLabel, cellVisibility: percent, visibilityLimit: 0.7, direction: .toLeft)
    }
    
    fileprivate func animateStatusBarFor(cellVisibility percent: CGFloat) {
        animate(statusLabel, cellVisibility: percent, visibilityLimit: 0.7)
    }
    
    fileprivate func animateTemperatureFor(cellVisibility percent: CGFloat) {
        animate(temperatureLabel, cellVisibility: percent, visibilityLimit: 0.55)
    }
    
    fileprivate func animateMessageFor(cellVisibility percent: CGFloat) {
        animate(sentenceLabel, cellVisibility: percent, visibilityLimit: 0.35)
    }
    
    private func animate(_ view: UIView, cellVisibility percent: CGFloat, visibilityLimit threshold: CGFloat, direction: Direction = .toRight) {
        let mustAppear = percent > threshold
        
        if mustAppear {
            applyFlyInAnimation(of: view, direction: direction)
        } else {
            applyFlyOutAnimation(of: view, direction: direction)
        }
    }
    
    private func applyFlyOutAnimation(of view: UIView, direction: Direction = .toRight) {
        
        guard view.state == .inScreen else { return }
        view.state = .outsideScreen
        view.animation?.stopAnimation(false)
        view.animation?.finishAnimation(at: UIViewAnimatingPosition.end)
        view.animation = UIViewPropertyAnimator(duration: animationDuration, curve: animationCurve, animations: nil)
        
        view.animation?.addAnimations { [unowned self] in
            view.alpha = 0.0
            let translationX = (direction == .toRight) ? self.frame.width : -1 * self.frame.width;
            view.transform = CGAffineTransform(translationX: translationX, y: 0.0)
        }
        
        view.animation?.startAnimation()
    }
    
    private func applyFlyInAnimation(of view: UIView, direction: Direction = .toRight) {
        
        guard view.state == .outsideScreen else { return }
        view.state = .inScreen
        view.animation?.stopAnimation(false)
        view.animation?.finishAnimation(at: UIViewAnimatingPosition.end)
        
        view.animation = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 0.8) {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }
        
        view.animation?.startAnimation()
    }
}

private var associatedStateHandle: UInt8 = 0
private var associatedAnimationHandle: UInt8 = 1

fileprivate extension UIView {
    
    enum AnimationState {
        case inScreen
        case outsideScreen
    }
    
    fileprivate var state: AnimationState {
        get {
            let value = objc_getAssociatedObject(self, &associatedStateHandle) as? AnimationState
            return value ?? .inScreen
        }
        
        set {
            objc_setAssociatedObject(self, &associatedStateHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var animation: UIViewPropertyAnimator? {
        get {
            return objc_getAssociatedObject(self, &associatedAnimationHandle) as? UIViewPropertyAnimator
        }
        
        set {
            objc_setAssociatedObject(self, &associatedAnimationHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
