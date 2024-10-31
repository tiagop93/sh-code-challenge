//
//  FavoriteBreedsView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import SwiftUI

struct FavoriteBreedsView: View {
    @State var viewModel: CatFavoriteStatus
    
    var body: some View {
        NavigationStack {
            List(viewModel.getFavoriteBreeds()) { catBreed in
                NavigationLink {
                    CatDetailsView(catBreed: catBreed, viewModel: viewModel)
                } label: {
                    // breed image
                    // breed name
                    Text(catBreed.name)
                    // breed average lifespan
                }
            }
            .navigationTitle("Favorite Breeds")
        }
    }
}

#Preview {
    FavoriteBreedsView(viewModel: CatFavoriteStatus(dataStore: .shared))
}
