//
//  MyMoviesView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI
import CoreData

struct MyMoviesView: View {
    @StateObject var myMoviesViewModel: MyMoviesViewModel

    var body: some View {
        AuthContainerView(authContainerViewModel: myMoviesViewModel) {
            if myMoviesViewModel.movies.isEmpty, !myMoviesViewModel.loading, myMoviesViewModel.searchText == "" {
                NavigationView {
                    VStack {
                        Spacer()
                        Text("boxes.is_empty").multilineTextAlignment(.center).padding()
                        Spacer()
                    }
                    .navigationTitle("menu.movies")
                }
            } else {
                NavigationStack {
                    if myMoviesViewModel.movies.isEmpty, !myMoviesViewModel.loading {
                        Text("general.no_result_for_search".localized(arguments: myMoviesViewModel.searchText)).padding()
                    }
                    List {
                        ForEach(myMoviesViewModel.movies, id: \.id) { movie in
                            NavigationLink(destination: MovieView(movieViewModel: MovieViewModel(lightBox: movie)).toolbar(.hidden, for: .tabBar)) {
                                BoxItemView(box: movie)
                            }
                        }
                        .listRowSeparator(.hidden,
                                          edges: .all)
                        if myMoviesViewModel.showLoadMore {
                            LoadView().onAppear {
                                myMoviesViewModel.loadMoreData()
                            }.listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .searchable(text: $myMoviesViewModel.searchText)
                    .navigationTitle("menu.movies")
                    .refreshable {
                        myMoviesViewModel.loadData()
                    }
                    .onChange(of: myMoviesViewModel.searchText) { _, newValue in
                        if newValue == "" {
                            myMoviesViewModel.loadData()
                        } else {
                            myMoviesViewModel.runSearch()
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear() {
            myMoviesViewModel.loadData()
        }
    }
}

#Preview {
    MyMoviesView(myMoviesViewModel: MyMoviesViewModel())
}
