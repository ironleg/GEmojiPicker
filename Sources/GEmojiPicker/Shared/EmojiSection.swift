//
//  EmojiSection.swift
//  GEmojiPickerProject
//
//  Created by GoEun Jeong on 2021/07/23.
//

import SwiftUI

public struct EmojiSection<T: Hashable>: View {
    private var title: String?
    private var items: [T]
    private var contentKeyPath: KeyPath<T, String>
    private var completionHandler: (T) -> Void
    
    private var columns: [GridItem] {
        Array(repeating: .init(.flexible()), count: columnCount)
    }
    
    private var columnCount = 6
    
    public init(title: String? = nil, items: [T], contentKeyPath: KeyPath<T, String>, completionHandler: @escaping (T) -> Void) {
        self.title = title
        self.items = items
        self.contentKeyPath = contentKeyPath
        self.completionHandler = completionHandler
    }
    
    public var body: some View {
        if let title = title {
            Section(header: SectionHeader(title: title)) {
                grid
            }
        } else {
            grid
        }
    }
    
   // macOS에서 다수의 버튼 사용시 로딩 속도가 엄청 느림
#if false
    private var grid: some View {
        LazyVGrid(columns: columns) {
            ForEach(items, id: contentKeyPath) { item in
                Button(action: {
                    completionHandler(item)
                }) {
                    emojiItem(content: item[keyPath: contentKeyPath])
                }
                .buttonStyle(PlainButtonStyle())
                .padding(4)
            }
        }
    }
#else
    private var grid: some View {
        LazyVGrid(columns: columns) {
            ForEach(items, id: contentKeyPath) { item in
                emojiItem(content: item[keyPath: contentKeyPath])
                .padding(4)
                .onTapGesture {
                    completionHandler(item)
                }
            }
        }
    }
#endif
    
    private func emojiItem(content: String) -> some View {
        VStack {
            Text(content)
                 .font(.system(size: 30))
        }
            //.font(.largeTitle)
    }
}

struct EmojiSection_Previews: PreviewProvider {
    static var previews: some View {
        let store = EmojiStore()
        let testItems = Array(store.allEmojis.prefix(12))
        EmojiSection(title: "Test",
                     items: testItems,
                     contentKeyPath: \.string,
                     completionHandler: { _ in })
    }
}


public struct SectionHeader: View {
    public let title: String
    #if os(iOS)
    public let titleFont: Font = .caption
    #elseif os(macOS)
    public let titleFont: Font = .title3
    #endif
    
    public var body: some View {
        #if os(iOS)
        sectionText
        #elseif os(macOS)
        sectionText.padding()
        #endif
    }
    
    var sectionText: some View {
        Text(title)
            .foregroundColor(.gray)
            .font(titleFont)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(filledBackground)
    }
    
    var filledBackground: some View {
        Group {
            #if os(iOS)
            GeometryReader { proxy in
                Color.background
                    .frame(
                        width: proxy.size.width * 3,
                        height: proxy.size.height * 3
                    )
            }
            .offset(x: -20, y: -20)
            #elseif os(macOS)
            EmptyView()
            #endif
        }
    }
}


struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(title: "Test")
    }
}
