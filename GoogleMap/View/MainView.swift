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
                VStack {
                    VStack(spacing: 15) {
                        buttonReviousRoute()
                        buttonMyLocation()
                    }
                    .padding(.leading)
                    .frame(maxWidth: getRect().width, alignment: .leading)
                    .padding(.top, 50)
                    Spacer()
                    
                    bottomStartNewTrack()
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                }
            } else {
                HStack(spacing: 15) {
                    buttonMyLocation()
                    buttonReviousRoute()
                    bottomStartNewTrack()
                }
                .frame(maxWidth: getRect().width, maxHeight: getRect().height, alignment: .bottomTrailing)
                .padding(20)
            }
            
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func button(image: String) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: props.isLandscape ? 70 : 50)
            
            Image(systemName: image)
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.bold)
        }
    }
    
    @ViewBuilder
    func buttonMyLocation() -> some View {
        VStack {
            Button {
                viewModel.myLocation()
            } label: {
                button(image: "location.circle.fill")
            }
        }
    }
    
    @ViewBuilder
    func buttonReviousRoute() -> some View {
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
                button(image: !startNewTrack ? "flag.2.crossed" : "camera")
            }
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
                                .frame(width: startNewTrack || props.isLandscape ? 70 : getRect().width / 1.1, height: 70)
                            
                            Text(startNewTrack ? "Stop" : "GO")
                                .foregroundColor(.white)
                                .font(startNewTrack ? .title2 : .title)
                                .fontWeight(.bold)
                                .animation(nil)
                        }
                    }
                }
            }
        }
    }
}

