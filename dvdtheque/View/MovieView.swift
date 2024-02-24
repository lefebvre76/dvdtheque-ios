//
//  MovieView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI
import CoreData

struct MovieView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var movieViewModel: MovieViewModel
    @State var opacity = 0.0
    @State var navBarButtonColor = Color.black

    var body: some View {
        AuthContainerView(authContainerViewModel: movieViewModel) {
            if let movie = movieViewModel.movie {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    VStack() {
                        MovieDetailView(movie: movie, opacity: $opacity).padding(.bottom, 1)
                    }
                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                        }.tint(navBarButtonColor)
                        Spacer()
                        Text("\(movie.title)").bold().opacity(Double(opacity))
                        Spacer()
                    }.padding()
                        .background(Color(UIColor.systemBackground).opacity(Double(opacity)))
                        .onChange(of: opacity) { _, value in
                            withAnimation {
                                if opacity < 0.25 {
                                    navBarButtonColor = .black
                                } else {
                                    navBarButtonColor = Color(uiColor: UIColor.label)
                                }
                            }
                        }
                }).navigationBarHidden(true)
            }
        }.onAppear {
            movieViewModel.loadData()
        }
    }
}

#Preview {
    MovieView(movieViewModel: MovieViewModel(lightBox: 
                                                LightBox(id: 1, type: "BRD", title: "Batman", illustration: Illustration(original: "", thumbnail: ""), loaned: false)))
}
