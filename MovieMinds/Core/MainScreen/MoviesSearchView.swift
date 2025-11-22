//
//  MoviesSearchView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct MoviesSearchView: View {
    
    @ObservedObject var viewModel: MainScreenViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(colorScheme == .light ? .black : .white)
                    .onTapGesture {
                        viewModel.searchText = ""
                        dismiss()
                    }
                CustomSearchBar(text: $viewModel.searchText,
                                isSearchBarActive: true)
            }
            
            Text("No. of Results: \(viewModel.movieSearchList.count)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                
            
            ScrollView {
                ForEach(viewModel.movieSearchList) { movie in
                    NavigationLink {
                        MovieDetailsView(movie: movie)
                    } label: {
                        SearchResultRowView(movie: movie)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal,16)
    }
}


struct SearchResultRowView: View {
    
    let movie: MovieDetailsModel
    @State var uiImage: UIImage?
    
    var body: some View {
        VStack {
            HStack() {
                ImageDownloadView(uiImage: $uiImage)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.trailing, 20)
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.black)
                        .lineLimit(2)
                    CircularRatingView(rating: movie.rating)
                        .frame(width: 15, height: 15)
                }
                Spacer()
            }
            Divider()
        }
        
        .onAppear {
            guard let imageURL = movie.imageURL, uiImage == nil else { return }
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.uiImage = UIImage(data: data)
                }
            }
            .resume()
        }
    }
}
