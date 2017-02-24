//
//  StudentInfoModel.swift
//  OntheMap
//
//  Created by Rakesh on 2/24/17.
//  Copyright © 2017 Rakesh Kumar. All rights reserved.
//

import Foundation

struct StudentInfoModel{
    
    static var students = [StudentInformation]()
    
    static func getStudentList(fromStudents newStudents:[[String:AnyObject]]){
        
        students.removeAll()
        for student in newStudents{
            let newStudent = StudentInformation(studentDict: student)
            self.students.append(newStudent)
        }
    }
}
