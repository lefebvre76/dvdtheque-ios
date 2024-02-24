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
            if loansViewModel.loans.isEmpty, !loansViewModel.loading {
                NavigationView {
                    VStack {
                        Spacer()
                        Text("loans.is_empty").multilineTextAlignment(.center).padding()
                        Spacer()
                    }.refreshable {
                        loansViewModel.loadData()
                    }
                }
            } else {
                NavigationStack {
                    List {
                        ForEach(loansViewModel.loans, id: \.id) { loan in
                            NavigationLink(destination: LoanView(loanViewModel: LoanViewModel(loan: loan, completion: loansViewModel.loadData)).toolbar(.hidden, for: .tabBar)) {
                                LoanItemView(loan: loan).swipeActions {
                                    Button {
                                        loansViewModel.deleteItem(loan: loan)
                                    } label: {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 20))
                                        Text((loan.type == "BORROW" ? "box.return_to" : "box.return_to_me").localized(arguments: loan.contact))
                                    }.tint(.red)
                                }
                            }
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
                    .refreshable {
                        loansViewModel.loadData()
                    }
                }
            }
        }.onAppear() {
            loansViewModel.loadData()
        }
    }
}
