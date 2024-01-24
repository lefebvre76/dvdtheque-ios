//
//  BoxView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 20/12/2023.
//

import SwiftUI
import CoreData

struct BoxView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var boxViewModel: BoxViewModel
    @State var opacity = 0.0
    @State var navBarButtonColor = Color.black

    var body: some View {
        AuthContainerView(authContainerViewModel: boxViewModel) {
            if let box = boxViewModel.box {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    VStack() {
                        BoxDetailView(box: box, opacity: $opacity).padding(.bottom, 1)
                    }
                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                        }.tint(navBarButtonColor)
                        Spacer()
                        Text("\(box.title)").bold().opacity(Double(opacity))
                        Spacer()
                        Button {
                            boxViewModel.showActionDialog = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                        }.tint(navBarButtonColor)
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
                .sheet(isPresented: $boxViewModel.showLoanForm) {
                    CreateLoanView(createLoanViewModel: CreateLoanViewModel(box: box, parentBox: boxViewModel.parent_box, isBorrow: boxViewModel.isBorrow, completion: {
                        boxViewModel.closeLoanView()
                        boxViewModel.loadData()
                    }))
                }
            }
        }.onAppear {
            boxViewModel.loadData()
        }
        .confirmationDialog(
            Text("general.actions"),
            isPresented: $boxViewModel.showActionDialog,
            titleVisibility: .visible
        ) {
            if !(boxViewModel.box?.in_collection ?? false) {
                if boxViewModel.box?.in_wishlist ?? false {
                    Button("box.add_to_collection") {
                        boxViewModel.moveToCollection()
                    }
                }
                if let loan = boxViewModel.box?.loans.first(where: { $0.type == "BORROW" }) {
                    Button("box.return_to".localized(arguments: loan.contact)) {
                        boxViewModel.removeLoan(id: loan.id)
                    }
                } else {
                    Button("box.borrow") {
                        boxViewModel.isBorrow = true
                        boxViewModel.showLoanForm = true
                    }
                }
            } else {
                if let loan = boxViewModel.box?.loans.first(where: { $0.type == "LOAN" }) {
                    Button("box.return_to_me".localized(arguments: loan.contact)) {
                        boxViewModel.removeLoan(id: loan.id)
                    }
                } else {
                    Button("box.loan") {
                        boxViewModel.isBorrow = false
                        boxViewModel.showLoanForm = true
                    }
                }
            }
            if boxViewModel.parent_box == nil {
                Button("general.delete", role: .destructive) {
                    boxViewModel.delete()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    BoxView(boxViewModel: BoxViewModel(lightBox: LightBox(id: 1, type: "BRD", title: "Batman", illustration: Illustration(original: "", thumbnail: ""), loaned: false)))
}
