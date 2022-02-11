//
//  EditView.swift
//  BucketList
//
//  Created by Dante Cesa on 2/10/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name: String
    @State private var description: String
    
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Name", text: $name)
                } header: {
                    Text("Name")
                }
                Section {
                    TextEditor(text: $description)
                } header: {
                    Text("Description")
                }
            }
            .navigationTitle("Place Details…")
            .toolbar {
                Button("Save") {
                    let newLocation = Location(id: UUID(), name: name, description: description, latitude: location.latitude, longitude: location.longitude)
                    onSave(newLocation)
                    
                    dismiss()
                }
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { newLocation in }
    }
}
