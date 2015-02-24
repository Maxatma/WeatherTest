//
//  Weather.h
//  Test
//
//  Created by Alexander on 1/20/15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) NSNumber * tempMin;
@property (nonatomic, retain) NSNumber * tempMax;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSNumber * windSpeed;

@end
