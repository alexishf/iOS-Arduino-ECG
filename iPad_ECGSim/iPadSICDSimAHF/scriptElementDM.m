//
//  scriptElementDM.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 22/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "scriptElementDM.h"

@implementation scriptElementDM

@synthesize scriptName=_scriptName;
@synthesize scriptDescription=_scriptDescription;
@synthesize scriptAuthor=_scriptAuthor;
@synthesize scriptCreationDate=_scriptCreationDate;
@synthesize scriptInstructions=_scriptInstructions;

-(id)init{
    self = [super init];
    
    if (self){
        self.scriptName = [[NSString alloc] init];
        self.scriptDescription = [[NSString alloc] init];
        self.scriptAuthor = [[NSString alloc] init];
        self.scriptCreationDate = [[NSString alloc] init];
        self.scriptInstructions = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - Almacenamiento de scripts con NSCoding

//Almacenar (cofificar)
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_scriptName           forKey:@"scriptName"];
    [encoder encodeObject:_scriptDescription    forKey:@"scriptDescription"];
    [encoder encodeObject:_scriptAuthor         forKey:@"scriptAuthor"];
    [encoder encodeObject:_scriptCreationDate   forKey:@"scriptCreationDate"];
    [encoder encodeObject:_scriptInstructions   forKey:@"scriptInstructions"];
}
//Recuperar (decodificar)
-(id) initWithCoder:(NSCoder *)decoder{
    if (self= [super init]){
        _scriptName =           [decoder decodeObjectForKey:@"scriptName"];
        _scriptDescription =    [decoder decodeObjectForKey:@"scriptDescription"];
        _scriptAuthor =         [decoder decodeObjectForKey:@"scriptAuthor"];
        _scriptCreationDate =   [decoder decodeObjectForKey:@"scriptCreationDate"];
        _scriptInstructions =   [decoder decodeObjectForKey:@"scriptInstructions"];
    }
    return self;
}


#pragma mark - Otros

//Iniciador sin indicar fecha (la crea automaticamente)
-(void)iniciaNombre:(NSString*)name
       descripcion:(NSString*)description
            autor:(NSString *)author{
    
        //Obtengo la fecha de hoy y la paso a string
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MMM/yyyy, HH:mm"];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:now];
    
        //Asigno la propiedad 'fecha de creacion' y el resto
        self.scriptCreationDate=dateString;
        self.scriptName=name;
        self.scriptDescription=description;
        self.scriptAuthor=author;
}

//Iniciador indicando fecha manualmente
-(void)iniciaNombre:(NSString*)name
        descripcion:(NSString*)description
              autor:(NSString *)author
              fecha:(NSString *)fecha{
    
    //Asigno la propiedad 'fecha de creacion' y el resto
    self.scriptCreationDate=fecha;
    self.scriptName=name;
    self.scriptDescription=description;
    self.scriptAuthor=author;
}

- (void) createInstructionT:(NSString *)nombre inMinute:(float)minuto inSecond:(float)segundo
                 parameter1:(NSString *)p1 parameter2:(NSString *)p2  {
    
    //Creamos el objeto 'instruccion'
    instructionElementDM* instruccion = [[instructionElementDM alloc] init];
    
    //Inicializamos su variables de instancia
    instruccion.name = nombre;
    instruccion.inMinute = [NSNumber numberWithFloat:minuto];
    instruccion.inSecond = [NSNumber numberWithFloat:segundo];
    instruccion.parameter1 = p1;
    instruccion.parameter2 = p2;
    
    //Añado la instruccion que acabo de crear al vector de instrucciones
    [self.scriptInstructions addObject:instruccion];
}

- (void) insertaInstruccion: (instructionElementDM*) instruccion{
    //Añado la instruccion que acabo de crear al vector de instrucciones
    [self.scriptInstructions addObject:instruccion];
}

@end
