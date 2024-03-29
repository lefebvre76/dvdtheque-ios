//
//  UserView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import CoreData

struct UserView: View {
    @StateObject var userViewModel = UserViewModel()

    var body: some View {
        AuthContainerView(authContainerViewModel: userViewModel) {
            NavigationStack {
                VStack {
                    VStack() {
                        if let user = userViewModel.user {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 100))
                                .padding(.bottom)
                            HStack {
                                Text("user.hello").font(.title)
                                Text("\(user.name)").font(.title).bold()
                                Spacer()
                                Button(
                                    action: userViewModel.showEditionPage,
                                    label: {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 30))
                                            .foregroundColor(Color(uiColor: UIColor.label))
                                    }
                                )
                            }.padding(.bottom).padding(.horizontal)
                            
                            ScrollView {
                                VStack(alignment: .leading) {
                                    Text("user.favorite_kinds").font(.headline).padding(.horizontal)
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 5) {
                                            ForEach(user.favorite_kinds, id: \.id) { kind in
                                                KindItemView(name: "\(kind.name) (\(kind.total))")
                                            }
                                        }.padding(.horizontal)
                                    }
                                    Text("user.favorite_directors").font(.headline).padding(.top, 20).padding(.horizontal)
                                    ScrollView(.horizontal) {
                                        HStack(alignment: .top, spacing: 20) {
                                            ForEach(user.favorite_directors, id: \.id) { director in
                                                CelebrityItemView(celebrity: director)
                                            }
                                        }.padding(.horizontal)
                                    }
                                    Text("user.favorite_actors").font(.headline).padding(.top, 20).padding(.horizontal)
                                    ScrollView(.horizontal) {
                                        HStack(alignment: .top, spacing: 20) {
                                            ForEach(user.favorite_actors, id: \.id) { actor in
                                                CelebrityItemView(celebrity: actor)
                                            }
                                        }.padding(.horizontal)
                                    }
                                }
                                NavigationLink(destination: MyBoxesView(myBoxesViewModel: MyBoxesViewModel(isWishlist: true))) {
                                    HStack {
                                        Image(systemName: "heart")
                                        Text("menu.wishlist")
                                    }
                                }.padding()
                            }
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()
                    Button(
                        action: userViewModel.logout,
                        label: {
                            Text("button.logout")
                                .frame(maxWidth: .infinity, maxHeight: 45)
                                .foregroundColor(Color.red)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 23)
                                        .stroke(.red, lineWidth: 2)
                                )
                        }
                    ).padding(.bottom).padding(.horizontal)
                }
                .onAppear(){
                    userViewModel.loadUserInformations()
                }
            }
        }
        .sheet(isPresented: $userViewModel.editionPagePresented) {
            if let user = userViewModel.user {
                UserEditionView(userEditionViewModel:
                                    UserEditionViewModel(user: user) { updatedUser in
                    if let value = updatedUser {
                        userViewModel.updateUser(user: value)
                    }
                    userViewModel.hideEditionPage()
                })
            }
        }
    }
}

#Preview {
    UserView()
}
