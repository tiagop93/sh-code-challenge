//
//  CatDashboardView.swift
//  SHCodeChallenge
//
//  Created by Tiago Pereira on 29/10/2024.
//

import SwiftUI

struct CatDashboardView: View {
    
    @State private var viewModel = CatDashboardViewModel(apiClient: APIClient(), dataStore: .shared)
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
                        ForEach(viewModel.catBreeds) { catBreed in
                            NavigationLink {
                                CatDetailsView(catBreed: catBreed)
                            } label: {
                                CatItemView(catBreed: catBreed)
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
                        Text("Error fetching cat breeds.")
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
            .onChange(of: viewModel.searchString) { _, newValue in
                if newValue.isEmpty {
                    viewModel.reloadData()
                }
            }
            .onSubmit(of: .search) {
                viewModel.searchData()
            }
            .autocorrectionDisabled()
            .overlay {
                if viewModel.state == .loading && !viewModel.catBreeds.isEmpty {
                    ProgressView()
                }
                if viewModel.state == .success && viewModel.catBreeds.isEmpty {
                    ContentUnavailableView {
                        Text("No breeds found.")
                    } description: {
                        Text("Try a different search.")
                    }
                }
            }
            .navigationDestination(isPresented: $showFavorites) {
                FavoriteBreedsView()
            }
        }
        .environment(viewModel)
    }
}

#Preview {
    CatDashboardView()
        .preferredColorScheme(.dark)
}
