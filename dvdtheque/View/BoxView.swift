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
            }
        }.onAppear {
            boxViewModel.loadData()
        }
        .confirmationDialog(
            Text("Actions"),
            isPresented: $boxViewModel.showActionDialog,
            titleVisibility: .visible
        ) {
            if boxViewModel.box?.in_collection ?? false {
                Button("box.add_to_wishlist") {
                    print("move to wishlist")
                }
            }
            if boxViewModel.box?.in_wishlist ?? false {
                Button("box.add_to_collection") {
                    print("move to collection")
                }
            }
            Button("general.delete", role: .destructive) {
                print("delete")
            }
        }
    }
}

#Preview {
    BoxView(boxViewModel: BoxViewModel(lightBox: LightBox(id: 1, type: "BRD", title: "Batman", illustration: Illustration(original: "", thumbnail: ""))))
}
