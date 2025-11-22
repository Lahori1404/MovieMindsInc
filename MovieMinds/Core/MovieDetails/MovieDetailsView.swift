//
//  MovieDetailsView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//
import SwiftUI
import YouTubePlayerKit

struct MovieDetailsView: View {
    
    @StateObject var viewModel: MovieDetailsViewModel
    @Environment(\.dismiss) var dismiss
    @State var isExpanded = false
    
    init(movie: MovieDetailsModel) {
        _viewModel = .init(wrappedValue: .init(movie: movie, uiImage: movie.image))
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack {
                        ZStack{
                            Rectangle()
                                .fill(.thinMaterial)
                                .frame(height: geometry.size.height * 0.55)
                            ImageDownloadView(uiImage: $viewModel.uiImage)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height * 0.55)
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.movie.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.bottom)
                                Spacer()
                                Text("IMDB")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                CircularRatingView(rating: viewModel.movie.rating)
                            }
                            
                            if !viewModel.trailerKey.isEmpty {
                                YouTubePlayerView(
                                    YouTubePlayer(source: .video(id: viewModel.trailerKey))
                                )
                                .frame(height: 240)
                                .padding(.vertical, 20)
                            }
                            
                            Text("About")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.bottom, 5)
                            Text(viewModel.movie.overview)
                                .foregroundStyle(.gray)
                                .lineLimit(isExpanded ? nil : 2)
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }, label: {
                                Text(isExpanded ? "Read Less" : "Read More")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .underline()
                            })
                        }
                        .padding()
                    }
                }
                Divider()
                stickyBottomView
                    .edgesIgnoringSafeArea(.bottom)
            }
        })
        .task {
            viewModel.loadMovieImage()
            await viewModel.fetchTrailerKey()
        }
        .sheet(isPresented: $viewModel.showUserWatchlistSheet) {
            WatchlistSheetView(viewModel: viewModel)
            .presentationDetents([.medium, .large])
        }
        .overlay {
            if viewModel.showConfirmationDialogue {
                CustomDialogueView(isActive: $viewModel.showConfirmationDialogue,
                                   action: { _ in },
                                   isUserInputDialogue: false,
                                   movieName: viewModel.movie.title)
            }
        }
        .overlay {
            if viewModel.showUserInputDialogue {
                CustomDialogueView(isActive: $viewModel.showUserInputDialogue,
                                   action: { watchlistName in
                    viewModel.addWatchlist(watchlistName: watchlistName)
                },
                                   isUserInputDialogue: true)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
    
    var stickyBottomView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Original Language")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Text(viewModel.movie.originalLanguage)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            Spacer()
            Button(action: {
                viewModel.showUserWatchlistSheet = true
            }, label: {
                HStack(spacing: 10) {
                    Image(systemName: "popcorn.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                    Text("Add to Watchlist")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(.green)
            })
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding([.horizontal,.top], 16)
    }
}


