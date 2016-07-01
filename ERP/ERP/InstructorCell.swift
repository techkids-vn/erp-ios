//
//  InstructorCell.swift
//  ERP
//
//  Created by Mr.Vu on 6/14/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import RxSwift

class InstructorCell: UICollectionViewCell {

    @IBOutlet weak var numberCheck: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var attandanceView: UIView!
    
    var teachingRecordsVar : Variable<Int> = Variable(0)
    var instructor : Instructor? {
        didSet {
            self.layout()
        }
    }
    
    func layout() {
        self.lblName.text = "\(instructor!.name)"
        self.lblCode.text = "\(instructor!.code)"
        
        LazyImage.showForImageView(self.imvAvatar, url: instructor?.imgUrl)
        NetworkContext.fetchAllTeachingRecords( {
            teachingRecords in
            var currentTime = ""
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            let year = components.year
            let month = components.month
            let day = components.day
            if month >= 10 {
                if day >= 10{
                    currentTime = "\(year)-\(month)-\(day)"
                }
                else {
                    currentTime = "\(year)-\(month)-0\(day)"
                }
                
            }
            else {
                if day >= 10{
                    currentTime = "\(year)-0\(month)-\(day)"
                }
                else {
                    currentTime = "\(year)-0\(month)-0\(day)"
                }
                
            }

            self.teachingRecordsVar.value = teachingRecords.filter{
                    teachingRecord in
                print(teachingRecord.date.string)
                    return (teachingRecord.date.string == currentTime && teachingRecord.code == self.instructor?.code)
                }
            .count
            
        })
        _ = teachingRecordsVar.asObservable().subscribeNext {count in
            self.numberCheck.text = "\(count)"
        }
    }
}
