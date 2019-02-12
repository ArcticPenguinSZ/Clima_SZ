//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import DropDown //using DropDown Cocoapod

//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnterNewCityName (city: String)
}

//We use the UITextFieldDelegate protocol to use cool functions like textFieldDidBeginEditing
class ChangeCityViewController: UIViewController, UITextFieldDelegate {
    
    var nameCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropDown()
        changeCityTextField.delegate = self
    }
    
    @IBOutlet weak var changeCityTextField: UITextField!
    let cityNameMenu = DropDown()
    
    func setUpDropDown() {
        //Setting the position of the drop down menu
        cityNameMenu.anchorView = changeCityTextField
        cityNameMenu.bottomOffset = CGPoint(x: 0, y: changeCityTextField.bounds.height)
        //Make the changeCityTextField show what users have selected from the drop down menu
        cityNameMenu.selectionAction = {[weak self] (index, item) in
            self?.changeCityTextField.text = "\(item)"
        }
    }
    
    //Once users begin editing, we want to keep track of each letter they have written, so we add a new target / action method to decide if the text field has changed.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //We want to search the JSON list of city names for those that start with the letters that users have typed
    @objc func textFieldDidChange(_ textField: UITextField) {
        //cityNameMenu.dataSource is the list of names that will be displayed in the drop-down menu
        cityNameMenu.dataSource = []
        nameCount = 0
        let path = Bundle.main.path(forResource: "current.city.list", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        //Use do and catch to handle error
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            for city in json as! [ Dictionary < String , AnyObject > ] {
                let name = city["name"]
                if (name?.hasPrefix(changeCityTextField.text ?? "A"))! && nameCount <= 6 {
                    nameCount += 1
                    cityNameMenu.dataSource.append(name as! String)
                    cityNameMenu.dataSource.sort()
                }
            }
        }
        catch {
            print(error)
        }
        cityNameMenu.show()
    }

    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    
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
