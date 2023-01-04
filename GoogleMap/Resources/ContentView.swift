//
//  ContentView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    var body: some View {
        VStack {
            ResponsiveView { props in
                MainView(props: props)
            }
        }
    }
}
