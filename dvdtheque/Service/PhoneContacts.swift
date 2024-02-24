//
//  PhoneContacts.swift
//  dvdtheque
//
//  Created by loic lefebvre on 24/02/2024.
//

import SwiftUI
import Contacts

struct PhoneContact {
    var id: String
    var name: String
    var avatarData: Data?
}

struct PhoneContacts {
    
    private let contactStore = CNContactStore()
    private let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactThumbnailImageDataKey] as [Any]
    
    func getContacts() -> [PhoneContact] {

        var results: [CNContact] = []

        for container in getContactStoreContainer() {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results.map({ contact in
            let fullName: String = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            return PhoneContact(id: "\(contact.identifier)", name: fullName, avatarData: contact.thumbnailImageData)
        })
    }
    
    func getContact(id: String) -> PhoneContact? {
        for container in getContactStoreContainer() {
            do {
                let contact = try contactStore.unifiedContact(withIdentifier: id, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                let fullName: String = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                return PhoneContact(id: "\(contact.id)", name: fullName, avatarData: contact.thumbnailImageData)
            } catch { }
        }
        return nil
    }
    
    private func getContactStoreContainer() -> [CNContainer] {
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch { }
        return allContainers
    }
}
