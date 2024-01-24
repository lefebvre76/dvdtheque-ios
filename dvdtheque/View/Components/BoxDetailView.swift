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
    @Binding var opacity: Double
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let illustrationHeight = CGFloat(300)

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: box.illustration.original), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)

                    },
                               placeholder: {
                        Image(systemName: "opticaldisc")
                            .font(.system(size: 60))
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    })
                }.background(.white)
                    .offset(y: -geometry.frame(in: .global).minY)
                    .frame(width: UIScreen.main.bounds.width,
                           height: (geometry.frame(in: .global).minY > 0 ? geometry.frame(in: .global).minY : 0) + 300)
                    .onChange(of: geometry.frame(in: .global).minY) { _, value in
                        let offset = illustrationHeight + value
                        let start = safeAreaInsets.top + 44
                        let end = safeAreaInsets.top
                        if offset < start {
                            if offset > end {
                                opacity = 1 - Double((offset - end)/(start-end))
                                return
                            }
                            opacity = 1
                        } else {
                            opacity = 0
                        }
                    }
            }.frame(height: illustrationHeight)
            VStack(alignment: .leading, spacing: 15) {
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
                    
                    ExpandableText(box.synopsis, lineLimit: 3).frame(maxWidth: .infinity, alignment: .leading)
                    if box.directors.count > 0 {
                        Text(box.directors.count > 1 ? "box.directors" : "box.director").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: 20) {
                                ForEach(box.directors, id: \.id) { director in
                                    CelebrityItemView(celebrity: director)
                                }
                            }
                        }
                    }
                    if box.actors.count > 0 {
                        Text(box.actors.count > 1 ? "box.actors" : "box.actor").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: 20) {
                                ForEach(box.actors, id: \.id) { actor in
                                    CelebrityItemView(celebrity: actor)
                                }
                            }
                        }
                    }
                    if box.composers.count > 0 {
                        Text(box.composers.count > 1 ? "box.composers" : "box.composer").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: 20) {
                                ForEach(box.composers, id: \.id) { composer in
                                    CelebrityItemView(celebrity: composer)
                                }
                            }
                        }
                    }
                    if box.boxes.count > 0 {
                        Text("box.in_package").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20)
                        ForEach(box.boxes, id: \.id) { subBox in
                            NavigationLink(destination: BoxView(boxViewModel: BoxViewModel(lightBox: subBox, parent_box: box))) {
                                BoxItemView(box: subBox)
                            }
                        }

                    }
                    Spacer()
                }.padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
                .offset(y: -20)
            }
        }
        .ignoresSafeArea(.all)
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
                           directors: [Celebrity(id: 1, name: "Stevent Speilberg", photo: Illustration(original: "https://image.tmdb.org/t/p/w300_and_h450_bestv2/tZxcg19YQ3e8fJ0pOs7hjlnmmr6.jpg", thumbnail: "https://image.tmdb.org/t/p/w90_and_h90_face/tZxcg19YQ3e8fJ0pOs7hjlnmmr6.jpg"))],
                           actors: [], composers: [], boxes: [
                            LightBox(id: 2, type: "BRD", title: "Dark Shadows", illustration: Illustration(original: "http://localhost/storage/8/old-dark_shadows_bis_br.0.jpg", thumbnail: "http://localhost/storage/8/conversions/old-dark_shadows_bis_br.0-thumbnail.jpg"), loaned: false)
                           ], in_collection: true, in_wishlist: false, loans: []), opacity:  .constant(0)).preferredColorScheme(.dark)
}
