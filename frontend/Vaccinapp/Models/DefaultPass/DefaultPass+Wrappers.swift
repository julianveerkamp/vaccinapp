//
//  DefaultPass+Wrappers.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 05.06.22.
//

import Foundation
import CoreData

extension DefaultPass {
    func selectNewPass(_ pass: VaccinationPass, in context: NSManagedObjectContext) {
        self.pass = pass
        
        do {
            try context.save()
        } catch {
            print("ERROR: Failed to save new defaultPass")
        }
    }
}
