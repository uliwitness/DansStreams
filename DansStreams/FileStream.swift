//
//  FileStream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

public struct FileInputStream : InputStream {
	var file: UnsafeMutablePointer<FILE>
	
	public init(contentsOf path: String) {
		self.file = fopen(path, "r")
	}
	
	public func hasData(count: Int) -> Bool {
		data.count > offset
	}
	
	public mutating func read(count: Int) async -> Data {
		let result = data.subdata(in: offset..<(offset + count))
		offset += count
		return result
	}
	
}

public struct FileOutputStream : OutputStream {
	var file: UnsafeMutablePointer<FILE>

	public init(contentsOf path: String) {
		self.file = fopen(path, "w")
	}

	public mutating func write(data: Data) async {
		data.withUnsafeBytes { (rawBuffer : UnsafeRawBufferPointer) -> Void in
			fwrite(UnsafeRawPointer(rawBuffer), 1, data.count, file)
		}
	}
	
}
