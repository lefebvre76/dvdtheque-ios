//
//  CelebrityItemView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 19/12/2023.
//

import SwiftUI
import SwiftData

struct CelebrityItemView: View {
    var celebrity: Celebrity

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: celebrity.photo?.thumbnail ?? ""), content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipped()
                    .cornerRadius(50)
            },
                       placeholder: {
                HStack {
                    Image(systemName: "person.circle")
                        .font(.system(size: 75))
                        .padding(.bottom, 2)
                }
                .frame(width: 75, height: 75)
            })
            
            Text("\(celebrity.name)").lineLimit(2).frame(width: 110).multilineTextAlignment(.center)
        }
        .padding(5)
        
    }
}

#Preview {
    CelebrityItemView(celebrity: Celebrity(id: 1, name: "Tom Hanks", photo: Illustration(original: "https://image.tmdb.org/t/p/w300_and_h450_bestv2/xndWFsBlClOJFRdhSt4NBwiPq2o.jpg", thumbnail: "https://image.tmdb.org/t/p/w90_and_h90_face/xndWFsBlClOJFRdhSt4NBwiPq2o.jpg")))
}

#Preview {
    CelebrityItemView(celebrity: Celebrity(id: 1, name: "Malcolm McDowell", photo: nil))
}
