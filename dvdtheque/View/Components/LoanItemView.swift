//
//  LoanItemView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/01/2024.
//

import SwiftUI

struct LoanItemView: View {
    var loan: Loan

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: loan.box.illustration.thumbnail), content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipped()
            },
                       placeholder: {
                HStack {
                    Image(systemName: "opticaldisc")
                        .font(.largeTitle)
                }
                .frame(width: 75, height: 75)
            })
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(loan.box.title).multilineTextAlignment(.leading).frame(maxWidth: .infinity, alignment: .leading).lineLimit(2).padding(.bottom, 2)
                    Text(loan.type == "BORROW" ? "loan.borrow_to".localized(arguments: loan.contact) : "loan.loan_at".localized(arguments: loan.contact)).bold()
                    
                }.frame(maxWidth: .infinity)
                Spacer()
                if let date = loan.reminderDatetoString() {
                    HStack {
                        Spacer()
                        if loan.reminderDateIsPast() {
                            Image(systemName: "exclamationmark.triangle").foregroundColor(.red)
                            Text("\("loan.reminder_date".localized()) : \(date)").foregroundColor(.red)
                        } else {
                            Text("\("loan.reminder_date".localized()) : \(date)")
                        }
                    }
                }
            }.frame(maxWidth: .infinity, minHeight: 75, maxHeight: 75).padding(.vertical, 2)
        }.accentColor(Color(uiColor: UIColor.label))
    }
}

#Preview {
    LoanItemView(loan: Loan(id: 1, type: "LOAN", contact: "John Doo", reminder: Int(Date.now.timeIntervalSince1970 - 3600), comment: nil, box: LightBox(id: 1, type: "BRD", title: "Jurassic Park Collection", illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"), loaned: false), parent_box: nil))
}
