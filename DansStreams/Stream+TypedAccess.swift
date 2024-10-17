//
//  Stream+TypedAccess.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

extension InputStream {
	
	mutating func read<T: FixedWidthInteger>() async -> T? {
		guard let data = await read(count: MemoryLayout<T>.size) else { return nil }
		return data.withUnsafeBytes { rawBuffer in
			rawBuffer.load(as: T.self)
		}
	}
	
	mutating func readCString(encoding: String.Encoding = .utf8) async -> String? {
		var bytes = [UInt8]()
		while true {
			guard let byte: UInt8 = await read() else { return nil }
			if byte == 0 { break }
			bytes.append(byte)
		}
		return String(bytes: bytes, encoding: encoding)
	}
	
	mutating func readByteCountedString(encoding: String.Encoding = .utf8) async -> String? {
		guard let length: UInt8 = await read() else { return nil }
		guard let data = await read(count: Int(length)) else { return nil }
		return String(data: data, encoding: encoding)
	}
	
	mutating func read32CountedString(encoding: String.Encoding = .utf8) async -> String? {
		guard let length: UInt32 = await read() else { return nil }
		guard let data = await read(count: Int(length)) else { return nil }
		return String(data: data, encoding: encoding)
	}
	
	mutating func read64CountedString(encoding: String.Encoding = .utf8) async -> String? {
		guard let length: UInt64 = await read() else { return nil }
		guard let data = await read(count: Int(length)) else { return nil }
		return String(data: data, encoding: encoding)
	}
}
