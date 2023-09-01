//
//  LocationSearchView.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
            //header view
            
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField("  Current location", text: $startLocationText)
                        .frame(height: 42)
                        .background(Color(.systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    TextField("  Where to? ", text: $viewModel.queryFragment)
                        .frame(height: 42)
                        .background(Color(.systemGray4))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                }
            }
            .padding(.horizontal)
            .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            //list
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
        }
        .background(Color.theme.backgroundColor)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation))
    }
}
