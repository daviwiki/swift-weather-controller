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
    
    fileprivate let animationDuration: TimeInterval = 0.25
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
}

extension WeatherCell: OnScroll {
    
    func onScrollTo(offset: CGPoint, intoDisplay frame: CGRect, inset: UIEdgeInsets) {
        
        let y = offset.y
        let h = frame.height
        let cellY = self.frame.origin.y
        let cellH = self.frame.height
        
        if y + inset.top > cellY {
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
            
            contentView.alpha = 1.0
            statusLabel.transform = CGAffineTransform.identity
            iconView.transform = CGAffineTransform.identity
        }
    }
}

extension WeatherCell {
    
    enum Direction {
        case toLeft
        case toRight
    }
    
    fileprivate func resetViewTransformations() {
        layer.removeAllAnimations()
        hourLabel.transform = CGAffineTransform.identity
        statusLabel.transform = CGAffineTransform.identity
        temperatureLabel.transform = CGAffineTransform.identity
        sentenceLabel.transform = CGAffineTransform.identity
        
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
            applyFlyInAnimation(of: view)
        } else {
            applyFlyOutAnimation(of: view, direction: direction)
        }
    }
    
    private func applyFlyOutAnimation(of view: UIView, direction: Direction = .toRight) {
        
        guard view.transform == CGAffineTransform.identity else { return }
        
        let animation = UIViewPropertyAnimator(duration: animationDuration, curve: animationCurve, animations: { [unowned self] in
            view.alpha = 0.0
            let translationX = (direction == .toRight) ? self.frame.width : -1 * self.frame.width;
            view.transform = CGAffineTransform(translationX: translationX, y: 0.0)
        })
        
        animation.startAnimation()
    }
    
    private func applyFlyInAnimation(of view: UIView) {
        
        guard view.transform != CGAffineTransform.identity else { return }
        
        let animation = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 0.8) {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }
                
        animation.startAnimation()
    }
    
    private func straightSlope(a: CGPoint, b: CGPoint) -> CGFloat {
        return (b.y - a.y) / (b.x - a.x)
    }
}
