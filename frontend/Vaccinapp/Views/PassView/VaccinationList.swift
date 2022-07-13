//
//  VaccinationList.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 02.05.22.
//

import Foundation
import SwiftUI
import CoreData

class VaccinationListController: NSObject, ObservableObject {
    @Published var vaccinations = [Vaccination]()
    
    var persistence: PersistenceController
    
    init(pass wrappedPass: Optional<VaccinationPass>) {
        self.persistence = PersistenceController.shared
        super.init()
        if let pass = wrappedPass {
            vaccinations = pass.wrappedVaccines
        }
    }
}

extension VaccinationListController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        vaccinations = controller.fetchedObjects as? [Vaccination] ?? []
    }
}

struct VaccinationList: View {
    @ObservedObject var controller: VaccinationListController
    
    var body: some View {
        if controller.vaccinations.count > 0 {
            List {
                ForEach(controller.vaccinations) { item in
                    NavigationLink {
                        VaccinationDetail(item: item)
                    } label: {
                        Text(item.target?.name ?? "Unknown Vaccine")
                        if item.valid {
                            EmptyView()
                        } else {
                            Spacer()
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
                .onAppear {
                    controller.persistence.container.viewContext.refreshAllObjects()
                    controller.vaccinations.forEach({$0.validate()})
                }
            }
        } else {
            Text("Add some new Vaccinations to get started.")
                .fontWeight(.semibold)
                .font(.system(size: 30))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.systemGray4))
                .padding()
                .padding([.bottom], 50)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { controller.vaccinations[$0] }.forEach(controller.persistence.container.viewContext.delete)
            
            do {
                try controller.persistence.container.viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
