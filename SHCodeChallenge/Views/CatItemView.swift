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
        ZStack(alignment: .topTrailing) {
            VStack {
                AsyncImage(url: breed.imageUrl) { phase in
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
                
                Text(breed.name)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.bottom, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Button(action: {
                //TODO: Add implementation
            }) {
                Image(systemName: "heart")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red)
                    .frame(width: 25, height: 25)
                    .padding(6)
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: -10, y: -2)
        }
    }
}
