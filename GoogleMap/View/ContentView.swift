//
//  ContentView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 15.12.2022.
//

import SwiftUI

struct ContentView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var time = 0
    @State var startNewTrack = false
    @State var previousRoute = false
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            MapView()
            //                .animation(nil)
        }
        .overlay(alignment: .top) {
            bottompReviousRoute()
        }
        .overlay(alignment: .bottom) {
            bottomStartNewTrack()
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func bottompReviousRoute() -> some View {
        VStack {
            if !startNewTrack {
                Button {
                    withAnimation {
                        previousRoute.toggle()
                    }
                } label: {
                    ZStack {
                        Capsule()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "flag.2.crossed")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 70)
            }
        }
    }
    
    @ViewBuilder
    func bottomStartNewTrack() -> some View {
        VStack {
            Button {
                if startNewTrack {
                    viewModel.saveResult()
                }
                time = -1
                viewModel.routeTime = ""
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
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, dash: [2]))
                                )
                            
                            Text(previousRoute ? "time: 1:59, distance: 1.4 km" : "time: \(viewModel.routeTime)" )
                                .onReceive(timer, perform: { imput in
                                    time += 1
                                    viewModel.timer(seconds: time)
                                })
                                .foregroundColor(.black)
                                .font(previousRoute ? .title3 : .title2)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
