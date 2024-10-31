//
//  CatDashboardView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import SwiftUI

struct CatDashboardView: View {
    
    @State private var viewModel = CatDashboardViewModel(apiClient: APIClient())
    @State private var favoriteVM = CatFavoriteStatus(dataStore: .shared)
    @State private var showFavorites = false
    @Environment(\.dismissSearch) var dismissSearch
    
    private let gridItemWidth: CGFloat = 150
    private let spacing: CGFloat = 16
    
    var body: some View {
        NavigationStack {
            ScrollView {
                switch viewModel.state {
                case .none, .loading, .success:
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: gridItemWidth), spacing: spacing)
                    ]) {
                        ForEach(viewModel.catBreeds, id: \.id) { catBreed in
                            NavigationLink {
                                CatDetailsView(catBreed: catBreed, viewModel: favoriteVM)
                            } label: {
                                CatItemView(catBreed: catBreed, viewModel: favoriteVM)
                                    .onAppear {
                                        if viewModel.isLastCatBreed(catBreed) {
                                            viewModel.triggerLoadNextPage()
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .onAppear {
                        viewModel.loadDataIfNeeded()
                    }
                case .failed:
                    ContentUnavailableView {
                        Text("Error loading users")
                    } description: {
                        Button("Retry") {
                            viewModel.reloadData()
                        }
                    }
                }
                
            }
            .padding(.horizontal, spacing)
            .navigationTitle("Cats App")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFavorites = true
                    } label: {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .searchable(
                text: $viewModel.searchString,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onSubmit(of: .search) {
                viewModel.searchData()
            }
            .autocorrectionDisabled()
            .overlay {
                if viewModel.state == .loading && !viewModel.catBreeds.isEmpty {
                    ProgressView()
                }
            }
            .navigationDestination(isPresented: $showFavorites) {  // Navigate to FavoriteBreedsView
                FavoriteBreedsView(viewModel: favoriteVM)
            }
        }
    }
}

#Preview {
    CatDashboardView()
        .preferredColorScheme(.dark)
}
