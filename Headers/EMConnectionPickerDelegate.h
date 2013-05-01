#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>
#import "EMDeviceBasicDescription.h"

/**
 * Objects that implement EMConnectionPickerDelegate are responsible for handling callbacks from EMConnectionIndicator
 */

@protocol EMConnectionPickerDelegate <NSObject>

/**
 * The connection picker has chosen a device.
 */
-(void)connectionPickerDidSelectDevice:(EMDeviceBasicDescription *)device;

/**
 * The connection picker has cancelled selection.
 */
-(void)connectionPickerDidCancel:(id)sender;

@end