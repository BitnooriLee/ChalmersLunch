//
//  ContentView.swift
//  ChalmersLunch
//
//  Created by Bitnoori Lee on 2022-04-04.
//

import SwiftUI



struct ContentView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var restaurant: Restaurant
    var onSave: (Restaurant) -> Void
    
    @State private var name: String
    @State private var description: String
    @State private var restaurants = [Restaurant]()
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(pages, id: \.pageid) {
                            page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save"){
                    var newRestaurant = restaurant
                 //   newRestaurant.id = UUID()
                   // newRestaurant.name = name
                   // newRestaurant.description = description
                    onSave(newRestaurant)
                    dismiss()
                }
            }
            .task {
                await fetchData()
            }
        }
    }
        
        init(restaurant:Restaurant, onSave: @escaping (Restaurant)-> Void) {
            self.restaurant = restaurant
            self.onSave = onSave
        //    _name = State(initialValue: restaurant.name)
        //    _description = State(initialValue: restaurant.description)
        }
        
        func fetchData() async {
            let urlString = "http://carbonateapiprod.azurewebsites.net/api/v1/mealprovidingunits/\(restaurants[0].mealProvidingUnitID)/dishoccurrences"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                
                
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode(Restaurant.self, from: data) {
                    restaurants = decodedResponse.restaurants
                }
                
             //   let items = try JSONDecoder().decode(Result.self, from: data)
            //    pages = items.query.pages.values.sorted()
            //    loadingState = .loaded
            } catch {
             //   loadingState = .failed
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(restaurant: Restaurant.example) { _ in }
    }
}
