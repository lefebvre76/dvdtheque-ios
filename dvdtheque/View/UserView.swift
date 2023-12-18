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
                    }
                    HStack {
                        Text("user.mail")
                        Text("\(user.email)")
                        Spacer()
                    }.padding(.top)
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
            )
        }.padding()
        .onAppear(){
            userViewModel.loadUserInformations()
        }
    }
}

#Preview {
    UserView()
}
