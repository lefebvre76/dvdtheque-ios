//
//  MyBoxes.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import CoreData

struct LoginView: View {
    @StateObject var loginViewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("application.name")
                .font(.title)
                .padding(.top)
            Spacer()
            VStack {
                if loginViewModel.showRegistration {
                    TextFieldError(text: $loginViewModel.name, placeholder: "user.name", errors: loginViewModel.nameErrors)
                }
                TextFieldError(text: $loginViewModel.email, placeholder: "user.mail", errors: loginViewModel.showRegistration ? loginViewModel.emailErrors : [])
                TextFieldError(text: $loginViewModel.password, placeholder: "user.password", errors: loginViewModel.showRegistration ? loginViewModel.passwordErrors : loginViewModel.errorMessages, securised: true)
                if loginViewModel.showRegistration {
                    TextFieldError(text: $loginViewModel.confirmation, placeholder: "user.password_confirmation", errors: loginViewModel.confirmationErrors, securised: true)
                }
            }

            Button(
                action: {
                    loginViewModel.showRegistration = !loginViewModel.showRegistration
                },
                label: {
                    if loginViewModel.showRegistration {
                        Text("button.login")
                    } else {
                        Text("button.register")
                    }
                }
            )
            
            Spacer()
            Button(
                action: loginViewModel.showRegistration ? loginViewModel.register : loginViewModel.auth,
                label: {
                    if loginViewModel.load {
                        ProgressView().padding(.trailing, 5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("button.loading")
                    } else {
                        Text(loginViewModel.showRegistration ? "button.register" : "button.login")
                    }
                }
            ).buttonStyle(PrimaryButton())
            .padding(.top).disabled(loginViewModel.load)
        }
        .padding()
        .interactiveDismissDisabled()
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel(completion: {
        // Success Login
    }))
}
