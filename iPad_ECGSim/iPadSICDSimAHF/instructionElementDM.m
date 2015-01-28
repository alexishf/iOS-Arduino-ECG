//
//  instructionElementDM.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 23/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "instructionElementDM.h"

@implementation instructionElementDM

@synthesize name=_name;
@synthesize parameter1=_parameter1;
@synthesize parameter2=_parameter2;
@synthesize inMinute=_inMinute;
@synthesize inSecond=_inSecond;


#pragma mark - Almacenamiento de la instrucción con NSCoding


//Almacenar (cofificar)
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_name       forKey:@"name"];
    [encoder encodeObject:_parameter1 forKey:@"parameter1"];
    [encoder encodeObject:_parameter2 forKey:@"parameter2"];
    [encoder encodeObject:_inMinute   forKey:@"inMinute"];
    [encoder encodeObject:_inSecond   forKey:@"inSecond"];
}
//Recuperar (decodificar)
-(id) initWithCoder:(NSCoder *)decoder{
    if (self= [super init]){
        _name =       [decoder decodeObjectForKey:@"name"];
        _parameter1 = [decoder decodeObjectForKey:@"parameter1"];
        _parameter2 = [decoder decodeObjectForKey:@"parameter2"];
        _inMinute =   [decoder decodeObjectForKey:@"inMinute"];
        _inSecond =   [decoder decodeObjectForKey:@"inSecond"];
    }
    return self;
}


@end
