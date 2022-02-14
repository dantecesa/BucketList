//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Dante Cesa on 2/11/22.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedLocation: Location?
        @Published var isUnlocked: Bool = false
        
        @Published var authenticationErrorMessage: String = ""
        @Published var showAutenticationError: Bool = false
        
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
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "You need to authenticate to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        Task { @MainActor in
                            self.authenticationErrorMessage = "Sorry, we could not authenticate you. Please try again."
                            self.showAutenticationError = true
                        }
                    }
                }
            } else {
                self.authenticationErrorMessage = "Sorry, your device does not have biometrics."
                self.showAutenticationError = true
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "Empty Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
            save()
        }
        
        func deleteLocation(place: Location) {
            guard let index = locations.firstIndex(of: place) else { return }
            print("We found the item to delete!")
            locations.remove(at: index)
            print("We've deleted it!")
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
