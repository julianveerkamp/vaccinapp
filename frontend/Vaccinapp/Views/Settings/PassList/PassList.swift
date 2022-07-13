//
//  PassList.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 10.05.22.
//

import SwiftUI

struct PassList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VaccinationPass.name, ascending: true)],
        animation: .default)
    private var passes: FetchedResults<VaccinationPass>
    
    @State private var name = ""
    
    var body: some View {
        List {
            ForEach(passes) { item in
                NavigationLink {
                    PassDetail(item)
                } label: {
                    Text("\(item.wrappedType.emoji)   \(item.name)")
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Passes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddPassWrapper()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { passes[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print(nsError)
            }
        }
    }
}
