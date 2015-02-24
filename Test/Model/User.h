//
//  User.h
//  Test
//
//  Created by Alexander on 1/19/15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSNumber * userEnabled;
@property (nonatomic, retain) NSString * photo;

@end
