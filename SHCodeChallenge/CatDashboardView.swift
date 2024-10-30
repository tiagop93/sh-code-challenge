//
//  CatDashboardView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import SwiftUI

struct CatDashboardView: View {
    
    @State private var viewModel = CatDashboardViewModel(apiClient: APIClient())
    
    let gridItemWidth: CGFloat = 150
    let spacing: CGFloat = 16
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: gridItemWidth), spacing: spacing)
                ]) {
                    ForEach(viewModel.catBreeds, id: \.id) { catBreed in
                        CatItemView(breed: catBreed)
                    }
                }
            }
            .padding(.horizontal, spacing)
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
        .preferredColorScheme(.dark)
}
