//
//  ContentView.swift
//  ChalmersLunch
//
//  Created by Bitnoori Lee on 2022-04-04.
//

import SwiftUI


extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}


struct ContentView: View {
    
    let restaurantIDmap : [String: String]  = ["Kårrestaurangen":
                                            "21f31565-5c2b-4b47-d2a1-08d558129279",
                                        "Express Johanneberg": "3d519481-1667-4cad-d2a3-08d558129279",
                                          "Hyllan":
                                            "a7f0f75b-c1cb-4fc3-d2a6-08d558129279",
                                        "Linsen":
                                            "b672efaf-032a-4bb8-d2a5-08d558129279",
                                        "SMAK":
                                            "3ac68e11-bcee-425e-d2a8-08d558129279",
                                        "L's Kitchen":
                                            "c74da2cf-aa1a-4d3a-9ba6-08d5569587a1",
                                        "L´s Resto":
                                            "c6742862-3cc5-47b1-d2a4-08d558129279",
                                        "Kokboken":
                                            "4dce0df9-c6e7-46cf-d2a7-08d558129279",
                           ]

    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var restaurant: Restaurant
    var onSave: (Restaurant) -> Void
    
   // @State private var name: String
   // @State private var description: String
    @State private var restaurants = [Restaurant]()
    
    @State private var loadingState = LoadingState.loading
    
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredRestaurants) { restaurant in
                NavigationLink {
                    RestaurantView(restaurant:  restaurant)
                } label: {
                    HStack{
                    Image("Kårrestaurangen_1") //need to fix
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        }
                    
                    VStack(alignment: .leading) {
                        Text(restaurants[0].mealProvidingUnit.mealProvidingUnitName)
                            .font(.headline)
                        Text("\(restaurants.count) menu")
                            .foregroundColor(.secondary)
                    }
                    if favorites.contains(restaurant) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite restaurant")
                            .foregroundColor(.red)
                    }
                        
                    }
                    
                }
            }
        .navigationTitle("Restaurant")
        .searchable(text: $searchText, prompt: "Search for a restaurant")
        .task {
                    await fetchData()
                }
            
        WelcomeView()
            
        }
        .environmentObject(favorites)
    }
    
    var filteredRestaurants: [Restaurant] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter {
                $0.mealProvidingUnit.mealProvidingUnitName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }


      
       // init(restaurant:Restaurant, onSave: @escaping (Restaurant)-> Void) {
        //    self.restaurant = restaurant
        //    self.onSave = onSave
        //    _name = State(initialValue: restaurant.name)
        //    _description = State(initialValue: restaurant.description)
        //}
        
        func fetchData() async {
            let urlString = "http://carbonateapiprod.azurewebsites.net/api/v1/mealprovidingunits/\(restaurants[0].mealProvidingUnitID)/dishoccurrences"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode(Restaurants.self, from: data) {
                    restaurants = decodedResponse.results
                }
                
             //   let items = try JSONDecoder().decode(Result.self, from: data)
            //    pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(restaurant: Restaurant.example) { _ in }
        
        
    }
}
