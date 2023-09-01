//
//  RideRequestView.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRide: RideType = .uberX
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top)
            
            HStack {
                VStack {
                    Circle()
                        .fill(Color.theme.secondaryBackgroundColor)
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color.theme.secondaryBackgroundColor)
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(Color.theme.primaryTextColor)
                        .frame(width: 6, height: 6)
                }
                
                VStack {
                    HStack {
                        Text("Current Location")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(viewModel.pickupTime ?? "")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        if let location = viewModel.selectedUberLocation {
                            Text(location.title)
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        
                        Text(viewModel.dropTime ?? "")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Text("Total Trip of \(viewModel.tripDistance ?? "0.0") Km")
                .foregroundColor(.gray)
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            Divider()
            
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) { type in
                        VStack(alignment: .center) {
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                            VStack {
                                Text(type.description)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                Text("\(viewModel.computeRidePrice(forType: type).toCurrency())")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(width: 122, height: 140)
                        .foregroundColor(type == selectedRide ? .white : Color.theme.primaryTextColor )
                        .background(type == selectedRide ? Color(.systemBlue) : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedRide ? 1.2 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRide = type
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.never)
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 1234")
                    .fontWeight(.semibold)
                
                Spacer()
                Image(systemName: "chevron.right")
                    .padding(.trailing)
            }
            .frame(height: 45)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button {
                
            } label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(.blue)
                    .cornerRadius(7)
                    .foregroundColor(.white)
            }

        }
        .padding(.bottom, 26)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}
