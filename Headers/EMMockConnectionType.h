#import <Foundation/Foundation.h>
#import "EMConnectionType.h"
#import "EMMockDevice.h"

/**
 * A connection type implementatino for mock devices
 */

@interface EMMockConnectionType : NSObject <EMConnectionType> {

}

/**
 * Adds a mock device to the connection type.
 * There are no mock devices available by default.  You must add a mock device using this method to interact with it.
 * @param device The device to add
 */
-(void)addMockDevice:(EMMockDevice *)device;

/**
 * Removes a mock device from the connection type.
 * @param device The device to remove
 */

-(void)removeMockDevice:(EMMockDevice *)device;

@end
