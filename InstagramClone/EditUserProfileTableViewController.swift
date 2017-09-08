//
//  EditUserProfileTableViewController.swift
//  InstaClone
//
//  Created by Michael A on 2017-08-27.
//  Copyright © 2017 AI Labs. All rights reserved.
//

import UIKit


class EditUserProfileTableViewController: UITableViewController {
    fileprivate let cellIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        setupNavigationItems()
    }

    fileprivate func setupNavigationItems() {
        navigationController?.navigationBar.tintColor = .black
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain
            , target: self, action: #selector(cancelLeftBarButtonTapped))
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain
            , target: self, action: #selector(doneRightBarButtonTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func cancelLeftBarButtonTapped() {
      self.dismiss(animated: true, completion: nil)
    }
    @objc private func doneRightBarButtonTapped() {
    print("done tapped")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        } else if section == 1 {
            return 4
        } else {
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.imageView?.image = #imageLiteral(resourceName: "person-placeholder")
        cell.textLabel?.text = "testing"
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return view.frame.height * 0.25
        } else if section == 1 {
            return 0
        } else {
            return 40
        }
    }
}









