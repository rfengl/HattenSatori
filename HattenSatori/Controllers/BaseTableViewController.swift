//
//  BaseTableController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController: BaseController, UITableViewDelegate, UITableViewDataSource, CustomPickerDelegate, RefreshDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    var mItems: [UITableView: [BaseTableItem]]?
    
    override func getBackgroundImage() -> UIImage? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        //        showInstruction()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        if self.tableView.delegate.isEmpty {
            self.tableView.delegate = self
        }
        if self.tableView.dataSource.isEmpty {
            self.tableView.dataSource = self
        }
        
        if self.refreshControl.isEmpty {
            self.refreshControl = UIRefreshControl()
            self.tableView.addSubview(self.refreshControl!)
        }
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refresh(sender: nil)
    }
    
    func refresh(sender: AnyObject?) {
        mItems = nil
        if let control = sender as? UIRefreshControl {
            control.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func buildItems(_ sender: AnyObject?) -> [BaseTableItem]? {
        return [BaseTableItem]()
    }
    
    func getItems(_ sender: AnyObject?) -> [BaseTableItem]? {
        if mItems.isEmpty {
            mItems = [UITableView: [BaseTableItem]]()
        }
        if let tableView = sender as? UITableView {
            if mItems?[tableView] == nil {
                mItems?[tableView] = buildItems(sender)
            }
            return mItems?[tableView]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.lineHeight * 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        
        if let options = getItems(tableView) {
            for item in options {
                if type(of: item) == BaseTableGroup.self {
                    count = count + 1
                }
            }
            
            if count == 0 {
                return 1
            }
        }
        
        return count
    }
    
    func hasGroup() -> Bool {
        return numberOfSections(in: tableView) > 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = getItems(tableView) {
            if hasGroup() {
                if let group = items[section] as? BaseTableGroup {
                    return group.children?.count ?? 0
                }
            }
            return items.count
        }
        return 0
    }
    
    func dequeueReusableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        
        if let customCell = cell as? BaseTableViewCell {
            if let items = getItems(tableView) {
                if hasGroup() {
                    let item = items[indexPath.section]
                    if let item = (item as? BaseTableGroup)?.children?[indexPath.row] {
                        customCell.initCell(item: item)
                    } else {
                        customCell.initCell(item: item)
                    }
                } else {
                    customCell.initCell(item: items[indexPath.row])
                }
            }
        }
        
        return cell
    }
}
