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
                    
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            
        }
        
        task.resume()
    
    }
    
    func updateWeatherData(with weatherData: Weather) {
        cityName.text = "\(weatherData.name)"
        //weatherDescription.text = "\(weatherData.weather.first?.description ?? "")"
        if let description = weatherData.weather.first?.description {
               // Capitalize the first letter of the weather description
               let FormattedDescription = description.prefix(1).capitalized + description.dropFirst()
            weatherDescription.text = "\(FormattedDescription)"
           } else {
               weatherDescription.text = "N/A"
           }
        
        // Convert Kelvin to Celsius
        temperatureLabel.text = "\(Int(weatherData.main.temp - 273.15))°"
        humidityLevelLabel.text = "\(Int(weatherData.main.humidity))%"
        windSpeedLabel.text = "\(weatherData.wind.speed) m/s"
        
        // Load image
               if let iconName = weatherData.weather.first?.icon {
                   loadImageURL(iconName)
               }
    }
    
    // Load image from the URL
    func loadImageURL(_ iconName: String) {
        let imageUrl = URL(string: "https://openweathermap.org/img/w/\(iconName).png")
        
        if let imageUrl = imageUrl {
            let task = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherIcon.image = image
                    }
                }
            }
            task.resume()
        }
    }
}

