#import <UIKit/UIKit.h>

@protocol EMConnectionType;

/**
 * EMDeviceBasicDescription is a class used to describe basic device characteristics throughout the entire framework.
 * All devices, regardless of connection type, will have these properties.
 *
 * All classes implementing the EMConnectionType protocol will receive and deliver device information in the form of an EMDeviceBasicDescription.
 */

@interface EMDeviceBasicDescription : NSObject

/**
 * The name of the device used thoughout the framework.
 * Like the unique_identifier, this property needs to be unique.
 */
@property (nonatomic, strong) NSString *name;

/**
 * A concrete EMConnectionType instance that will be used to send messages to the device.
 */
@property (nonatomic, strong) id<EMConnectionType> connectionType;

/*
 * An object that can describe the device to the provided connection type.
 * For example, for bluetooth, this might be an instance of CBPeripheral.
 */
@property (nonatomic, strong) id deviceObject;

/**
 A value between -100 and 0 used to describe signal strength.
 */
@property (nonatomic) float signalStrength;


/**
 Data that was discovered along with the device.
 Ex: When dealing with bluetooth, this is the advertising packet data
 */
@property (nonatomic, strong) NSData *discoveryData;

@end
