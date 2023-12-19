//
//  KindItemView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 19/12/2023.
//

import SwiftUI
import SwiftData

struct KindItemView: View {
    var name: String

    var body: some View {
        VStack {
            Text("\(name)")
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .foregroundColor(.white)
                
        }
        .background(.gray)
        .cornerRadius(10)
        
    }
}

#Preview {
    KindItemView(name: "Science-fiction")
}
