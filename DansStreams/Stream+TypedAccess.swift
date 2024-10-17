//
//  Stream+TypedAccess.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

extension InputStream {
	
	func read<T: FixedWidthInteger>() async throws -> T {
		let data = try await read(count: MemoryLayout<T>.size)
		return data.withUnsafeBytes { rawBuffer in
			rawBuffer.load(as: T.self)
		}
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

	func writeCString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		try await write(data: data)
		try await write(UInt8(0))
	}

	func writeByteCountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt8.max else { throw StreamError.stringTooLong }
		try await write(UInt8(data.count))
		try await write(data: data)
	}

	func write16CountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt16.max else { throw StreamError.stringTooLong }
		try await write(UInt16(data.count))
		try await write(data: data)
	}

	func write32CountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt32.max else { throw StreamError.stringTooLong }
		try await write(UInt32(data.count))
		try await write(data: data)
	}

	func write64CountedString(_ str: String, encoding: String.Encoding = .utf8) async throws {
		guard let data = str.data(using: encoding) else { throw StreamError.textEncodingUnsuitable }
		guard data.count <= UInt64.max else { throw StreamError.stringTooLong }
		try await write(UInt64(data.count))
		try await write(data: data)
	}

}
