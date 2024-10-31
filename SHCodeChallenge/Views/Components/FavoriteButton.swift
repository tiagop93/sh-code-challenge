//
//  FavoriteButton.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 31/10/2024.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    var size: CGFloat = 45
    
    var body: some View {
        Button(action: {
            isFavorite.toggle()
        }) {
            Image(systemName: isFavorite ? "heart.fill": "heart")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.red)
                .frame(width: size, height: size)
                .padding(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoriteButton(isFavorite: Binding.constant(true), size: 45)
}
