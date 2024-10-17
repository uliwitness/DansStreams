//
//  DataStream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
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
	}

}
