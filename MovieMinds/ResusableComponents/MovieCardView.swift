//
//  SwiftUIView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct MovieCardView: View {
    
    enum MovieCardConstants {
        static let standardCardWidth: CGFloat = (AppConstants.screenWidth/3 - AppConstants.standardPaddingMedium)
        static let standardCardHeight: CGFloat = 160
        static let cardCornerRadius: CGFloat = 10
        static let ratingXOffset: CGFloat = 10
        static let ratingYOffset: CGFloat = 12
    }
    
    let imageURL: URL?
    let movieName: String
    let movieRating: Double
    let releaseYear: String
    @State var uiImage: UIImage?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            movieThumbnailViewBuilder()
                .padding(.bottom, AppConstants.standardPaddingMedium)
            
            Text(movieName)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .foregroundStyle(colorScheme == .light ? .black : .white)
                .lineLimit(2)
        }
        .onAppear {
            guard let imageURL = imageURL, uiImage == nil else { return }
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.uiImage = UIImage(data: data)
                }
            }
            .resume()
        }
        .frame(width: MovieCardConstants.standardCardWidth)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    func movieThumbnailViewBuilder() -> some View {
        VStack(spacing: .zero) {
            ImageDownloadView(uiImage: $uiImage)
        }
        .frame(width: MovieCardConstants.standardCardWidth,
               height: MovieCardConstants.standardCardHeight)
        .clipShape(RoundedRectangle(cornerRadius: MovieCardConstants.cardCornerRadius))
        .overlay(alignment: .bottomLeading) {
            CircularRatingView(rating: movieRating)
                .offset(x: MovieCardConstants.ratingXOffset,
                        y: MovieCardConstants.ratingYOffset)
        }
        .overlay(alignment: .topTrailing) {
            MessagePileView(text: String(releaseYear.prefix(4)))
        }
    }
}
