//
//  Stream+TypedAccess.swift
//  DansStreams
//
//  Created by Uli Kusterer on 17.10.24.
//

import Foundation

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
	
	mutating func read16CountedString(encoding: String.Encoding = .utf8) async -> String? {
		guard let length: UInt16 = await read() else { return nil }
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

extension OutputStream {
	
	mutating func write<T: FixedWidthInteger>(_ num: T) async {
		var vNum = num
		let data = withUnsafeBytes(of: &vNum) { (buf: UnsafeRawBufferPointer) -> Data? in
			guard let ba = buf.baseAddress else { return nil }
			return Data(bytes: ba, count: MemoryLayout<T>.size)
		}
		guard let data = data else { return }
		await write(data: data)
	}

	mutating func writeCString(_ str: String) async {
		guard let data = str.data(using: .utf8) else { return }
		await write(data: data)
		await write(UInt8(0))
	}

	mutating func writeByteCountedString(_ str: String) async {
		guard let data = str.data(using: .utf8) else { return }
		guard data.count <= UInt8.max else { return }
		await write(UInt8(data.count))
		await write(data: data)
	}

	mutating func write16CountedString(_ str: String) async {
		guard let data = str.data(using: .utf8) else { return }
		guard data.count <= UInt16.max else { return }
		await write(UInt16(data.count))
		await write(data: data)
	}

	mutating func write32CountedString(_ str: String) async {
		guard let data = str.data(using: .utf8) else { return }
		guard data.count <= UInt32.max else { return }
		await write(UInt32(data.count))
		await write(data: data)
	}

	mutating func write64CountedString(_ str: String) async {
		guard let data = str.data(using: .utf8) else { return }
		guard data.count <= UInt64.max else { return }
		await write(UInt64(data.count))
		await write(data: data)
	}

}
