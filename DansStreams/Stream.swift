//
//  Stream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

/// A stream that allows sequentially reading from a given source of bytes.
public protocol InputStream {
	/// Is there currently any data on this stream?
	var hasData: Bool { get }
	
	func hasData(count: Int) -> Bool
	
	mutating func read(count: Int) async -> Data?
	
	mutating func skip(count: Int) async
}

public extension InputStream {
	
	var hasData: Bool {
		return hasData(count: 1)
	}
	
	mutating func skip(count: Int) async {
		_ = await read(count: count)
	}
	
}

/// A stream that allows appending to a given container of bytes.
public protocol OutputStream {
	mutating func write(data: Data) async
}

///
public protocol Stream : InputStream, OutputStream {
	
}
