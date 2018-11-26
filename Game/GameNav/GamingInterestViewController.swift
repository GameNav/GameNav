//
//  GamingInterestViewController.swift
//  GameNav
//
//  Created by Premdeep Kaur on 2018-10-03.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit
import SQLite
class GamingInterestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlet for picker
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var gamename: UILabel!
    //global variable for picker data
    let game = ["PS4","PS3","OS-Windows","OS-Mac","X-Box"]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return game[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return game.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gamename.text = game[row]
    }

    // USER ID!
    let USERID = 1;
    
    
    // variables
    var arcade = false;
    var fps = false;
    var action = false;
    var mystery = false;
    var adventure = false;
    var rpg = false;
    var puzzles = false;
    var horror = false;
    var strategy = false;
    var simulation = false;

    
    //Outlet for switch
    @IBOutlet var arcadeSwitch: [UISwitch]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load interests from database
        //------------------------------
        
        // connect to database
        var db:Connection?
        
        let databaseFileName = "GameAppDB.sqlite"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
        print("Path to database: \(databaseFilePath)")
        
        do {
            db = try Connection(databaseFilePath)
            print("done connecting to db")
        }
        catch {
            print("database conneciton error: ")
            print(error)
        }
        
        print("get user from database")
        
        do {
            
            let interestTable = Table("interests")
           // let colUserID = Expression<Int?>("userid")
            let colArcade = Expression<Bool?>("arcade")
            let colFPS = Expression<Bool?>("fps")
            let colAction = Expression<Bool?>("action")
            let colMystery = Expression<Bool?>("mystery")
            let colAdventure = Expression<Bool?>("adventure")
            let colRPG = Expression<Bool?>("rpg")
            let colPuzzles = Expression<Bool?>("puzzles")
            let colHorror = Expression<Bool?>("horror")
            let colStrategy = Expression<Bool?>("strategy")
            let colSimulation = Expression<Bool?>("simulation")
            
            
            // get user from database
            if let item = try db!.pluck(interestTable) {
                print("+++++++= GETTING USER FROM DB! ++++++")
                print("Updating switches")
                arcadeSwitch[0].isOn = item[colArcade]!
                arcadeSwitch[1].isOn = item[colFPS]!
                arcadeSwitch[2].isOn = item[colAction]!
                arcadeSwitch[3].isOn = item[colMystery]!
                arcadeSwitch[4].isOn = item[colAdventure]!
                arcadeSwitch[5].isOn = item[colRPG]!
                arcadeSwitch[6].isOn = item[colPuzzles]!
                arcadeSwitch[7].isOn = item[colHorror]!
                arcadeSwitch[8].isOn = item[colStrategy]!
                arcadeSwitch[9].isOn = item[colSimulation]!
                print("+++++++= ============= ++++++")
                
            }
        }
        catch {
            print("error when update")
            print(error)
        }
    }
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        arcade = arcadeSwitch[0].isOn
        fps = arcadeSwitch[1].isOn
        action = arcadeSwitch[2].isOn
        mystery = arcadeSwitch[3].isOn
        adventure = arcadeSwitch[4].isOn
        rpg = arcadeSwitch[5].isOn
        puzzles = arcadeSwitch[6].isOn
        horror = arcadeSwitch[7].isOn
        strategy = arcadeSwitch[8].isOn
        simulation = arcadeSwitch[9].isOn
        
        

        // connect to database
        var db:Connection?
        
        let databaseFileName = "GameAppDB.sqlite"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
        print("Path to database: \(databaseFilePath)")
        
        do {
            db = try Connection(databaseFilePath)
            print("done connecting to db")
        }
        catch {
            print("database conneciton error: ")
            print(error)
        }
        
        print("trying to save to db")
        
        let query = "UPDATE interests SET arcade = ?, fps = ?, action =?, mystery = ?, adventure = ?, rpg = ?, puzzles = ?, horror = ?, strategy = ?, simulation = ? WHERE id=\(USERID)"
        
        
        do {
            let stmt = try db!.prepare(query)
            let rowid = try stmt.run(arcade, fps, action, mystery, adventure, rpg, puzzles, horror, strategy, simulation)
            //let rowid = try db!.run(query)
            print("update finished, row number = \(rowid)")
        }
        catch {
            print("error when update")
            print(error)
        }
        
    }
    

}
