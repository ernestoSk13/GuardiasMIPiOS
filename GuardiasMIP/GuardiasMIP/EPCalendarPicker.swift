//
//  EPCalendarPicker.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

@objc public protocol EPCalendarPickerDelegate{
    optional    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError)
    optional    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate)
    optional    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate])
}

public class EPCalendarPicker: UICollectionViewController {

    public var calendarDelegate : EPCalendarPickerDelegate?
    public var multiSelectEnabled: Bool
    public var showsTodaysButton: Bool = true
    private var arrSelectedDates = [NSDate]()
    public var tintColor: UIColor
    
    public var dayDisabledTintColor: UIColor
    public var weekdayTintColor: UIColor
    public var weekendTintColor: UIColor
    public var todayTintColor: UIColor
    public var dateSelectionColor: UIColor
    public var monthTitleColor: UIColor
    
    // new options
    public var startDate: NSDate?
    public var hightlightsToday: Bool = true
    public var hideDaysFromOtherMonth: Bool = false
    public var barTintColor: UIColor
    var passedFirstDay = false
    var turnIndex = 0
    
    public var backgroundImage: UIImage?
    public var backgroundColor: UIColor?
    
    private(set) public var startYear: Int
    private(set) public var endYear: Int
    private(set) public var startMonth: Int
    private(set) public var endMonth: Int
    var sharedHelper =  (UIApplication.sharedApplication().delegate as! AppDelegate)._coreDataHelper
    var turnos = [Turno!]()
    var turnViews = [TurnView!]()
    var lastView : ViewController?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guardias"
        // setup Navigationbar
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
       self.navigationController?.navigationBar.barTintColor = UIColor.containerViewColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        // setup collectionview
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false

        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "EPCalendarCell1", bundle: NSBundle(forClass: EPCalendarPicker.self )), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.registerNib(UINib(nibName: "EPCalendarHeaderView", bundle: NSBundle(forClass: EPCalendarPicker.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        inititlizeBarButtons()

        
        
        if backgroundImage != nil {
            self.collectionView!.backgroundView =  UIImageView(image: backgroundImage)
        } else if backgroundColor != nil {
            self.collectionView?.backgroundColor = backgroundColor
        } else {
            self.collectionView?.backgroundColor = UIColor.whiteColor()
        }
        retrieveTurns()
        //let collectionViewFrameOrigin = turnViews.last!.frame.origin.y + turnViews.last!.frame.size.height + 30
        
        
       // self.collectionView?.frame = CGRectMake(0, collectionViewFrameOrigin, self.view.frame.size.width, self.view.frame.size.height - collectionViewFrameOrigin)
        self.view.backgroundColor = UIColor.whiteColor()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.scrollToToday()
        }
        
    }
    

    
    func retrieveTurns() {
        turnos = self.sharedHelper.savedObjectInstanceFromObjectWithName("Turno", onDatabaseWithConditions: nil) as! [Turno!]
        turnos.sortInPlace{$0.ordenTurno < $1.ordenTurno}
        placeExistingTurns()
        
    }
    
    func placeExistingTurns() {
         var collectionViewFrameOrigin = CGFloat(400)
        
        var style = UIBlurEffectStyle.Light
        
        if #available(iOS 10, *) {
            style = .Light
        }
        
        let blurEffect = UIBlurEffect(style: style)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, collectionViewFrameOrigin)
        view.addSubview(blurredEffectView)
        
        
        for turno in turnos {
            let lastTurn = turnViews.last
            var yPosition = CGFloat(80)
            var xPosition = (lastTurn != nil) ? CGFloat(lastTurn!.frame.origin.x + lastTurn!.frame.size.width + 20) : CGFloat(20)
            
            if lastTurn != nil && lastTurn!.frame.origin.y >  80 + 15 {
                yPosition = lastTurn!.frame.origin.y
            }
            
            if (lastTurn != nil && xPosition + lastTurn!.frame.size.width > self.view.frame.size.width) {
                yPosition = CGFloat(lastTurn!.frame.origin.y + lastTurn!.frame.size.height + 20)
                xPosition = CGFloat(20)
            }
            
            let initialFrame = CGRectMake(blurredEffectView.frame.size.width, yPosition, 40, 40)
            let finalFrame   = CGRectMake(xPosition, yPosition, 40, 40)
            let newTurnView = TurnView(turnName: turno.idTurno! , order: Int(turno.ordenTurno!)!, frame: initialFrame)
            
            UIView.animateWithDuration(1.0, delay: 0.5, options: [.CurveEaseInOut], animations: {
                newTurnView.frame = finalFrame
                }, completion: nil)
            
            blurredEffectView.addSubview(newTurnView)
            turnViews.append(newTurnView)
        }
        collectionViewFrameOrigin = turnViews.last!.frame.origin.y + turnViews.last!.frame.size.height + 15
        BlurredViewHeight = collectionViewFrameOrigin
        blurredEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, collectionViewFrameOrigin)
        
    }
    
    
    func hacerCalculos() {
       
    }

    
    func inititlizeBarButtons(){
        

        let cancelButton = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(EPCalendarPicker.onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton

        var arrayBarButtons  = [UIBarButtonItem]()
        
        if multiSelectEnabled {
            let questionButton = UIBarButtonItem(title: "?", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(EPCalendarPicker.showAlertInfo))
            arrayBarButtons.append(questionButton)
        }
        
        if showsTodaysButton {
            let todayButton = UIBarButtonItem(title: "Hoy", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(EPCalendarPicker.onTouchTodayButton))
            arrayBarButtons.append(todayButton)
            todayButton.tintColor = UIColor.whiteColor()
        }
        
        self.navigationItem.rightBarButtonItems = arrayBarButtons
        
    }
    
    
    func showAlertInfo() {
        let alert = UIAlertController(title: "Calendario de Guardias", message: "Para saber que color corresponde a cada guardia, observa en la parte superior la nomenclatura de turnos y su respectivo color.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { void in
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public convenience init(){
        self.init(startYear: EPDefaults.startYear, startingMonth: 1, endYear: EPDefaults.endYear, endMonth: 12, multiSelection: EPDefaults.multiSelection, selectedDates: nil);
    }
    
    public convenience init(startYear: Int, endYear: Int) {
        self.init(startYear:startYear, startingMonth: 1, endYear:endYear, endMonth: 12, multiSelection: EPDefaults.multiSelection, selectedDates: nil)
    }
    
    public convenience init(multiSelection: Bool) {
        self.init(startYear: EPDefaults.startYear, startingMonth: 1, endYear: EPDefaults.endYear, endMonth: 12, multiSelection: multiSelection, selectedDates: nil)
    }
    
    public convenience init(startYear: Int, endYear: Int, multiSelection: Bool) {
        self.init(startYear: EPDefaults.startYear, startingMonth: 1, endYear: EPDefaults.endYear, endMonth: 12, multiSelection: multiSelection, selectedDates: nil)
    }
    
    public init(startYear: Int, startingMonth: Int,  endYear: Int, endMonth: Int, multiSelection: Bool, selectedDates: [NSDate]?) {
        
        self.startYear = startYear
        self.endYear = endYear
        self.startMonth = startingMonth
        self.endMonth = endMonth
        
        self.multiSelectEnabled = multiSelection
        
        //Text color initializations
        self.tintColor = EPDefaults.tintColor
        self.barTintColor = EPDefaults.barTintColor
        self.dayDisabledTintColor = EPDefaults.dayDisabledTintColor
        self.weekdayTintColor = EPDefaults.weekdayTintColor
        self.weekendTintColor = EPDefaults.weekendTintColor
        self.dateSelectionColor = EPDefaults.dateSelectionColor
        self.monthTitleColor = EPDefaults.monthTitleColor
        self.todayTintColor = EPDefaults.todayTintColor

        //Layout creation
        let layout = UICollectionViewFlowLayout()
        //layout.sectionHeadersPinToVisibleBounds = true  // If you want make a floating header enable this property(Avaialble after iOS9)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = EPDefaults.headerSize
        if let _ = selectedDates  {
            self.arrSelectedDates.appendContentsOf(selectedDates!)
        }
        super.init(collectionViewLayout: layout)
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UICollectionViewDataSource

    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if startYear > endYear {
            return 0
        }
        
        let numberOfMonths = 12 * (endYear - startYear) + 12
        return numberOfMonths
    }


    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let startDate = NSDate(year: startYear, month: 1, day: 1)
        let firstDayOfMonth = startDate.dateByAddingMonths(section)
        let addingPrefixDaysWithMonthDyas = ( firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - NSCalendar.currentCalendar().firstWeekday )
        let addingSuffixDays = addingPrefixDaysWithMonthDyas%7
        var totalNumber  = addingPrefixDaysWithMonthDyas
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        
        return totalNumber
    }

    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EPCalendarCell1
        
        let calendarStartDate = NSDate(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(indexPath.section)
        let prefixDays = ( firstDayOfThisMonth.weekday() - NSCalendar.currentCalendar().firstWeekday)
        
        
        
        if indexPath.row >= prefixDays {
            cell.isCellSelectable = true
            let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row-prefixDays)
            let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth()-1)
            
            cell.currentDate = currentDate
            cell.lblDay.text = "\(currentDate.day())"
            
            if arrSelectedDates.filter({ $0.isDateSameDay(currentDate)
            }).count > 0 && (firstDayOfThisMonth.month() == currentDate.month()) {

                cell.selectedForLabelColor(dateSelectionColor)
            }
            else{
                cell.deSelectedForLabelColor(weekdayTintColor)
               
                if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                    cell.lblDay.textColor = weekendTintColor
                }
                if (currentDate > nextMonthFirstDay) {
                    cell.isCellSelectable = false
                    if hideDaysFromOtherMonth {
                        cell.lblDay.textColor = UIColor.clearColor()
                    } else {
                        cell.lblDay.textColor = self.dayDisabledTintColor
                    }
                    
                }
                if currentDate.isDateSameDay(NSDate(fromString: turnos[0].inicioTurno!, format: DateFormat.ISO8601(.Date))) && hightlightsToday {
                    if  (cell.isCellSelectable != false) {
                    passedFirstDay = true
                    turnIndex = 0
                    
                    let firstDayColor = colorFromString(turnos[0].colorTurno!)
                    cell.setTodayCellColor(firstDayColor)
                    turnIndex += 1
                    }
                } else {
                    if  (cell.isCellSelectable != false) {
                        if passedFirstDay {
//                            if turnIndex > turnos.count - 1 {
//                                turnIndex = 0
//                            }
                            
                            let fecha = cell.currentDate.toString(format: DateFormat.ISO8601(.Date))
                            let correspodingDate = sharedHelper.singleInstanceOf("Fecha", where: "fechaTurno", isEqualTo: fecha) as? Fecha
                            if correspodingDate != nil {
                                let cellColor = colorFromString((correspodingDate?.turnoFecha!.colorTurno)!)
                                cell.setTodayCellColor(cellColor)
                            }
                            
//                            let cellColor = colorFromString(turnos[turnIndex].colorTurno!)
//                            cell.setTodayCellColor(cellColor)
//                            turnIndex += 1
                        } else if currentDate.isLaterThanDate(NSDate(fromString: turnos[turnIndex].inicioTurno!, format: DateFormat.ISO8601(.Date))) && currentDate.isEarlierThanDate(NSDate(fromString: turnos[turnIndex].finTurno!, format: DateFormat.ISO8601(.Date))) {
                            let fecha = cell.currentDate.toString(format: DateFormat.ISO8601(.Date))
                            let correspodingDate = sharedHelper.singleInstanceOf("Fecha", where: "fechaTurno", isEqualTo: fecha) as? Fecha
                            if correspodingDate != nil {
                                let cellColor = colorFromString((correspodingDate?.turnoFecha!.colorTurno)!)
                                cell.setTodayCellColor(cellColor)
                            }
                        }
                    }
                }
               
                if startDate != nil {
                    if NSCalendar.currentCalendar().startOfDayForDate(cell.currentDate) < NSCalendar.currentCalendar().startOfDayForDate(startDate!) {
                        cell.isCellSelectable = false
                        cell.lblDay.textColor = self.dayDisabledTintColor
                    }
                }
            }
        }
        else {
            cell.deSelectedForLabelColor(weekdayTintColor)
            cell.isCellSelectable = false
            let previousDay = firstDayOfThisMonth.dateByAddingDays(-( prefixDays - indexPath.row))
            cell.currentDate = previousDay
            cell.lblDay.text = "\(previousDay.day())"
            if hideDaysFromOtherMonth {
                cell.lblDay.textColor = UIColor.clearColor()
            } else {
                cell.lblDay.textColor = self.dayDisabledTintColor
            }
        }
        
        
        let firstDate = NSDate(fromString: turnos[0].inicioTurno!, format: DateFormat.ISO8601(.Date))
        let endingDate = NSDate(fromString: turnos[0].finTurno!, format: DateFormat.ISO8601(.Date))
        let currentDate = cell.currentDate.dateByAddingHours(3)
        let currentFinalDate = cell.currentDate.dateBySubtractingHours(2)
        if currentDate.isEarlierThanDate(firstDate) || currentFinalDate.isLaterThanDate(endingDate) {
            
            if cell.currentDate.isSunday() || cell.currentDate.isSaturday() {
                cell.deSelectedForLabelColor(self.weekendTintColor)
            }
            
            if cell.currentDate.isWeekday() {
                cell.deSelectedForLabelColor(weekdayTintColor)
            }
        }
        
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func colorFromString(color: String) -> UIColor {
        let valuesArray = color.componentsSeparatedByString(" ")
        let red = Float(valuesArray[1])
        let green = Float(valuesArray[2])
        let blue = Float(valuesArray[3])
        let alpha = Float(valuesArray[4])
        
        let finalColor = UIColor(red: CGFloat(red!), green: CGFloat(green!), blue: CGFloat(blue!), alpha: CGFloat(alpha!))
        
        return finalColor
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        let rect = UIScreen.mainScreen().bounds
        let screenWidth = rect.size.width - 7
        return CGSizeMake(screenWidth/7, screenWidth/7);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(5, 0, 5, 0); //top,left,bottom,right
    }
    
    override public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! EPCalendarHeaderView
            
            let startDate = NSDate(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths(indexPath.section)
            
            header.lblTitle.text = firstDayOfMonth.monthNameFull()
            header.lblTitle.textColor = monthTitleColor
            header.updateWeekdaysLabelColor(weekdayTintColor)
            header.updateWeekendLabelColor(weekendTintColor)
            header.backgroundColor = UIColor.clearColor()
            
            return header;
        }

        return UICollectionReusableView()
    }
    
    override public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EPCalendarCell1
//        if !multiSelectEnabled && cell.isCellSelectable! {
//            calendarDelegate?.epCalendarPicker!(self, didSelectDate: cell.currentDate)
//            cell.selectedForLabelColor(dateSelectionColor)
//            dismissViewControllerAnimated(true, completion: nil)
//            return
//        }
//        
//        if cell.isCellSelectable! {
//            if arrSelectedDates.filter({ $0.isDateSameDay(cell.currentDate)
//            }).count == 0 {
//                arrSelectedDates.append(cell.currentDate)
//                cell.selectedForLabelColor(dateSelectionColor)
//                
//                if cell.currentDate.isToday() {
//                    cell.setTodayCellColor(dateSelectionColor)
//                }
//            }
//            else {
//                arrSelectedDates = arrSelectedDates.filter(){
//                    return  !($0.isDateSameDay(cell.currentDate))
//                }
//                if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
//                    cell.deSelectedForLabelColor(weekendTintColor)
//                }
//                else {
//                    cell.deSelectedForLabelColor(weekdayTintColor)
//                }
//                if cell.currentDate.isToday() && hightlightsToday{
//                    cell.setTodayCellColor(todayTintColor)
//                }
//            }
//        }
        
    }
    
    //MARK: Button Actions
    
    internal func onTouchCancelButton() {
       //TODO: Create a cancel delegate
//        calendarDelegate?.epCalendarPicker!(self, didCancel: NSError(domain: "EPCalendarPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        if lastView != nil {
            lastView?.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    internal func onTouchDoneButton() {
        //gathers all the selected dates and pass it to the delegate
        calendarDelegate?.epCalendarPicker!(self, didSelectMultipleDate: arrSelectedDates)
        dismissViewControllerAnimated(true, completion: nil)
    }

    internal func onTouchTodayButton() {
        scrollToToday()
    }
    
    
    public func scrollToToday () {
        let today = NSDate()
        scrollToMonthForDate(today)
    }
    
    public func scrollToMonthForDate (date: NSDate) {

        let month = date.month()
        let year = date.year()
        let section = ((year - startYear) * 12) + month
        let indexPath = NSIndexPath(forRow:1, inSection: section-1)
        
        self.collectionView?.scrollToIndexpathByShowingHeader(indexPath)
    }
    
    
}
