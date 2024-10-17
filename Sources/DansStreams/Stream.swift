//
//  Stream.swift
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

enum StreamError: Error {
	/// Either all of stream read, or stream is full and can't write anymore.
	case endOfStream
	/// Couldn't decode the given data as the desired text encoding, or couldn't encode the string to write in the requested encoding.
	case textEncodingUnsuitable
	/// Can't fit the given string or array into the stream with the given length indicator.
	case dataTooLong
}

/// A stream that allows sequentially reading from a given source of bytes.
public protocol InputStream: AnyObject {
	/// Is there currently any data on this stream?
	var hasData: Bool { get }
	
	func hasData(count: Int) -> Bool
	
	func read(count: Int) async throws -> Data
	
	func skip(count: Int) async throws
}

public extension InputStream {
	
	var hasData: Bool {
		return hasData(count: 1)
	}
	
	func skip(count: Int) async throws {
		_ = try await read(count: count)
	}
	
}

/// A stream that allows appending to a given container of bytes.
public protocol OutputStream: AnyObject {
	func write(data: Data) async throws
}

///
public protocol Stream : InputStream, OutputStream {
	
}


public protocol Seekable {
	
	var position: Int { get set }
	
}

public protocol SeekableInputStream: Seekable, InputStream {}
public protocol SeekableOutputStream: Seekable, OutputStream {}
public protocol SeekableStream: Seekable, Stream {}
