//
//  Favorite.swift
//  DotaCheck
//
//  Created by Hui Hong Zheng on 12/1/21.
//
import CoreData

@objc(Favorite)
class Favorite:NSManagedObject{
    @NSManaged var game_ID: String!
    @NSManaged var game_name: String!
}
