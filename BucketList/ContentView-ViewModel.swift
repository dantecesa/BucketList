//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Dante Cesa on 2/11/22.
//

import Foundation
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedLocation: Location?
        
        let savePath: URL = FileManager.documentsDirectory.appendingPathComponent("savedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try? JSONEncoder().encode(locations)
                try data?.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Something went wrong trying to save places.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "Empty Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedLocation = selectedLocation else { return }
            
            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }
    }
}
