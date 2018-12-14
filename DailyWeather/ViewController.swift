//
//  ViewController.swift
//  DailyWeather
//
//  Created by Nicholas Whitfield on 10/18/18.
//  Copyright © 2018 RandomFacts. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var dailyData = [WeatherData]()
    var coordinates: String?
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var weeklySummary: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = #imageLiteral(resourceName: "forest_hill_fog_111466_1920x1080")
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        getJSON()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //updates the user's location as the user moves
        let location: CLLocation = locations[0] as CLLocation
        coordinates = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        print(coordinates!)
    }
    
    fileprivate func getJSON() {
        let apiKey: String = "f76846fdd5f8eec08477e5b99482e92c"
        let jsonURLString = "https://api.darksky.net/forecast/\(apiKey)/32.39073316569662,-90.39809631192162"
        guard let url = URL(string: jsonURLString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dailyWeather = try decoder.decode(DailyWeather.self, from: data)
                self.dailyData = dailyWeather.data
//                encoder.outputFormatting = .prettyPrinted
//                let encodedResults = try encoder.encode(dailyWeather)
//                print(encodedResults.stringDescription)
                DispatchQueue.main.async {
                    self.weeklySummary.numberOfLines = 0
                    self.weeklySummary.text = dailyWeather.summary
                    self.weeklySummary.textColor = .white
                    self.icon.image = UIImage(named: dailyWeather.icon)
                    self.TableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        
        let date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let weekDay = formatter.string(from: date!)
        
        let forcecastData = dailyData[indexPath.row]
        cell.weekdayLabel.text = weekDay
        cell.dailyIcon.image = UIImage(named: forcecastData.icon)
        cell.tempHighLabel.text = "\(Int(forcecastData.temperatureHigh))°F"
        cell.tempLowLabel.text = "\(Int(forcecastData.temperatureLow))°F"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
}

