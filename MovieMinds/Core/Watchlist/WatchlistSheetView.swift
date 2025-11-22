//
//  WatchlistSheetView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct WatchlistSheetView: View {
    
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            if viewModel.watchlists.isEmpty {
                Spacer()
                VStack(alignment: .center) {
                    Image(systemName: "tray.fill")
                        .resizable()
                        .frame(width: 60, height: 50)
                        .foregroundStyle(.pink)
                    
                    Text(markdown: viewModel.emptyWatchlistText)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else {
                
                HStack(alignment: .bottom) {
                    Text("WatchlistSheetView.yourWatchlists".localized())
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black.opacity(0.6))
                    Spacer()
                }
                .padding(.horizontal, AppConstants.standardPaddingMedium)
                .padding(.bottom, 6)
                
                HStack(spacing: .zero) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .padding(.trailing, 4)
                    Text(viewModel.infoText)
                        .font(.caption)
                    Spacer()
                }
                .padding([.horizontal, .bottom], AppConstants.standardPaddingMedium)
                .foregroundStyle(.gray)
                
                Divider()
                    .foregroundStyle(.gray.opacity(AppConstants.mediumOpacity))
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .zero) {
                        ForEach(viewModel.watchlistNames, id: \.self) { watchlist in
                            Button {
                                viewModel.addWatchlist(watchlistName: watchlist)
                            } label: {
                                WatchlistButtonRowView(name: watchlist)
                            }
                        }
                    }
                }
            }
            
            Button {
                viewModel.showUserInputDialogue = true
                viewModel.showUserWatchlistSheet = false
            } label: {
                addToWatchlistButtonView()
            }
        }
        .padding(.top, 30)
    }
    
    func WatchlistButtonRowView(name: String) -> some View {
        VStack(spacing: .zero) {
            HStack {
                Text(name)
                    .font(.callout)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.leading, AppConstants.standardPaddingMedium)
            .background(.clear)
            Divider()
                .foregroundStyle(.gray.opacity(AppConstants.mediumOpacity))
        }
    }
    
    func addToWatchlistButtonView() -> some View {
        HStack {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 16, height: 16)
            Text("WatchlistSheetView.addAWatchlist".localized())
                .font(.callout)
                .foregroundStyle(.gray)
            Spacer()
        }
        .padding(.leading, AppConstants.standardPaddingMedium)
        .foregroundStyle(.gray)
    }
}
