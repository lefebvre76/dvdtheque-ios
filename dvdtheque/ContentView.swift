//
//  ContentView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 15/12/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        TabView {
            MyBoxesView().tabItem {
                Label("menu.boxes", systemImage: "opticaldisc.fill")
            }
            BarCodeScannerView().tabItem {
                Label("menu.add", systemImage: "barcode.viewfinder")
            }
            UserView().tabItem {
                Label("menu.account", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
