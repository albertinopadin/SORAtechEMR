//
//  EMSerialPacket.h
//  Emmoco
//
//  Created by bob frankel on 8/18/11.
//  Copyright 2011 Emmoco, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSchema.h"
#import "EMChecksum.h"

@class EMSchema;

#define EM_MAX_DATA_SIZE 240
#define EM_HEADER_SIZE 4

enum {
    EMSerialPacket_NOP          = 1 << 0,
    EMSerialPacket_FETCH        = 1 << 1,
    EMSerialPacket_FETCH_DONE   = 1 << 2,
    EMSerialPacket_STORE        = 1 << 3,
    EMSerialPacket_STORE_DONE   = 1 << 4,
    EMSerialPacket_INDICATOR    = 1 << 5
};
typedef NSUInteger EMSerialPacketKind;

typedef struct EMSerialPacketHeader {
    int size;
    EMSerialPacketKind kind;
    int resourceId;
} EMSerialPacketHeader;
    
@interface EMSerialPacket : NSObject {

}

@property(readonly) uint8_t* buffer;
@property(readonly) int length;

- (id)initWithSchema:(EMSchema*)resourceSchema;
- (id)initWithSchema:(EMSchema*)resourceSchema withSize:(int)size;
- (void)addChecksum;
- (void)addHeader:(EMSerialPacketHeader*)header;
- (void)addInteger:(long long)anInt forByteSize:(int)size;
- (void)alignTo:(int)align;
- (void)padWithZeroes;
- (void)rewind;
- (void)scanHeader:(EMSerialPacketHeader*)header;
- (long long)scanIntegerForByteSize:(int)size asUnsigned:(BOOL)isUnsigned;

@end
