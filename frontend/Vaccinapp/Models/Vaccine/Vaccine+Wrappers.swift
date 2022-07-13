//
//  Vaccine+Wrappers.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 05.06.22.
//

import Foundation
import CoreData

extension Vaccine: Comparable {
    public static func < (lhs: Vaccine, rhs: Vaccine) -> Bool {
        lhs.name < rhs.name
    }
    
    
}

extension Vaccine {
    static func get(name: String) -> NSFetchRequest<Vaccine> {
        let request = Vaccine.fetchRequest()
        
        let predicate = NSPredicate(format: "name == %@", name)
        
        request.predicate = predicate
        
        return request
    }
}
