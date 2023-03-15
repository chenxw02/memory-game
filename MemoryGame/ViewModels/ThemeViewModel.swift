//
//  ThemeViewModel.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/26/23.
//

import SwiftUI

class ThemeViewModel: ObservableObject {
    
    @Published private(set) var model = ThemeModel()
    
    var themes: Array<ThemeModel.Theme> {
        model.themes
    }
    
    func delete(indexSet: IndexSet){
        model.delete(indexSet: indexSet)
    }
    
    func move(indices: IndexSet, newOffset: Int){
        model.move(indices: indices, newOffset: newOffset)
    }
    
    func add(title: String, content: String) -> Int{
        model.add(title: title, content: content)
    }
    
    func contentCheck(title: String, content: String) -> Int{
        model.contentCheck(title: title, content: content)
    }
}
