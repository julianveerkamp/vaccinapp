//
//  VaccinePass+CoreDataClass.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//
//

import Foundation
import CoreData

enum GenericError: Error {
    case todo
}

@objc(VaccinationPass)
public class VaccinationPass: NSManagedObject, Decodable {
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { throw GenericError.todo }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "VaccinationPass", in: context) else { throw GenericError.todo }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedName = try container.decode(String.self, forKey: .name)
        self.name = findSuitableName(decodedName, in: context)
        
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? "none"
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? "human"
        self.dob = try container.decodeIfPresent(Date.self, forKey: .dob) ?? Date.now
        let vaccinationArray = try container.decode([Vaccination].self, forKey: .vaccinations)
        self.vaccines = NSSet(array: vaccinationArray)
    }
    
    private func findSuitableName(_ name: String, in context: NSManagedObjectContext, depth: Int = 0) -> String {
        var newName = name
        
        if depth > 0 {
            newName = "\(name)-\(depth)"
        }
        
        let request = VaccinationPass.getByName(newName)
        request.fetchLimit = 1
        
        if (try? context.fetch(request).first) != nil {
            print("Pass found with name=\(newName), trying next option")
            return findSuitableName("\(name)", in: context, depth: depth+1)
        } else {
            return newName
        }
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
 }
