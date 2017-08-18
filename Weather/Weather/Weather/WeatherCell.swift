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
        
        hourLabel.text = nil
        iconView.fileName = nil
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
