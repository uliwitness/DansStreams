//
//  main.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

var fOutputStream = FileOutputStream(contentsOf: "Testfile.data")
let fData = "My name is Gully Foyle, and Terra is my Nation.\0".data(using: .utf8)!
await fOutputStream.write(data: fData)

var fInputStream = FileInputStream(contentsOf: "Testfile.data")
let fStr = await fInputStream.readCString()!
print("fStr = \(fStr)")

let data = "Let's see what this is?\0".data(using: .utf8)!
var inputStream = DataInputStream(data: data)
let str = await inputStream.readCString()!

print("str = \(str)")

