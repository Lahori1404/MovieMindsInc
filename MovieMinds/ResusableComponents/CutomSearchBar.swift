//
//  CutomSearchBarView.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import SwiftUI

/// Custom search bar with SwiftUI custom bar, search icon and cross icon
struct CustomSearchBar: View {
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    var isSearchBarActive: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.leading, 4)
                .foregroundStyle(colorScheme == .light ? .black : .white)
            if isSearchBarActive {
                SearchBar(text: $text)
                    .padding(.horizontal, 0)
                    .frame(height: 38)
                
                Button {
                    // Clear text of search bar textfield
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .padding(.trailing, 8)
                        .foregroundStyle(.gray)
                }
            } else {
                Text("Your Movie")
                    .foregroundColor(.gray)
                    .frame(height: 38)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 19)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1)
        )
    }
}

/// SwiftUI custom bar
struct SearchBar: View {
    @Binding var text: String
    
    @FocusState private var isSearchBarFocused: Bool
    private let placeholder: String = "Your Movie".localized()

    init(text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        Button(action: { }, label: {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
                TextField(placeholder, text: $text) {
                    guard !text.isEmpty else { return }
                }
                .multilineTextAlignment(.leading)
                .focused($isSearchBarFocused)
                .onAppear {
                    isSearchBarFocused = true
                }
                .tint(.black)
                .foregroundStyle(.gray)
            }
        })
        .padding(.horizontal)
    }
}

