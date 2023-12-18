//
//  AuthContainerView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import CoreData

struct AuthContainerView<Content: View>: View {
    @StateObject var authContainerViewModel: AuthContainerViewModel
    @ViewBuilder let content: Content
    
    init(authContainerViewModel: AuthContainerViewModel, @ViewBuilder contentBuilder: () -> Content){
        self.content = contentBuilder()
        self._authContainerViewModel = StateObject(wrappedValue: authContainerViewModel)
    }

    var body: some View {
        VStack {
            content
        }
        .sheet(isPresented: $authContainerViewModel.showAuthView) {
            LoginView(loginViewModel: LoginViewModel(completion: {
                authContainerViewModel.userIsLogged()
            }))
        }
    }
}
