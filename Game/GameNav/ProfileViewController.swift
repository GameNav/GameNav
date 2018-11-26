//
//  ProfileViewController.swift
//  GameNav
//
//  Created by Premdeep Kaur on 2018-09-24.
//  Copyright © 2018 My Mac. All rights reserved.
//

import UIKit
import SQLite
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {


    // variables
    let USERID = 1;
    
    // outlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var camerabtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loading profile page")
        
        //makes the UI Image round
        imageview.layer.borderWidth = 1
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = UIColor.black.cgColor
        imageview.layer.cornerRadius = imageview.frame.height/2
        imageview.clipsToBounds = true
        
        // connect to db
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
        
        print("trying to save to file")
        
     //   let userProfiles = Table("userprofiles")
       // let colID = Expression<Int?>("id")
       // let colFirstName = Expression<String?>("firstname")
     //   let colLastName = Expression<String?>("lastname")
        
    //    let query = userProfiles.filter(colID == USERID)
        
        do {
            let result = try db!.prepare("SELECT * FROM userprofiles WHERE id=1")
            
            print("Num cols: \(result.columnCount)")
            
            for col in result {
                txtFirstName.text = "\(col[1]!)"           // col[1] = firstname col
                txtLastName.text = "\(col[2]!)"            // col[2] = lastname col
            }
            
            
            for (i, colName) in result.columnNames.enumerated() {
                if (colName == "firstname") {
                    //txtFirstName.text = result[i]
                }
            }
            
        }
        catch {
            print("error when insert")
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        print("Save button pressed")
        
        // get first and last name frum txtbox
        let first = txtFirstName.text!
        let last = txtLastName.text!
        
        if (first.isEmpty || last.isEmpty) {
            print("must fill in f or l name")
            
            txtFirstName.text = ""
            txtLastName.text = ""
            
            return
        }
        
        
        
        
        // connect to database
        // -------------------------
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
        
        print("trying to save to file")
        
        
        // sql query
        let query = "UPDATE userprofiles SET firstname = ?, lastname = ? WHERE id=\(USERID)"
        
        
        do {
            let stmt = try db!.prepare(query)
            
            // replace ? with variable
            let rowid = try stmt.run(first, last)

            print("update finished, row number = \(rowid)")
            
            // show popup when done save
            let alertController = UIAlertController(title: nil, message: "Profile updated!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        catch {
            print("error when update")
            print(error)
            
            // show popup if error come
            let alertController = UIAlertController(title: nil, message: "Error!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    //Camera functions-the user can select the photo from the camera or from the gallery as per the convinience of the user.
    @IBAction func selectimage(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        
        let selectSourceAlert = UIAlertController(title: "PhotoSource", message: "Choose a source", preferredStyle: .actionSheet)
        
        
        selectSourceAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        }))
        
        selectSourceAlert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }))
        
        selectSourceAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present (selectSourceAlert, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info [UIImagePickerControllerOriginalImage] as! UIImage
        
        imageview.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

