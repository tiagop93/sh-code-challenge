//
//  CatDashboardView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import SwiftUI

struct CatDashboardView: View {
    
    @State private var viewModel = CatDashboardViewModel()
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: self.columns) {
                    ForEach(viewModel.cats, id: \.id) { catBreed in
                        CatItemView(breed: catBreed)
                    }
                }
            }
            .navigationTitle("Cats App")
            .searchable(
                text: $viewModel.searchString,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .autocorrectionDisabled()
        }
    }
}

#Preview {
    CatDashboardView()
}
