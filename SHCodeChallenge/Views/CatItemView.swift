//
//  CatItemView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import SwiftUI

struct CatItemView: View {
    let breed: CatBreed
    private let imageSize: CGFloat = 150
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: breed.image?.url ?? "")) { phase in
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
            Text(breed.name)
                .font(.headline)
                .lineLimit(1)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
