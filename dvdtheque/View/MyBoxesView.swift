//
//  MyBoxes.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import CoreData

struct MyBoxesView: View {
    @StateObject var myBoxesViewModel = MyBoxesViewModel()

    var body: some View {
        AuthContainerView(authContainerViewModel: myBoxesViewModel) {
            NavigationStack {
                List {
                    ForEach(myBoxesViewModel.boxes, id: \.id) { box in
                        NavigationLink(destination: BoxView(boxViewModel: BoxViewModel(lightBox: box))) {
                            BoxItemView(box: box)
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
                .listStyle(.plain)
                .navigationTitle("boxes.list")
                .onAppear() {
                    myBoxesViewModel.loadData()
                }
            }
        }
    }
}

#Preview {
    MyBoxesView()
}
