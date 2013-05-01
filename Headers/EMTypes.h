//
//  EMDevice.h
//  Emmoco
//
//  Copyright 2012 Emmoco, Inc.. All rights reserved.
//

typedef enum {
    EMOperationStatusSuccess,
    EMOperationStatusFailure
} EMOperationStatus;

/*
 * Block type used to doing callbacks to user programs. User programs define callbacks conforming to this 
 * block signature and the framework calls them back suppling status value and data object
 */
typedef void(^EMResourceBlock)(EMOperationStatus status, EMResourceValue *value);

typedef void(^EMStatusBlock)(EMOperationStatus status);

typedef void(^EMFailBlock)(NSError *error);