//
//  scriptElementDM.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 22/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "instructionElementDM.h"

@interface scriptElementDM : NSObject <NSCoding>
    @property (nonatomic, strong) NSString *scriptName;
    @property (nonatomic, strong) NSString *scriptDescription;
    @property (nonatomic, strong) NSString *scriptAuthor;
    @property (nonatomic, strong) NSString *scriptCreationDate;
    //Contiene las intrucciones del script
    @property (nonatomic, strong) NSMutableArray *scriptInstructions;

-(void) iniciaNombre:(NSString*)name
         descripcion:(NSString*)description
               autor:(NSString *)author;

//Iniciador indicando fecha manualmente
-(void)iniciaNombre:(NSString*)name
        descripcion:(NSString*)description
              autor:(NSString *)author
              fecha:(NSString *)fecha;

- (void) createInstructionT:(NSString *)nombre
                   inMinute:(float)minuto
                   inSecond:(float)segundo
                 parameter1:(NSString *)p1
                 parameter2:(NSString *)p2;

- (void) insertaInstruccion: (instructionElementDM*) instruccion;

@end
