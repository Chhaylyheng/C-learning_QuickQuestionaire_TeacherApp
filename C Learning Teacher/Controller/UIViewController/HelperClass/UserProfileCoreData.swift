//
//  UserProfileCoreData.swift
//  C Learning Teacher
//
//  Created by kit on 2/19/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import Foundation
import CoreData

class Userprofiles {
    
    static func insertUserProfile( _email: String , _username : String,_hashkey : String, _profileImage : NSData, _lastlogin : String,completion: (_ result: Bool)->()){
        print(_email,_username)
        let userProfile = NSEntityDescription.insertNewObject(forEntityName: "UserProfile", into: manageObjectContext)
        userProfile.setValue(_email , forKey: "email")
        userProfile.setValue(_username, forKey: "username")
        userProfile.setValue(_hashkey, forKey: "hashkey")
        userProfile.setValue(_profileImage, forKey: "profileImage")
        userProfile.setValue(_lastlogin, forKey: "lastlogin")
        
        
        do{
            try  manageObjectContext.save()
            completion(true)
            
        } catch {
            print("error")
        }
        
        
    }
        
    

    
   
    
    func getByIdUserProfile(_id: NSManagedObjectID) -> UserProfile? {
        return manageObjectContext.object(with: _id) as? UserProfile
    }
    
   static func deleteAllData(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try manageObjectContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                manageObjectContext.delete(managedObjectData)
                try manageObjectContext.save()
                
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
  

}
