//
//  Medicine.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visit;

@interface Medicine : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * dosage;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSString * maternalLastName;
@property (nonatomic, retain) NSNumber * medicineId;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * paternalLastName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * purpose;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * visitId;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * patientId;
@property (nonatomic, retain) Visit *visit;

@end
