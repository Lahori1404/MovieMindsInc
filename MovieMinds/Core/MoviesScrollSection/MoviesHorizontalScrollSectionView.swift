//
//  MoviesHorizontalScrollSectionView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct MoviesHorizontalScrollSectionView: View {
    
    let movies: [MovieDetailsModel]
    let sectionType: MainScreenSection
    
    
    init(movies: [MovieDetailsModel],
         sectionType: MainScreenSection) {
        self.movies = movies
        self.sectionType = sectionType
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text(sectionType.sectionName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()

                NavigationLink {
                    if sectionType == .yourWatchlists {
                        WatchlistsView(movies: movies)
                    } else {
                        MoviesGridView(movies: movies,
                                       sectionName: sectionType.sectionName)
                    }
                } label: {
                    HStack {
                        Text("HorizontalScrollView.all".localized())
                            .font(.caption)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 6, height: 6)
                            .bold()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    .foregroundStyle(.black)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            .padding(.bottom, 24)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                HStack(alignment: .top,
                       spacing: 8) {
                    ForEach(movies.prefix(6), id: \.id) { movie in
                        NavigationLink {
                            MovieDetailsView(movie: movie)
                        } label: {
                            MovieCardView(imageURL: movie.imageURL,
                                          movieName: movie.title,
                                          movieRating: movie.rating,
                                          releaseYear: movie.releaseDate,
                                          uiImage: movie.image)
                        }
                    }
                }
                       .padding(.horizontal, 10)
            }
            Spacer()
        }
        .modifier(HorizontalScrollViewModifier(sectionType: sectionType))
    }
}
