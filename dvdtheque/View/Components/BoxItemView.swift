//
//  BoxItemView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import SwiftData

struct BoxItemView: View {
    var box: LigthBox

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: box.illustration.thumbnail), content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipped()
            },
                       placeholder: {
                HStack {
                    Image(systemName: "opticaldisc")
                        .font(.largeTitle)
                }
                .frame(width: 75, height: 75)
            })
            VStack {
                Text(box.title).frame(maxWidth: .infinity, alignment: .leading).bold().padding(.top, 2)
                Spacer()
            }.frame(maxWidth: .infinity, minHeight: 75)
            Spacer()
        }
    }
}

#Preview {
    BoxItemView(box: LigthBox(id: 1, type: "BRD", title: "Jurassic Park Collection", illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg")))
}
