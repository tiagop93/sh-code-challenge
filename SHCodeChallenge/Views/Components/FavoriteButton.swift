//
//  FavoriteButton.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import SwiftUI

struct FavoriteButton: View {
    
    @Environment(CatDashboardViewModel.self) private var viewModel
    var catBreed: CatBreed
    var size: CGFloat = 45
    
    var body: some View {
        Button(action: {
            viewModel.toggleFavorite(for: catBreed)
        }) {
            Image(systemName: catBreed.isFavorite ? "heart.fill": "heart")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.red)
                .frame(width: size, height: size)
                .padding(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
