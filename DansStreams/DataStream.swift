//
//  DataStream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

public struct DataInputStream : InputStream {
	var offset: Int = 0
	var data: Data
	
	public init(data: Data) {
		self.data = data
	}
	
	public func hasData(count: Int) -> Bool {
		count > 0 && data.count >= (offset + count)
	}
	
	public mutating func read(count: Int) async -> Data? {
		if !hasData(count: count) {
			return nil
		}
		let result = data.subdata(in: offset..<(offset + count))
		offset += count
		return result
	}

	public mutating func skip(count: Int) async {
		offset += count
	}

}

public struct DataOutputStream : OutputStream {
	public var data: Data
	
	public init(data: Data = Data()) {
		self.data = data
	}
	
	public mutating func write(data: Data) async {
		self.data.append(data)
	}
	
}
