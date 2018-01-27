//
//  MonthViewController.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    var years = NSMutableArray()
    var days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var allDays = NSMutableArray()
    var currentlySelectedYear: Int = 2018
    var currentlySelectedMonthIndex: Int = 0 // starts from 0
    
    var agendaTableView: UITableView!
    var yearBarButtonItem: UIBarButtonItem!
    
    let dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: DayHeaderView.viewHeight())

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = false

        return collectionView
    }()
    
    lazy var weekDayView: WeekDayView = {
        return WeekDayView()
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //check for leap year
        for i in 0..<years.count {
            let year = years[i] as! Int
            if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0)) {
                days[1] = 29
            } else {
                days[1] = 28
            }
            
            allDays.addObjects(from: days)
        }
        
        setupNavViews()
        setupCollectionView()
        setupTableView()
    }
    
    //MARK: Configure subviews
    
    func setupNavViews() -> Void {
        yearBarButtonItem = UIBarButtonItem(title: "\(currentlySelectedYear)", style: .plain, target: self, action: #selector(MonthViewController.didTapBackButton(_:)))
        yearBarButtonItem.setTitlePositionAdjustment(UIOffset(horizontal: -30, vertical: 0), for: .default)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItems = [yearBarButtonItem]
    }
    
    func setupCollectionView() -> Void {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reusedIdentifier())
        dayCollectionView.register(DayHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DayHeaderView.reusedIdentifier())

        self.view.addSubview(dayCollectionView)
        dayCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 94).isActive = true
        dayCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        dayCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dayCollectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        weekDayView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weekDayView)
        weekDayView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        weekDayView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weekDayView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        weekDayView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.dayCollectionView.reloadData()
            self.dayCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: ((self.years.index(of: self.currentlySelectedYear) * 12) + self.currentlySelectedMonthIndex)), at: .top, animated: false)

            if let attributes = self.dayCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: ((self.years.index(of: self.currentlySelectedYear) * 12) + self.currentlySelectedMonthIndex))) {
                self.dayCollectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - self.dayCollectionView.contentInset.top), animated: false)
            }

        }
    }
    
    func setupTableView() -> Void {
        self.agendaTableView = UITableView.init(frame: .zero, style: .plain)
        self.agendaTableView.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.reusedIdentifier())
        self.agendaTableView.delegate = self
        self.agendaTableView.dataSource = self
        self.agendaTableView.backgroundColor = .white
        self.agendaTableView.separatorStyle = .none
        self.view.addSubview(self.agendaTableView)
        
        self.agendaTableView.translatesAutoresizingMaskIntoConstraints = false
        agendaTableView.topAnchor.constraint(equalTo: self.dayCollectionView.bottomAnchor, constant: 0).isActive = true
        agendaTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        agendaTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        agendaTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    //MARK: UICollectionViewDelegate, UICollectionViewDataSource
    // Years starts from 2005 to 2050
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let yearIndex = Int(ceil(Double(section / 12)))
        let monthIndex = Int(ceil(Double(section % 12)))
        let year = years.object(at: yearIndex) as! Int
        let firstWeekDayMonth = firstWeekDay(year: year, monthIndex: monthIndex)

        return (allDays[section] as! Int) + firstWeekDayMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let yearIndex = Int(ceil(Double(indexPath.section / 12)))
        let monthIndex = Int(ceil(Double(indexPath.section % 12)))
        let year = years.object(at: yearIndex) as! Int
        
        let firstWeekDayMonth = firstWeekDay(year: year, monthIndex: monthIndex)
        
        yearBarButtonItem.title = "\(year)"

        let cell: DayCell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reusedIdentifier(), for: indexPath) as! DayCell
        if indexPath.item <= firstWeekDayMonth - 2 {
            cell.configureWithDay("", isAgendaTagged: false)
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstWeekDayMonth + 2
            cell.isHidden = false
            cell.configureWithDay("\(calcDate)", isAgendaTagged: true)
        }
        
        if indexPath.item == 0 || (indexPath.item % 7 == 0) || ((indexPath.item + 1) % 7) == 0 {
            cell.dayLabel.textColor = Color.negation.withAlpha(0.6)
        } else {
            cell.dayLabel.textColor = Color.darkText.value
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let yearIndex = Int(ceil(Double(indexPath.section / 12)))
            let monthIndex = Int(ceil(Double(indexPath.section % 12)))
            let year = years.object(at: yearIndex) as! Int
            let firstWeekDayMonth = firstWeekDay(year: year, monthIndex: monthIndex)
            print("firstWeekDayMonth \(firstWeekDayMonth) year \(year), monthIndex \(monthIndex)")

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:DayHeaderView.reusedIdentifier() , for: indexPath) as! DayHeaderView
            headerView.configureViewWithMonth(months[monthIndex], index: firstWeekDayMonth - 1)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth / 7, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.reusedIdentifier(), for: indexPath) as! AgendaCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AgendaCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Actions
    
    @objc func didTapBackButton(_ sender: UIBarButtonItem) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helpers
    
    func firstWeekDay(year: Int, monthIndex: Int) -> Int {
        return ("\(year)-\(monthIndex + 1)-01".date?.firstDayOfTheMonth.weekday)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
