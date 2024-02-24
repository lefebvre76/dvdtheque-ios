//
//  PrimaryButton.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 45)
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(30)
    }
}
