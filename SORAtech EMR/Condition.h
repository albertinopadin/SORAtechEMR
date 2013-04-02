//
//  Condition.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/2/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visit;

@interface Condition : NSManagedObject

@property (nonatomic, retain) NSString * conditionName;
@property (nonatomic, retain) NSNumber * patientId;
@property (nonatomic, retain) NSNumber * visitId;
@property (nonatomic, retain) Visit *conditions;

@end
