//
//  HorizontalScrollViewModifier.swift
//  MovieMinds
//
//  Created by Lahori, Divyansh on 11/22/25.
//

import Foundation
import SwiftUI

struct HorizontalScrollViewModifier: ViewModifier {
    let sectionType: MainScreenSection
    func body(content: Content) -> some View {
        content
            .background(sectionType == .yourWatchlists ? .green.opacity(0.2) : .blue.opacity(0.2))
            .border(sectionType == .yourWatchlists ? .green.opacity(0.3) : .blue.opacity(0.3))
            .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 6, bottomLeading: 6)))
            .padding(.leading, 10)
    }
}
