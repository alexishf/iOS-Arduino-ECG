//
//  instruccionesPosibles.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 27/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "instruccionesPosibles.h"

@implementation instruccionesPosibles

@synthesize listaPosiblesIns=listaPosiblesIns;

-(id) init{
    self = [super init];
    
    self.listaPosiblesIns = [[NSMutableDictionary alloc] init];
    
    //Descripcion de la instrucción, y su código que coincido con el ESTADO
    //El comando para cambiar el ritmo es 100, luego se adjunta el valor que representa al ritmo concreto
    [self.listaPosiblesIns setObject:@"Sinus Rhythm"              forKey:[@(SINUSAL0) stringValue]];
    [self.listaPosiblesIns setObject:@"Atrial tachycardia"        forKey:[@(AT) stringValue]];
    [self.listaPosiblesIns setObject:@"Arial fibrillation (slow)" forKey:[@(FA1) stringValue]];
    [self.listaPosiblesIns setObject:@"Arial fibrillation (fast)" forKey:[@(FA2) stringValue]];
    [self.listaPosiblesIns setObject:@"Ventricular tachycardia 1" forKey:[@(TV1) stringValue]];
    [self.listaPosiblesIns setObject:@"Ventricular tachycardia 2" forKey:[@(TV2) stringValue]];
    [self.listaPosiblesIns setObject:@"Premature ventricular Contraction" forKey:[@(PVC) stringValue]];
    [self.listaPosiblesIns setObject:@"Premature atrial Contraction"      forKey:[@(PAC) stringValue]];
    [self.listaPosiblesIns setObject:@"Ventricular rhythm"         forKey:[@(ESCPV) stringValue]];
    [self.listaPosiblesIns setObject:@"Asystole"                   forKey:[@(ASISTOLIA) stringValue]];
    [self.listaPosiblesIns setObject:@"Ventricular fibrillation 1" forKey:[@(FV1) stringValue]];
    [self.listaPosiblesIns setObject:@"Ventricular fibrillation 2" forKey:[@(FV2) stringValue]];

    //Como clave, asigo el valor del comando correspondiente a cada parametro
    [self.listaPosiblesIns setObject:@"PR interval"               forKey:[@(cIntervaloPR ) stringValue]];
    [self.listaPosiblesIns setObject:@"QT interval"               forKey:[@(cIntervaloST) stringValue]];
    [self.listaPosiblesIns setObject:@"Heart Rate"                forKey:[@(cFrecCardiaca) stringValue]];
    [self.listaPosiblesIns setObject:@"P wave amplitude"          forKey:[@(cAmplitudP) stringValue]];
    [self.listaPosiblesIns setObject:@"R wave amplitude"          forKey:[@(cAmplitudR) stringValue]];
    [self.listaPosiblesIns setObject:@"T wave amplitude"          forKey:[@(cAmplitudT) stringValue]];
    [self.listaPosiblesIns setObject:@"Amplitude sinus rhythm signal" forKey:[@(cAmplitudRS) stringValue]];
    [self.listaPosiblesIns setObject:@"SEC/Prim R wave"           forKey:[@(cRenSECprim) stringValue]];
    [self.listaPosiblesIns setObject:@"ALT/Prim R wave"           forKey:[@(cRenALTprim) stringValue]];

    return self;
}

@end
