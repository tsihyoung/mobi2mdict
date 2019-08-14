#!/usr/bin/swift
import Foundation

let file = CommandLine.arguments[1]
let text = try String(contentsOfFile: file)
var lines: [String] = text.components(separatedBy: CharacterSet.newlines)
lines.removeLast(1)

var uidEntry = [String:String]()

for lineNumber in 0..<lines.count where lineNumber%3 == 1 {
    let cur = lines[lineNumber]
    if let idxRange = cur.range(of: "a id=\"") {
        var uid = String()
        for char in cur[idxRange.upperBound...] {
            if char != "\"" {
                uid.append(char)
            } else {
                break
            }
        }
        let prev = lines[lineNumber-1]
        let regular = prev.replacingOccurrences(of: "'", with: "\\'", options: .literal, range: nil).replacingOccurrences(of: "-", with: "\\-", options: .literal, range: nil).replacingOccurrences(of: "/", with: "\\/", options: .literal, range: nil).replacingOccurrences(of: "(", with: "\\(", options: .literal, range: nil).replacingOccurrences(of: ")", with: "\\)", options: .literal, range: nil)
        uidEntry[uid] = regular
    }
}

var counter = 1
let total = uidEntry.count
for (uid,entry) in uidEntry {
    print("gsed -i $'s/<a  href=\\\"#\(uid)\\\" >/<a href=\\\"entry\\:\\/\\/\(entry)\\\">/g' \(file) &&")
    print("echo \"\(counter) ID href replaced\" &&")
    counter += 1
}

counter = 1
for uid in uidEntry.keys {
    print("gsed -i 's/<a id=\\\"\(uid)\\\" \\/>//g' \(file) &&")
    if counter < total {
        print("echo \"\(counter) <a id> removed\" &&")
    } else {
        print("echo \"\(counter) <a id> removed\"")
    }
    counter += 1
}
