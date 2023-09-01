//
//  HomeView.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import SwiftUI

struct HomeView: View {
    
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                } else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                ActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 5)
            }
            
            if mapState == .locationSelected || mapState == .lineAdded{
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                viewModel.userLocation = location
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
