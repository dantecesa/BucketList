//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Dante Cesa on 2/13/22.
//

import SwiftUI

extension EditView {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @MainActor class ViewModel: ObservableObject {
        var location: Location
        
        @Published var name: String
        @Published var description: String
        
        @Published private(set) var loadingState = LoadingState.loading
        @Published private(set) var pages: [Page] = []
        
        
        init(location: Location) {
            self.location = location
            
            _name = Published(initialValue: location.name)
            _description = Published(initialValue: location.description)
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        func createNewLocation() -> Location {
            return Location(id: UUID(), name: name, description: description, latitude: location.latitude, longitude: location.longitude)
        }
    }
}
