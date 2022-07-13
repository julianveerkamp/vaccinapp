//
//  PersistenceTests.swift
//  VaccinappTests
//
//  Created by Julian Veerkamp on 22.06.22.
//

import XCTest
import CoreData
@testable import Vaccinapp

class PersistenceTests: XCTestCase {
    let persistence = PersistenceController.preview
    let targetRequest = DiseaseTarget.fetchRequest()
    
    var context: NSManagedObjectContext {
        persistence.container.viewContext
    }
    
    override func setUpWithError() throws {
        let vaccine = Vaccine(context: context)
        vaccine.id = "id"
        vaccine.name = "Test Vaccine"
        vaccine.manufacturer = "ACME Inc."
        
        let target = DiseaseTarget(context: context)
        target.id = "000000001"
        target.type = "human"
        target.addToVaccines(vaccine)
        target.name = "Test Target 1"
        
        let vaccination = Vaccination(context: context)
        vaccination.timestamp = Date.now
        vaccination.target = target
        vaccination.vaccine = vaccine
        vaccination.valid = true
    }

    override func tearDownWithError() throws {
        context.rollback()
    }

    func testAddNewTarget() throws {
        let newTarget = DiseaseTargetDTO(targetID: "000000002", type: "human", vaccines: [], name: "Test Target 2")
        
        let initialCount = try context.count(for: targetRequest)
        XCTAssertEqual(initialCount, 1)
        
        persistence.addNewTarget(newTarget, context: context)
        
        let count = try context.count(for: targetRequest)
        XCTAssertEqual(count, 2)
    }
    
    func testUpdateExistingTarget() throws {
        let newTarget = DiseaseTargetDTO(targetID: "000000001", type: "human", vaccines: [], name: "Updated Target 1")
        
        let initialCount = try context.count(for: targetRequest)
        XCTAssertEqual(initialCount, 1)
        
        persistence.addNewTarget(newTarget, context: context)
        
        let count = try context.count(for: targetRequest)
        XCTAssertEqual(count, 1)
        
        let r = targetRequest
        r.predicate = NSPredicate(format: "name == %@", newTarget.name)
        
        if let t = try? context.fetch(r).first {
            XCTAssertEqual(t.name, newTarget.name)
        } else {
            XCTFail("Missing Target")
        }
    }
    
    func testWrappedType() {
        let r = targetRequest
        r.predicate = NSPredicate(format: "name == %@", "Test Target 1")
        
        if let t = try? context.fetch(r).first {
            t.wrappedType = .human
            XCTAssertEqual(t.type, "human")
            XCTAssertEqual(t.wrappedType, .human)
        } else {
            XCTFail("Missing Target")
        }
    }
    
    func testWrappedVaccines() {
        let r = targetRequest
        r.predicate = NSPredicate(format: "name == %@", "Test Target 1")
        
        if let t = try? context.fetch(r).first {
            XCTAssertEqual(t.wrappedVaccines.count, 1)
            XCTAssert((t.wrappedVaccines as Any) is [Vaccine])
        } else {
            XCTFail("Missing Target")
        }
    }
    
    func testWrappedVaccinations() {
        let r = targetRequest
        r.predicate = NSPredicate(format: "name == %@", "Test Target 1")
        
        if let t = try? context.fetch(r).first {
            XCTAssertEqual(t.wrappedVaccinations.count, 1)
            XCTAssert(t.wrappedVaccinations.first!.target!.name == "Test Target 1")
        } else {
            XCTFail("Missing Target")
        }
    }
        
        
    
    func testCoding() {
        
    }
}
