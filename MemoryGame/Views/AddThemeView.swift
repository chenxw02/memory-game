//
//  AddThemeView.swift
//  MemoryGame
//
//  Created by Christopher Chan on 3/1/23.
//

import SwiftUI

struct AddThemeView: View {
    let themeItem: ThemeViewModel
    @State var themeName: String = ""
    @State var themeContent: String = ""
    @State var alertFlag: Int = 0
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @Environment(\.dismiss) var dismissSheet
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {dismissSheet()}, label: {Text("Cancel")})
                Spacer()
                Button {
                    alertFlag=themeItem.add(title: themeName, content: themeContent)
                    if alertFlag == 0 {
                        dismissSheet()
                    } else {
                        if alertFlag == 1 {
                            alertTitle = alertOptions.titleTooShort.title
                            alertMessage = alertOptions.titleTooShort.message
                        } else if alertFlag == 2 {
                            alertTitle = alertOptions.titleTooLong.title
                            alertMessage = alertOptions.titleTooLong.message
                        } else if alertFlag == 3 {
                            alertTitle = alertOptions.emojiTooFew.title
                            alertMessage = alertOptions.emojiTooFew.message
                        } else if alertFlag == 4 {
                            alertTitle = alertOptions.emojisTooMany.title
                            alertMessage = alertOptions.emojisTooMany.message
                        } else if alertFlag == 5 {
                            alertTitle = alertOptions.duplicates.title
                            alertMessage = alertOptions.duplicates.message
                        }
                        showAlert.toggle()
                    }
                    
                } label: {
                    Text("Done")
                }
                
            }.padding()
            
            VStack(spacing: 10) {
                
                // I tried to put this comb into a View, but ran into binding erros
                HStack {
                    Text("Name")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                TextField("Type anything🤪", text: $themeName)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.15).cornerRadius(10))
                    .foregroundColor(.black)
                
                HStack {
                    Text("Content")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                
                TextField("Any emoji you like will do😘", text: $themeContent)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.15).cornerRadius(10))
                    .foregroundColor(.black)
            }.padding(.horizontal)
            
            Spacer()
            
            Text("Type in at least 4 emojis and no more than 10 emojis.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.leading)
            
            
        }
        .navigationTitle("Add a new theme ")
        .alert(isPresented: $showAlert) {
            getAlert(title: alertTitle, message: alertMessage)
        }
        
    }
    
    func getAlert(title: String, message: String) -> Alert {
        let button = Alert.Button.default(Text("OK"))
        return Alert(title: Text(title), message: Text(message), dismissButton: button)
    }
    
    struct alertOptions {
        struct titleTooLong {
            static let title: String = "Title too long!"
            static let message: String = "Please keep your chosen name in 15 characters🙁"
        }
        struct titleTooShort {
            static let title: String = "No name!"
            static let message: String = "Please choose a name for this collection🤓"
        }
        struct emojisTooMany {
            static let title: String = "Too many emojis!"
            static let message: String = "You can only choose at most 10 emojis for this collection, pick up your favorites🤪"
        }
        struct emojiTooFew {
            static let title: String = "Too few emojis!"
            static let message: String = "Please at least choose 4 emojis for this collection😘"
        }
        struct duplicates {
            static let title: String = "Duplicates!"
            static let message: String = "Sorry, but one emoji can only appear once🥶"
        }
    }
}
