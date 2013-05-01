//
//  EMSchema.h
//  Emmoco
//
//  Created by bob frankel on 8/7/11.
//  Copyright 2011 Emmoco, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMResourceValue.h"

typedef enum {
    EMResourceAccessTypeRead = 1 << 0,
    EMResourceAccessTypeWrite = 1 << 1,
    EMResourceAccessTypeIndicate = 1 << 2,
} EMResourceAccessType;

@class EMResourceValue;

/**
 * A set of meta-data describing a set of resources.
 * Written by Bob Frankel and Carolyn Vaughan
 */
@interface EMSchema : NSObject {

}

/**
 * Creates a EMResourceSchema instance from the contents of a file.
 * @param fileName a file containing JSON content
 * @return a newly created EMResourceSchema instance
 */
+ (EMSchema*)schemaFromFile:(NSString*)fileName;

/**
 * Get the read/write/indicator access capabilities of a named resource
 * @param resourceName a valid resource name in this schema
 * @return an NSString containing the characters 'r', 'w', and 'i' as appropriate
 * @exception UsageError the resource name is invalid
 */
- (EMResourceAccessType)accessForResource:(NSString*)resourceName;

/**
 * Returns a sorted NSArray containing all application resource names in this schema
 */
- (NSArray*)applicationResources;

/**
 * Get the parameters associated with a number type.
 * @param type a valid number type name in this schema
 * @return a four-element NSArray holding the min, max, step, and prec parameters of this type
 * @exception UsageError the number type name is invalid
 */
- (NSArray*)numberParametersForType:(NSString*)type;

/**
* Get the representation type associated with a number type.
* @param type a valid number type name in this schema
* @return an integral representation type
* @exception UsageError the number type name is invalid
*/
- (NSString*)numericRepresentationForType:(NSString*)type;

/**
 * Get the values associated with an enum type.
 * @param type a valid enum type name in this schema
 * @return a NSDictionary containing enum value names and their corresponding ordinal
 * @exception UsageError the enum type name is invalid
 */
- (NSDictionary*)enumValuesForType:(NSString*)type;

/**
 * Get the names of the fields associated with a struct type.
 * @param type a valid struct type name in this schema
 * @return a NSArray containing field names
 * @exception UsageError the struct type name is invalid
 */
- (NSArray*)fieldNamesForType:(NSString*)type;

/**
 * Get the fields associated with a struct type.
 * @param type a valid struct type name in this schema
 * @return a NSDictionary containing field names and their corresponding type code
 * @exception UsageError the struct type name is invalid
 */
- (NSDictionary*)fieldsForType:(NSString*)type;

/**
 * Get the length of this string type.
 * @param type a valid string type name in this schema
 * @return the length of this string type
 * @exception UsageError the string type name is invalid
 */
- (int)stringLengthForType:(NSString*)type;

/**
 * Returns the fully-qualified name of this schema.
 */
- (NSString*)name;

/**
 * Returns the protocol level of this schema
 */
- (int)protocolLevel;

/**
 * Returns an NSDictionary containing all resource names in this schema and their corresponding type code.
 */
- (NSDictionary*)resources;

/**
 * Returns the maximum size in bytes amongst all resource types in this schema.
 */
- (int)maxResourceSize;

/**
 * Get the alignment of a named resource
 * @param resourceName a named resource in this schema
 * @return the alignment in bytes of this resource
 * @exception UsageError the resource name is invalid
 */
- (int)byteAlignmentForResource:(NSString*)resourceName;

/**
 * Get the unique id associated with a named resource
 * @param resourceName a named resource in this schema
 * @return the corresponding resource id
 * @exception UsageError the resource name is invalid
 */
- (int)idForResource:(NSString*)resourceName;

/**
 * Get the resource name associated with this resource id
 * @param resourceId a resource id
 * @return the corresponding resource name
 * @exception UsageError the resource id is invalid
 * @see idForResource:
 */
- (NSString*)nameForResourceWithID:(int)resourceId;

/**
 * Get the size of a named resource
 * @param resourceName a named resource in this schema
 * @return the size in bytes of this resource
 * @exception UsageError the resource name is invalid
 */
- (int)sizeForResourceNamed:(NSString*)resourceName;

/**
 * Get the size of a standard scalar type
 * @param type a scalar type code
 * @return the size in bytes of this standard type
 * @exception UsageError the type code is invalid
 */
- (int)sizeForStandardType:(NSString*)type;

/**
 * Get the alignment of a standard scalar type
 * @param type a scalar type code
 * @return the alignment in bytes of this standard type
 * @exception UsageError the type code is invalid
 */
- (int)alignmentForStandardType:(NSString*)type;

/**
 * Returns a sorted NSArray containing all system resource names in this schema
 */
- (NSArray*)systemResources;

/**
 * Get the type of a named resource
 * @param resourceName the name of a resource in this schema
 * @return the type code associated with this resource
 * @exception UsageError the resource name is invalid
 */
- (NSString*)typeOfResourceNamed:(NSString*)resourceName;

/**
 * Returns the owner of the schema definition this schema was created from.
 */
- (NSString*)owner;

/**
 * Returns the version of the schema definition this schema was created from.
 */
- (NSString*)version;

/**
 * Returns the description associated with this schema.
 */
- (NSString*)schemaDescription;

/**
 * Returns the UUID associated with this schema.
 */
- (NSString*)UUID;

/**
 * Returns the UUID associated with this schema as an array of numbers.
 */
- (NSArray *)numericalUUID;

/**
 * Returns the build number associated with this schema as an array of numbers.
 */
- (NSArray *)buildDate;

/**
 * Returns the schema hash associated with this schema as an array of numbers.
 */
- (NSArray *)schemaHash;

/**
 * Create a new ResourceValue instance for a named resource.
 * @param resourceName a named resource in this schema
 * @return a newly created EMResourceValue to a value for this resource
 * @exception UsageError the resource name is invalid
 */
- (EMResourceValue*)newResourceValueForResourceNamed:(NSString*)resourceName;

/* 
 * TODO - fill in this documentation 
 */
- (BOOL)validateResourceNamed:(NSString*)resourceName withAccess:(EMResourceAccessType)access;

-(NSNumber *)embeddedProtocolNumber;

@end
