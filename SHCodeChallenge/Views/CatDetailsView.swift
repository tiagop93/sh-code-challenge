//
//  CatDetailsView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 30/10/2024.
//

import SwiftUI

struct CatDetailsView: View {
    let breed: CatBreed
    
    var body: some View {
        ScrollView {
            VStack {
                Text(breed.name)
                    .font(.largeTitle)
                AsyncImage(url: breed.imageUrl) { phase in
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
            }.padding()
            VStack(alignment: .leading, spacing: 6) {
                Text("Origin: \(breed.origin)")
                    .font(.subheadline)
                Text("Temperament: \(breed.temperament)")
                    .font(.subheadline)
                Text("Description: \(breed.description)")
                    .font(.subheadline)
            }.padding()
            
            Spacer()
        }
        // fav button
    }
}

#Preview {
    let catBreed = MockAPIClient().getFirstCatBreed()
    return CatDetailsView(breed: catBreed!)
        .preferredColorScheme(.dark)
}
