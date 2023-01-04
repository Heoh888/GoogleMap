//
//  MainView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 30.12.2022.
//

import SwiftUI
import GoogleMaps

struct MainView: View {
    
    @State var startNewTrack = false
    @State var previousRoute = false
    @State var locationManager = CLLocationManager()
    @StateObject var viewModel = MainViewModel()
    
    var props: Properties
    
    var body: some View {
        VStack {
            MapView()
                .environmentObject(viewModel)
        }
        .overlay(alignment: .top) {
            if !props.isLandscape {
                bottompReviousRoute()
            }
        }
        .overlay(alignment: .bottom) {
            bottomStartNewTrack()
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func bottompReviousRoute() -> some View {
        VStack {
            Button {
                if !startNewTrack {
                    viewModel.getPreviousResult()
                    withAnimation {
                        previousRoute.toggle()
                    }
                    if !previousRoute {
                        viewModel.mapClear()
                        viewModel.viewManager = .default
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: props.isLandscape ? 70 : 50)
                    
                    Image(systemName: !startNewTrack ? "flag.2.crossed" : "camera")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity, alignment: props.isLandscape ? .trailing : .leading)
            .padding(.horizontal)
            .padding(.vertical, props.isLandscape ? 20 : 50)
        }
    }
    
    @ViewBuilder
    func bottomStartNewTrack() -> some View {
        VStack {
            Button {
                if startNewTrack {
                    viewModel.saveResult()
                    viewModel.viewManager = .default
                    viewModel.mapClear()
                } else {
                    viewModel.viewManager = .startNewTrack
                }
                viewModel.time = -1
                viewModel.routeTime = ""
                withAnimation {
                    startNewTrack.toggle()
                }
            } label: {
                HStack {
                    if props.isLandscape {
                        bottompReviousRoute()
                    }
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
                            
                            Text(previousRoute ? "time: \(viewModel.previousResultTime), distance: \(viewModel.previousResultDistance)" : "time: \(viewModel.routeTime)" )
                                .onReceive(viewModel.timer, perform: { imput in
                                    viewModel.time += 1
                                    viewModel.timer(seconds: viewModel.time)
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
                                .frame(width: startNewTrack || props.isLandscape ? 70 : UIScreen.main.bounds.width / 1.1, height: 70)
                            
                            Text(startNewTrack ? "Stop" : "GO")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .animation(nil)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: startNewTrack || props.isLandscape ? .trailing : .center)
            .padding(.horizontal, !props.isLandscape ? 25 : 50)
            .padding(.bottom, !props.isLandscape ? 50 : 20)
        }
    }
}

