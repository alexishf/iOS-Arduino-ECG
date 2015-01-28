//
//  instructionElementDM.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 23/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

//Clase que representa una instrucción del script
//Uso variables de instancias públicas en lugar de propiedades porque... porque sí
//por probar otra cosas
@interface instructionElementDM : NSObject<NSCoding>{
@public
   // NSString *name; //AF, VT, PRInterval
   // NSString *parameter1;
   // NSString *parameter2;
   // NSNumber *inSecond; //segundo en el que se ejecuta
}

@property (nonatomic,strong) NSString *name; //AF, VT, PRInterval
@property (nonatomic,strong) NSString *parameter1;
@property (nonatomic,strong) NSString *parameter2;
@property (nonatomic,strong) NSNumber *inMinute; //minute en el que se ejecuta
@property (nonatomic,strong) NSNumber *inSecond; //segundo en el que se ejecuta

@end
