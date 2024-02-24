//
//  MovieDetailView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @Binding var opacity: Double
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let illustrationHeight = CGFloat(300)

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: movie.illustration.original), content: { image in
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
                    Text(movie.title).frame(maxWidth: .infinity, alignment: .leading).font(.title).padding(.bottom, 2).padding(.horizontal)
                    if let edition = movie.edition {
                        Text(edition).frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).padding(.bottom, 2).padding(.horizontal)
                    }
                    HStack {
                        if movie.year > 0 {
                            Text("\(movie.year)")
                        }
                        Spacer()
                        Image("\(movie.type)")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(uiColor: UIColor.label))
                            .frame(height: 25)
                    }.frame(maxWidth: .infinity).padding(.horizontal)
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(movie.kinds, id: \.id) { kind in
                                KindItemView(name: kind.name)
                            }
                        }.padding(.horizontal)
                    }.padding(.vertical)
                    
                    ExpandableText(movie.synopsis, lineLimit: 3).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    if movie.directors.count > 0 {
                        Text(movie.directors.count > 1 ? "box.directors" : "box.director").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20).padding(.horizontal)
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: 20) {
                                ForEach(movie.directors, id: \.id) { director in
                                    CelebrityItemView(celebrity: director)
                                }
                            }.padding(.horizontal)
                        }
                    }
                    if movie.actors.count > 0 {
                        Text(movie.actors.count > 1 ? "box.actors" : "box.actor").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20).padding(.horizontal)
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: 20) {
                                ForEach(movie.actors, id: \.id) { actor in
                                    CelebrityItemView(celebrity: actor)
                                }
                            }.padding(.horizontal)
                        }
                    }
                    if movie.composers.count > 0 {
                        Text(movie.composers.count > 1 ? "box.composers" : "box.composer").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20).padding(.horizontal)
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: 20) {
                                ForEach(movie.composers, id: \.id) { composer in
                                    CelebrityItemView(celebrity: composer)
                                }
                            }.padding(.horizontal)
                        }
                    }
                    if movie.parent_boxes.count > 0 {
                        Divider()
                        Text("movie.parent_packages").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 20).padding(.horizontal)
                        VStack {
                            ForEach(movie.parent_boxes, id: \.id) { box in
                                NavigationLink(destination: BoxView(boxViewModel: BoxViewModel(lightBox: box, parent_box: nil))) {
                                    BoxItemView(box: box)
                                }
                            }
                        }.padding()
                    }
                    Spacer()
                }.padding(.vertical)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
                .offset(y: -20)
            }
        }
        .ignoresSafeArea(.all)
    }
}
