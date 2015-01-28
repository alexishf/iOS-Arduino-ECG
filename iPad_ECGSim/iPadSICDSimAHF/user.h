//
//  user.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 21/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject

@property (strong,nonatomic) NSString* userName;


@property (strong,nonatomic) NSNumber* pointsThisExperience;

// Pointer to the experience list
@property (strong,nonatomic) NSMutableArray *experiencesList;

// Points for every experience for this user
@property (strong,nonatomic) NSMutableArray *experiencesPoints;

// List of experiences enabled for this user
@property (strong,nonatomic) NSMutableArray *experiencesEnabled;

@end
