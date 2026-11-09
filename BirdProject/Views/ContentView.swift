//
//  ContentView.swift
//  BirdProject
//
//  Created by Marina Gomes Fontenele on 12/08/26.
//

import SwiftUI

struct ContentView: View {
    
    let viewModel = SoundDetectionViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "bird.fill")
                    .imageScale(.large)
                    .foregroundStyle(.purpleBird)
                Text("Bird Sound")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.purpleBird)
            }
            
            Spacer()
            
            if !viewModel.detectionStarted {
                ContentUnavailableView("Nenhum Som Detectado", systemImage: "waveform.badge.magnifyingglass", description: Text("Clique no microfone para identificar o \n canto de um pássaro."))
                
            } else if let predictedSound = viewModel.identifiedSound {
                VStack(spacing: 10) {
                    
                    Image(predictedSound.0)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(14)
                        .padding(.horizontal,80)
                    Text(predictedSound.0)
                        .font(.system(size: 26))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(.backPurple)
                        })
                    Text("\(predictedSound.1) de certeza")
                        .font(.system(size: 16))
                        .foregroundStyle(.backPurple)
                        .fontWeight(.semibold)
                }
                .multilineTextAlignment(.center)
                .padding()
                .foregroundStyle(.white)
//               .background(content: {
//                    RoundedRectangle(cornerRadius: 14)
//                        .fill(.backPurple)
//                })
            } else {
                ProgressView("Analisando som...")
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    viewModel.detectionStarted.toggle()
                }
                viewModel.detectionStarted ? viewModel.startDetection() : viewModel.stopDetection()
            } label: {
                Circle()
                    .frame(maxWidth: 90, maxHeight: 80)
                    .overlay(alignment: .center) {
                        Image(systemName: viewModel.detectionStarted ? "stop.fill" : "microphone.fill")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(5)
                            .font(.system(size: 34))
                            .accessibilityHidden(true)
                            .shadow(color: .gray, radius: 5)
                    }
//                Image(systemName: viewModel.detectionStarted ? "stop.fill" : "mic.fill")
//                    .font(.system(size: 50))
//                    .padding(30)
//                    .background(viewModel.detectionStarted ? .gray.opacity(0.7) : Color(.purpleBird))
//                    .foregroundStyle(.white)
//                    .clipShape(Circle())
//                    .shadow(color: .gray, radius: 5)
//                    .contentTransition(.symbolEffect(.replace))
            }
            .tint(.purpleBird)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
