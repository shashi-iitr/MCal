//
//  ViewController.swift
//  MCalApp
//
//  Created by shashi kumar on 25/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
    var currentYear: Int = Calendar.current.component(.year, from: Date())
    var currentYearIndex = 0
    var years = NSMutableArray()

    var selectedYear: Int = 2018
    var selectedMonthIndex: Int = 0
    
    let monthCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: YearCellHeaderView.viewHeight())

        let monthCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        monthCollectionView.showsHorizontalScrollIndicator = false
        monthCollectionView.showsVerticalScrollIndicator = false
        monthCollectionView.translatesAutoresizingMaskIntoConstraints = false
        monthCollectionView.backgroundColor = .white
        monthCollectionView.allowsMultipleSelection = false
        
        return monthCollectionView
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
        self.title = "Calendar"
        
        let month = Calendar.current.component(.month, from: Date())
        print("month \(month)")
        
        print("currentYear \(currentYear)")
        currentYearIndex = currentIndex(startYear: 2005, endYear: 2050)
        print("currentYearIndex \(currentYearIndex)")

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Calendar"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    func setupViews() -> Void {
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.reusedIdentifier())
        monthCollectionView.register(YearCellHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: YearCellHeaderView.reusedIdentifier())
        
        self.registerForPreviewing(with: self, sourceView: monthCollectionView)

        self.view.addSubview(monthCollectionView)
        monthCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        monthCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        monthCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        monthCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.monthCollectionView.reloadData()
            self.monthCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: self.currentYearIndex), at: .top, animated: false)
            
            if let attributes = self.monthCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: self.currentYearIndex)) {
                self.monthCollectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - self.monthCollectionView.contentInset.top), animated: false)
            }
        }
    }
    
    //MARK: UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = monthCollectionView.indexPathForItem(at: location) {
            let selectedYear = years[indexPath.section] as! Int
            let selectedMonthIndex = indexPath.item
            
            let monthVC = MonthViewController.init(nibName: nil, bundle: nil)
            monthVC.years = years
            monthVC.currentlySelectedYear = selectedYear
            monthVC.currentlySelectedMonthIndex = selectedMonthIndex
            monthVC.view.backgroundColor = .white

            return monthVC
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
        
    //MARK: UICollectionViewDelegate, UICollectionViewDataSource
    // Years starts from 2005 to 2050
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return years.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MonthCell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.reusedIdentifier(), for: indexPath) as! MonthCell
        cell.configureWithMonth(months[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)        
        selectedYear = years[indexPath.section] as! Int
        selectedMonthIndex = indexPath.item
        
        let monthVC = MonthViewController.init(nibName: nil, bundle: nil)
        monthVC.years = years
        monthVC.currentlySelectedYear = selectedYear
        monthVC.currentlySelectedMonthIndex = selectedMonthIndex
        self.navigationController?.pushViewController(monthVC, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth / 3, height: (screenHeight - 64 - 50) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:YearCellHeaderView.reusedIdentifier() , for: indexPath) as! YearCellHeaderView
            headerView.configureViewWithYear(years[indexPath.section] as! Int)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    //MARK: Helpers
        
    func currentIndex(startYear: Int, endYear: Int) -> Int {
        var index = 0
        for i in startYear...endYear {
            years.add(i)
        }
        print("currentYear \(currentYear)")
        if years.contains(currentYear) == true {
            index = years.index(of: currentYear)
        }
        
        return index
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

