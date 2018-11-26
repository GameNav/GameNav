//
//  ViewController.swift
//  GameNav
//
//  Created by Premdeep Kaur on 2018-09-20.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit
import SQLite
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let keyword = textFeild.text!
        
        // 2. build a search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = keyword
        
        // 2b) Tell IOS where on the map to search
        
        // my coordinates are for mountain view, california
        let coord = CLLocationCoordinate2DMake(43.7732907, -79.3380697)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(coord, span)
        mapView.setRegion(region, animated: true)
        
        //mapView.setRegion(regionA, animated: true)
        searchRequest.region = region
        
        // 3. send your search request to Apple
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            //print(response!.boundingRegion)
            
            print("-----------------------")
            
            let places = response!.mapItems
            for x in places {
                
                let name = x.name!
//                let phone = x.phoneNumber
                let lat = x.placemark.coordinate.latitude
                let long = x.placemark.coordinate.longitude
                
                //print(String(describing: name))
                print(name)
                print("Coordinates: \(lat) , \(long)")
                
                // add pins to your map
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2DMake(lat, long)
                pin.title = name
                self.mapView.addAnnotation(pin)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //___________________________________________________________________Creating DB when clicked ___________________________________________________
    @IBAction func createDBPressed(_ sender: Any) {
        // run code to create db the first tym
        
        var db: OpaquePointer?
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("GameAppDB.sqlite")
        print("Database path: ")
        print(fileURL)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("database created")
        }
    }
}

//___________________________________________________________________UI STUFFS______________________________________________________________________

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
