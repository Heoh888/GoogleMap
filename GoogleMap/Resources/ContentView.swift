//
//  ContentView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    @StateObject var viewModel = AuthorizationsViewModel()
    
    var body: some View {
        VStack {
            ResponsiveView { props in
                if viewModel.userLoggedIn {
                    MainView(props: props)
                } else {
                    AuthorizationsView(viewModel: viewModel, props: props)
                }
            }
        }
    }
}
