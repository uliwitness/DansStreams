//
//  FileStream.swift
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

public class FileInputStream : SeekableInputStream {
	var file: UnsafeMutablePointer<FILE>
	
	public init(contentsOf path: String) {
		self.file = fopen(path, "rb")
	}
	
	deinit {
		fclose(file)
	}
	
	public var position: Int {
		set(newPos) {
			fseek(file, newPos, SEEK_SET)
		}
		get {
			return ftell(file)
		}
	}
	
	public func hasData(count: Int) -> Bool {
		let oldpos = ftell(file)
		fseek(file, 0, SEEK_END)
		let endpos = ftell(file)
		return (endpos - oldpos) > count
	}
	
	public func read(count: Int) async throws -> Data {
		var result = Data(count: count)
		let readCount = result.withUnsafeMutableBytes { (buffer: UnsafeMutableRawBufferPointer) -> Int in
			fread(buffer.baseAddress, 1, count, file)
		}
		if result.count != readCount { throw StreamError.endOfStream }
		return result
	}
	
}

public class FileOutputStream : SeekableOutputStream {
	var file: UnsafeMutablePointer<FILE>

	public init(contentsOf path: String) {
		self.file = fopen(path, "wb")
	}
	
	deinit {
		fclose(file)
	}

	public var position: Int {
		set(newPos) {
			fseek(file, newPos, SEEK_SET)
		}
		get {
			return ftell(file)
		}
	}
	
	public func write(data: Data) async throws {
		let writtenBytes = data.withUnsafeBytes { (rawBuffer : UnsafeRawBufferPointer) -> Int in
			fwrite(rawBuffer.baseAddress, 1, rawBuffer.count, file)
		}
		if writtenBytes != data.count { throw StreamError.endOfStream }
		fflush(file)
	}
	
}

public class FileStream : SeekableStream {
	var file: UnsafeMutablePointer<FILE>
	
	public init(contentsOf path: String) {
		self.file = fopen(path, "rb+")
	}
	
	deinit {
		fclose(file)
	}
	
	public var position: Int {
		set(newPos) {
			fseek(file, newPos, SEEK_SET)
		}
		get {
			return ftell(file)
		}
	}
	
	public func hasData(count: Int) -> Bool {
		let oldpos = ftell(file)
		fseek(file, 0, SEEK_END)
		let endpos = ftell(file)
		return (endpos - oldpos) > count
	}
	
	public func read(count: Int) async throws -> Data {
		var result = Data(count: count)
		let readCount = result.withUnsafeMutableBytes { (buffer: UnsafeMutableRawBufferPointer) -> Int in
			fread(buffer.baseAddress, 1, count, file)
		}
		if result.count != readCount { throw StreamError.endOfStream }
		return result
	}
	
	public func write(data: Data) async throws {
		let writtenBytes = data.withUnsafeBytes { (rawBuffer : UnsafeRawBufferPointer) -> Int in
			fwrite(rawBuffer.baseAddress, 1, rawBuffer.count, file)
		}
		if writtenBytes != data.count { throw StreamError.endOfStream }
		fflush(file)
	}
	
}
