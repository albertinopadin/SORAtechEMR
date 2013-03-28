//
//  Visit.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Medicine, Patient;

@interface Visit : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * diastolicBloodPressure;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * patientId;
@property (nonatomic, retain) NSString * pulse;
@property (nonatomic, retain) NSString * systolicBloodPressure;
@property (nonatomic, retain) NSString * temperature;
@property (nonatomic, retain) NSNumber * visitId;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSNumber * doctorId;
@property (nonatomic, retain) NSSet *medicines;
@property (nonatomic, retain) Patient *patient;
@end

@interface Visit (CoreDataGeneratedAccessors)

- (void)addMedicinesObject:(Medicine *)value;
- (void)removeMedicinesObject:(Medicine *)value;
- (void)addMedicines:(NSSet *)values;
- (void)removeMedicines:(NSSet *)values;

@end
