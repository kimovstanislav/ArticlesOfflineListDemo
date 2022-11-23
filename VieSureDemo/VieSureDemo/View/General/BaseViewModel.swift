//
//  BaseViewModel.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 23.11.22.
//

import Foundation

class BaseViewModel: ObservableObject {
    @Published var alertModel: AlertViewModel = AlertViewModel()
    
    func showAlert(title: String, message: String) {
        alertModel.show(title: title, message: message)
    }

    func hide() {
        alertModel.hide()
    }
}
