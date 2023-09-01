//
//  LocationSearchActivationView.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/07.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("Where to ?")
                .foregroundColor(Color(.darkGray))
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 34, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
                .shadow(color: .black, radius: 6)
        )
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
