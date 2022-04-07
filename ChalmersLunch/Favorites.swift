//
//  Favorites.swift
//  ChalmersLunch
//
//  Created by Bitnoori Lee on 2022-04-04.
//

import Foundation

class Favorites: ObservableObject {
    private var restaurants: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        restaurants = []
    }
    func contains(_ resort: Restaurant) -> Bool {
        restaurants.contains(restaurant.id)
    }
    
    func add(_ restaurant: Restaurant) {
        objectWillChange.send()
        restaurants.insert(restaurant.id)
        save()
    }
    
    func remove(_ restaurant: Restaurant) {
        objectWillChange.send()
        restaurants.insert(restaurant.id)
        save()
    }
    func save() {
        
    }
}
