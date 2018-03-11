//
//  User.swift
//  Firebase Firestore Example
//
//  Created by Owen Thomas on 3/10/18.
//  Copyright © 2018 Owen Thomas. All rights reserved.
//

import Foundation
import Firebase

struct User {
  var dbRef: DocumentReference
  var firstName: String
  var lastName: String
  var middleName: String?
  
  init?(snapShot: QueryDocumentSnapshot) {
    let data = snapShot.data()
    self.dbRef = snapShot.reference
    self.firstName = data["first"] as? String ?? "Firstname"
    self.lastName = data["last"] as? String ?? "Lastname"
    self.middleName = data["middle"] as? String
  }
  
  func delete() {
    dbRef.delete()
  }
  
  static var users = [User]()
  static var dbRef: CollectionReference {
    return db.collection("users")
  }
  static var db: Firestore = {
    FirebaseApp.configure()
    return Firestore.firestore()
  }()
  
  static func addUser(firstName: String = "Ada", middleName: String? = nil, lastname: String = "Lovelace") {
    var ref: DocumentReference? = nil
    var data: [String: String] = [
      "first": firstName,
      "last": lastname,
    ]
    data["middle"] = middleName
    ref = db.collection("users").addDocument(data: data) { err in
      if let err = err {
        print("Error adding document: \(err)")
      } else {
        print("Document added with ID: \(ref!.documentID)")
      }
    }
  }
  
  static func getAllUsers(completion: @escaping () -> Void) {
    db.collection("users").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        users = querySnapshot?.documents.flatMap( { User(snapShot: $0) } ) ?? []
        completion()
      }
    }
  }
}
