//
//  EditView.swift
//  BucketList
//
//  Created by Dante Cesa on 2/10/22.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location, String) -> Void
    
    init(location: Location, onSave: @escaping (Location, String) -> Void) {
        self.viewModel = ViewModel(location: location)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Name") {
                    TextField("Name", text: $viewModel.name)
                }
                
                Section("Description") {
                    TextEditor(text: $viewModel.description)
                }
                
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        ForEach(viewModel.pages, id:\.pageid) { page in
                            VStack(alignment: .leading) {
                                Text(page.title)
                                    .font(.headline)
                                Text(page.description)
                                    .foregroundColor(.secondary)
                            }
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
                Button(role: .destructive, action: {
                    onSave(viewModel.location, "Delete")
                    
                    dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Remove this item")
                    }
                })
            }
            .navigationTitle("Place Details…")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newLocation = viewModel.createNewLocation()
                        onSave(newLocation, "Save")
                        
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { newLocation, String in }
    }
}
