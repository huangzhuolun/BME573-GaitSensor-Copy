//
//  GaitSensorUpdateApp.swift
//  GaitSensorUpdate
//
//  Created by Thomas  Hagan on 10/28/20.
//

import SwiftUI

@main
struct GaitSensorUpdateApp: App {
    var viewModel: BLEScannerVM = BLEScannerVM()
    var body: some Scene {
        WindowGroup {
            BLEScannerView(viewmodel: viewModel)
        }
    }
}
