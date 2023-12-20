//
//  BoxView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 20/12/2023.
//

import SwiftUI
import CoreData

struct BoxView: View {
    @StateObject var boxViewModel: BoxViewModel

    var body: some View {
        AuthContainerView(authContainerViewModel: boxViewModel) {
            if let box = boxViewModel.box {
                BoxDetailView(box: box)
            }
        }.onAppear {
            boxViewModel.loadData()
        }
    }
}

#Preview {
    BoxView(boxViewModel: BoxViewModel(lightBox: LightBox(id: 1, type: "BRD", title: "Batman", illustration: Illustration(original: "", thumbnail: ""))))
}
