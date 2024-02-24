//
//  LoanDetailView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI
import SwiftData

struct LoanDetailView: View {
    var loan: Loan
    @Binding var opacity: Double
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let illustrationHeight = CGFloat(300)

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: loan.box.illustration.original), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)

                    },
                               placeholder: {
                        Image(systemName: "opticaldisc")
                            .font(.system(size: 60))
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    })
                }.background(.white)
                    .offset(y: -geometry.frame(in: .global).minY)
                    .frame(width: UIScreen.main.bounds.width,
                           height: (geometry.frame(in: .global).minY > 0 ? geometry.frame(in: .global).minY : 0) + 300)
                    .onChange(of: geometry.frame(in: .global).minY) { _, value in
                        let offset = illustrationHeight + value
                        let start = safeAreaInsets.top + 44
                        let end = safeAreaInsets.top
                        if offset < start {
                            if offset > end {
                                opacity = 1 - Double((offset - end)/(start-end))
                                return
                            }
                            opacity = 1
                        } else {
                            opacity = 0
                        }
                    }
            }.frame(height: illustrationHeight)
            VStack(alignment: .leading, spacing: 15) {
                VStack {
                    Text(loan.box.title).frame(maxWidth: .infinity, alignment: .leading).font(.title).padding(.bottom, 2).padding(.horizontal)
                    HStack {
                        Text(loan.type == "BORROW" ? "loan.borrow_to".localized(arguments: loan.contact) : "loan.loan_at".localized(arguments: loan.contact)).bold()
                        Spacer()
                        Image("\(loan.box.type)")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(uiColor: UIColor.label))
                            .frame(height: 25)
                    }.frame(maxWidth: .infinity).padding(.horizontal)
                    
                    if let date = loan.reminderDatetoString() {
                        HStack {
                            if loan.reminderDateIsPast() {
                                Image(systemName: "exclamationmark.triangle").foregroundColor(.red)
                                Text("\("loan.reminder_date".localized()) : \(date)").foregroundColor(.red)
                            } else {
                                Text("\("loan.reminder_date".localized()) : \(date)")
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                    
                    if let comment = loan.comment {
                        Text("\(comment)")
                            .italic()
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    
                    if let parentBox = loan.parent_box {
                        Text("Tiré du coffret")
                            .bold()
                            .padding(.top, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        BoxItemView(box: parentBox).padding(.horizontal)
                    }
                    Spacer()
                }.padding(.vertical)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
                .offset(y: -20)
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoanDetailView(loan:
                    Loan(id: 1,
                         type: "LOAN",
                         contact: "Patrick",
                         reminder: Int(Date.now.timeIntervalSince1970 - 3600),
                         comment: "Lorem ipsum",
                         box: LightBox(id: 1, type: "BRD", title: "Jurassic Park Collection", illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"), loaned: true), parent_box: LightBox(id: 1, type: "BRD", title: "Jurassic Park Collection", illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"), loaned: false)), opacity: .constant(0))
}

