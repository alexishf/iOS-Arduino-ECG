//
//  communicationDM.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 27/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "communicationDM.h"

//Inicializamos variables de instancia privadas
@interface communicationDM (){
    RscMgr *rscMgr;
    UInt8 rxBuffer[BUFFER_LEN];
    UInt8 txBuffer[BUFFER_LEN];
    int  iniciandoArduino;
}
@end

@implementation communicationDM

@synthesize delegate=_delegate;

//Inicializador del objeto
-(id)init{
    //Siempre invocamos al inicializador de la clase superior
    self = [super init];
    //Inicializo el objeto responsable de las comunicaciones
    rscMgr = [[RscMgr alloc] init];
    //Defino esta clase como delegada de rscMgr
	[rscMgr setDelegate:self];
    return self;
}


#pragma mark - Public methods
//--------------------------------------------------------------------
- (int) sendCommand:(int)command withValue:(int)value {
    //Preparo el contenido de lo que vamos a enviar al micro
    //El byte de menos pesos [0], indica el comando
    //El valor se representa en un 'int'(4 bytes). Hacemos rotaciones a la derecha tal que:
    txBuffer[0] = command;
    txBuffer[1] = (value >> 24) & 0xFF;
    txBuffer[2] = (value >> 16) & 0xFF;
    txBuffer[3] = (value >> 8) & 0xFF;
    txBuffer[4] = value & 0xFF;
    
    int bytesWritten = [rscMgr write:txBuffer Length:LongComando];
    
    NSLog( @"Wrote %d bytes to serial cable.", bytesWritten);
    NSLog( @"%u %u %u %u %u \n", txBuffer[0], txBuffer[1], txBuffer[2], txBuffer[3], txBuffer[4]);
    
    return bytesWritten;
}

- (void) comienzaInicioHardware{
    iniciandoArduino=1;
}
- (void) terminaInicioHardware{
    iniciandoArduino=0;
}


#pragma mark - RscMgrDelegate methods and send methods
//--------------------------------------------------------------------
- (void)sendString:(NSString *)string {
    NSLog(@"sendString:");

    int bytesToWrite = string.length;
    for ( int i = 0; i < bytesToWrite; i++ ) {
        txBuffer[i] = (int)[string characterAtIndex:i];
    }
	int bytesWritten = [rscMgr write:txBuffer Length:bytesToWrite];
    NSLog( @"Wrote %d bytes to serial cable.", bytesWritten);
}

- (void) cableConnected:(NSString *)protocol {
    NSLog(@"Cable Connected: %@", protocol);
    //[rscMgr setBaud:9600];
	[rscMgr setBaud:57600];
    
    serialPortConfig portCfg;
	[rscMgr getPortConfig:&portCfg];
    portCfg.txAckSetting = 1;
    [rscMgr setPortConfig:&portCfg requestStatus: NO];
    
    [rscMgr open];
    
    //Envio el msg al delegado
    [self.delegate cableSerialConectado:self];
}

- (void) cableDisconnected {
    NSLog(@"Cable disconnected");
    //Envio el msg al delegado
    [self.delegate cableSerialDesconectado:self];
}

- (void) portStatusChanged {
    NSLog(@"portStatusChanged");
}

- (void) readBytesAvailable:(UInt32)numBytes {
    NSLog(@"readBytesAvailable:");
    int bytesRead = [rscMgr read:rxBuffer Length:numBytes];
    NSLog( @"Read %d bytes from serial cable.", bytesRead );
    for(int i = 0;i < numBytes;++i) {
        NSString *string = [NSString stringWithFormat:@"%c", ((char *)rxBuffer)[i]];
        
        //Si detectamos final de comando ($)...
        if ([string isEqual:@"$"]){
             //Si estamos en proceso de inicializacion, iniciamos siguiente parametro
             if (iniciandoArduino==1){
               [self.delegate iniciarParametrosArduino];
             }
            
            //Choque entregado: '!xx', donde 'xx' es la energia
        }else if([string isEqual:@"!"]){
            
            NSString *cifra1 = [NSString stringWithFormat:@"%c", ((char *)rxBuffer)[i+1]];
            NSString *cifra2 = [NSString stringWithFormat:@"%c", ((char *)rxBuffer)[i+2]];
            int energia = [[cifra1 stringByAppendingString:cifra2] intValue];
            
            // Avisamos al delegado de que ha llegado un CHOQUE!!
            [self.delegate choqueRecibido:energia conPolaridad:@"STD"];
            
            //Inicio de rafaga 50Hz: '['
        }else if([string isEqual:@"["]){
            [self.delegate inicioRafaga];
            //[self inicioRafaga];
            
            //Fin de rafaga 50Hz: ]'
        }else if([string isEqual:@"]"]){
            [self.delegate finRafaga];
            //[self finRafaga];
        }
    }
    
}

- (BOOL) rscMessageReceived:(UInt8 *)msg TotalLength:(int)len {
    NSLog(@"rscMessageRecieved:TotalLength:");
    return FALSE;
}

- (void) didReceivePortConfig {
    NSLog(@"didRecievePortConfig");
}
@end
