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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        guard let availableURL = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text, let url = URL(string: availableURL) , UIApplication.shared.canOpenURL(url) == true else{
            
            self.createAlertMessage(title: "Invalid URL", message: "Unable to open provided link.")
            return
        }
    }

}
