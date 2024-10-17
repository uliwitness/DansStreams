//
//  Stream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
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
