//
//  DataStream.swift
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

import Foundation

public class DataInputStream : SeekableInputStream {
	var data: Data
	
	public init(data: Data) {
		self.data = data
	}
	
	public var position: Int = 0
	
	public func hasData(count: Int) -> Bool {
		count > 0 && data.count >= (position + count)
	}
	
	public func read(count: Int) async throws -> Data {
		if !hasData(count: count) { throw StreamError.endOfStream }
		let result = data.subdata(in: (data.startIndex + position)..<(data.startIndex + position + count))
		position += count
		return result
	}

	public func skip(count: Int) async {
		position += count
	}

}

public class DataOutputStream : SeekableOutputStream {
	public var data: Data
	public var position: Int = 0

	public init(data: Data = Data()) {
		self.data = data
	}
	
	public func write(data: Data) async throws {
		let minLen = position + data.count
		if self.data.count < minLen {
			self.data.count = minLen
		}
		self.data.replaceSubrange((data.startIndex + position)..<(data.startIndex + position + data.count), with: data)
		position += data.count
	}
	
}

public class DataStream : SeekableStream {
	var data: Data
	public var position: Int = 0

	public init(data: Data = Data()) {
		self.data = data
	}
	
	public func hasData(count: Int) -> Bool {
		count > 0 && data.count >= (position + count)
	}
	
	public func read(count: Int) async throws -> Data {
		if !hasData(count: count) { throw StreamError.endOfStream }
		let result = data.subdata(in: (data.startIndex + position)..<(data.startIndex + position + count))
		position += count
		return result
	}

	public func skip(count: Int) async {
		position += count
	}
	
	public func write(data: Data) async throws {
		let minLen = position + data.count
		if self.data.count < minLen {
			self.data.count = minLen
		}
		self.data.replaceSubrange((data.startIndex + position)..<(data.startIndex + position + data.count), with: data)
		position += data.count
	}

}
