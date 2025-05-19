//
//  CircularBuffer.swift
//  AirAP
//
//  Created by neon443 on 19/05/2025.
//

import Foundation

class CircularBuffer {
	private var buffer = TPCircularBuffer()
	
	init(size: Int32 = 131-072) {
		let success = _TPCircularBufferInit(&buffer, size, MemoryLayout.size(ofValue: buffer))
		assert(success, "failed to init tpcirc buffer")
	}
	
	deinit {
		TPCircularBufferClear(&buffer)
	}
	
	func write(audio: UnsafeRawPointer, size: Int32) {
		TPCircularBufferProduceBytes(&buffer, audio, size)
	}
	
	func read(length: Int32) -> Data? {
		var available: Int32 = 0
		guard
			let pointer = TPCircularBufferTail(&buffer, &available),
			available > 0
		else {
			return nil
		}
		
		let length = min(length, available)
		let data = Data(bytes: pointer, count: Int(length))
		TPCircularBufferConsume(&buffer, length)
		return data
	}
	
	func clean() {
		TPCircularBufferClear(&buffer)
	}
	
	var dataCount: Int32 {
		buffer.fillCount
	}
}
