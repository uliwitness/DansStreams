//
//  Stream+TypedAccess.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

extension InputStream {
	
	mutating func read<T: FixedWidthInteger>() async -> T {
		let data = await read(count: MemoryLayout<T>.size)
		return data.withUnsafeBytes { rawBuffer in
			rawBuffer.load(as: T.self)
		}
	}
	
	mutating func readCString(encoding: String.Encoding = .utf8) async -> String? {
		var bytes = [UInt8]()
		while true {
			let byte: UInt8 = await read()
			bytes.append(byte)
			if byte == 0 { break }
		}
		return String(bytes: bytes, encoding: encoding)
	}
	
	mutating func readByteCountedString(encoding: String.Encoding = .utf8) async -> String? {
		let length: UInt8 = await read()
		let data = await read(count: Int(length))
		return String(data: data, encoding: encoding)
	}
	
	mutating func read32CountedString(encoding: String.Encoding = .utf8) async -> String? {
		let length: UInt32 = await read()
		let data = await read(count: Int(length))
		return String(data: data, encoding: encoding)
	}
	
	mutating func read64CountedString(encoding: String.Encoding = .utf8) async -> String? {
		let length: UInt64 = await read()
		let data = await read(count: Int(length))
		return String(data: data, encoding: encoding)
	}
}
