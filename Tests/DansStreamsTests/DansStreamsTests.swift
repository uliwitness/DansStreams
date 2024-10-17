//
//  DansStreamsTests.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//
//	Copyright (c) 2024 Uli Kusterer
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this
//	software and associated documentation files (the "Software"), to deal in the Software
//	without restriction, including without limitation the rights to use, copy, modify,
//	merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//	permit persons to whom the Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be included in all copies
//	or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//	PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//	CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//	OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Testing
@testable import DansStreams

@Test func testFileStream() async throws {
	let fileOutputStream = FileOutputStream(contentsOf: "Testfile.data")
	let expectedString = "My name is Gully Foyle, and Terra is my Nation."
	let dataToWrite = (expectedString + "\0").data(using: .utf8)!
	try await fileOutputStream.write(data: dataToWrite)
	
	let fileInputStream = FileInputStream(contentsOf: "Testfile.data")
	let readString = try await fileInputStream.readCString()
	#expect(readString == expectedString)
}

@Test func testDataStream() async throws
{
	let expectedString = "Let's see what this is?"
	let dataToWrite = (expectedString + "\0").data(using: .utf8)!
	let dataInputStream = DataInputStream(data: dataToWrite)
	let readString = try await dataInputStream.readCString()

	#expect(readString == expectedString)

}
