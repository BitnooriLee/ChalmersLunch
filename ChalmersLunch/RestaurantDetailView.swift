//
//  RestaurantDetailView.swift
//  ChalmersLunch
//
//  Created by Bitnoori Lee on 2022-04-07.
//


import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    
    var body: some View {
        Group {
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                
           //     Text("\(restaurant.elevation)m")
                    .font(.title3)
            }
            VStack {
                Text("Snow")
                    .font(.caption.bold())
             //   Text("\(restaurant.snowDepth)cm")
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct SkuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(restaurant: Restaurant.example)
    }
}
