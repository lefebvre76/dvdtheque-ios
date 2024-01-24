//
//  TextFieldError.swift
//  dvdtheque
//
//  Created by loic lefebvre on 12/01/2024.
//

import SwiftUI

struct TextFieldError: View {
    @Binding var text: String
    var placeholder: String
    var errors: [String] = []
    var securised = false
    var isMultiLine = false

    var body: some View {
        VStack(alignment: .leading) {
            if securised {
                SecureField(
                    placeholder.localized(),
                    text: $text
                )
            } else if isMultiLine {
                TextField(
                    placeholder.localized(),
                    text: $text,
                    axis: .vertical)
                .lineLimit(2...)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            } else {
                TextField(
                    placeholder.localized(),
                    text: $text
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
            }
            Divider()

            ForEach(errors, id: \.self) { message in
                Text(message).font(.caption2).multilineTextAlignment(.leading).foregroundColor(.red)
            }
        }
        .padding(.bottom)
    }
}


#Preview {
    TextFieldError(text: .constant(""), placeholder: "test", errors: ["error 01", "error 02"], securised: true)
}

#Preview {
    TextFieldError(text: .constant(""), placeholder: "test", errors: ["error 01", "error 02"])
}

#Preview {
    TextFieldError(text: .constant(""), placeholder: "test", errors: ["error 01", "error 02"], isMultiLine: true)
}
