//
//  ViewController.swift
//  WeatherPro
//
//  Created by user234693 on 11/11/23.
//

import UIKit

class ViewController: UIViewController {

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
                } catch{
                    
                    print ("SOME ERROR")
                }
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    

}

