//
//  Persistence+Methods.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.07.22.
//

import Foundation
import CoreData

// MARK: Update and initial Setup
extension PersistenceController {
    func update() {
        let controller = UpdateNetworkController(session: APISession(), persistence: self)
        
        controller.update()
    }
    
    func initialImport() {
        
        update()
        
        print("initial import")
        let defaultPass = DefaultPass(context: container.viewContext)
        
        let newPass = VaccinationPass(context: container.viewContext)
        newPass.name = "Default"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        newPass.dob = formatter.date(from: "1990/01/01") ?? Date.now
        newPass.wrappedGender = .male
        newPass.wrappedType = .human
        
        defaultPass.pass = newPass
        
        do {
            try container.viewContext.save()
            print("Initial Import succesfull")
        } catch {
            container.viewContext.rollback()
            print("Failed to save: \(error)")
        }
    }
}

// MARK: Add Object Methods
extension PersistenceController {
    func addNewRecommendation(_ rec: DiseaseTargetDTO, context: NSManagedObjectContext) {
        let request = Recommendation.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "target.id == %@", rec.targetID)
        
        var newRec: Recommendation
        
        if let existingR = try? context.fetch(request).first {
            print("Update existing Recommendation for '\(rec.name)'")
            newRec = existingR
        } else {
            print("Add new Recommendation for '\(rec.name)'")
            newRec = Recommendation(context: context)
        }
        newRec.wrappedType = PassType(rawValue: rec.type) ?? PassType.human
        
        if let countries = rec.countries {
            newRec.countries = countries
        }
        
        if let age = Int16(rec.age ?? "0") {
            newRec.age = age
        }
        
        newRec.wrappedGender = Gender(rawValue: rec.gender ?? "none") ?? Gender.none
        
        let p = NSPredicate(format: "id == %@", rec.targetID)
        let f = DiseaseTarget.fetchRequest()
        f.predicate = p
        f.fetchLimit = 1
        
        if let target = try? context.fetch(f).first {
            target.recommendation = newRec
            newRec.target = target
        } else {
            print("ERROR: Missing Disease Target \(rec.targetID)")
            fatalError("ERROR: Missing Disease Target \(rec.targetID)")
            // Handle missing DiseaseTarget
        }
    }
    
    func addNewTarget(_ item: DiseaseTargetDTO, context: NSManagedObjectContext) {
        let request = DiseaseTarget.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", item.targetID)
        
        var target: DiseaseTarget
        
        if let existingTarget = try? context.fetch(request).first {
            print("Update existing Target '\(item.name)'")
            target = existingTarget
        } else {
            print("Add new Target '\(item.name)'")
            target = DiseaseTarget(context: context)
            target.id = item.targetID
        }
        
        target.name = item.name
        target.wrappedType = PassType(rawValue: item.type) ?? PassType.human
        
        for v in item.vaccines {
            addNewVaccine(v, to: target, context: context)
        }
    }
    
    func addNewVaccine(_ item: VaccineDTO, to target: DiseaseTarget, context: NSManagedObjectContext) {
        let request = Vaccine.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", item.id)
        
        var vaccine: Vaccine
        if let existingVaccine = try? context.fetch(request).first {
            print("Update existing Vaccine '\(item.name)'")
            vaccine = existingVaccine
            
            if existingVaccine.target != target {
                target.addToVaccines(vaccine)
            }
        } else {
            print("Add new Vaccine '\(item.name)'")
            vaccine = Vaccine(context: context)
            vaccine.id = item.id
            target.addToVaccines(vaccine)
        }
        
        vaccine.name = item.name
        vaccine.manufacturer = item.manufacturer
    }
    
    func addVaccination(_ item: AddVaccinationDTO, to pass: VaccinationPass, context: NSManagedObjectContext) throws {
        let newItem = Vaccination(context: context)
        newItem.timestamp = item.timestamp
        newItem.target = item.diseaseSelection
        newItem.vaccine = item.vaccineSelection
        newItem.addPass(pass)
        newItem.valid = item.valid
        
        for c in item.certificates {
            try newItem.addCertificate(c)
        }
    }
}
