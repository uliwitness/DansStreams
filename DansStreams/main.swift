//
//  main.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

let data = "Let's see what this is?\0".data(using: .utf8)!
var inputStream = DataInputStream(data: data)
let str = await inputStream.readCString()!

print("\(str)")

