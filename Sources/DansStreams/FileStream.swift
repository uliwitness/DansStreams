//
//  FileStream.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
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
