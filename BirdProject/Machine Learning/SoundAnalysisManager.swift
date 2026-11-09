//
//  SoundAnalysisManager.swift
//  BirdProject
//
//  Created by Marina Gomes Fontenele on 12/08/26.
//

import SoundAnalysis
import Combine

final class SoundAnalysisManager: NSObject {
    
    private let bufferSize = 8192
    
    private var audioEngine: AVAudioEngine?
    private var inputBus: AVAudioNodeBus?
    private var inputFormat: AVAudioFormat?
    
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    
    private let analysisQueue = DispatchQueue(label: "com.createwithswift.AnalysisQueue")
    
    private var retainedObserver: SNResultsObserving?
    private var subject: PassthroughSubject<SNClassificationResult, Error>?
    
    static let shared = SoundAnalysisManager()
    
    private override init() {}
    
    //pega entrada do microfone e obtem também o formato do áudio
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        let inputBus = AVAudioNodeBus(0)
        self.inputBus = inputBus
        inputFormat = audioEngine?.inputNode.inputFormat(forBus: inputBus)
    }
    
    //adiciona uma requisição de classificação
    private func startAnalysis(_ requestAndObserver: (request: SNRequest, observer: SNResultsObserving)) throws {
        setupAudioEngine()
        
        guard let audioEngine = audioEngine,
              let inputBus = inputBus,
              let inputFormat = inputFormat else { return }
        
        let streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        self.streamAnalyzer = streamAnalyzer
        try streamAnalyzer.add(requestAndObserver.request, withObserver: requestAndObserver.observer)
        retainedObserver = requestAndObserver.observer
        
        //instala um tap para capturar os buffers de audio e bota eles em uma fila
        self.audioEngine?.inputNode.installTap(
            onBus: inputBus,
            bufferSize: UInt32(bufferSize),
            format: inputFormat
        ) { buffer, time in
            self.analysisQueue.async {
                self.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    func startSoundClassification(subject: PassthroughSubject<SNClassificationResult, Error>,
                                  inferenceWindowSize: Double? = nil,
                                  overlapFactor: Double? = nil) {
        do {
            let observer = ResultsObserver(subject: subject)
            
            //trasforma o modelo em uma requisição do Sound Analysis
            let soundClassifier = try BirdSoundClassifier4(configuration: MLModelConfiguration())
            let model = soundClassifier.model
            let request = try SNClassifySoundRequest(mlModel: model)
            
            if let inferenceWindowSize = inferenceWindowSize {
                request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 48_000)
            }
            if let overlapFactor = overlapFactor {
                request.overlapFactor = overlapFactor
            }
            
            //isso será passado para o subject e a função startAnalysis será chamada
            self.subject = subject
            try startAnalysis((request, observer))
        } catch {
            print("Unable to prepare request with Sound Classifier: \(error.localizedDescription)")
            subject.send(completion: .failure(error))
            self.subject = nil
        }
    }
    
    //remove requisições e libera StreamAnalyzer, observer e audio engine
    func stopSoundClassification() {
        autoreleasepool {
            if let audioEngine = audioEngine {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }
            if let streamAnalyzer = streamAnalyzer {
                streamAnalyzer.removeAllRequests()
            }
            streamAnalyzer = nil
            retainedObserver = nil
            audioEngine = nil
        }
    }
}
