//
//  SoundDetectionViewModel.swift
//  BirdProject
//
//  Created by Marina Gomes Fontenele on 12/08/26.
//

import Observation
import SoundAnalysis
import Combine

@Observable
class SoundDetectionViewModel {
    
    @ObservationIgnored
    let soundAnalysisManager = SoundAnalysisManager.shared
    
    @ObservationIgnored
    var lastTime: Double = 0
    
    var detectionStarted = false
    var identifiedSound: (identifier: String, confidence: String)?
    private var detectionCancellable: AnyCancellable? = nil
    
    //formata o audio
    private func formattedDetectionResult(_ result: SNClassificationResult) -> (identifier: String, confidence: String)? {
        //recebe o resultado do sound analysis e pega a primeira classificação
        guard let classification = result.classifications.first else { return nil }
        
        if lastTime == 0 {
            lastTime = result.timeRange.start.seconds
        }
        
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds - lastTime)
        print("Analysis result for audio at time: \(formattedTime)")
        
        let displayName = classification.identifier.replacingOccurrences(of: "_", with: " ").capitalized
        let confidence = classification.confidence
        let confidencePercentString = String(format: "%.2f%%", confidence  * 100.0)
        print("\(displayName): \(confidencePercentString) confidence.\n")
        
        return (displayName, confidencePercentString)
    }
    
    func startDetection() {
        //cria um PassthroughSubject para receber os resultados
        let classificationSubject = PassthroughSubject<SNClassificationResult, Error>()
        
        detectionCancellable = classificationSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in self.detectionStarted = false },
                  receiveValue: { result in
                //formata um resultado quando ele chega
                self.identifiedSound = self.formattedDetectionResult(result)
            })
        
        //começa a capturar e analisar o audio
        soundAnalysisManager.startSoundClassification(subject: classificationSubject)
    }
    
    //zera o tempo, pega o ultimo som identificado e para a classificação
    func stopDetection() {
        lastTime = 0
        identifiedSound = nil
        soundAnalysisManager.stopSoundClassification()
    }
}
