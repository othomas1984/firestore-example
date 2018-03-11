//
//  ViewController.swift
//  Firebase Firestore Example
//
//  Created by Owen Thomas on 3/10/18.
//  Copyright © 2018 Owen Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var middleName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBAction func addAUserTapped(_ sender: Any) {
    guard let first = firstName.text, let last = lastName.text else { return }
    User.addUser(firstName: first, middleName: middleName.text == "" ? nil : middleName.text, lastname: last)
    [firstName, middleName, lastName].forEach({ $0?.text = nil; $0?.resignFirstResponder() })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.tableFooterView = UIView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    User.dbRef.addSnapshotListener { (querySnapshot, error) in
      User.getAllUsers() {
        self.tableview.reloadData()
      }
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return User.users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath)
    let user = User.users[indexPath.row]
    cell.textLabel?.text = user.firstName + " " + (user.middleName != nil ? user.middleName! + " " : "") + user.lastName
    cell.detailTextLabel?.text = user.dbRef.documentID
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    User.users[indexPath.row].delete()
  }
}
