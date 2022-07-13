//
//  UpdateNetworkController.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 22.06.22.
//

import Foundation
import Combine

class UpdateNetworkController: ObservableObject, UpdateService {
    var session: APIService
    var cancellables = [AnyCancellable]()
    let persistence: PersistenceController
    
    init(session: APIService = APISession(), persistence: PersistenceController = PersistenceController.shared) {
        self.session = session
        self.persistence = persistence
    }
    
    func update() {
        let cancellable = self.update()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
            }) { (result) in
                let context = self.persistence.container.newBackgroundContext()
                
                for item in result.items {
                    self.persistence.addNewTarget(item, context: context)
                }
                do {
                    try context.save()
                }
                catch {
                    print(error)
                    context.rollback()
                }
            }
        cancellables.append(cancellable)
    }
}
