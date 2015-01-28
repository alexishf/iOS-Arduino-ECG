//
//  senial.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "senial.h"

@implementation senial

@synthesize senialOriginal=_senialOriginal;
@synthesize senialaMostrar=_senialaMostrar;


-(id)init{
    self.senialOriginal = [[NSMutableArray alloc] init];
    self.senialaMostrar = [[NSMutableArray alloc] init];
    return self;
}
 

@end
