//
//  CelebrityItemView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 19/12/2023.
//

import SwiftUI
import SwiftData

struct CelebrityItemView: View {
    var name: String

    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .font(.system(size: 50))
                .padding(.bottom, 2)
            Text("\(name)").lineLimit(2).frame(minWidth: 100, maxWidth: 150)
        }
        .padding(5)
        
    }
}

#Preview {
    CelebrityItemView(name: "Tom Hanks")
}
