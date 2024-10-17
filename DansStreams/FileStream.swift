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
		self.file = fopen(path, "rb")
	}
	
	public func hasData(count: Int) -> Bool {
		let oldpos = ftell(file)
		fseek(file, 0, SEEK_END)
		let endpos = ftell(file)
		return (endpos - oldpos) > count
	}
	
	public mutating func read(count: Int) async -> Data? {
		var result = Data(count: count)
		let readCount = result.withUnsafeMutableBytes { (buffer: UnsafeMutableRawBufferPointer) in
			fread(buffer.baseAddress, 1, count, file)
		}
		if result.count != readCount {
			result.count = readCount
		}
		return result
	}
	
}

public struct FileOutputStream : OutputStream {
	var file: UnsafeMutablePointer<FILE>

	public init(contentsOf path: String) {
		self.file = fopen(path, "wb")
	}

	public mutating func write(data: Data) async {
		data.withUnsafeBytes { (rawBuffer : UnsafeRawBufferPointer) -> Void in
			fwrite(rawBuffer.baseAddress, 1, rawBuffer.count, file)
		}
		fflush(file)
	}
	
}
