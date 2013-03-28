//
//  Patient.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 3/22/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visit;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSNumber * alzheimerDisease;
@property (nonatomic, retain) NSNumber * cancer;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * dateOfBirth;
@property (nonatomic, retain) NSNumber * diabetes;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * emeCity;
@property (nonatomic, retain) NSString * emeEmail;
@property (nonatomic, retain) NSString * emeFirstName;
@property (nonatomic, retain) NSString * emeLine1;
@property (nonatomic, retain) NSString * emeLine2;
@property (nonatomic, retain) NSString * emeMaternalLastName;
@property (nonatomic, retain) NSString * emeMiddleName;
@property (nonatomic, retain) NSString * emePaternalLastName;
@property (nonatomic, retain) NSString * emePhoneNumber;
@property (nonatomic, retain) NSString * emeState;
@property (nonatomic, retain) NSString * emeZip;
@property (nonatomic, retain) NSString * empCity;
@property (nonatomic, retain) NSString * empEmail;
@property (nonatomic, retain) NSString * empLine1;
@property (nonatomic, retain) NSString * empLine2;
@property (nonatomic, retain) NSString * empName;
@property (nonatomic, retain) NSString * empPhoneNumber;
@property (nonatomic, retain) NSString * empState;
@property (nonatomic, retain) NSString * empZip;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * groupNumber;
@property (nonatomic, retain) NSNumber * heartDisease;
@property (nonatomic, retain) NSNumber * influenza;
@property (nonatomic, retain) NSString * insuranceName;
@property (nonatomic, retain) NSNumber * kidneyDisease;
@property (nonatomic, retain) NSString * line1;
@property (nonatomic, retain) NSString * line2;
@property (nonatomic, retain) NSNumber * majorInjury;
@property (nonatomic, retain) NSString * maternalLastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * paternalLastName;
@property (nonatomic, retain) NSNumber * patientId;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * piCity;
@property (nonatomic, retain) NSString * piDateOfBirth;
@property (nonatomic, retain) NSString * piEmail;
@property (nonatomic, retain) NSString * piEmpCity;
@property (nonatomic, retain) NSString * piEmpEmail;
@property (nonatomic, retain) NSString * piEmpLine1;
@property (nonatomic, retain) NSString * piEmpLine2;
@property (nonatomic, retain) NSString * piEmpName;
@property (nonatomic, retain) NSString * piEmpPhoneNumber;
@property (nonatomic, retain) NSString * piEmpState;
@property (nonatomic, retain) NSString * piEmpZip;
@property (nonatomic, retain) NSString * piFirstName;
@property (nonatomic, retain) NSString * piLine1;
@property (nonatomic, retain) NSString * piLine2;
@property (nonatomic, retain) NSString * piMaternalLastName;
@property (nonatomic, retain) NSString * piMiddleName;
@property (nonatomic, retain) NSString * piPaternalLastName;
@property (nonatomic, retain) NSString * piPhoneNumber;
@property (nonatomic, retain) NSString * piSocialSecurityNumber;
@property (nonatomic, retain) NSString * piState;
@property (nonatomic, retain) NSString * piZip;
@property (nonatomic, retain) NSString * policyNumber;
@property (nonatomic, retain) NSString * relationshipToPrimaryInsured;
@property (nonatomic, retain) NSNumber * respiratoryDiseases;
@property (nonatomic, retain) NSNumber * septicemia;
@property (nonatomic, retain) NSString * sGroupNumber;
@property (nonatomic, retain) NSString * sInsuranceName;
@property (nonatomic, retain) NSString * socialSecurityNumber;
@property (nonatomic, retain) NSString * sPiCity;
@property (nonatomic, retain) NSString * sPiDateOfBirth;
@property (nonatomic, retain) NSString * sPiEmail;
@property (nonatomic, retain) NSString * sPiEmpCity;
@property (nonatomic, retain) NSString * sPiEmpEmail;
@property (nonatomic, retain) NSString * sPiEmpLine1;
@property (nonatomic, retain) NSString * sPiEmpLine2;
@property (nonatomic, retain) NSString * sPiEmpName;
@property (nonatomic, retain) NSString * sPiEmpPhoneNumber;
@property (nonatomic, retain) NSString * sPiEmpState;
@property (nonatomic, retain) NSString * sPiEmpZip;
@property (nonatomic, retain) NSString * sPiFirstName;
@property (nonatomic, retain) NSString * sPiLine1;
@property (nonatomic, retain) NSString * sPiLine2;
@property (nonatomic, retain) NSString * sPiMaternalLastName;
@property (nonatomic, retain) NSString * sPiMiddleName;
@property (nonatomic, retain) NSString * sPiPaternalLastName;
@property (nonatomic, retain) NSString * sPiPhoneNumber;
@property (nonatomic, retain) NSString * sPiSocialSecurityNumber;
@property (nonatomic, retain) NSString * sPiState;
@property (nonatomic, retain) NSString * sPiZip;
@property (nonatomic, retain) NSString * sPolicyNumber;
@property (nonatomic, retain) NSString * srelationshipToPrimaryInsured;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * stroke;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *visits;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addVisitsObject:(Visit *)value;
- (void)removeVisitsObject:(Visit *)value;
- (void)addVisits:(NSSet *)values;
- (void)removeVisits:(NSSet *)values;

@end
