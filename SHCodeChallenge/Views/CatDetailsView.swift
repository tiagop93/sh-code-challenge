//
//  CatDetailsView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import SwiftUI

struct CatDetailsView: View {
    @State private var viewModel: CatFavoriteStatus
    let catBreed: CatBreed
    
    init(catBreed: CatBreed, viewModel: CatFavoriteStatus) {
        self.catBreed = catBreed
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(catBreed.name)
                    .font(.largeTitle)
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: catBreed.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure(_):
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                    
                    FavoriteButton(isFavorite: viewModel.isFavoriteBinding(for: catBreed.id), size: 45)
                }
            }.padding()
            VStack(alignment: .leading, spacing: 6) {
                Text("Origin: \(catBreed.origin)")
                    .font(.subheadline)
                Text("Temperament: \(catBreed.temperament)")
                    .font(.subheadline)
                Text("Description: \(catBreed.description)")
                    .font(.subheadline)
            }.padding()
            
            Spacer()
        }
        // fav button
    }
}
