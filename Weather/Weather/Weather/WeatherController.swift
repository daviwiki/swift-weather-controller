
import UIKit

protocol WeatherControllerInput: AnyObject {
    func showError(message: String)
    func showWeather(weather: Weather.ViewModel)
}

protocol WeatherControllerOutput: AnyObject {
    func loadWeather(request: Weather.Request)
}

class WeatherController: UIViewController, WeatherControllerInput {
    
    var output: WeatherControllerOutput!
    
    @IBOutlet private weak var mainIconView: UIImageView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherStatusLabel: UILabel!
    @IBOutlet private weak var conditionsLabel: UILabel!
    @IBOutlet private weak var hoursTableView: UITableView!
    @IBOutlet private weak var tempBubbleView: UIView!
    
    private var gradientLayer: CAGradientLayer?
    private var weather: Weather.ViewModel?
    
    @IBOutlet weak var tableViewToTopOfConstraint: NSLayoutConstraint!
    private var tableViewTopInset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainIconView.tintColor = .white
        tempBubbleView.layer.cornerRadius = tempBubbleView.frame.size.width / 2.0
        tempBubbleView.clipsToBounds = true
        
        hoursTableView.estimatedRowHeight = 92
        hoursTableView.rowHeight = UITableView.automaticDimension
        
        tableViewTopInset = abs(tableViewToTopOfConstraint.constant)
        hoursTableView.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0.0, bottom: 0.0, right: 0.0)
        
        let request = Weather.Request()
        output.loadWeather(request: request)
    }
    
    func showWeather(weather: Weather.ViewModel) {
        self.weather = weather
        configureDesign(weather: weather)
        hoursTableView.reloadData()
    }
    
    func showError(message: String) {
        // todo:
    }
}

extension WeatherController {
    
    fileprivate func configureDesign(weather: Weather.ViewModel) {
        
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = view.bounds
            gradientLayer?.startPoint = CGPoint(x: 0.6, y: 0.0)
            gradientLayer?.endPoint = CGPoint(x: 0.4, y: 1.0)
            view.layer.insertSublayer(gradientLayer!, at: 0)
        }
        
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        weatherStatusLabel.textColor = UIColor.white
        conditionsLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        
        if weather.mode == .light {
            light()
        } else {
            dark()
        }
    }
    
    private func dark() {
        
        // Main icon
        mainIconView.image = UIImage(systemName: Constants.WeatherIcons.Moon.stars)
        
        // Gradient
        let startColor = Constants.ColorNames.nightBgGradient.color
        let midColor = Constants.ColorNames.midBgGradient.color
        let endColor = Constants.ColorNames.sunnyBgGradient.color
        
        gradientLayer?.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer?.locations = [0.0, 0.45, 0.75]
        
        // Titles
        locationLabel.textColor = startColor.darkened()
    }
    
    private func light() {
        
        // Main icon
        mainIconView.image = UIImage(systemName: Constants.WeatherIcons.Sunny.clear)
        
        // Gradient
        let startColor = Constants.ColorNames.sunnyBgGradient.color
        let midColor = Constants.ColorNames.midBgGradient.color
        let endColor = Constants.ColorNames.nightBgGradient.color
        
        gradientLayer?.colors = [startColor.cgColor, startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer?.locations = [0.0, 0.3, 0.75, 0.9]
        
        // Titles
        locationLabel.textColor = startColor.darkened()
        
    }
}

extension WeatherController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? OnScroll else { return }
        cell.willDisplay(offset: tableView.contentOffset, intoDisplay: tableView.frame, inset: tableView.contentInset)
    }
    
}

extension WeatherController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weathercell", for: indexPath)
        if let cell = cell as? WeatherCell, let hour = weather?.items[indexPath.row] {
            cell.show(weather: hour)
        }
        return cell
    }
}

extension WeatherController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        applyScrollTransform(at: scrollView.contentOffset)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        applyScrollTransform(at: scrollView.contentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        applyScrollTransform(at: scrollView.contentOffset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        applyScrollTransform(at: targetContentOffset.pointee)
    }
    
    private func applyScrollTransform(at offset: CGPoint) {
        hoursTableView
            .visibleCells
            .compactMap({ $0 as? OnScroll })
            .forEach { cell in
                cell.onScrollTo(offset: offset, intoDisplay: hoursTableView.frame, inset: hoursTableView.contentInset)
            }
    }
}
