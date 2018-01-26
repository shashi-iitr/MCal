//
//  MonthViewController.swift
//  MCalApp
//
//  Created by shashi kumar on 26/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

protocol MonthViewControllerDelegate: class {
    func calendarScrolledToYear(_ year: Int, monthIndex: Int)
}

class MonthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var years = NSMutableArray()
    var days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentlySelectedYear: Int = 2018
    var currentlySelectedMonthIndex: Int = 0 // starts from 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var collectionViewHeightConstraint: NSLayoutConstraint?
    
    weak var delegate: MonthViewControllerDelegate?
    
    var leftItem: UIBarButtonItem?
    let backButtonView = MonthBackButtonView.init(frame: CGRect.init(x: 0, y: 0, width: 104, height: 44))
    
    let dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
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
        let currentYear: Int = Calendar.current.component(.year, from: Date())
        let currentMonthIndex: Int = Calendar.current.component(.month, from: Date()) - 1 // jan = 1, that's why reduce 1
        if currentMonthIndex == 1 && currentYear % 4 == 0 {
            days[currentMonthIndex] = 29
        }
        firstWeekDayOfMonth = firstWeekDay()
        print("firstWeekDayOfMonth \(firstWeekDayOfMonth)")
        
        setupNavViews()
        setupSubViews()
    }
    
    //MARK: Configure subviews
    
    func setupNavViews() -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MonthViewController.didTapBackButton))
        backButtonView.addGestureRecognizer(tap)
        backButtonView.configureTitle("\(months[currentlySelectedMonthIndex]) \(currentlySelectedYear)")
        leftItem = UIBarButtonItem.init(customView: backButtonView)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftItem
        leftItem?.tintColor = .blue
        self.navigationController?.navigationBar.tintColor = .blue
    }
    
    func setupSubViews() -> Void {
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.reusedIdentifier())
        
        self.view.addSubview(dayCollectionView)
        dayCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 94).isActive = true
        dayCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        dayCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        if firstWeekDayOfMonth - 1 + days[currentlySelectedMonthIndex] > 35 {
            collectionViewHeightConstraint = dayCollectionView.heightAnchor.constraint(equalToConstant: 300)
            collectionViewHeightConstraint?.isActive = true
        } else {
            collectionViewHeightConstraint = dayCollectionView.heightAnchor.constraint(equalToConstant: 250)
            collectionViewHeightConstraint?.isActive = true
        }
        
        weekDayView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(weekDayView)
        weekDayView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        weekDayView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weekDayView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        weekDayView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.dayCollectionView.reloadData()
            self.dayCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: ((self.years.index(of: self.currentlySelectedYear) * 12) + self.currentlySelectedMonthIndex)), at: .top, animated: false)
        }
    }
    
    //MARK: UICollectionViewDelegate, UICollectionViewDataSource
    // Years starts from 2005 to 2050
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return years.count * months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days[currentlySelectedMonthIndex] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MonthCell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.reusedIdentifier(), for: indexPath) as! MonthCell
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.configureWithMonth("")
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.configureWithMonth("\(calcDate)")
        }
        
        if indexPath.item == 0 || (indexPath.item % 7 == 0) || ((indexPath.item + 1) % 7) == 0 {
            cell.monthLabel.textColor = UIColor.init(red: 250/255, green: 90/255, blue: 90/255, alpha: 1)
        } else {
            cell.monthLabel.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == dayCollectionView {
            let pageHeight = scrollView.frame.height
            let index = dayCollectionView.contentOffset.y / pageHeight
            let yearIndex = Int(ceil(index)) / 12
            print("yearIndex \(yearIndex)")
            
            let monthIndex = Int(ceil(index)) % 12
            print("monthIndex \(monthIndex)")
            
            currentlySelectedYear = years[yearIndex] as! Int
            currentlySelectedMonthIndex = monthIndex
            
            print("currentlySelectedYear \(currentlySelectedYear)")
            print("currentlySelectedMonthIndex \(currentlySelectedMonthIndex)")
            
            firstWeekDayOfMonth = firstWeekDay()
            self.dayCollectionView.reloadData()
            
            backButtonView.configureTitle("\(months[currentlySelectedMonthIndex]) \(currentlySelectedYear)")
            
            if firstWeekDayOfMonth - 1 + days[currentlySelectedMonthIndex] > 35 {
                collectionViewHeightConstraint?.isActive = false
                collectionViewHeightConstraint = dayCollectionView.heightAnchor.constraint(equalToConstant: 300)
                collectionViewHeightConstraint?.isActive = true
            } else {
                collectionViewHeightConstraint?.isActive = false
                collectionViewHeightConstraint = dayCollectionView.heightAnchor.constraint(equalToConstant: 250)
                collectionViewHeightConstraint?.isActive = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.dayCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: ((self.years.index(of: self.currentlySelectedYear) * 12) + self.currentlySelectedMonthIndex)), at: .top, animated: false)
            }
            
            self.dayCollectionView.reloadData()
        }
    }
    
    //MARK: Actions
    
    @objc func didTapBackButton() -> Void {
        if let delegate = delegate {
            delegate.calendarScrolledToYear(currentlySelectedYear, monthIndex: currentlySelectedMonthIndex)
        }
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: Helpers
    
    func firstWeekDay() -> Int {
        return ("\(currentlySelectedYear)-\(currentlySelectedMonthIndex + 1)-01".date?.firstDayOfTheMonth.weekday)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
