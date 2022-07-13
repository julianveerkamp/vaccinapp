//
//  NSPredicateExtension.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 05.06.22.
//

import Foundation

extension NSPredicate {
    func or(_ p: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, p])
    }
    
    func and(_ p: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, p])
    }
}
