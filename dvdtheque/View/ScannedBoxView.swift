//
//  AddBoxView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 16/01/2024.
//

import Foundation
import SwiftUI

struct ScannedBoxView: View {

    @StateObject var scannedBoxViewModel: ScannedBoxViewModel
    @State var opacity = 0.0
    @State var closeButtonColor = Color.black

    var body: some View {
        AuthContainerView(authContainerViewModel: scannedBoxViewModel) {
            ZStack(content: {
                VStack() {
                    BoxDetailView(box: scannedBoxViewModel.box, opacity: $opacity)
                    VStack() {
                        if !scannedBoxViewModel.box.in_collection {
                            Button(action: {
                                scannedBoxViewModel.add(wishlist: false)
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                Text("box.add_to_collection").padding()
                            })
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .padding(.horizontal)
                            if !scannedBoxViewModel.box.in_wishlist {
                                Button(action: {
                                    scannedBoxViewModel.add(wishlist: true)
                                }, label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                    Text("box.add_to_wishlist").padding()
                                })
                                .frame(maxWidth: .infinity, maxHeight: 45)
                                .foregroundColor(.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 35)
                                        .stroke(.blue, lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                        if let loan = scannedBoxViewModel.box.loans.first(where: { $0.type == "LOAN" }) {
                            Button(action: {
                                scannedBoxViewModel.removeLoan(id: loan.id)
                            }, label: {
                                Text("box.return_to_me".localized(arguments: loan.contact)).padding()
                            })
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(.blue, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        } else if scannedBoxViewModel.box.in_collection {
                            Button(action: {
                                scannedBoxViewModel.isBorrow = false
                                scannedBoxViewModel.showLoanForm = true
                            }, label: {
                                Text("box.loan").padding()
                            })
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(.blue, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                        if let loan = scannedBoxViewModel.box.loans.first(where: { $0.type == "BORROW" }) {
                            Button(action: {
                                scannedBoxViewModel.removeLoan(id: loan.id)
                            }, label: {
                                Text("box.return_to".localized(arguments: loan.contact)).padding()
                            })
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(.blue, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        } else if !scannedBoxViewModel.box.in_collection {
                            Button(action: {
                                scannedBoxViewModel.isBorrow = true
                                scannedBoxViewModel.showLoanForm = true
                            }, label: {
                                Text("box.borrow").padding()
                            })
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(.blue, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                VStack() {
                    HStack() {
                        Text("\(scannedBoxViewModel.box.title)").bold().opacity(Double(opacity)).padding()
                        Spacer()
                        Button(action: {
                            scannedBoxViewModel.close()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(closeButtonColor)
                                .padding()
                        })
                    }
                        .background(Color(UIColor.systemBackground).opacity(Double(opacity)))
                        .onChange(of: opacity) { _, value in
                            withAnimation {
                                if opacity < 0.25 {
                                    closeButtonColor = .black
                                } else {
                                    closeButtonColor = Color(uiColor: UIColor.label)
                                }
                            }
                        }
                    Spacer()
                }
            }).navigationBarHidden(true)
        }
        .sheet(isPresented: $scannedBoxViewModel.showLoanForm) {
            CreateLoanView(createLoanViewModel: CreateLoanViewModel(box: scannedBoxViewModel.box, parentBox: nil, isBorrow: scannedBoxViewModel.isBorrow, completion: { _ in
                scannedBoxViewModel.close()
            }))
        }
    }
}


#Preview {
    ScannedBoxView(scannedBoxViewModel: ScannedBoxViewModel(box: Box(id: 1,
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
                                                                     ], in_collection: true, in_wishlist: false, loans: []))).preferredColorScheme(.dark)
}
