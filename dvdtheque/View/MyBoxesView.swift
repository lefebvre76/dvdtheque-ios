//
//  MyBoxes.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import CoreData

struct MyBoxesView: View {
    @StateObject var myBoxesViewModel: MyBoxesViewModel

    var body: some View {
        AuthContainerView(authContainerViewModel: myBoxesViewModel) {
            if myBoxesViewModel.boxes.isEmpty, !myBoxesViewModel.loading, myBoxesViewModel.searchText == "" {
                NavigationView {
                    VStack {
                        Spacer()
                        Text(myBoxesViewModel.isWishlist ? "wishlist.is_empty" : "boxes.is_empty").multilineTextAlignment(.center).padding()
                        Spacer()
                    }
                    .navigationTitle(myBoxesViewModel.isWishlist ? "menu.wishlist" : "menu.boxes")
                }
            } else {
                NavigationStack {
                    if myBoxesViewModel.boxes.isEmpty, !myBoxesViewModel.loading {
                        Text("general.no_result_for_search".localized(arguments: myBoxesViewModel.searchText)).padding()
                    }
                    List {
                        ForEach(myBoxesViewModel.boxes, id: \.id) { box in
                            NavigationLink(destination: BoxView(boxViewModel: BoxViewModel(lightBox: box, completion: myBoxesViewModel.loadData)).toolbar(.hidden, for: .tabBar)) {
                                BoxItemView(box: box).swipeActions {
                                    Button {
                                        myBoxesViewModel.launchDeleteItem(box: box)
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 20))
                                        Text("general.delete")
                                    }.tint(.red)
                                    
                                    Button {
                                        myBoxesViewModel.addToWishlist(box: box)
                                    } label: {
                                        Image(systemName: "plus")
                                            .font(.system(size: 20))
                                        Text(myBoxesViewModel.isWishlist ? "menu.boxes" : "menu.wishlist")
                                    }
                                }
                            }
                        }
                        .listRowSeparator(.hidden,
                                          edges: .all)
                        if myBoxesViewModel.showLoadMore {
                            LoadView().onAppear {
                                myBoxesViewModel.loadMoreData()
                            }.listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .searchable(text: $myBoxesViewModel.searchText)
                    .refreshable {
                        myBoxesViewModel.loadData()
                    }
                    .onChange(of: myBoxesViewModel.searchText) { _, newValue in
                        if newValue == "" {
                            myBoxesViewModel.loadData()
                        } else {
                            myBoxesViewModel.runSearch()
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle(myBoxesViewModel.isWishlist ? "menu.wishlist" : "menu.boxes")
                    .confirmationDialog(
                        Text("box.delete_confirmation".localized(arguments: "\(myBoxesViewModel.toBeDeleted?.title ?? "")")),
                        isPresented: $myBoxesViewModel.showingDeleteAlert,
                        titleVisibility: .visible
                    ) {
                        Button("general.delete", role: .destructive) {
                            withAnimation {
                                myBoxesViewModel.deleteItem()
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            myBoxesViewModel.loadData()
        }
    }
}

#Preview {
    MyBoxesView(myBoxesViewModel: MyBoxesViewModel())
}
