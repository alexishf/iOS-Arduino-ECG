//
//  communicationDM.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 27/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RscMgr.h"
#import "constantes.h"

//Implementamos un protocolo para pasar los eventos relacionados
//con las comunicaciones a las clases delegadas
@protocol communicationDMprotocol <NSObject>
//Métodos cuya implementación en el delegado es opcional
@optional
- (void) iniciarParametrosArduino;
- (void) recibidoDesdeSICD:(id)sender;
- (void) choqueRecibido:(int)energia conPolaridad:(NSString*)polaridad;
- (void) inicioRafaga;
- (void) finRafaga;

//Métodos que se han de implementar obligatoriamente en el delegado
@required
- (void)cableSerialConectado:(id)sender;
- (void)cableSerialDesconectado:(id)sender;
@end


@interface communicationDM : NSObject <RscMgrDelegate>

//Propiedades (son públicas)
@property (weak,nonatomic) id <communicationDMprotocol> delegate;

//Métodos públicos
- (int) sendCommand:(int)command withValue:(int)value;
- (void) comienzaInicioHardware;
- (void) terminaInicioHardware;

@end
