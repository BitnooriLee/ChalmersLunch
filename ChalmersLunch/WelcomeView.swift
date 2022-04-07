//
//  WelcomeView.swift
//  ChalmersLunch
//
//  Created by Bitnoori Lee on 2022-04-04.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to ChalmersLunch!")
                .font(.largeTitle)
            
            Text("Please select a restaurant from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
