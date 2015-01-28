//
//  iPadSICDSimAHFViewController.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "iPadSICDSimAHFViewController.h"
#import "sicdEcgVCViewController.h"

@interface iPadSICDSimAHFViewController (){
    //Inicializamos variables de instancia privadas
    
    //indica si se esta grabando un señal...
    int longitudSenial;
    int indiceGrafica;
    int delta;
    int test;
    int offsetIndice;
    int indiceMuestra;
    int contadorPVC;
    int contadorPAC;
    int trRandom;
    
    //Parametros iniciales Ritmo sinusal
    int longP;
    int longSegmentoPR;
    int longQRS;
    int longSegmentoST;
    int longT;
    int longSegmentoTP;
    int longPVC;
    float VELOCIDAD_ECG;//Tiempo en segundo de escritura en la grafica

    //Timer para test
    Timer *timer;
}
@end


@implementation iPadSICDSimAHFViewController


@synthesize comModel=_comModel;
@synthesize dataModel;
@synthesize monitorECG;
@synthesize panelGrabacionECG;

@synthesize senialMutable;

@synthesize PwaveLabel;
@synthesize QRSWaveLabel;
@synthesize TWaveLabel;
@synthesize senialValueLabel;

@synthesize HeartRateLabel;
@synthesize PRintervalLabel;
@synthesize STIntervalLabel;
@synthesize HRmaximumLabel;

@synthesize HRslider;
@synthesize PRslider;
@synthesize QTslider;
@synthesize PwaveAmplitude;
@synthesize QRSwaveAmplitude;
@synthesize TwaveAmplitude;
@synthesize senialAmplitude;




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    indiceGrafica=0;
    delta=0;
    test=0;
    offsetIndice=0;
    indiceMuestra=0;
    contadorPVC=0;
    contadorPAC=0;
    
    //Roto 90º el selector de amp de RS
    // (Hay que quitar el 'tick' autolayout del slider)
    senialAmplitude.transform=
       CGAffineTransformRotate(senialAmplitude.transform,270.0/180*M_PI);
    
    //Inicialización del temporizador. TESTs
    //timer = [[Timer alloc] init];
    //timerGrabacion = [[Timer alloc] init];
    
    //Inicializo los valores del interfaz
    [self InicializarValoresIterfaz];
    
    int OffsetAcelerador = 1;
    int resolucion = [[dataModel.opciones objectForKey:@"ResolucionSenial"] intValue];
    VELOCIDAD_ECG = (0.001*resolucion)*OffsetAcelerador;
    
    //Inicializa el vector que contendrá la senial
    senialMutable = [[NSMutableArray alloc] init];
    
    // Cambiamos la senial a efectos de la visualización en el gráfico
    self.senialMutable = [dataModel generaSenial:ASISTOLIA];
    
    // Monitor ECG
    // ---------------------------
    // El primer VC dentro del vector 'child...' es el Monitor ECG
    self.monitorECG = [self.childViewControllers objectAtIndex:0];
    // Pasamos el modelo de datos
    self.monitorECG.dataModel=self.dataModel;
    // Inicializamos el ECG
    [self.monitorECG inicializaECG];
    
    
    // Panel de grabación ECG
    // -----------------------------
    // El segundo elemento en el vector 'child...' es el panel de grabación
    self.panelGrabacionECG= [self.childViewControllers objectAtIndex:1];
    // Pasamos el modelo de datos
    self.panelGrabacionECG.dataModel=self.dataModel;
    // Me asigno como delegado
    self.panelGrabacionECG.delegate = self;
    
    // Modelo de comunicaciones
    // -------------------------
    // Me hago delegado del objeto de comunicaciones
    self.comModel.delegate = self;
}


- (void)InicializarValoresIterfaz{
    
    //Inicialización de la toolBar
    //----------------------------
    //Actualizo el estado del icono CABLE CONECTADO
    BOOL cableConectado =    [[self.dataModel.opciones objectForKey:@"cableSerieConectado"] boolValue];
    [[[self.mainToolBar items] objectAtIndex:8] setEnabled:cableConectado];
    //Actualizo el estado del icono HARDWARE INICIALIZADO
    BOOL hardwareInciado =    [[self.dataModel.opciones objectForKey:@"hardwareInicializado"] boolValue];
    if (hardwareInciado) {
        //El icono HARDWARE es el elemento 9 de la toolbar
        [[[self.mainToolBar items] objectAtIndex:9] setEnabled:FALSE];
        [[[self.mainToolBar items] objectAtIndex:9] setTintColor:[UIColor greenColor]];
    }
    
    //Activo iconos de seleccione de vectores y screening
    [[[self.mainToolBar items] objectAtIndex:0] setEnabled:TRUE];
    [[[self.mainToolBar items] objectAtIndex:1] setEnabled:TRUE];
    [[[self.mainToolBar items] objectAtIndex:2] setEnabled:TRUE];
    [[[self.mainToolBar items] objectAtIndex:4] setEnabled:TRUE];
    [[[self.mainToolBar items] objectAtIndex:6] setEnabled:TRUE];

    //-----------------------------
    
    self.HRslider.minimumValue =    [[dataModel.opciones objectForKey:@"HRmin"] intValue];
    self.HRminimumLabel.text =      [dataModel.opciones  objectForKey:@"HRmin"];
    self.HRslider.maximumValue =    [[dataModel.opciones objectForKey:@"HRmax"] intValue];
    self.HRmaximumLabel.text =      [dataModel.opciones  objectForKey:@"HRmax"];
    self.HRslider.value =           [[dataModel.opciones objectForKey:@"HRini"] intValue];
    self.HeartRateLabel.text= [NSString  stringWithFormat:@"%@ lpm", [dataModel.opciones objectForKey:@"HRini"]];

    self.PRslider.minimumValue =    [[dataModel.opciones objectForKey:@"PRmin"] intValue];
    self.PRminimumLabel.text =      [dataModel.opciones  objectForKey:@"PRmin"];
    self.PRslider.maximumValue =    [[dataModel.opciones objectForKey:@"PRmax"] intValue];
    self.PRmaximumLabel.text =      [dataModel.opciones  objectForKey:@"PRmax"];
    self.PRslider.value =           [[dataModel.opciones objectForKey:@"PRini"] intValue];
    self.PRintervalLabel.text= [NSString  stringWithFormat:@"%@ ms", [dataModel.opciones objectForKey:@"PRini"]];
    
    self.QTslider.minimumValue =    [[dataModel.opciones objectForKey:@"QTmin"] intValue];
    self.STminimumLabel.text =      [dataModel.opciones  objectForKey:@"QTmin"];
    self.QTslider.maximumValue =    [[dataModel.opciones objectForKey:@"QTmax"] intValue];
    self.STmaximumLabel.text =      [dataModel.opciones  objectForKey:@"QTmax"];
    self.QTslider.value =           [[dataModel.opciones objectForKey:@"QTini"] intValue];
    self.STIntervalLabel.text= [NSString  stringWithFormat:@"%@ ms", [dataModel.opciones objectForKey:@"QTini"]];
 
    self.PwaveAmplitude.minimumValue =  [[dataModel.opciones objectForKey:@"Pmin"] intValue];
    self.PminimumValue.text =           [dataModel.opciones  objectForKey:@"Pmin"];
    self.PwaveAmplitude.maximumValue =  [[dataModel.opciones objectForKey:@"Pmax"] intValue];
    self.PmaximumValue.text =           [dataModel.opciones  objectForKey:@"Pmax"];
    self.PwaveAmplitude.value =         [[dataModel.opciones objectForKey:@"Pini"] intValue];
    self.PwaveLabel.text= [NSString  stringWithFormat:@"%@ x", [dataModel.opciones objectForKey:@"Pini"]];
    
    self.QRSwaveAmplitude.minimumValue =  [[dataModel.opciones objectForKey:@"QRSmin"] intValue];
    self.QRSminimumValue.text =           [dataModel.opciones  objectForKey:@"QRSmin"];
    self.QRSwaveAmplitude.maximumValue =  [[dataModel.opciones objectForKey:@"QRSmax"] intValue];
    self.QRSmaximumValue.text =           [dataModel.opciones  objectForKey:@"QRSmax"];
    self.QRSwaveAmplitude.value =         [[dataModel.opciones objectForKey:@"QRSini"] intValue];
    self.QRSWaveLabel.text= [NSString  stringWithFormat:@"%@ x", [dataModel.opciones objectForKey:@"QRSini"]];
    
    self.TwaveAmplitude.minimumValue =  [[dataModel.opciones objectForKey:@"Tmin"] intValue];
    self.TminimumValue.text =           [dataModel.opciones  objectForKey:@"Tmin"];
    self.TwaveAmplitude.maximumValue =  [[dataModel.opciones objectForKey:@"Tmax"] intValue];
    self.TmaximumValue.text =           [dataModel.opciones  objectForKey:@"Tmax"];
    self.TwaveAmplitude.value =         [[dataModel.opciones objectForKey:@"Tini"] intValue];
    self.TWaveLabel.text= [NSString  stringWithFormat:@"%@ x", [dataModel.opciones objectForKey:@"Tini"]];

    self.senialAmplitude.minimumValue =  [[dataModel.opciones objectForKey:@"SenialMin"] intValue];
    self.senialMinimumLabel.text =       [dataModel.opciones  objectForKey:@"SenialMin"];
    self.senialAmplitude.maximumValue =  [[dataModel.opciones objectForKey:@"SenialMax"] intValue];
    self.senialMaximumLabel.text =       [dataModel.opciones  objectForKey:@"SenialMax"];
    self.senialAmplitude.value =         [[dataModel.opciones objectForKey:@"SenialIni"] intValue];
    self.senialValueLabel.text= [NSString  stringWithFormat:@"%@ x", [dataModel.opciones objectForKey:@"SenialIni"]];
    
    /*
    self.secondsToRecordStepper.maximumValue = [[dataModel.opciones objectForKey:@"segundosAgrabarMax"] intValue];
    self.secondsToRecordStepper.value = [[dataModel.opciones objectForKey:@"segundosAgrabarIni"] intValue];
    self.secondsToRecordFieldText.text =[dataModel.opciones objectForKey:@"segundosAgrabarIni"];
     */
    
    self.sliderPot0.minimumValue =[[dataModel.opciones objectForKey:@"AmpRCanalSecMin"] intValue];
    self.sliderPot0.maximumValue =[[dataModel.opciones objectForKey:@"AmpRCanalSecMax"] intValue];
    self.sliderPot0.value =       [[dataModel.opciones objectForKey:@"AmpRCanalSecAct"] intValue];
    self.Pot0Label.text= [NSString  stringWithFormat:@"%@x", [dataModel.opciones objectForKey:@"AmpRCanalSecAct"]];
    
    self.sliderPot1.minimumValue =[[dataModel.opciones objectForKey:@"AmpRCanalAltMin"] intValue];
    self.sliderPot1.maximumValue =[[dataModel.opciones objectForKey:@"AmpRCanalAltMax"] intValue];
    self.sliderPot1.value =       [[dataModel.opciones objectForKey:@"AmpRCanalAltAct"] intValue];
    self.Pot1Label.text= [NSString  stringWithFormat:@"%@x", [dataModel.opciones objectForKey:@"AmpRCanalAltAct"]];
}





#pragma mark - Selección de vector
- (IBAction)primarySelected:(id)sender {
    self.ECGtitle.text = @"Primary Vector (ring to can)";
    [dataModel.opciones setObject:@(0) forKey:@"VectorEnPantalla"];
}

- (IBAction)secundarySelected:(id)sender {
    self.ECGtitle.text = @"Secundary Vector (tip to can)";
    [dataModel.opciones setValue:@(1) forKey:@"VectorEnPantalla"];
}

- (IBAction)alternateSelected:(id)sender {
    self.ECGtitle.text = @"Alternative Vector (tip to ring)";
    [dataModel.opciones setValue:@(2)forKey:@"VectorEnPantalla"];
}




#pragma mark - Implementación protocolo PanelGrabaciónECG
- (void) recordingEcg:(BOOL)started{
    
    // Comunico al 'monitor de ECG' si ha de grabar o no
    [self.monitorECG recordingECGstatus: started];
}


#pragma mark - Cambio parametros amplitud señal
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Cambiamos valor en etiquetas en tiempo real pero no se envia comando
// hasta que no se levante el dedo

- (IBAction)sliderPwaveChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    PwaveLabel.text= [NSString  stringWithFormat:@"%dx", sliderValue];
}

- (IBAction)sliderQRSWaveChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    QRSWaveLabel.text= [NSString  stringWithFormat:@"%dx", sliderValue];
}

- (IBAction)sliderTwaveChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    TWaveLabel.text= [NSString  stringWithFormat:@"%dx", sliderValue];
}

- (IBAction)sliderAmplitudRSchanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    senialValueLabel.text= [NSString  stringWithFormat:@"%dx", sliderValue];
}

- (IBAction)sliderPot0Changed:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    self.Pot0Label.text= [NSString  stringWithFormat:@"%dx", sliderValue];
}

- (IBAction)sliderPot1Changed:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    self.Pot1Label.text= [NSString  stringWithFormat:@"%dx", sliderValue];
}

// COMANDOS: Cambio parámetros de amplitud
//-----------------------------------------------------------------------
//COMANDO: 204. Cambio valor ONDA P
- (IBAction)sliderPwaveTouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaPwave:sliderValue];
}
- (IBAction)sliderPwaveTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaPwave:sliderValue];
}
- (void)cambiaPwave: (int)valor{
    //Actualiza el nuevo valor seleccionado en 'opciones'
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"Pact"];
    
    //Imprimo el cambio en la consola
    NSLog( @"Slider value: %d", valor);
    PwaveLabel.text= [NSString  stringWithFormat:@"%dx", valor];

    //Cambia la senial a efectos de visualizacion en el iPad
    self.senialMutable = [dataModel generaSenial:SINUSAL0];

    //Se envia el cambio al Arduino
    [self.comModel sendCommand:cAmplitudP withValue:valor];
}

//COMANDO: 205. Cambio valor ONDA QRS
- (IBAction)sliderQRSTouchedUP:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaQRSwave:sliderValue];
}
- (IBAction)sliderQRSwaveTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaQRSwave:sliderValue];
}
- (void)cambiaQRSwave: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"QRSact"];
    NSLog( @"Slider value: %d", valor);
    QRSWaveLabel.text= [NSString  stringWithFormat:@"%dx", valor];
    self.senialMutable = [dataModel generaSenial:SINUSAL0];
    [self.comModel sendCommand:cAmplitudR withValue:valor];
}

// COMANDO: 206. Cambio valor ONDA T
- (IBAction)sliderTwaveTouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaTwave:sliderValue];
}
- (IBAction)sliderTwaveTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaTwave:sliderValue];
}
- (void)cambiaTwave: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"Tact"];
    NSLog( @"Slider value: %d", valor);
    TWaveLabel.text= [NSString  stringWithFormat:@"%dx", valor];
    self.senialMutable = [dataModel generaSenial:SINUSAL0];
    [self.comModel sendCommand:cAmplitudT withValue:valor];
}

// COMANDO: 207. Cambio valor AMPLITUD ONDA RS
- (IBAction)sliderAmplitudRSTouchedUP:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaAmplitudRS:sliderValue];
}
- (IBAction)sliderAmplitudRSTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaAmplitudRS:sliderValue];
}
- (void)cambiaAmplitudRS: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"SenialAct"];
    NSLog( @"Slider value: %d", valor);
    senialValueLabel.text= [NSString  stringWithFormat:@"%dx", valor];
    self.senialMutable = [dataModel generaSenial:SINUSAL0];
    [self.comModel sendCommand:cAmplitudRS withValue:valor];
}

// COMANDO: 213. Cambio valor pot0: amplitud R en vector secundario (algo en primario)
- (IBAction)sliderPot0TouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaValorPot0:sliderValue];
}
- (IBAction)sliderPot0TouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaValorPot0:sliderValue];
}
- (void)cambiaValorPot0: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"AmpRCanalSecAct"];
    NSLog( @"Slider value: %d", valor);
    self.Pot0Label.text= [NSString  stringWithFormat:@"%dx", valor];
    
    //Activo el vector secundario en pantalla
    [self secundarySelected:self];
    
    //Cambio el valor a efectos de visualización en ECG
    
    //Envio el comando al Arduino
    [self.comModel sendCommand:cRenSECprim withValue:valor];
}

// COMANDO: 214. Cambio valor pot1: amplitud R en vector alternativo (algo en primario)
- (IBAction)sliderPot1TouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaValorPot1:sliderValue];
}
- (IBAction)sliderPot1TouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaValorPot1:sliderValue];
}
- (void)cambiaValorPot1: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"AmpRCanalAltAct"];
    NSLog( @"Slider value: %d", valor);
    self.Pot1Label.text= [NSString  stringWithFormat:@"%dx", valor];
    //Activo el vector alternativo en pantalla
    [self alternateSelected:self];
    //Envio el comando al Arduino
    [self.comModel sendCommand:cRenALTprim withValue:valor];
}




#pragma mark - Cambio parametros temporales señal
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (IBAction)sliderHearRateChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    HeartRateLabel.text= [NSString  stringWithFormat:@"%d lpm", sliderValue];
}

- (IBAction)sliderPRintervalChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    PRintervalLabel.text= [NSString  stringWithFormat:@"%d ms", sliderValue];
}

- (IBAction)sliderSTintervalChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int sliderValue = (int)slider.value;
    //NSLog( @"Slider value: %d", sliderValue);
    STIntervalLabel.text= [NSString  stringWithFormat:@"%d ms", sliderValue];
}

// COMANDOS: Cambio parámetros temporales
//-----------------------------------------------------------------------
// COMANDO: 200. Cambiar HR
- (IBAction)sliderHearRateTouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaHR:sliderValue];
}
- (IBAction)sliderHeartRateTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaHR:sliderValue];
}
- (void)cambiaHR: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"HRact"];
    NSLog( @"Slider value: %d", valor);
    HeartRateLabel.text= [NSString  stringWithFormat:@"%d lpm", valor];
    [dataModel generaSenial:SINUSAL0];
    [self.comModel sendCommand:cFrecCardiaca withValue:valor];
}

// COMANDO: 201. Cambiar PR
- (IBAction)sliderPRIntervalTouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaPR:sliderValue];
}
- (IBAction)sliderPRintervalTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaPR:sliderValue];
}
- (void)cambiaPR: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"PRact"];
    NSLog( @"Slider value: %d", valor);
    PRintervalLabel.text= [NSString  stringWithFormat:@"%d ms", valor];
    [dataModel generaSenial:SINUSAL0];
    [self.comModel sendCommand:cIntervaloPR withValue:valor];
    
    HRslider.maximumValue = 60000/(PRslider.value+QTslider.value);

    //Max 200lpm
    if (HRslider.maximumValue>200){
        HRslider.maximumValue=200;
        HRmaximumLabel.text = @"200 lpm";
    }else{
        HRmaximumLabel.text = [NSString stringWithFormat:@"%d lpm",
                               (int)HRslider.maximumValue];
    }
}

// COMANDO: 202. Cambiar QT
- (IBAction)sliderSTintervalTouchedUp:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaQT:sliderValue];
}
- (IBAction)sliderSTintervalTouchedUpOut:(id)sender {
    int sliderValue = (int)[(UISlider *)sender value];
    [self cambiaQT:sliderValue];
}
- (void)cambiaQT: (int)valor{
    NSString *dato=[NSString stringWithFormat:@"%d",valor];
    [dataModel.opciones setObject:dato forKey:@"QTact"];
    NSLog( @"Slider value: %d", valor);
    STIntervalLabel.text= [NSString  stringWithFormat:@"%d ms", valor];
    
    [dataModel generaSenial:SINUSAL0];
    [self.comModel sendCommand:cIntervaloST withValue:valor];

    HRslider.maximumValue = 60000/(PRslider.value+QTslider.value);

    //Max 200lpm
    if (HRslider.maximumValue>200){
        HRslider.maximumValue=200;
        HRmaximumLabel.text = @"200 lpm";
    }else{
        HRmaximumLabel.text = [NSString stringWithFormat:@"%d lpm",
                               (int)HRslider.maximumValue];
    }
}




#pragma mark - Comandos: Cambio tipo de ritmo
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// COMANDO: 100. Cambiar de ritmo
// ---------------------------------------------------------
//#define SINUSAL0  49
- (IBAction)setSinusRhythm:(id)sender {
    // Cambiamos la senial a efectos de la visualización en el gráfico
    self.senialMutable = [dataModel generaSenial:SINUSAL0];
    //Enviamos el cambio al Arduino
    [self.comModel sendCommand:cRitmo withValue:SINUSAL0];
}
//#define FA1 (rapida)      70
- (IBAction)setAF1:(id)sender {
    [dataModel generaSenial:FA1];
    [self.comModel sendCommand:cRitmo withValue:FA1];
}
//#define FA2 (lenta)      71
- (IBAction)setAF2:(id)sender {
    [dataModel generaSenial:FA2];
    [self.comModel sendCommand:cRitmo withValue:FA2];
}
//#define TV1      50
- (IBAction)setTV1:(id)sender {
    [dataModel generaSenial:TV1];
    [self.comModel sendCommand:cRitmo withValue:TV1];
}
//#define TV2      51
- (IBAction)setTV2:(id)sender {
    [dataModel generaSenial:TV2];
    [self.comModel sendCommand:cRitmo withValue:TV2];
}
//#define TV3      52
- (IBAction)setTV3:(id)sender {
    [dataModel generaSenial:TV3];
    [self.comModel sendCommand:cRitmo withValue:TV3];
}
//#define FV1      80
- (IBAction)setVF1:(id)sender {
    [dataModel generaSenial:FV1];
    [self.comModel sendCommand:cRitmo withValue:FV1];
}
//#define FV12      90
- (IBAction)setVF2:(id)sender {
    [dataModel generaSenial:FV2];
    [self.comModel sendCommand:cRitmo withValue:FV2];
}
//#define PVC      55
- (IBAction)setPVC:(id)sender {
    [dataModel generaSenial:PVC];
    [self.comModel sendCommand:cRitmo withValue:PVC];
}
//#define PAC      56
- (IBAction)setPAC:(id)sender {
    self.senialMutable = [dataModel generaSenial:PAC];
    [self.comModel sendCommand:cRitmo withValue:PAC];
}
//#define AT
- (IBAction)setAT:(id)sender {
    self.senialMutable = [dataModel generaSenial:AT];
    [self.comModel sendCommand:cRitmo withValue:AT];
}
//#define ESCV
- (IBAction)setEscV:(id)sender {
    [dataModel generaSenial:ESCPV];
    [self.comModel sendCommand:cRitmo withValue:ESCPV];
}

//#define ASISTOLIA 30
- (IBAction)setAsistolia:(id)sender {
    [dataModel generaSenial:ASISTOLIA];
    [self.comModel sendCommand:cRitmo withValue:ASISTOLIA];
}

- (IBAction)setRafaga:(id)sender {
    [dataModel generaSenial:SHOCKSTD];
}




#pragma mark - Gestión Rafaga/Choque/Pacing
//--------------------------------------------------------------------

/*
- (void) inicioRafaga{

    UIImage *imagen = [UIImage imageNamed: @"radioButton1selected.png"];
    self.RafagaEnabledImg.image = imagen;
    
    //Muestro la ráfaga en el ECG
    self.senialMutable = [dataModel generaSenial:RAFAGA];
}
 */

/*
- (void) finRafaga{

    //Apago luz verde
    UIImage *imagen = [UIImage imageNamed: @"radioButton1notselected.png"];
    self.RafagaEnabledImg.image = imagen;
    
    self.RafagaLastDateLabel.text = [self dameFechaHora];
    
    //Después de la ráfaga viene la FV
    [self setVF2:self];
}
*/


- (void)revierteaSinusal{
    [self.comModel sendCommand:cRitmo withValue:SINUSAL0];
    NSLog( @"Enviada orden de revertir a sinusal al Arduino");
}



/*
//Se llama cuando se detecta un choque entregado por el S-ICD
//Polaridad:STD o INV
- (void) choqueEngregadoDe:(int)energia  conPolaridad:(NSString *)polaridad{
    //NSLog( @"Choque recibido de %d Julios.", number);

    
    //HAY QUE MOSTRAR EN EL ECG LA SEÑAL DEL CHOQUE (COMO SI FUERA UNA PVC)
    // ...
    
    
    //El ritmo vuelve a sinusal despues de un choque
    // Cambiamos la senial a efectos de la visualización en el gráfico
    self.senialMutable = [dataModel generaSenial:SINUSAL0];


    
    //Fecha/hora del choque
    self.ChoqueLastDateLabel.text = [self dameFechaHora];
    
    //Energía del choque
    self.ChoqueEnergiaLabel.text = [@(energia) stringValue];
    
    //Polaridad del choque
    self.ChoquePolaridadLabel.text = polaridad;
    
    //Activo el boton verde de choque y despues de 2 segundos lo apago
    UIImage *imagen = [UIImage imageNamed: @"radioButton1selected.png"];
    self.ChoqueEnabledImg.image = imagen;
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(desactivaBotonVerdeChoque)
                                   userInfo:nil
                                    repeats:NO];
}
*/



//Se llama cuando expira el tiempo de boton verde de choque encendido
- (void) desactivaBotonVerdeChoque{
    UIImage *imagen = [UIImage imageNamed: @"radioButton1notselected.png"];
    self.ChoqueEnabledImg.image = imagen;
}


- (NSString *) dameFechaHora{
    //Obtengo la fecha/hora actual y actualizo etiqueta
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MMM/yyyy, HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
    return dateString;
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

- (void) choqueRecibido:(int)energia conPolaridad:(NSString*)polaridad{
    
    //El ritmo vuelve a sinusal despues de un choque
    self.senialMutable = [dataModel generaSenial:SINUSAL0];
    
    //Fecha/hora del choque
    self.ChoqueLastDateLabel.text = [self dameFechaHora];
    
    //Energía del choque
    self.ChoqueEnergiaLabel.text = [@(energia) stringValue];
    
    //Polaridad del choque
    self.ChoquePolaridadLabel.text = polaridad;
    
    //Activo el boton verde de choque y despues de 2 segundos lo apago
    UIImage *imagen = [UIImage imageNamed: @"radioButton1selected.png"];
    self.ChoqueEnabledImg.image = imagen;
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(desactivaBotonVerdeChoque)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) inicioRafaga{
    UIImage *imagen = [UIImage imageNamed: @"radioButton1selected.png"];
    self.RafagaEnabledImg.image = imagen;
    
    //Muestro la ráfaga en el ECG
    self.senialMutable = [dataModel generaSenial:RAFAGA];
}

- (void) finRafaga{
    //Apago luz verde
    UIImage *imagen = [UIImage imageNamed: @"radioButton1notselected.png"];
    self.RafagaEnabledImg.image = imagen;
    
    self.RafagaLastDateLabel.text = [self dameFechaHora];
    
    //Después de la ráfaga viene la FV
    [self setVF2:self];
}




#pragma mark - Navegation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showECGvectores"])
    {
        sicdEcgVCViewController *VC = (sicdEcgVCViewController*)[segue destinationViewController];
        //Paso el modelo de datos al View Controller llamado
        VC.dataModel = self.dataModel;
    }
    
    else if ([[segue identifier] isEqualToString:@"showRecordedECG"])
    {
        PDFViewControler *VC = (PDFViewControler*)[segue destinationViewController];
        //Paso el modelo de datos
        VC.dataModel = self.dataModel;
        VC.tipoPDF = @"recordedECG";
    }
    
    else if ([[segue identifier] isEqualToString:@"showGeneradorPdf"])
    {
        PDFViewControler *VC = (PDFViewControler*)[segue destinationViewController];
        //Paso el modelo de datos
        VC.dataModel = self.dataModel;
        VC.tipoPDF = @"Screening";
    }
}


@end
