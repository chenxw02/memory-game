//
//  ThemeModel.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/26/23.
//

import Foundation

struct ThemeModel {
    
    private(set) var themes: Array<Theme> = []{
        didSet{
            save()
        }
    }
    
    private let themesKey: String = "theme_list"
    
    struct Theme: Identifiable, Codable {
        let themeTitle: String
        let themeContent: String
        let id: String
    }
    
    init(){
        // default themes
        let item1=Theme(themeTitle: "Sports Balls", themeContent: "⚽️🏀🏈⚾️🥎🎾🏐🏉", id: UUID().uuidString)
        let item2=Theme(themeTitle: "Vegetables", themeContent: "🍅🍆🥦🥬🥒🌶🫑🌽", id: UUID().uuidString)
        let item3=Theme(themeTitle: "Fruits", themeContent: "🍏🍎🍐🍊🍋🍌🍉🍇", id: UUID().uuidString)
        let item4=Theme(themeTitle: "Animals", themeContent: "🐶🐱🐭🐹🐰🦊🐻🐼", id: UUID().uuidString)
        themes.append(item1)
        themes.append(item2)
        themes.append(item3)
        themes.append(item4)
        load()
    }
    
    mutating func delete(indexSet: IndexSet){
        themes.remove(atOffsets: indexSet)
    }
    
    mutating func move(indices: IndexSet, newOffset: Int){
        print("entering move")
        themes.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    mutating func add(title: String, content: String) -> Int{
        let flag = contentCheck(title: title, content: content)
        if flag == 0 {
            let item = Theme(themeTitle: title, themeContent: content, id: UUID().uuidString)
            themes.append(item)
        }
        return flag
    }
    
    func save() {
        if let encodedData = try? JSONEncoder().encode(themes) {
            UserDefaults.standard.set(encodedData, forKey: themesKey)
        }
    }
    
    mutating func load(){
        guard
            let data = UserDefaults.standard.data(forKey: themesKey),
            let savedThemes = try? JSONDecoder().decode([Theme].self, from: data)
        else {
            return
        }
        
        self.themes = savedThemes
    }
    
    func contentCheck(title: String, content: String) -> Int{
        print("entering contentCheck")
        if title.count < 16 && title.count > 0 {
            let emojiContent = content.emojiString
            let emojiCount = emojiContent.count
            if Set(emojiContent).count == emojiContent.count {
                if emojiCount > 3 && emojiCount < 11 {
                    return 0
                } else if emojiCount <= 3{
                    // emojis too few
                    return 3
                } else {
                    // emojis too many
                    return 4
                }
            } else {
                // duplicats
                return 5
            }
        } else if title.count == 0 {
            // title missing
            return 1
        } else {
            // title too long
            return 2
        }
    }
    
    
}

extension Character {
    // A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    // Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var emojis: [Character] { filter { $0.isEmoji } }
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
}

