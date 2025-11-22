//
//  MainScreenView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct MainScreenView: View {
    
    @StateObject var viewModel = MainScreenViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    MoviesSearchView(viewModel: viewModel)
                } label: {
                    CustomSearchBar(text: $viewModel.searchText,
                                    isSearchBarActive: viewModel.hasSearchStarted)
                    .padding(.horizontal, 16)
                }
                ScrollView (showsIndicators: false) {
                    if viewModel.setupComplete != .failure {
                        VStack(spacing: 10) {
                            
                            if !viewModel.watchlists.isEmpty {
                                MoviesHorizontalScrollSectionView(movies: viewModel.watchlists,
                                                                  sectionType: .yourWatchlists)
                            }
                            
                            ForEach(viewModel.moviesList) { movieList in
                                MoviesHorizontalScrollSectionView(movies: viewModel.setUpMovieDetailsModel(movieList),
                                                                  sectionType: movieList.id ?? .trending)
                            }
                        }
                    } else if !viewModel.watchlists.isEmpty {
                        MoviesHorizontalScrollSectionView(movies: viewModel.watchlists,
                                                          sectionType: .yourWatchlists)
                        
                    } else {
                        VStack {
                            Image(systemName: "iphone.gen1.slash")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.blue.opacity(AppConstants.mediumOpacity))
                            Text("MainScreen.errorStateText".localized())
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("Reload")
                                .font(.title3)
                                .foregroundStyle(.blue)
                                .underline()
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    Task {
                                        viewModel.setupComplete = .loading
                                        await viewModel.setupMainScreen()
                                    }
                                }
                        }
                        .padding()
                    }
                }
                .task {
                    await viewModel.setupMainScreen()
                }
                .overlay {
                    if viewModel.setupComplete == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                            .scaleEffect(2.0, anchor: .center)
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.hasSearchStarted, content: {
                MoviesSearchView(viewModel: viewModel)
                    .transition(.move(edge: .trailing))
            })
        }
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel())
}
