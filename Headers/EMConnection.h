
/** @file */ 

#import <Foundation/Foundation.h>
#import "EMSchema.h"
#import "EMConnectionType.h"
#import "EMTypes.h"

@class EMConnection;

@protocol EMConnectionDelegate <NSObject>

-(void)connectionDidTimeout:(EMConnection *)connection;
-(void)connectionDidDisconnect:(EMConnection *)connection;

@end

/**
 * The state of the current connection.  Use KVO to receive updates on this property and react to changes.
 */

typedef enum {
    EMConnectionStateDisconnected, // Disconnected state, no error
    EMConnectionStatePending, // A connection has been started, and is pending completion
    EMConnectionStateSchemaNotFound, // The schema for the connection is not in the application bundle
    EMConnectionStateInvalidSchemaHash, // The device didn't respond with a valid schema hash
    EMConnectionStateConnected, // Connected state, no error
    EMConnectionStateDisrupted, // The connection was interrupted
    EMConnectionStatePendingForDefaultSchema, // The schema could not be found and the connection is being "forced" with the provided default schema.  Note: This state will only occur if you have provided a default schema and told the connection manager to force a connection with it.
    EMConnectionStateTimeout // The connection timed out
} EMConnectionState;

extern NSString * const kEMConnectionDidReceiveIndicatorNotificationName;
extern NSString * const kEMIndicatorResourceKey;
extern NSString * const kEMIndicatorNameKey;
extern NSString * const kEMConnectionErrorDomain;

@interface EMConnection : NSObject <EMDeviceDelegate> {
    @protected
    EMSchema *_systemSchema;
}

/**
 * This block will be called when an open connection is closed for any reason
 */
@property (atomic, strong) EMResourceBlock connectionClosedBlock;

/**
 * The timeout interval for a pending connection
 */
@property (atomic) NSTimeInterval connectionAttemptTimeout;

/**
 * The connection delegate.  EMConnectionManager will post connect and disconnect delegate messages to this object if it is set.
 */
@property (nonatomic, unsafe_unretained) id<EMConnectionDelegate> connectionDelegate;


/**
 * The EMDeviceBasicDescription used for conenction
 */
@property (nonatomic, strong) EMDeviceBasicDescription *device;

/**
 *  The schema for connection
 */
@property (nonatomic, strong) EMSchema *schema;


/**
 * Creates a new EMConnection object.
 * Actual connection and disconnection to the named target occurs through calls to open and close on this object.
 * @param device The basic description of a device
 */
- (id)initWithDevice:(EMDeviceBasicDescription *)device;

/**
 * Creates a new EMTargetConnection object.
 * Actual connection and disconnection to the named target occurs through calls to open and close on this object.
 * @param device the name of the target device, including one of the pre-defined prefixes
 * @param resourceSchema the schema describing the resources available in this connection
 */
- (id)initWithDevice:(EMDeviceBasicDescription *)device schema:(EMSchema*)resourceSchema;


/**
 * Returns true if connected and false otherwise.
 */
- (BOOL)isConnected;

/**
 * Opens a connection to the @device device property
 * @param successBlock A block to call on a successful connect
 * @param failBlock A block to call on a failed connect
 */
- (void)openConnectionWithSuccess:(EMResourceBlock)successBlock onFail:(EMFailBlock)failBlock;

/**
 * Cancels the attempt to open this EMTargetConnection, posting the open block with a failed status.
 */
- (void)cancelOpen;

/**
 * Closes the connection
 * @param successBlock A block to call on a successful disconnect
 * @param failBlock A block to call on a failed disconnect
 */
- (void)closeConnectionWithSuccess:(EMResourceBlock)successBlock onFail:(EMFailBlock)failBlock;

/**
 * Reads a value
 * @param resourceName The name of the resource to read
 * @param successBlock A block to call on a successful read
 * @param failBlock A block to call on a failed read
 */
-(void)readValueNamed:(NSString *)resourceName onSuccess:(EMResourceBlock)successBlock onFail:(EMFailBlock)failBlock;

-(void)readSystemValueNamed:(NSString *)resourceName onSuccess:(EMResourceBlock)successBlock onFail:(EMFailBlock)failBlock;

/**
 * Writes a resource to the device
 * @param resourceValue The resource value
 * @param successBlock A block to call on a successful write
 * @param failBlock A block to call on a failed write
 */

-(void)writeResource:(EMResourceValue *)resourceValue onSuccess:(EMResourceBlock)successBlock onFail:(EMFailBlock)failBlock;

- (NSString*)connectedDeviceSchemaHash;


@end

