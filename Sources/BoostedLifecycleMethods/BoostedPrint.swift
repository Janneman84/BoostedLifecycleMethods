//
//  BoostedPrint.swift
//  BoostedLifecycleMethods
//
//  Created by Jan de Vries on 06/06/2026.
//

import Foundation

nonisolated(unsafe) var debuggy = false

//formatter for print()'s timestamp (below), is lazily instantiated so never gets called in release builds:
nonisolated(unsafe) fileprivate var printTimeDateFormatter : DateFormatter = {
    let tdf = DateFormatter()
    tdf.dateFormat = "HH:mm:ss.SSS"
    return tdf
}()


//redefinition of print() so it only prints to console in debug builds, and adds a timestamp which is often handy:
func print(_ items: Any..., separator: String = "", terminator: String = "\n") {
    #if DEBUG
    if debuggy {
        var idx = items.startIndex
        let endIdx = items.endIndex
        repeat {
            Swift.print("\(printTimeDateFormatter.string(from: Date())) \(items[idx])", separator: separator, terminator: idx+1 == endIdx ? terminator : separator)
            idx += 1
        }
        while idx < endIdx
    }
    #endif
}
