//
//  TPCircularBufferFillCount.c
//  AirAP
//
//  Created by neon443 on 04/06/2025.
//

#include "TPCircularBuffer.h"
#include "TPCircularBufferFillCount.h"

int TPCircularBufferFillCount(TPCircularBuffer *buffer) {
	return buffer->fillCount;
}

//TPCircularBufferGetAvailableSpace(<#TPCircularBuffer *buffer#>, <#const AudioStreamBasicDescription *audioFormat#>)
//for later?
