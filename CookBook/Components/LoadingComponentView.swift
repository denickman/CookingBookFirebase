//
//  LoadingComponentView.swift
//  CookBook
//
//  Created by Denis Yaremenko on 12.07.2025.
//

import SwiftUI

struct LoadingComponentView: View {
    var body: some View {
        ZStack {
            Color.black.opacity((0.4))
            
            ProgressView()
                .tint(.white)
              
        }
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    LoadingComponentView()
}
