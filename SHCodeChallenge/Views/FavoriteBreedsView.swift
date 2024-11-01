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
            List(viewModel.favoriteBreeds) { catBreed in
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
            .onAppear {
                viewModel.loadFavoriteBreeds()
            }
            .overlay {
                if viewModel.favoriteBreeds.isEmpty {
                    ContentUnavailableView {
                        Text("No favorite breeds.")
                    } description: {
                        Text("Your favorite breeds will appear here.")
                    }
                }
            }
        }
    }
}

#Preview {
    FavoriteBreedsView()
        .preferredColorScheme(.dark)
        .environment(CatDashboardViewModel(apiClient: APIClient(), dataStore: .shared))
}
