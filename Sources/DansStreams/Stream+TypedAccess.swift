//
//  Stream+TypedAccess.swift
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

extension InputStream {
	
	func read<T: FixedWidthInteger>() async throws -> T {
		let data = try await read(count: MemoryLayout<T>.size)
		return data.withUnsafeBytes { rawBuffer in
			rawBuffer.load(as: T.self)
		}
	}
	
	func readByteCountedArray<T: FixedWidthInteger>() async throws -> [T] {
		let count: UInt8 = try await read()
		var result = [T](repeating: 0, count: Int(count))
		for x in 0..<Int(count) {
			result[x] = try await read()
		}
		return result
	}
	
	func read16CountedArray<T: FixedWidthInteger>() async throws -> [T] {
		let count: UInt16 = try await read()
		var result = [T](repeating: 0, count: Int(count))
		for x in 0..<Int(count) {
			result[x] = try await read()
		}
		return result
	}
	
	func read32CountedArray<T: FixedWidthInteger>() async throws -> [T] {
		let count: UInt32 = try await read()
		var result = [T](repeating: 0, count: Int(count))
		for x in 0..<Int(count) {
			result[x] = try await read()
		}
		return result
	}
	
	func read64CountedArray<T: FixedWidthInteger>() async throws -> [T] {
		let count: UInt64 = try await read()
		var result = [T](repeating: 0, count: Int(count))
		for x in 0..<Int(count) {
			result[x] = try await read()
		}
		return result
	}

	func readCString(encoding: String.Encoding = .utf8) async throws -> String {
		var bytes = [UInt8]()
		while true {
			let byte: UInt8 = try await read()
			if byte == 0 { break }
			bytes.append(byte)
		}
		guard let result = String(bytes: bytes, encoding: encoding) else { throw StreamError.textEncodingUnsuitable }
		return result
	}
	
	func readByteCountedString(encoding: String.Encoding = .utf8) async throws -> String {
		let length: UInt8 = try await read()
		let data = try await read(count: Int(length))
		guard let result = String(data: data, encoding: encoding) else { throw StreamError.textEncodingUnsuitable }
		return result
	}
	
	func read16CountedString(encoding: String.Encoding = .utf8) async throws -> String {
		let length: UInt16 = try await read()
		let data = try await read(count: Int(length))
		guard let result = String(data: data, encoding: encoding) else { throw StreamError.textEncodingUnsuitable }
		return result
	}
	
	func read32CountedString(encoding: String.Encoding = .utf8) async throws -> String {
		let length: UInt32 = try await read()
		let data = try await read(count: Int(length))
		guard let result = String(data: data, encoding: encoding) else { throw StreamError.textEncodingUnsuitable }
		return result
	}

	func read64CountedString(encoding: String.Encoding = .utf8) async throws -> String {
		let length: UInt64 = try await read()
		let data = try await read(count: Int(length))
		guard let result = String(data: data, encoding: encoding) else { throw StreamError.textEncodingUnsuitable }
		return result
	}
	
}

extension OutputStream {
	
	func write<T: FixedWidthInteger>(_ num: T) async throws {
		var vNum = num
		let data = withUnsafeBytes(of: &vNum) { (buf: UnsafeRawBufferPointer) -> Data? in
			guard let ba = buf.baseAddress else { return nil }
			return Data(bytes: ba, count: MemoryLayout<T>.size)
		}
		try await write(data: data!)
	}

	func writeByteCountedArray<T: FixedWidthInteger>(_ nums: [T]) async throws {
		guard nums.count > UInt8.max else { throw StreamError.dataTooLong }
		try await write(UInt8(nums.count))
		for num in nums {
			try await write(num)
		}
	}

	func write16CountedArray<T: FixedWidthInteger>(_ nums: [T]) async throws {
		guard nums.count > UInt16.max else { throw StreamError.dataTooLong }
		try await write(UInt16(nums.count))
		for num in nums {
			try await write(num)
		}
	}

	func write32CountedArray<T: FixedWidthInteger>(_ nums: [T]) async throws {
		guard nums.count > UInt32.max else { throw StreamError.dataTooLong }
		try await write(UInt32(nums.count))
		for num in nums {
			try await write(num)
		}
	}

	func write64CountedArray<T: FixedWidthInteger>(_ nums: [T]) async throws {
		guard nums.count > UInt64.max else { throw StreamError.dataTooLong }
		try await write(UInt64(nums.count))
		for num in nums {
			try await write(num)
		}
	}

	func writeCString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		try await write(data: data)
		try await write(UInt8(0))
	}

	func writeByteCountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt8.max else { throw StreamError.dataTooLong }
		try await write(UInt8(data.count))
		try await write(data: data)
	}

	func write16CountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt16.max else { throw StreamError.dataTooLong }
		try await write(UInt16(data.count))
		try await write(data: data)
	}

	func write32CountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt32.max else { throw StreamError.dataTooLong }
		try await write(UInt32(data.count))
		try await write(data: data)
	}

	func write64CountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt64.max else { throw StreamError.dataTooLong }
		try await write(UInt64(data.count))
		try await write(data: data)
	}

}
