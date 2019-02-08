//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import iOSDropDown


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnterNewCityName (city: String)
    
}


class ChangeCityViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDropDownMenu()
    }
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:

    @IBOutlet weak var changeCityTextField: DropDown!
    
    func updateDropDownMenu() {
        let dropDownMenu = changeCityTextField
        let path = Bundle.main.path(forResource: "current.city.list", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            for city in json as! [Dictionary<String,AnyObject>] {
                let name = city["name"]
                print(name)
                dropDownMenu?.optionArray.append(name as! String)
                //dropDownMenu?.optionArray.sort()
                //if name!.contains(changeCityTextField.text ?? "Something is wrong") {
                //}
            }
        }
        catch {
            print(error)
        }
    }
    
    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnterNewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
