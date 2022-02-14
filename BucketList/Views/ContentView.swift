//
//  ContentView.swift
//  BucketList
//
//  Created by Dante Cesa on 2/10/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.white)
                                .background(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedLocation = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.25)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(.black.opacity(0.75))
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedLocation) { place in
                EditView(location: place) { newLocation, action in
                    if action == "Save" {
                        viewModel.updateLocation(location: newLocation)
                    } else if action == "Delete" {
                        viewModel.deleteLocation(place: newLocation)
                    }
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .alert("Cannot authenticate", isPresented: $viewModel.showAutenticationError) {
                Button("OK") { }
            } message: {
                Text(viewModel.authenticationErrorMessage)
            }
        }
    }
}

extension FileManager {
    static func readData(_ fileName: String) throws -> String {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        return try String(contentsOf: url)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
