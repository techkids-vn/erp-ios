//
//  CalendarView.swift
//  ERP
//
//  Created by Mr.Vu on 6/25/16.
//  Copyright © 2016 Techkids. All rights reserved.
//

import UIKit
import CVCalendar
import RxSwift
import RxCocoa

class CalendarSelectorView: UIView ,CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var calendarMenu: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    var time : Variable<String> = Variable("")
    
    override func awakeFromNib() {
        self.calendarView.calendarDelegate = self
        self.calendarMenu.menuViewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.calendarView.commitCalendarViewUpdate()
        self.calendarMenu.commitMenuViewUpdate()
    }
    
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    func firstWeekday() -> Weekday {
        return Weekday.Monday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        let day = dayView.date.day
        let month = dayView.date.month
        let year = dayView.date.year
        self.time.value = "\(year)-\(month)-\(day)"
    }


}
