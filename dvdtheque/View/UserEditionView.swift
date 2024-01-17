//
//  UserEditionView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 12/01/2024.
//

import SwiftUI

struct UserEditionView: View {
    @StateObject var userEditionViewModel: UserEditionViewModel

    var body: some View {
        AuthContainerView(authContainerViewModel: userEditionViewModel) {
            VStack {
                HStack {
                    Spacer()
                    Button(
                        action: userEditionViewModel.close,
                        label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(Color(uiColor: UIColor.label))
                                .padding(.vertical)
                                .padding(.leading)
                                .padding(.trailing, 0)
                        }
                    )
                }
                Text("user.profil").font(.title)

                TextFieldError(text: $userEditionViewModel.username, placeholder: "user.name", errors: [])
                
                Text("user.update_password").font(.subheadline).padding()
                TextFieldError(text: $userEditionViewModel.password, placeholder: "user.password", errors: userEditionViewModel.passwordErrors, securised: true)
                
                TextFieldError(text: $userEditionViewModel.newPassword, placeholder: "user.new_password", errors: userEditionViewModel.newPasswordErrors, securised: true)
                
                TextFieldError(text: $userEditionViewModel.newPasswordConfirmation, placeholder: "user.new_password_confirmation", errors: userEditionViewModel.confirmationErrors, securised: true)

                Spacer()
                Button(
                    action: userEditionViewModel.updateUserInformations,
                    label: {
                        if userEditionViewModel.load {
                            ProgressView().padding(.trailing, 5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("button.loading")
                        } else {
                            Text("button.save")
                        }
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: 45)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(30)
                .padding(.top).disabled(userEditionViewModel.load)
            }
        }.padding()
    }
}

#Preview {
    UserEditionView(userEditionViewModel: UserEditionViewModel(user: User(name: "John Doo", email: "test@test.com", total_boxes: 10, total_movies: 10, favorite_kinds: [], favorite_directors: [], favorite_actors: []), completion: nil))
}
