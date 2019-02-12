//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import DropDown

//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnterNewCityName (city: String)
    
}


class ChangeCityViewController: UIViewController, UITextFieldDelegate {
    
    var nameCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropDown()
        changeCityTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        cityNameMenu.dataSource = []
        nameCount = 0
        let path = Bundle.main.path(forResource: "current.city.list", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            for city in json as! [Dictionary<String,AnyObject>] {
                let name = city["name"]
                //dropDownMenu?.optionArray.sort()
                if (name?.hasPrefix(changeCityTextField.text ?? "A"))! && nameCount <= 6 {
                    
                    nameCount += 1
                    cityNameMenu.dataSource.append(name as! String)
                    
                }
            }
        }
        catch {
            print(error)
        }
        cityNameMenu.show()
    }

    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    let cityNameMenu = DropDown()
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    
    func setUpDropDown() {
        cityNameMenu.anchorView = changeCityTextField
        cityNameMenu.bottomOffset = CGPoint(x: 0, y: changeCityTextField.bounds.height)
        cityNameMenu.selectionAction = {[weak self] (index, item) in
            self?.changeCityTextField.text = "\(item)"
        }
    }
    
    func updateDropDownMenu() {

        let path = Bundle.main.path(forResource: "current.city.list", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
    
            for city in json as! [Dictionary<String,AnyObject>] {
                let name = city["name"]
                
                
                //dropDownMenu?.optionArray.sort()
                if name!.contains(changeCityTextField.text ?? "Something is wrong") {
                    
                }
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
