//
//  ProgressComponentView.swift
//  CookBook
//
//  Created by Denis Yaremenko on 14.07.2025.
//

import SwiftUI

struct ProgressComponentView: View {
    
    @Binding var value: Float
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
            ProgressView("Uploading...", value: 5, total: 10)
                .padding(.horizontal)
               
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProgressComponentView(value: .constant(0.5))
}
