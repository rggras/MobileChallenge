//
//  CitiesView.swift
//  MobileChallenge
//
//  Created by Rodrigo Gras on 06/01/2026.
//

import SwiftUI

struct CitiesView: View {
    @StateObject private var viewModel = CitiesViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, uala!")
        }
        .padding()
    }
}

#Preview {
    CitiesView()
}
