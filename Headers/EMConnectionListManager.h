#import "EMConnectionType.h"
#import <Foundation/Foundation.h>

/**
 * kEMConnectionManagerDidStartUpdating is the name of a notification that is posted when the list manager begins updating, or scanning, for available devices
 */

extern NSString * const kEMConnectionManagerDidStartUpdating;

/**
 * kEMConnectionManagerDidStopUpdating is the name of a notification that is posted when the list manager stops updating, or scanning, for available devices
 */

extern NSString * const kEMConnectionManagerDidStopUpdating;

/**
 * EMConnectionListManager is a singleton class used for viewing a list of devices available for interaction.
 */
@interface EMConnectionListManager : NSObject <EMConnectionTypeScannerDelegate> {
    @private
    NSMutableArray *_deviceListInternalCache;
}

/**
 * @param devices
 * A list of devices that has been discovered as available by the connection list manager
 */
@property (nonatomic, strong, readonly) NSArray *devices;

/**
 * @param filterPredicate
 * A filter that allows only devices conforming to the predicate to be visible
 */
@property (nonatomic, strong) NSPredicate *filterPredicate;

/**
 * @param updating
 * A boolean value indicating whether or not the connection list manager is actively updating the devices list
 */
@property (nonatomic, getter = isUpdating, readonly) BOOL updating;


/**
 * @param automaticallyConnectsToLastDevice
 * A boolean value indicating whether or not the connection list manager should automatically connect to the last device it was connected to if it encounters it in a scan.
 */
@property (nonatomic) BOOL automaticallyConnectsToLastDevice;


/**
 * Use the +sharedManager to get the singleton, shared instance of EMConnectionListManager
 */
+(EMConnectionListManager *)sharedManager;

/**
 * Retrieve a device description for a given unique identifier
 * @param name The name of the device
 */

-(EMDeviceBasicDescription *)deviceBasicDescriptionForDeviceNamed:(NSString *)name;

/**
 * Tells the connection list manager to begin actively looking for devices to interact with.
 */
-(void)startUpdating;

/**
 * Tells the connection list manager to stop looking for devices to interact with.
 */
-(void)stopUpdating;

/**
 * Manually clears out all devices on the connection list manager.
 */
-(void)reset;


/**
 * Adds a connection type to the connection list manager's updates.  Calling this method also begins an update.
 * @param connectionType An instance of a class that implements the EMConnectionType protocol
 */
-(void)addConnectionTypeToUpdates:(id<EMConnectionType>)connectionType;

/**
 * Removes a connection type from the connection list manager's updates.
 * @param connectionType An instance of a class that implements the EMConnectionType protocol
 */
-(void)removeConnectionToFromUpdates:(id<EMConnectionType>)connectionType;

/**
 * Removes all connection types from the connection list manager's updates
 */
-(void)removeAllConnectionTypesFromUpdates;

@end
