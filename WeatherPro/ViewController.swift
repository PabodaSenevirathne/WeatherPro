//
//  ViewController.swift
//  WeatherPro
//
//  Created by user234693 on 11/11/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var humidityLevelLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    // Create a CLLocationManager instance
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request permission to use location services
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Start updating location
        locationManager.startUpdatingLocation()
        // getWeatherAPI()
    }
    
    // Get new location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
          return
    }
            
        // Stop updating location
        // locationManager.stopUpdatingLocation()
            
        // get weather data based on the current location
        getWeatherAPI(for: location.coordinate)
        
        }
    
    // get error message if there is an error obtaining location data
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
        print("Error getting location: \(error.localizedDescription)")
        
    }
    
    // get weather data
    func getWeatherAPI(for coordinates: CLLocationCoordinate2D){
                
        let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=b822db056acf7f212fae8acc4a13a245")
        
        guard let url = apiUrl else {
            print("Invalid URL")
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
    
    // update weather data in the UI
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

