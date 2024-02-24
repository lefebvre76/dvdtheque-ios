//
//  PhoneContactSelectorView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI

struct PhoneContactSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contacts: [PhoneContact] = []
    @State private var selectedContact: PhoneContact?
    @State private var searchText: String = ""
    @State private var allContacts: [PhoneContact] = []
    
    private var completionHandler: (PhoneContact?) -> Void

    init(selectedContact: PhoneContact?, completionHandler: @escaping (PhoneContact?) -> Void) {
        self.completionHandler = completionHandler
        self.selectedContact = selectedContact
    }
    
    var body: some View {
        VStack {
            HStack() {
                Text("loan.add_contact").font(.title)
                Spacer()
                Button(action: {
                    self.completionHandler(self.selectedContact)
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(Color(uiColor: UIColor.label))
                        .padding()
                        .padding(.trailing, 0)
                })
            }.padding()
            HStack {
                TextField("general.search", text: $searchText)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .textFieldStyle(.plain)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            }.padding(.horizontal)
            
            List {
                ForEach(contacts, id: \.id) { contact in
                    VStack(spacing: 0) {
                        HStack {
                            if let data = contact.avatarData, let uiimage = UIImage(data: data) {
                                Image(uiImage: uiimage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 40))
                                    .frame(width: 40, height: 40)
                            }
                            Text(contact.name)
                            Spacer()
                            if contact.id == self.selectedContact?.id ?? "" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.selectedContact?.id == contact.id {
                            self.selectedContact = nil
                        } else {
                            self.selectedContact = contact
                        }
                    }
                    .padding(2)
                }.listRowInsets(.none)
            }
            .listStyle(.plain)
            .onChange(of: searchText) { _, newValue in
                if newValue == "" {
                    contacts = allContacts
                } else {
                    contacts = allContacts.filter({ contact in
                        return contact.name.lowercased().contains(newValue.lowercased())
                    })
                }
            }
            .onAppear() {
                loadContacts()
            }
            if let contact = self.selectedContact {
                HStack {
                    Button {
                        self.completionHandler(contact)
                        dismiss()
                    } label: {
                        Text("loan.select_contact".localized(arguments: contact.name))
                    }.buttonStyle(PrimaryButton())
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    PhoneContactSelectorView(selectedContact: nil) { _ in
    }
}

internal extension PhoneContactSelectorView {
    func loadContacts() {
        allContacts = PhoneContacts().getContacts().sorted(by: { $0.name < $1.name })
        contacts = allContacts
    }
}
