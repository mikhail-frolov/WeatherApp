// Name: Mikhail Frolov 
// ID: 164788184

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Outlets
    @IBOutlet weak var txtCity : UITextField!
    @IBOutlet weak var lblWeatherIno : UILabel!
    @IBOutlet weak var btnGetWeather: UIButton!
    
    // Link API
    let urlLink = "https://api.weatherapi.com/v1/current.json?key=c5812941b8114ff8b5e140343211004"
    
    let cityList = ["Moscow", "Toronto", "Berlin", "Beijing", "London", "Rome", "Tokyo", "Singapore"]
    var outputLabel = ""
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtCity.inputView = pickerView
        lblWeatherIno.isHidden = true
        
        btnGetWeather.layer.cornerRadius = 10
        
    }

    private func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else {
                print("Error")
                return
            }
            
            //have data
            var result: TheWeather?
            do {
                result = try JSONDecoder().decode(TheWeather.self, from: data)
            }
            catch {
                print("Json failed to convert: \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            self.outputLabel = "Current weather in: " + json.location.name + "\nTemperature in C: " + String(format: "%.1f", json.current.temp_c) + "°C\nFeels Like: " + String(format: "%.1f", json.current.feelslike_c) + "°C\nTemperature in F: " + String(format: "%.1f", json.current.temp_f) + "°F\nFeels Like: " + String(format: "%.1f", json.current.feelslike_f) + "°F\nWind Direction: " + json.current.wind_dir + "\nWind Speed: " + String(format: "%.1f", json.current.wind_kph) + "km/h\nUltraviolet Index: " + String(format: "%.1f", json.current.uv) + "nm\n" + "Humidity: " + String(json.current.humidity) + "%"
            
            DispatchQueue.main.async {
                self.lblWeatherIno.text = self.outputLabel
                
            }
        })
        task.resume()
    }
    
    // Clicked Button
    @IBAction func onButtonCicked(_sender: UIButton){
    if (txtCity.text != "")
    {
        lblWeatherIno.isHidden = false
        let fullUrl = urlLink + "&q=" + txtCity.text! + "&aqi=no"
        getData(from: fullUrl)
    }
    }
    
    // Configuring Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCity.text = cityList[row]
        txtCity.resignFirstResponder()
    }
}

// Codable Data
struct Location: Codable {
    public let name: String!
    public let country: String!
}
struct Current: Codable {
    public let temp_c: Double!
    public let feelslike_c: Double!
    public let temp_f: Double!
    public let feelslike_f: Double!
    public let wind_kph: Double!
    public let wind_dir: String!
    public let uv: Double!
    public let humidity: Int!
}

struct TheWeather: Codable {
    public let location: Location
    public let current: Current
}

