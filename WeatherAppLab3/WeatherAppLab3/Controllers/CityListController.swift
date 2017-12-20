//
//  CityDetailViewController.swift
//  WeatherAppLab3
//
//  Created by admin on 12/18/17.
//  Copyright © 2017 NayanGoel. All rights reserved.
//

import UIKit

var bool:Bool = true
var loadData : Int = 0

class CityListController: UITableViewController, UISearchResultsUpdating {
    
    var items = ["San Jose, CA, United States"]
    var addedItems = ["San Jose, CA, United States"]
    let searchController = UISearchController(searchResultsController: nil)
    var googleLocation = GoogleLocationAPIModal()
    var weatherModal = WeatherDataModal()
    override func viewDidLoad() {
       navigationItem.title = "City List View"
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.sectionHeaderHeight = 50
    
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        super.viewDidLoad()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if var searchText = searchController.searchBar.text, !searchText.isEmpty {
            googleLocation.downloadData (searchText: &searchText,completed:{
                self.items = self.googleLocation.cities
                bool = false;
                
                self.tableView.reloadData()
            })
        } else {
            items = addedItems
            bool = true;
             tableView.reloadData()
        }
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !bool {
        bool = true
            
        addedItems.append(items[indexPath.row])
        items = addedItems
        searchController.isActive = false;
            loadData = addedItems.count*3
        print(loadData)
       tableView.reloadData()
        }
        else {
            var fullNameArr = items[indexPath.row].components(separatedBy: ",")
            let cityName: String = fullNameArr[0].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
           weatherModal.setCurrentCity(city: cityName)
            let storyBoard = UIStoryboard(name:"Main",bundle:Bundle.main)
            let destination = storyBoard.instantiateViewController(withIdentifier: "CityDetailViewController") as! CityDetailViewController
            navigationController?.pushViewController(destination, animated: true)
        }
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(bool)
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath as IndexPath) as! MyCell
        if !bool{
            myCell.nameLabel.text = items[indexPath.row]
            myCell.actionButton.setTitle("", for: [])
            myCell.myTableViewController = self
            return myCell
            
        }
        else{
            var fullNameArr = items[indexPath.row].components(separatedBy: ",")
            let cityName: String = fullNameArr[0].replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            weatherModal.downloadData(city: cityName, completed:{
                myCell.nameLabel.text = self.items[indexPath.row]+"\nCurrent Time:"+self.weatherModal.formatteddate+"\nCurrent temperature:"+self.weatherModal.currenttemp
                if loadData != -1{
                self.tableView.reloadData()
                    loadData = loadData - 1
                }
            })
            myCell.actionButton.setTitle("Delete", for: [])
            myCell.myTableViewController = self
            return myCell
        }
    }
    
    
    
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
             addedItems.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
}

class MyCell: UITableViewCell {
    
    var myTableViewController: CityListController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: [])
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        print(bool)
        addSubview(nameLabel)
            addSubview(actionButton)
         actionButton.addTarget(self, action: #selector(MyCell.handleAction), for: .touchUpInside)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
   }
    
    func handleAction() {
        myTableViewController?.deleteCell(cell : self)
    }
    
}
