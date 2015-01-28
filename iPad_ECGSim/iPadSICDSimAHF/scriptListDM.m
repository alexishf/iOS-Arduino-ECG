//
//  scriptListDM.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 25/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "scriptListDM.h"

@implementation scriptListDM

@synthesize scritps=_scritps;
@synthesize savedScriptsPath=savedScriptsPath;


-(id)init{
    self = [super init];
    if (self) {
        self.scritps = [[NSMutableArray alloc] init];
        
        [self creaScriptsDemo];
    }
    return self;
}



#pragma mark - NSCoding: Almacenado y recuperación de scripts
//-----------------------------------------------------------
//Dado un nombre de archivo, obtengo la ruta donde se almacena
- (NSString *) getPathForSavedScripts:(NSString*)filename{

    //Obtengo el directorio (array de directoris) de DOCUMENTO del SANDBOX
    NSArray * documentDirectories =
           NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //El primer elemento contiene la carpeta DOCUMENTS
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    //Devuelvo la ruta del directorio DOCUMENT junt con el nombre de archivo
    return [documentDirectory stringByAppendingPathComponent:filename];
}

//Cargar los scripts almacenados en el disco al vector de scripts
- (BOOL) cargarScripts{
    NSString* rutaArchivo = [self getPathForSavedScripts:fileNameSavedScripts];
    if (rutaArchivo!=nil){
        _scritps = [NSKeyedUnarchiver unarchiveObjectWithFile:rutaArchivo];
        return TRUE;
    }else{
        return FALSE;
    }
}

//Almacena los scripts en el disco
- (void) almacenarScripts{
    //Obtengo la ruta
    NSString* rutaArchivo = [self getPathForSavedScripts:fileNameSavedScripts];
    //Almaceno el vector de scripts (_scripts) en tal ruta
    [NSKeyedArchiver archiveRootObject:_scritps toFile:rutaArchivo];
}



#pragma mark - Carga de scripts demos (por defecto en la App)
//-----------------------------------------------------------
- (void) creaScriptsDemo{
    
    
    //Script 1
    scriptElementDM* script1 = [[scriptElementDM alloc] init];
    [script1 iniciaNombre:@"NSVT + VT"
              descripcion:@"The patient develops a NSVT and then a fast VT that must be converted with a shock"
                    autor:@"Alexis Herrera"
                    fecha:@"03/ago/2014, 21:30"];
    
    [script1 createInstructionT:@"Sinus Rhythm"   inMinute: 0 inSecond: 0 parameter1:nil parameter2:nil];
    [script1 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 1 parameter1:@"70" parameter2:nil];
    [script1 createInstructionT:@"PR interval"    inMinute: 0 inSecond: 5 parameter1:@"200" parameter2:nil];
    [script1 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond:10 parameter1:@"90" parameter2:nil];
    [script1 createInstructionT:@"Ventricular tachycardia 1"           inMinute: 0 inSecond:15 parameter1:nil parameter2:nil];
    [script1 createInstructionT:@"Sinus Rhythm"  inMinute: 0 inSecond:21 parameter1:nil parameter2:nil];
    [script1 createInstructionT:@"Ventricular tachycardia 1"           inMinute: 0 inSecond:35 parameter1:nil parameter2:nil];
    
    [self.scritps addObject:script1];
    
    
    
    //Script 2
    scriptElementDM* script2 = [[scriptElementDM alloc] init];
    [script2 iniciaNombre:@"SVT Discrimination: INSIGHT"
              descripcion:@"In this script you are going to experience how the SVT discriminator works"
                    autor:@"Alexis Herrera"
                    fecha:@"03/ago/2014, 21:30"];
    
    [script2 createInstructionT:@"Sinus Rhythm"    inMinute: 0 inSecond: 0 parameter1:nil parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"      inMinute: 0 inSecond: 1 parameter1:@"60" parameter2:nil];
    [script2 createInstructionT:@"PR interval"     inMinute: 0 inSecond: 2 parameter1:@"100" parameter2:nil];
    [script2 createInstructionT:@"QT interval"     inMinute: 0 inSecond: 3 parameter1:@"200" parameter2:nil];

    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 4 parameter1:@"100" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 6 parameter1:@"120" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 9 parameter1:@"150" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 12 parameter1:@"170" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 15 parameter1:@"190" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 25 parameter1:@"100" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 27 parameter1:@"80" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 29 parameter1:@"70" parameter2:nil];
    [script2 createInstructionT:@"Heart Rate"     inMinute: 0 inSecond: 31 parameter1:@"60" parameter2:nil];
    [script2 createInstructionT:@"Arial fibrillation (fast)"   inMinute: 0 inSecond: 41 parameter1:nil parameter2:nil];
    [script2 createInstructionT:@"Sinus Rhythm"   inMinute: 0 inSecond: 51 parameter1:nil parameter2:nil];
    [script2 createInstructionT:@"Ventricular tachycardia 2"           inMinute: 1 inSecond:00 parameter1:nil parameter2:nil];


    [self.scritps addObject:script2];
}

@end
