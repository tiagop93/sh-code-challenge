//
//  CatItemView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import SwiftUI

struct CatItemView: View {
    
    var catBreed: CatBreed
    private let imageSize: CGFloat = 150
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                AsyncImage(url: catBreed.imageUrl) { phase in
                    switch phase {
                    case .empty, .failure(_):
                        ProgressView()
                            .frame(width: imageSize, height: imageSize)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                    @unknown default:
                        ProgressView()
                    }
                }
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(10)
                
                Text(catBreed.name)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.bottom, 16)
            }
            
            FavoriteButton(catBreed: catBreed, size: 25)
        }
    }
}
