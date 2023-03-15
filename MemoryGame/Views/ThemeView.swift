//
//  ThemeView.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/26/23.
//

import SwiftUI

struct ThemeView: View {
    @ObservedObject var theme = ThemeViewModel()
    @State var showAddSheet: Bool = false
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(theme.themes){ theme in
                        // navigate to game
                        NavigationLink(destination: GameView(message: theme.themeContent, count: theme.themeContent.count*2)){
                            ListItemView(title: theme.themeTitle, content: theme.themeContent)
                        }
                            
                        
                    }
                    .onDelete(perform: theme.delete)
                    .onMove(perform: theme.move)
                }.navigationTitle("Themes")
                    .navigationBarTitleDisplayMode(.automatic)
                    .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                        showAddSheet.toggle()
                    }, label: {Text("Add")})
                        .sheet(isPresented: $showAddSheet, content: {AddThemeView(themeItem: theme)}))
                
            }
            
        }
    }
}

struct ListItemView: View {
    let title: String
    let content: String
    var body: some View {
        VStack(spacing: 5){
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                Spacer()
            }
            HStack {
                Text(content)
                Spacer()
            }
        }
    }
}

struct themeView_Previews: PreviewProvider {
    static var previews: some View {
        let theme = ThemeViewModel()
        ThemeView()
        AddThemeView(themeItem: theme)
    }
    
}
