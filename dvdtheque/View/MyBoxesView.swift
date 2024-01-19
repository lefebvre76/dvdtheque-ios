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
            if myBoxesViewModel.boxes.isEmpty, !myBoxesViewModel.loading {
                NavigationView {
                    VStack {
                        Text(myBoxesViewModel.isWishlist ? "wishlist.is_empty" : "boxes.is_empty")
                        Spacer()
                    }
                    .navigationTitle(myBoxesViewModel.isWishlist ? "menu.wishlist" : "menu.boxes")
                }
            } else {
                NavigationStack {
                    List {
                        ForEach(myBoxesViewModel.boxes, id: \.id) { box in
                            NavigationLink(destination: BoxView(boxViewModel: BoxViewModel(lightBox: box))) {
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
                    .onChange(of: myBoxesViewModel.searchText) { _, _ in
                        myBoxesViewModel.runSearch()
                    }
                    .listStyle(.plain)
                    .navigationTitle(myBoxesViewModel.isWishlist ? "menu.wishlist" : "menu.boxes")
                    .onAppear() {
                        myBoxesViewModel.loadData()
                    }
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
    }
}

#Preview {
    MyBoxesView(myBoxesViewModel: MyBoxesViewModel())
}
