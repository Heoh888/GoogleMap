//
//  AuthorizationsView.swift
//  GoogleMap
//
//  Created by Алексей Ходаков on 09.01.2023.
//

import SwiftUI
import RxSwift
import RxCocoa

struct AuthorizationsView: View {
    
    @StateObject var mapData = MainViewModel()
    @StateObject var viewModel: AuthorizationsViewModel
    @State var userName = ""
    @State var email = ""
    @State var password = ""
    @State var showLoginView = true
    @State var showRegistrationView = false
    
    var props: Properties
    
    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapData)
            HStack {
                LoginView(userName: $userName, password: $password)
                    .frame(width: getRect().width)
                RegistrationView(userName: $userName, password: $password, email: $email)
                    .frame(width: getRect().width)
            }
            .offset(x: showLoginView ?  getRect().width / 2 : -getRect().width / 2)
        }
        .overlay(alignment: .bottom) {
            HStack {
                buttonLogin()
                buttonRegistration()
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func buttonLogin() -> some View {
        ZStack {
            Button {
                withAnimation {
                    if !showLoginView {
                        showRegistrationView.toggle()
                        showLoginView.toggle()
                    } else {
                        viewModel.login(userName: userName, password: password)
                    }
                }
            } label: {
                HStack {
                    if showLoginView {
                        Text("Login")
                            .font(.system(size: 17, weight: .bold))
                    }
                    Image(systemName: "rectangle.righthalf.inset.filled.arrow.right")
                        .font(.system(size: 30, weight: .bold))
                }
            }
            .frame(width: showLoginView ? 200 : 70, height: 70)
            .background(showLoginView ? Color.blue : Color.gray)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    func buttonRegistration() -> some View {
        ZStack {
            Button {
                withAnimation {
                    if !showRegistrationView {
                        showRegistrationView.toggle()
                        showLoginView.toggle()
                    } else {
                        viewModel.registration(userName: userName, email: email, password: password)
                    }
                }
            } label: {
                HStack {
                    if showRegistrationView {
                        Text("Registration")
                            .font(.system(size: 17, weight: .bold))
                    }
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(.system(size: 30, weight: .bold))
                }
            }
            .frame(width: showRegistrationView ? 200 : 70, height: 70)
            .background(showRegistrationView ? Color.blue : Color.gray)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
        .padding(.bottom, 30)
    }
}

struct AuthorizationsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
