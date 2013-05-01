//
//  EMChecksum.h
//  Emmoco
//
//  Created by bob frankel on 8/18/11.
//  Copyright 2011 Emmoco, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMChecksum : NSObject {

}

- (void)addByte:(int)byte;
- (void)clear;
- (int)sum;

@end
