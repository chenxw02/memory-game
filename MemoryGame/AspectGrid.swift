//
//  AspectGrid.swift
//  MemoryGame
//
//  Created by Christopher Chan on 2/22/23.
//

import SwiftUI

// create our own stack
// this takes an Item and returns an ItemView
// generally this strcut produces a View, so it inherits View
// use <Item, ItemView> to declare this struct dose not really care the type of Item and ItemView
// ItemView produces a View, so it inherits View to
// use Identifiable to declare that Item is identifiable, in other words, it has a unique ID
struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    // content takes an Item and produces an ItemView
    // content need to be told how to turn an Item into an ItemView
    var content: (Item)->ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
            // we stack them together for future development
            VStack(){
                // columns: [GridItem(.adaptive(minimum: width))], spacing: 0: set the space between rows to 0
                // we need a func to set the space between columns to 0
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    // for every instance in items, we calls content to produce a ItemView for them
                    ForEach(items) {
                        item in
                        content(item).aspectRatio(2/3,contentMode: .fit)
                    }
                    
                }
                Spacer(minLength: 0)
            }
        }
        
    }
    
    // this func generates GridItems, set their column space to 0, and returns
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    // this func returns the expected width of every card
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount+(columnCount-1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}
