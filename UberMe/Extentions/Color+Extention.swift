//
//  Color+Extention.swift
//  UberMe
//
//  Created by Prakash Bist on 2023/08/08.
//

import SwiftUI


extension Color {
    static let theme = ColorTheme()
}
struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
}
