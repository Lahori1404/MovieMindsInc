//
//  ImageDownloadView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

struct ImageDownloadView: View {
    @Binding var uiImage: UIImage?
    var body: some View {
        if let image = uiImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            placeHolderImageViewBuilder()
        }
    }
    
    @ViewBuilder
    func placeHolderImageViewBuilder() -> some View {
        Rectangle().fill(.gray)
            .opacity(0.3)
            .overlay {
                Image(systemName: "movieclapper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            }
    }
}
