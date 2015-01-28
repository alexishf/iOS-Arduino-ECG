//
//  scriptListDM.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 25/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "scriptElementDM.h"
#import "constantes.h"

//Necesito almacenar en disco los scripts que creen los usuarios.
//Pasos para almacenar objetos usando NSCoding-NSUserDefaults
//
// 1) Implementar el protocolo NSCoding, y sus dos métodos:
//     - initWithCoder (para rescatar desde disco: unarchive
//     - encodeWithCoder (para almacenar en disco: archive


@interface scriptListDM : NSObject

@property (nonatomic,strong) NSMutableArray *scritps;
@property (copy) NSString *savedScriptsPath;


- (void) creaScriptsDemo;
- (void) almacenarScripts;
- (BOOL) cargarScripts;

@end
