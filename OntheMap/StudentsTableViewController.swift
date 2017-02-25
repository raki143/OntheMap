//
//  StudentsTableViewController.swift
//  OntheMap
//
//  Created by Rakesh Kumar on 24/02/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController{

    
    let reuseIdentifier = "studentcell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func getStudentLocations(){
        
        UdacityUserAPI.sharedInstance().getStudentLocations()
        
    }
    
    @IBAction func logout(){
        UdacityUserAPI.sharedInstance().logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postUserInformation(){
        print("post user Info")
    }
    
    @IBAction func refreshStudentDetails(){
        getStudentLocations()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentInfoModel.students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let studentCell = StudentInfoModel.students[indexPath.row]
        cell.textLabel?.text = "\(studentCell.firstName) \(studentCell.lastName)"
        cell.detailTextLabel?.text = "\(studentCell.mediaURL)"
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let availableURL = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text, let url = URL(string: availableURL) , UIApplication.shared.openURL(url) == true else{
            
            self.createAlertMessage(title: "Invalid URL", message: "Unable to open provided link.")
            return
        }
    }

}
