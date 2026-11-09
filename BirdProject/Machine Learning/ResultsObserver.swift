//
//  ResultsObserver.swift
//  BirdProject
//
//  Created by Marina Gomes Fontenele on 12/08/26.
//

import SoundAnalysis
import Combine  //gerencia fluxo de dados orinetados a eventos

class ResultsObserver : NSObject, SNResultsObserving {  //NSObject é uma classe de objetos em objective-c /
    
    //PassthroughSubject funciona como canal de comunicação, recebendo resultados e erros da análise
    private let subject: PassthroughSubject<SNClassificationResult, Error>
    
    init(subject: PassthroughSubject<SNClassificationResult, Error>) {
        self.subject = subject
    }
    
    //quando obtem um resultado
    func request(_ request: SNRequest, didProduce result: SNResult) {
        if let result = result as? SNClassificationResult {
            subject.send(result)
        }
    }
    
    //quando ocorre um erro
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \\(error.localizedDescription)")
        subject.send(completion: .failure(error))
    }
    
    //quando análise termina com sucesso
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
        subject.send(completion: .finished)
    }
}
