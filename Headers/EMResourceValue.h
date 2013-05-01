//
//  EMResourceValue.h
//  Emmoco
//
//  Created by bob frankel on 8/8/11.
//  Copyright 2011 Emmoco, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMSerialPacket.h"

@class EMSchema;
@class EMSerialPacket;
@class EMResourceValue;

/**
 * A protocol to define the methods that all EMResourceValue subclasses must define.
 *
 * Written by Carolyn Vaughan
 */

@protocol EMResourceValueProtocol

/**
 * Internal initialization method used by EMResourceValue subclasses
 * @param theName the name of this value
 * @param theType the type of this value
 * @param theResourceSchema the schema associated with this value
 * @return this value
 */
- (id)initWithName:(NSString*)theName type:(NSString*)theType schema:(EMSchema*)theResourceSchema;

/**
 * Returns true if the type of this value is an Array, and false otherwise.
 */
- (BOOL)isArray;

/**
 * Returns true if the type of this value is a Num, and false otherwise.
 */
- (BOOL)isNum;

/**
 * Returns true if the type of this value is an Enum, and false otherwise.
 */
- (BOOL)isEnum;

/**
 * Returns true if the type of this value is a File, and false otherwise.
 */
- (BOOL)isFile;

/**
 * Returns true if the type of this value is an Int, and false otherwise.
 */
- (BOOL)isInt;

/**
 * Returns true if the type of this value is a String, and false otherwise.
 */
- (BOOL)isString;

/**
 * Returns true if the type of this value is scalar (Num, Enum, Int, String), and false otherwise.
 */
- (BOOL)isScalar;

/**
 * Return true if the type of this value is a Struct, and false otherwise.
 */
- (BOOL)isStruct;

/**
 * Return true if the type of this value is a Void, and false otherwise.
 */
- (BOOL)isVoid;

/**
 * Used to put the resource's value to the device
 * @param buffer the data buffer being sent to the device
 *
 * The PUT is based on RESTful resourcing
 */
- (void)putData:(EMSerialPacket*)buffer;

/**
 * Used to get the resource's value from the device
 * @param buffer the data buffer being received from the device
 * @param size the amount of data the buffer holds
 *
 * The GET is based on RESTful resourcing
 */
- (void)getDataOfSize:(int)size fromBuffer:(EMSerialPacket*)buffer;

/**
 * Assign a double value to a resource.
 * @param value the value to be assigned, represented as a double
 */
- (void)setDoubleValue:(double)value;

/**
 * Assign a long value to a resource.  For Num and Enum resources, this sets the ordinal value for the resource instead of setting the value directly.
 * @param value the value to be assigned, represented as a long
 */
- (void)setLongValue:(long long)value;

/**
 * Assign a string value to a resource.
 * @param value the value to be assigned, represented as a String
 */
- (void)setStringValue:(NSString*)value;

/**
 * This ResourceValue, as a double.
 * @exception UsageError the type of this value is not a Num
 */
- (double)doubleValue;

/**
 * This ResourceValue, as a long.  For Num and Enum resources, this returns the ordinal value for the resource instead of the actual value.
 * @exception UsageError the type of this value is not a Scalar
 */
- (long long)longValue;

/**
 * This ResourceValue, as a String.
 * @exception UsageError the type of this value is not a Scalar
 */
- (NSString*)stringValue;

/**
 * Assign another resource value's value to this resource value
 * @param source the ResourceValue who's value you wish to assign to this EMResourceValue instance
 */
- (void)copyFromResource:(EMResourceValue*)source;

/**
 * Reset this ResourceValue to its initial state upon creation
 */
- (void)reset;

/**
 * The minimum numerical value for this ResourceValue.
 */
- (double)min;

/**
 * The maximum numerical value for this ResourceValue.
 */
- (double)max;

/**
 * The step for this ResourceValue.
 */
- (double)step;

/**
 * The maximum number of distinct values for this ResourceValue.
 */
- (long)length;

/**
 * An array of acceptable enum values for this ResourceValue.
 */
- (NSArray *)enumValues;

/**
 * An array of acceptable field names for this ResourceValue.
 */
- (NSArray *)fieldNames;

/**
 * Select a ResourceValue element from a ResourceValue Array by index
 * @param index the element to be selected 
 * @return the indexed element
 */
- (EMResourceValue*)index:(int)index;

/**
 * Select a ResourceValue element from a ResourceValue Struct by field name
 * @param fieldName the element to be selected 
 * @return the ResourceValue held in the selected field
 */
- (EMResourceValue*)select:(NSString*)fieldName;

/**
 * Return the end-of-file status for this ResourceValue File.  For internal use only. 
 */
- (BOOL)fileEof;

/**
 * Prepare a local file associated with this ResourceValue File for reading.  For internal use only;
 d*/
- (void)fileFetch;

/**
 * Prepare a local file associated with this ResourceValue File for writing.  For internal use only;
 */
- (void)fileStore;

-(NSData *)fileData;

@end

/**
 * A container for different types of resource values.
 * Instances of this class are used to hold values for resources whose types is
 * either Void, Int, Enum, Num, String, Struct, Array, or File.
 *
 * See also:
 *
 * - [EMSchema newResourceValueForResourceNamed:]
 *
 * Written by Bob Frankel and Carolyn Vaughan
 */
@interface EMResourceValue : NSObject <EMResourceValueProtocol> {

}

/**
 * The name of the resource.
 */
@property(readonly) NSString* name;

/**
 * The resource schema associated with the resource.
 */
@property(readonly) EMSchema* resourceSchema;

/**
 * The type of the resource.
 */
@property(readonly) NSString* type;

- (int)valueSize;
/**
 * Create a EMResourceValue.  This method is used internally by the framework.
 * @param name the name given to the newly-created value
 * @param type the type of the newly-created value
 * @param resourceSchema an EMSchema instance
 * @return a new EMResourceValue instance
 */
+ (EMResourceValue*)resourceWithName:(NSString*)name ofType:(NSString*)type fromSchema:(EMSchema*)resourceSchema;

@end

