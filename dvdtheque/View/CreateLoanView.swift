//
//  LoanView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 22/01/2024.
//

import Foundation
import SwiftUI

struct CreateLoanView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var createLoanViewModel: CreateLoanViewModel

    var body: some View {
        AuthContainerView(authContainerViewModel: createLoanViewModel) {
            VStack {
                HStack() {
                    Text(createLoanViewModel.isBorrow ? "borrow.create" : "loan.create").font(.title)
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(Color(uiColor: UIColor.label))
                            .padding()
                            .padding(.trailing, 0)
                    })
                }
                BoxItemView(box: createLoanViewModel.box).padding(.bottom)
                VStack {
                    TextFieldError(text: $createLoanViewModel.contact, placeholder: createLoanViewModel.isBorrow ? "borrow.contact" : "loan.contact", errors: createLoanViewModel.contactErrors)
                    
                    Toggle(createLoanViewModel.isBorrow ? "borrow.select_reminder_date" : "loan.select_reminder_date", isOn: $createLoanViewModel.showReminder)
                    
                    if createLoanViewModel.showReminder {
                        DatePicker(createLoanViewModel.isBorrow ? "borrow.reminder_date" : "loan.reminder_date", selection: $createLoanViewModel.reminder)
                        ForEach(createLoanViewModel.reminderErrors, id: \.self) { message in
                            Text(message).font(.caption2).multilineTextAlignment(.leading).foregroundColor(.red)
                        }
                    }
                    
                    Divider()
                        .padding(.bottom)

                    TextFieldError(text: $createLoanViewModel.comment, placeholder: "loan.comment", errors: createLoanViewModel.commentErrors, isMultiLine: true)
                }
                Spacer()
                Button(
                    action: createLoanViewModel.persisteLoan,
                    label: {
                        if createLoanViewModel.load {
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
                .padding(.top).disabled(createLoanViewModel.load)
            }.padding()
        }
    }
}

#Preview {
    CreateLoanView(createLoanViewModel: CreateLoanViewModel(box: Box(id: 1,
                                                                     type: "BRD",
                                                                     title: "Jurassic Park Collection",
                                                                     original_title: nil,
                                                                     year: 2015,
                                                                     synopsis: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse lacus ligula, hendrerit et sagittis vel, vehicula ac quam. Vestibulum suscipit pellentesque lorem non varius. Quisque malesuada tortor mi, auctor convallis felis aliquet ac. Nulla neque dui, semper sed bibendum vel, molestie ut mauris. Morbi convallis auctor convallis. Suspendisse blandit ullamcorper libero mollis efficitur. Curabitur facilisis a ligula vitae egestas. Suspendisse consectetur mi vel sem efficitur finibus at in eros. Pellentesque pellentesque nibh vel metus condimentum, sit amet mollis nisi dapibus. Nulla id imperdiet eros, et porta odio.",
                                                                     edition: "",
                                                                     editor: "",
                                                                     illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"),
                                                                     kinds: [Kind(id: 1, name: "Science Fiction"), Kind(id: 2, name: "Aventure")],
                                                                     directors: [Celebrity(id: 1, name: "Stevent Speilberg", photo: Illustration(original: "https://image.tmdb.org/t/p/w300_and_h450_bestv2/tZxcg19YQ3e8fJ0pOs7hjlnmmr6.jpg", thumbnail: "https://image.tmdb.org/t/p/w90_and_h90_face/tZxcg19YQ3e8fJ0pOs7hjlnmmr6.jpg"))],
                                                                     actors: [], composers: [], boxes: [
                                                                        LightBox(id: 2, type: "BRD", title: "Dark Shadows", illustration: Illustration(original: "http://localhost/storage/8/old-dark_shadows_bis_br.0.jpg", thumbnail: "http://localhost/storage/8/conversions/old-dark_shadows_bis_br.0-thumbnail.jpg"), loaned: false)
                                                                     ], in_collection: true, in_wishlist: false, loans: []), parentBox: nil)).preferredColorScheme(.dark)
}

