//
//  ReceipeDetailView.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 4/5/2024.
//

import SwiftUI

struct ReceipeDetailView: View {
    
    let receipe: Receipe
    
    var body: some View {
        VStack(alignment: .leading) { 

//            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
//                Image(receipe.image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 250)
//                    .clipped()
//            } else {
                AsyncImage(url: URL(string: receipe.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 250)
                        Image(systemName: "photo.fill")
                    }
                }
//            }

            HStack {
                Text(receipe.name)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
                Image(systemName: "clock.fill")
                    .font(.system(size: 15))
                Text("\(receipe.time) mins")
                    .font(.system(size: 15))
            }
            .padding(.top)
            .padding(.horizontal)
            Text(receipe.instructions)
                .font(.system(size: 15))
                .padding(.top, 10)
                .padding(.horizontal)
            Spacer()
        }
        
        .onAppear {
            for (key, value) in ProcessInfo.processInfo.environment {
                print("\(key): \(value)")
            }
        }
    }
}

#Preview {
    ReceipeDetailView(receipe: Receipe.mockReceipes[2])
}
