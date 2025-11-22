//
//  Movie+CoreDataProperties.swift
//
//
//  Created by Lahori, Divyansh on 7/18/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import UIKit

@objc(Movie)
class Movie: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var image: UIImage?
    @NSManaged public var language: String
    @NSManaged public var name: String
    @NSManaged public var overview: String
    @NSManaged public var rating: Double
    @NSManaged public var watchlistName: String
    @NSManaged public var id: Int64
    @NSManaged public var releaseDate: String
}

extension Movie : Identifiable {

}

