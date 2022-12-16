//
//  ContentView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var startNewTrack = false
    @State var previousRoute = false
    
    var body: some View {
        VStack {
            MapView()
                .overlay(alignment: .top) {
                    Button {
                        
                        previousRoute.toggle()
                        
                    } label: {
                        ZStack {
                            Capsule()
                                .foregroundColor(.blue)
                                .frame(width: 70, height: 70)
                            
                            Image(systemName: "flag.2.crossed")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 70)
                }
                .overlay(alignment: .bottom) {
                    Button {
                        withAnimation {
                            startNewTrack.toggle()
                        }
                    } label: {
                        HStack {
                            if startNewTrack || previousRoute {
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 70)
                                    
                                    Text(previousRoute ? "time: 1:59, distance: 1.4 km" : "time: 1:59" )
                                        .foregroundColor(.black)
                                        .font(previousRoute ? .title3 : .title)
                                        .fontWeight(.bold)
                                }
                            }
                            if !previousRoute {
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.blue)
                                        .frame(width: startNewTrack ? 100 : UIScreen.main.bounds.width / 1.1, height: 70)
                                    
                                    Text(startNewTrack ? "Stop" : "GO")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .animation(nil)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: startNewTrack ? .trailing : .center)
                    .padding(.horizontal)
                    .padding(.vertical, 70)
                    .disabled(previousRoute)
                }
                .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
