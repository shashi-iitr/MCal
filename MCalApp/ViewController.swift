//
//  ViewController.swift
//  MCalApp
//
//  Created by shashi kumar on 25/01/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var currentYear: Int = 2018
    var currentYearIndex = 0
    var years = NSMutableArray()
    let monthCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: CellHeaderView.viewHeight())

        let monthCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        monthCollectionView.showsHorizontalScrollIndicator = false
        monthCollectionView.showsVerticalScrollIndicator = false
        monthCollectionView.translatesAutoresizingMaskIntoConstraints = false
        monthCollectionView.backgroundColor = .white
//        monthCollectionView.isPagingEnabled = true
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
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.reusedIdentifier())
        monthCollectionView.register(CellHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CellHeaderView.reusedIdentifier())

        self.view.addSubview(monthCollectionView)
        monthCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
        monthCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        monthCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        monthCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let month = Calendar.current.component(.month, from: Date())
        print("month \(month)")
        
        currentYear = Calendar.current.component(.year, from: Date())
        print("currentYear \(currentYear)")
        
        currentYearIndex = currentIndex(startYear: 2005, endYear: 2050)
        print("currentYearIndex \(currentYearIndex)")
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.monthCollectionView.reloadData()
            self.monthCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: self.currentYearIndex), at: .top, animated: false)
            
            if let attributes = self.monthCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: self.currentYearIndex)) {
                self.monthCollectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - self.monthCollectionView.contentInset.top), animated: false)
            }
        }
    }
    
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:CellHeaderView.reusedIdentifier() , for: indexPath) as! CellHeaderView
            headerView.configureViewWithYear(years[indexPath.section] as! Int)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
        let pageHeight = scrollView.frame.height
        let index = self.monthCollectionView.contentOffset.y / pageHeight
        let newIndex = Int(ceil(index))
        print("newIndex \(newIndex)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            if let sv = self.monthCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: newIndex)) {
                let svFrame = sv.convert(scrollView.frame, to: self.view)
                print("svFrame \(svFrame)")
                if svFrame.origin.y - 64 < 20 {
                    if let attributes = self.monthCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: newIndex)) {
                        self.monthCollectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - self.monthCollectionView.contentInset.top), animated: false)
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        let pageHeight = scrollView.frame.height
        let index = self.monthCollectionView.contentOffset.y / pageHeight
        let newIndex = Int(ceil(index))
        print("newIndex \(newIndex)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            if let sv = self.monthCollectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: newIndex)) {
                let svFrame = sv.convert(scrollView.frame, to: self.view)
                print("svFrame \(svFrame)")
                if svFrame.origin.y - 64 < 20 {
                    if let attributes = self.monthCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: newIndex)) {
                        self.monthCollectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - self.monthCollectionView.contentInset.top), animated: false)
                    }
                }
            }
        }
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class CellHeaderView: UICollectionReusableView {
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        label.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        
        return label
    }()
    
    let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        self.addSubview(yearLabel)
        yearLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        yearLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        yearLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        yearLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true

        self.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func configureViewWithYear(_ year: Int) -> Void {
        yearLabel.text = "\(year)"
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }
    
    class func viewHeight() -> CGFloat {
        return 50
    }
}

class MonthCell: UICollectionViewCell {
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.init(red: 41/255, green: 41/255, blue: 40/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.contentView.addSubview(monthLabel)
        monthLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func configureWithMonth(_ month: String) -> Void {
        monthLabel.text = month
    }
    
    class func reusedIdentifier() -> String {
        return NSStringFromClass(self)
    }
}

