//
//  SectionsVC.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 18/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "SectionsVC.h"

@interface SectionsVC (){
    int iniciarParametro;
    int iniciandoArduino;
}
@end


@implementation SectionsVC

@synthesize dataModel=_dataModel;
@synthesize comModel=_comModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    //Inicializo el modelo de datos
    self.dataModel = [[SimulatorDataModel alloc] init];
    //Inicializo el modelo de comunicaciones
    self.comModel = [[communicationDM alloc] init];
    //Me hago delegado del objeto que gestiona las comunicaciones
    self.comModel.delegate=self;

    //Incializamos valores interfaz gráfico
    [self InicializarValoresIterfaz];
}

- (void) muestraOKmsgConTitulo:(NSString *)Titulo yTexto:(NSString *)Texto{
    //MSG indicando la correcta inicialización del hardware
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Titulo
                                                    message:Texto
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}


- (void)InicializarValoresIterfaz{
  //Inicialización de la toolBar
  //----------------------------
  //Actualizo el estado del icono CABLE CONECTADO
  BOOL cableConectado =    [[self.dataModel.opciones objectForKey:@"cableSerieConectado"] boolValue];
  [[[self.mainToolBar items] objectAtIndex:8] setEnabled:cableConectado];
  //Actualizo el estado del icono HARDWARE INICIALIZADO
  BOOL hardwareIniciado =    [[self.dataModel.opciones objectForKey:@"hardwareInicializado"] boolValue];
  if (hardwareIniciado) {
      //El icono HARDWARE es el elemento 9 de la toolbar
      [[[self.mainToolBar items] objectAtIndex:9] setEnabled:FALSE];
      [[[self.mainToolBar items] objectAtIndex:9] setTintColor:[UIColor greenColor]];
   }
   //-----------------------------

}

- (IBAction)initializeHardwarePressed:(id)sender {
    //Envio el msg de inicio de inicializacion
    [self.comModel comienzaInicioHardware];
    
    iniciarParametro=0;
    [self iniciarParametrosArduino];
}




#pragma mark - Métodos del protocolo <communicationDMprotocol>
//--------------------------------------------------------------
- (void)cableSerialConectado:(id)sender{
    [self muestraOKmsgConTitulo:@"Cable connected" yTexto:@"Communicaton cable connected"];
    //Icono cable conectado. Es el elemento 8 de la toolbar
    [[[self.mainToolBar items] objectAtIndex:8] setEnabled:TRUE];
    //[[[self.mainToolBar items] objectAtIndex:8] setTintColor:[UIColor greenColor]];
    //Icono hardware. Es el elemento 9 de la toolbar
    [[[self.mainToolBar items] objectAtIndex:9] setEnabled:TRUE];
    
    [self.dataModel.opciones setObject:@"TRUE" forKey:@"cableSerieConectado"];
}

- (void)cableSerialDesconectado:(id)sender{
    BOOL cableConectado =    [[self.dataModel.opciones objectForKey:@"cableSerieConectado"] boolValue];
    if (cableConectado){
        [self muestraOKmsgConTitulo:@"Cable disconnected" yTexto:@"Communicaton cable disconnected"];
        //Desactivo el icono de ENCHUFE
        [[[self.mainToolBar items] objectAtIndex:8] setEnabled:FALSE];
        //Desactivo el icono INICIAR HARDWARE
        [[[self.mainToolBar items] objectAtIndex:9] setEnabled:FALSE];
        
        [self.dataModel.opciones setObject:@"FALSE" forKey:@"cableSerieConectado"];
    }
}

- (void) iniciarParametrosArduino{
    int ritmoIni= [[self.dataModel.opciones objectForKey:@"RitmoInicial"] intValue];
    int HRini=  [[self.dataModel.opciones objectForKey:@"HRini"] intValue];
    int PRini=  [[self.dataModel.opciones objectForKey:@"PRini"] intValue];
    int QTini=  [[self.dataModel.opciones objectForKey:@"QTini"] intValue];
    int Pini=   [[self.dataModel.opciones objectForKey:@"Pini"] intValue];
    int QRSini= [[self.dataModel.opciones objectForKey:@"QRSini"] intValue];
    int Tini=   [[self.dataModel.opciones objectForKey:@"Tini"] intValue];
    int PausaTrasPVC=   [[self.dataModel.opciones objectForKey:@"PausaTrasPVC"] intValue];
    int FrecTA=   [[self.dataModel.opciones objectForKey:@"FrecuenciaTA"] intValue];
    int FrecEscV=   [[self.dataModel.opciones objectForKey:@"FrecuenciaEscapeV"] intValue];
    
    switch (iniciarParametro){
        case 0:
            //MSG de inicializacion al Arduino (no hace nada)
            [self.comModel sendCommand:50 withValue:0];
            iniciarParametro=1;
            break;
        case 1:
            //Tipo de ritmo
            [self.comModel sendCommand:100 withValue:ritmoIni];
            iniciarParametro++;
            break;
        case 2:
            //HR
            [self.comModel sendCommand:200 withValue:HRini];
            iniciarParametro++;
            break;
        case 3:
            //Intervalo PR
            [self.comModel sendCommand:201 withValue:PRini];
            iniciarParametro++;
            break;
        case 4:
            //Inervalo QT
            [self.comModel sendCommand:202 withValue:QTini];
            iniciarParametro++;
            break;
        case 5:
            //Amplitud P
            [self.comModel sendCommand:204 withValue:Pini];
            iniciarParametro++;
            break;
        case 6:
            //Amplitud QRS
            [self.comModel sendCommand:205 withValue:QRSini];
            iniciarParametro++;
            break;
        case 7:
            //Amplitud T
            [self.comModel sendCommand:206 withValue:Tini];
            iniciarParametro++;
            break;
        case 8:
            //Pausa tras PVC
            [self.comModel sendCommand:209 withValue:PausaTrasPVC];
            iniciarParametro++;
            break;
            
        case 9:
            //Frec AT
            [self.comModel sendCommand:210 withValue:FrecTA];
            iniciarParametro++;
            break;
            
        case 10:
            //Frec Ritmo Escape V
            [self.comModel sendCommand:211 withValue:FrecEscV];
            //Envio el msg de finalización de inicializacion
            [self.comModel terminaInicioHardware];
            [self muestraOKmsgConTitulo:@"Hardware initialized" yTexto:@"Hardware initialized correctly"];
            //Cambio a verde el icono de inicialización de hardware
            [[[self.mainToolBar items] objectAtIndex:9] setTintColor:[UIColor greenColor]];
            
            //Actualizo la variable en el modelo de datos
            [self.dataModel.opciones setObject:@"TRUE" forKey:@"hardwareInicializado"];
            break;
            
        default:
            break;
    }
}




#pragma mark - Navigation
//-----------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showFreeMode"]){
        iPadSICDSimAHFViewController *VC =
        (iPadSICDSimAHFViewController*)[segue destinationViewController];
        //Paso el modelo de datos y comunicaciones al ViewController llamado
        VC.dataModel = self.dataModel;
        VC.comModel = self.comModel;

    }
}

@end
