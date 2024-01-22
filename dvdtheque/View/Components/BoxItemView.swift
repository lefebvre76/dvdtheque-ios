//
//  BoxItemView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import SwiftData

struct BoxItemView: View {
    var box: LightBox

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
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(box.title).multilineTextAlignment(.leading).frame(maxWidth: .infinity, alignment: .leading).lineLimit(2).bold()
                    
                }.frame(maxWidth: .infinity)
                Spacer()
                HStack {
                    Image("\(box.type)")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(uiColor: UIColor.label))
                        .frame(height: 25)
                    Spacer()
                    if box.loaned {
                        Text("box.loaned").italic().padding(.trailing)
                    }
                }
            }.frame(maxWidth: .infinity, minHeight: 75, maxHeight: 75).padding(.vertical, 2)
        }.accentColor(Color(uiColor: UIColor.label))
    }
}

#Preview {
    BoxItemView(box: LightBox(id: 1, type: "BRD", title: "Jurassic Park Collection", illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"), loaned: false))
}

#Preview {
    BoxItemView(box: LightBox(id: 1, type: "BRD", title: "Jurassic Park Collection", illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"), loaned: true))
}
