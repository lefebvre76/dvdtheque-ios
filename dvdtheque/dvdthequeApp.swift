//
//  dvdthequeApp.swift
//  dvdtheque
//
//  Created by loic lefebvre on 15/12/2023.
//

import SwiftUI

@main
struct dvdthequeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
