//
//  BaseViewModel.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 23.11.22.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var alertModel: AlertViewModel = AlertViewModel()
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertModel.show(title: title, message: message)
        }
    }

    func hideAlert() {
        DispatchQueue.main.async {
            self.alertModel.hide()
        }
    }
    
    func processError(_ error: DetailedError) {
        ErrorLogger.logError(error)
        if error.isSilent { return }
        showAlert(title: error.title, message: error.message)
    }
}
