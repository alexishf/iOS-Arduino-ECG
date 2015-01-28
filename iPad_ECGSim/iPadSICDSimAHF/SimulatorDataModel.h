//
//  OptionsClass.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 08/06/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import "GDataXMLNode.h"
#import "senial.h"
//Para que no diera el error de linkado por duplicació de inclusión de .h,
//he declarado los arrays en el vecotro ritmos.h como 'static'
#import "ritmos.h"
#include "constantes.h"

@interface SimulatorDataModel : NSObject{
    
}

@property (nonatomic, strong) NSMutableDictionary *opciones;
@property (nonatomic, strong) NSMutableDictionary *seniales;
@property (nonatomic, strong) NSMutableArray *senialMutable;
@property (nonatomic, strong) NSMutableArray *senialCapturada;

- (void) imprimeOpcionesEnConsola;
- (NSMutableArray *)generaSenial:(int)ritmo;
- (float) dameMuestra:(float)muestra  enVector: (int)vector;
- (void) registraMuestra: (NSNumber *)muestra;
- (void) borraSenialCapturada;

@end
