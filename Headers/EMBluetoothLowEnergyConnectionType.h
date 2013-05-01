#import <Foundation/Foundation.h>
#import "EMConnectionType.h"
#import <CoreBluetooth/CoreBluetooth.h>

/**
 * EMBluethoothLowEnergyConnectionType is a concrete EMConnectionType for Bluetooth Low Energy.
 *
 * If you want the framework to interact with Bluetooth Low Energy devices, add an instance of this class to EMConnectionListManager via the -addConnectionTypeToUpdates: method.
 */

@interface EMBluetoothLowEnergyConnectionType : NSObject <EMConnectionType, CBCentralManagerDelegate, CBPeripheralDelegate> {

}

@property (nonatomic) NSTimeInterval scanResetTime;

@end
