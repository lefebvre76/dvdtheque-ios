//
//  LoanView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI
import CoreData

struct LoanView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var loanViewModel: LoanViewModel
    @State var opacity = 0.0
    @State var navBarButtonColor = Color.black

    var body: some View {
        AuthContainerView(authContainerViewModel: loanViewModel) {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    VStack() {
                        LoanDetailView(loan: loanViewModel.loan, opacity: $opacity)
                        Spacer()
                        VStack(spacing: 0) {
                            Button(
                                action: {
                                    loanViewModel.showLoanForm = true
                                },
                                label: {
                                    Text("general.edit")
                                        .frame(maxWidth: .infinity, maxHeight: 45)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 23)
                                                .stroke(.blue, lineWidth: 2)
                                        )
                                }
                            ).padding(.bottom)

                            Button((loanViewModel.loan.type == "LOAN" ? "box.return_to_me" : "box.return_to").localized(arguments: loanViewModel.loan.contact)) {
                                loanViewModel.delete() {
                                    dismiss()
                                }
                            }.buttonStyle(PrimaryButton())
                        }.padding()
                    }
                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                        }.tint(navBarButtonColor)
                        Spacer()
                        Text("\(loanViewModel.loan.box.title)").bold().opacity(Double(opacity))
                        Spacer()
                    }.padding()
                        .background(Color(UIColor.systemBackground).opacity(Double(opacity)))
                        .onChange(of: opacity) { _, value in
                            withAnimation {
                                if opacity < 0.25 {
                                    navBarButtonColor = .black
                                } else {
                                    navBarButtonColor = Color(uiColor: UIColor.label)
                                }
                            }
                        }
                }).navigationBarHidden(true)
                .sheet(isPresented: $loanViewModel.showLoanForm) {
                    CreateLoanView(createLoanViewModel: CreateLoanViewModel(loan: loanViewModel.loan, completion: { loan in
                        loanViewModel.updatedLoan(loan: loan)
                    }))
                }
            }.onAppear {
                loanViewModel.loadData()
            }
        }
    }


#Preview {
    LoanView(loanViewModel: LoanViewModel(loan: Loan(id: 1, 
                                                     type: "LOAN",
                                                     contact: "Patrick",
                                                     reminder: 1,
                                                     comment: "teest",
                                                     box: LightBox(id: 1,
                                                                 type: "BRD",
                                                                 title: "Jurassic Park Collection",
                                                                 illustration: Illustration(original: "http://localhost/storage/2/3d-jurassic_park_1_2_3_4_br.0.jpg", thumbnail: "http://localhost/storage/2/conversions/3d-jurassic_park_1_2_3_4_br.0-thumbnail.jpg"), 
                                                                   loaned: true), parent_box: nil)))
}
