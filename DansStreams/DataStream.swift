//
//  DataStream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

public class DataInputStream : InputStream {
	var offset: Int = 0
	var data: Data
	
	public init(data: Data) {
		self.data = data
	}
	
	public func hasData(count: Int) -> Bool {
		count > 0 && data.count >= (offset + count)
	}
	
	public func read(count: Int) async throws -> Data {
		if !hasData(count: count) { throw StreamError.endOfStream }
		let result = data.subdata(in: offset..<(offset + count))
		offset += count
		return result
	}

	public func skip(count: Int) async {
		offset += count
	}

}

public class DataOutputStream : OutputStream {
	public var data: Data
	
	public init(data: Data = Data()) {
		self.data = data
	}
	
	public func write(data: Data) async throws {
		self.data.append(data)
	}
	
}
