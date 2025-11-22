//
//  MoviesGridView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct MoviesGridView: View {
    
    let movies: [MovieDetailsModel]
    let sectionName: String?
    
    private let flexibleColumn = [
        GridItem(.flexible(), spacing: 4, alignment: .top),
        GridItem(.flexible(), spacing: 4, alignment: .top),
        GridItem(.flexible(), spacing: 4, alignment: .top)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(sectionName ?? "")
                .font(.title)
                .fontWeight(.bold)
                .padding([.leading, .bottom], 10)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: flexibleColumn, spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
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
                
            }
        }
        .padding(.top, 10)
    }
}
