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
    
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredRestaurants) { restaurant in
                NavigationLink {
                    RestaurantView(restaurant:  restaurant)
                } label: {
                    HStack{
                    Image(restaurant.country)
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
                        Text("\(restaurant.count) menu")
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
