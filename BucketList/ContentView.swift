//
//  ContentView.swift
//  BucketList
//
//  Created by Dante Cesa on 2/10/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State var locations: [Location] = []
    
    @State private var selectedLocation: Location?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
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
                        selectedLocation = location
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
                        let newLocation = Location(id: UUID(), name: "Empty Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        
                        locations.append(newLocation)
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
        .sheet(item: $selectedLocation) { place in
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    locations[index] = newLocation
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
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
