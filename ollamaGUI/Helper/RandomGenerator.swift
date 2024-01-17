//
//  RandomGenerator.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/17/24.
//

import Foundation

#if DEBUG
    enum RandomGenerator {
        static var randomNames: [String] {
            [
                "Unboxing the Secrets of [Mysterious Subject]: A Journey of Discovery",
                "From Novice to Ninja: Mastering the Art of [Intriguing Skill]",
                "Beyond the Surface: A Deep Dive into the World of [Unfamiliar Topic]",
                "Confessions of a [Unexpected Profession]: The Untold Stories of [Intriguing Aspect]",
                "The Unexpected Twists and Turns of [Intriguing Event]: A Story You Won't Believe",
                "Cracking the Code: Unraveling the Mysteries of [Complex Phenomenon]",
                "From Zero to Hero: My Personal Quest to Conquering [Daunting Challenge]",
                "Inside the Minds of [Fascinating Group]: A Glimpse into Their [Unique Perspective]",
                "The Forgotten Tale of [Historical Event or Figure]: A Retelling for the Modern Age",
                "Navigating the Labyrinth: A Guide to Surviving [Challenging Situation]",
            ]
        }
        
        static func randomDate(in range: Range<Date> = (Date.now - 100000)..<Date.now) -> Date {
                Date(
                    timeIntervalSinceNow: .random(
                        in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
                    )
                )
            }
        
    }
#endif
