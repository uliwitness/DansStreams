import Testing
@testable import DansStreams

@Test func testFileStream() async throws {
	let fileOutputStream = FileOutputStream(contentsOf: "Testfile.data")
	let expectedString = "My name is Gully Foyle, and Terra is my Nation."
	let dataToWrite = (expectedString + "\0").data(using: .utf8)!
	try await fileOutputStream.write(data: dataToWrite)
	
	let fileInputStream = FileInputStream(contentsOf: "Testfile.data")
	let readString = try await fileInputStream.readCString()
	#expect(readString == expectedString)
}

@Test func testDataStream() async throws
{
	let expectedString = "Let's see what this is?"
	let dataToWrite = (expectedString + "\0").data(using: .utf8)!
	let dataInputStream = DataInputStream(data: dataToWrite)
	let readString = try await dataInputStream.readCString()

	#expect(readString == expectedString)

}
