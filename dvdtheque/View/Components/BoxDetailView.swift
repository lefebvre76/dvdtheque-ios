//
//  BoxDetailView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 20/12/2023.
//

import SwiftUI
import SwiftData

struct BoxDetailView: View {
    var box: Box

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            HStack {
                AsyncImage(url: URL(string: box.illustration.original), content: { image in
                    image.frame(height: 250)
                        .scaledToFill()
                        .clipped()
                },
                           placeholder: {
                    HStack {
                        Image(systemName: "opticaldisc")
                            .font(.largeTitle)
                    }
                    .frame(width: 75, height: 75)
                })
            }.frame(maxWidth: .infinity, idealHeight: 200)
            ScrollView(.vertical, showsIndicators: true) {
                Spacer().frame(height: 250)
                VStack {
                    Text(box.title).frame(maxWidth: .infinity, alignment: .leading).font(.title).padding(.bottom, 2)
                    if let edition = box.edition {
                        Text(edition).frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).padding(.bottom, 2)
                    }
                    HStack {
                        if box.year > 0 {
                            Text("\(box.year)")
                        }
                        Spacer()
                        Image("\(box.type)")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(uiColor: UIColor.label))
                            .frame(height: 25)
                    }.frame(maxWidth: .infinity)
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(box.kinds, id: \.id) { kind in
                                KindItemView(name: kind.name)
                            }
                        }
                    }.padding(.vertical)
                    Text("\(box.synopsis)").frame(maxWidth: .infinity, alignment: .leading)
                    if box.directors.count > 0 {
                        Text(box.directors.count > 1 ? "box.directors" : "box.director").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(box.directors, id: \.id) { director in
                                    CelebrityItemView(name: "\(director.name)")
                                }
                            }
                        }
                    }
                    if box.actors.count > 0 {
                        Text(box.actors.count > 1 ? "box.actors" : "box.actor").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(box.actors, id: \.id) { actor in
                                    CelebrityItemView(name: "\(actor.name)")
                                }
                            }
                        }
                    }
                    if box.composers.count > 0 {
                        Text(box.composers.count > 1 ? "box.composers" : "box.composer").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(box.composers, id: \.id) { composer in
                                    CelebrityItemView(name: "\(composer.name)")
                                }
                            }
                        }
                    }
                    if box.boxes.count > 0 {
                        Text("box.in_package").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ForEach(box.boxes, id: \.id) { subBox in
                            NavigationLink(destination: BoxView(boxViewModel: BoxViewModel(lightBox: subBox))) {
                                BoxItemView(box: subBox)
                            }
                        }
                        
                    }
                    Spacer()
                }.padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(.background)
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    BoxDetailView(box: Box(id: 1,
                           type: "BRD",
                           title: "Jurassic Park Collection",
                           original_title: nil,
                           year: 2015,
                           synopsis: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse lacus ligula, hendrerit et sagittis vel, vehicula ac quam. Vestibulum suscipit pellentesque lorem non varius. Quisque malesuada tortor mi, auctor convallis felis aliquet ac. Nulla neque dui, semper sed bibendum vel, molestie ut mauris. Morbi convallis auctor convallis. Suspendisse blandit ullamcorper libero mollis efficitur. Curabitur facilisis a ligula vitae egestas. Suspendisse consectetur mi vel sem efficitur finibus at in eros. Pellentesque pellentesque nibh vel metus condimentum, sit amet mollis nisi dapibus. Nulla id imperdiet eros, et porta odio.",
                           edition: "",
                           editor: "",
                           illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"),
                           kinds: [Kind(id: 1, name: "Science Fiction"), Kind(id: 2, name: "Aventure")],
                           directors: [Celebrity(id: 1, name: "Stevent Speilberg")],
                           actors: [], composers: [], boxes: [
                                LightBox(id: 2, type: "BRD", title: "Dark Shadows", illustration: Illustration(original: "http://localhost/storage/8/old-dark_shadows_bis_br.0.jpg", thumbnail: "http://localhost/storage/8/conversions/old-dark_shadows_bis_br.0-thumbnail.jpg"))
                           ]))
}
