#import <Foundation/Foundation.h>

/**
 * A block based extension for NSTimer
 */

@interface NSTimer (EMAdditions)

/**
 * Allows you set a block for execution when the timer fires.
 * @param interval The time interval
 * @param block The block to execute
 * @param repeat A flag to indicate if the block should continuously repeat
 */
+(NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeat;

@end
