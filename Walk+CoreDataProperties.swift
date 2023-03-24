//
//  Walk+CoreDataProperties.swift
//  TwichCoreData_swift_4fev2023
//
//  Created by Lunack on 16/02/2023.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName:"Walk")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dog: Dog?

}

extension Walk : Identifiable {

}
