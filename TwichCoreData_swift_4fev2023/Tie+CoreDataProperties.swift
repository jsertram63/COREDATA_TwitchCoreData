//
//  Tie+CoreDataProperties.swift
//  TwichCoreData_swift_4fev2023
//
//  Created by Lunack on 11/02/2023.
//

import Foundation
import CoreData


extension Tie {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tie> {
        return NSFetchRequest<Tie>(entityName: "Tie")
    }
    
    @NSManaged public var name:String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastWorn: Date?
    @NSManaged public var rating:Double
    @NSManaged public var timeWorn: Int32
    @NSManaged public var id: UUID?
    @NSManaged public var url: URL?
    @NSManaged public var searchKey: String?
    @NSManaged public var photoData: Data?
    
}

extension Tie: Identifiable {
    
}
