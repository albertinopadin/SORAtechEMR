#import <Foundation/Foundation.h>
#import "EMResourceValue.h"

/**
 * Access operation is used to describe how resources are being accessed.
 * This type will be used when setting handlers for access in a custom mock device instance.
 */

typedef enum {
    EMMockDeviceAccessOperationRead,
    EMMockDeviceAccessOperationWrite,
} EMMockDeviceAccessOperation;

@class EMMockDevice;

/**
 * The mock device, through the EMMockDeviceDelegate protocol, can communicate indicators up to the application layer.
 * By default, this delegate is set to the EMMockConnectionType this device was added to.
 * In your subclasses of EMMockDevice, call this method on the delegate to send indicators.
 */
@protocol EMMockDeviceDelegate <NSObject>

-(void)mockDevice:(EMMockDevice *)device didUpdateValue:(EMResourceValue *)value;

@optional
-(void)mockDeviceDidConnect:(EMMockDevice *)device;
-(void)mockDeviceDidDisconnect:(EMMockDevice *)device error:(NSError *)error;

@end

/**
 * Mock devices are software simlulated versions of embedded systems.
 * Given an instance of EMSchema, mock devices can simulate just about any real-world embedded device.
 * Your application can assume the mock device and any real world embedded system with the same schema to be identical.
 */
@interface EMMockDevice : NSObject

/**
 * The schema associated with the mock device.
 */
@property (nonatomic, strong) EMSchema *schema;

/**
 * A name for the device.  This will ultimately be used as the -name property in this Mock devices EMDeviceBasicDescription
 */
@property (nonatomic, strong) NSString *deviceName;

/**
 * The delegate to which indicators are sent.
 */
@property (nonatomic, unsafe_unretained) id<EMMockDeviceDelegate> mockDeviceDelegate;

/**
 * Time to delay before connection occurs
 * Use this resource for real-life condition simulation
 */
@property (nonatomic) NSTimeInterval connectionDelayTime;

/**
 * This is the default initializer of all EMMockDevice instances.  Pass the name of a schema in your application bundle and the mock device will be generated around that schema.
 * @param name The name of the schema - do not include a file extension.
 */
-(id)initWithSchemaNamed:(NSString *)name;

/**
 * Use this method to add custom behavior to EMMockDevice subclasses.
 * Instances of EMMockDevice are generally naive.  They read, write, and indicate.  If you want to add behavior when certain properties are read or written, use this method.
 * @param handler A block to execute on on the given access operation
 * @param resourceName The name of the resource being accessed
 * @param operation The access operation that should trigger the handler on the given resource name
 */
-(void)addHandler:(void(^)(EMResourceValue *value))handler forResourceNamed:(NSString *)resourceName accessOperation:(EMMockDeviceAccessOperation)operation;

/**
 * The block passed into this method will be executed at a time interval.
 * Use this method to add internal mock device checks, build in time based behavior, or run checks on state.
 * @param block A block to execute
 * @param delay The delay before executing the block
 * @param repeats A flag indicating whether or not the block should continuously repeat
 */
-(void)executeBlock:(void(^)(void))block withDelay:(NSTimeInterval)delay repeats:(BOOL)repeats;

/**
 * Opens a connection to a mock device
 */
-(void)openConnection;

/**
 * Close connection to a mock device
 */
-(void)closeConnection;

/**
 * Write a value to the mock device.
 * @param value The value to write
 */
-(void)writeValue:(EMResourceValue *)value;

/**
 * Read a value from the mock device.
 * @param name The name of the value to write
 */
-(EMResourceValue *)readResourceNamed:(NSString *)name;


/**
 * Simulate a dropped connection from the mock device
 */
-(void)simulateConnectionInterrupt;

/**
 * The internal mapping of all current resource values
 *
 * Use this in subclasses of EMMockDevice when overriding read or write behavior
 */

-(NSDictionary *)propertyMapping;

@end
