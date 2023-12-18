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
                TextField(
                    "user.mail",
                    text: $loginViewModel.email
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                
                SecureField(
                    "user.password",
                    text: $loginViewModel.password
                )
                .padding(.top, 20)
                
                Divider()
            }
            Button(
                action: loginViewModel.auth,
                label: {
                    Text("button.login")
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(30)
                }
            ).padding(.top)
            Spacer()
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
