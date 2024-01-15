//
//  MarkdownTheme.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import MarkdownUI
import SwiftUI

extension Theme {
    static let user = Theme()
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
        }
        .link {
            ForegroundColor(.purple)
        }
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }
        .text {
            BackgroundColor(.blue)
        }

    static let assistant = Theme()
        .code {
            FontFamilyVariant(.monospaced)
            FontSize(.em(0.85))
        }.codeBlock { conf in
            conf.label
                .padding(.horizontal, 16)
                .padding(.vertical, 20)

                .markdownTextStyle {
                    ForegroundColor(.white)
                }
                .background(RoundedRectangle(cornerRadius: 8).fill(.black))
                .overlay(alignment: .topTrailing) {
                    Button (action: {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(conf.content, forType: .string)
                        print(conf.content)
                    }) {
                        Image(systemName: "doc.on.doc")
                    }.padding()
                }
        }
        .link {
            ForegroundColor(.purple)
        }
        .paragraph { configuration in
            configuration.label
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
        }
        .listItem { configuration in
            configuration.label
                .markdownMargin(top: .em(0.25))
        }
        .text {
            BackgroundColor(.white)
            ForegroundColor(.black)
        }
    
}
