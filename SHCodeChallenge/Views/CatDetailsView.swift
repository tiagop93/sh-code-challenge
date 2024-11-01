//
//  CatDetailsView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import SwiftUI

struct CatDetailsView: View {
    
    var catBreed: CatBreed
    
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
                    
                    FavoriteButton(catBreed: catBreed, size: 45)
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
