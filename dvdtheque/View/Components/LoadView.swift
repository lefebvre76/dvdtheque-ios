//
//  LoadView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 18/12/2023.
//

import SwiftUI
import SwiftData

struct LoadView: View {

    private var font: Font
    private var loaderColor: Color

    
    init(font: Font = .subheadline, loaderColor: Color = (Color(uiColor: UIColor.label))) {
        self.font = font
        self.loaderColor = loaderColor
    }
    
    var body: some View {
        HStack {
            ProgressView().padding(.trailing, 5).progressViewStyle(CircularProgressViewStyle(tint: loaderColor))

            Text("load.load_more_data").font(font).foregroundStyle(.gray)
        }.padding(.vertical, 5)
    }
}

#Preview {
    LoadView()
}
