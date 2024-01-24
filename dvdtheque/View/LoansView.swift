//
//  LoansView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/01/2024.
//

import SwiftUI

struct LoansView: View {
    @StateObject var loansViewModel = LoansViewModel()

    var body: some View {
        AuthContainerView(authContainerViewModel: loansViewModel) {
                NavigationStack {
                    List {
                        ForEach(loansViewModel.loans, id: \.id) { loan in
                            LoanItemView(loan: loan)
                        }
                        .listRowSeparator(.hidden,
                                          edges: .all)
                        if loansViewModel.showLoadMore {
                            LoadView().onAppear {
                                loansViewModel.loadMoreData()
                            }.listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("menu.loans")
                    .onAppear() {
                        loansViewModel.loadData()
                    }
            }
        }
    }
}
