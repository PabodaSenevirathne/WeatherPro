//
//  ViewController.swift
//  WeatherPro
//
//  Created by user234693 on 11/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var humidityLevelLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherAPI()
    }
    
    
    func getWeatherAPI(){
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Waterloo,CA&appid=b822db056acf7f212fae8acc4a13a245") else {
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            //print(data!)
            //if let data = data, let string = String(data: data, encoding: .utf8){
            //    print(string)
            // }
            
            if let data = data {
                let jsonDecorder = JSONDecoder()
                
                do{
                    let jsonData = try jsonDecorder.decode(Weather.self, from: data)
                    print(jsonData.name)
                    print(jsonData.coord)
                    DispatchQueue.main.async {
                        self.updateWeatherData(with: jsonData)
                    }
                } catch{
                    
                    print ("SOME ERROR")
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    func updateWeatherData(with weatherData: Weather) {
        cityName.text = "\(weatherData.name)"
        weatherDescription.text = "\(weatherData.weather.first?.description ?? "")"
        temperatureLabel.text = "\(Int(weatherData.main.temp - 273.15))°C" // Convert Kelvin to Celsius
        humidityLevelLabel.text = "\(Int(weatherData.main.humidity))%"
        windSpeedLabel.text = "\(weatherData.wind.speed) m/s"
        
        // Assuming OpenWeatherMap provides icon names like "01d", "02d", etc.
        if let iconName = weatherData.weather.first?.icon {
            print("Icon Name: \(iconName)")
            weatherIcon.image = UIImage(named: iconName)
        }
        
        
        
        
        
    }
}
