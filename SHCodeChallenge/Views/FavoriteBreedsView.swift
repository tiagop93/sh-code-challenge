//
//  FavoriteBreedsView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import SwiftUI

struct FavoriteBreedsView: View {
    
    @Environment(CatDashboardViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.getFavoriteBreeds()) { catBreed in
                NavigationLink {
                    CatDetailsView(catBreed: catBreed)
                } label: {
                    VStack(alignment: .leading) {
                        Text(catBreed.name)
                            .font(.title2)
                        Text("Life span: \(catBreed.lifeSpan)")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Favorite Breeds")
        }
    }
}

#Preview {
    FavoriteBreedsView()
        .preferredColorScheme(.dark)
        .environment(CatDashboardViewModel(apiClient: APIClient(), dataStore: .shared))
}
