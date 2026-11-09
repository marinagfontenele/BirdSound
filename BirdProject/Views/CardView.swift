//
//  CardView.swift
//  BirdProject
//
//  Created by Marina Gomes Fontenele on 13/08/26.
//

import SwiftUI

struct CardView: View {
    
    let viewModel = SoundDetectionViewModel()
  //  let predictedSound = viewModel.identifiedSound
    
    var body: some View {
        VStack(spacing: 10) {
            Image("Bem-Te-Vi")
                .resizable()
                .scaledToFit()
                .cornerRadius(14)
                .padding(.horizontal,80)
            Text("Bem-te-vi")
                .font(.system(size: 26))
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .background(content: {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.backPurple)
                })
            Text("100.0% de certeza")
                .font(.system(size: 16))
                .foregroundStyle(.backPurple)
                .fontWeight(.semibold)
        }
        .multilineTextAlignment(.center)
        .padding()
        .foregroundStyle(.white)
//        .background(content: {
//            RoundedRectangle(cornerRadius: 14)
//                .fill(.gray.opacity(0.2))
//        })
    }
}

#Preview {
    CardView()
}
