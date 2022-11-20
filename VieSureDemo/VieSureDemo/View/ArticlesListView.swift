//
//  ContentView.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 11.11.22.
//

import SwiftUI

struct ArticlesListView: View {
    @ObservedObject var viewModel: ArticlesListViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView(viewModel: ArticlesListViewModel())
    }
}
