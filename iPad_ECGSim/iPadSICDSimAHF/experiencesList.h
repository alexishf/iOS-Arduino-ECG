//
//  experiencesList.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 21/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "experience.h"

@interface experiencesList : NSObject

@property (nonatomic,strong) NSMutableArray* experiences;


- (void) inicializarExperiencias;
- (void) insertarExperience:(experience*)experiencia;

@end
