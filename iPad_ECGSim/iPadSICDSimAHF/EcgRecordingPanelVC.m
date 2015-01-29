//
//  EcgRecordingPanelVC.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 11/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "EcgRecordingPanelVC.h"

@interface EcgRecordingPanelVC (){
    // Indica si estamos en proceso de grabación
    BOOL grabando;
    // Timer periodo de actualización
    NSTimer *timerActualizacion;
    // Timer tiempo grabacion
    NSTimer *timerGrabacionECG;
    // Periodo actualizacon progress view
    float periodoActualizacion;
}

@end

@implementation EcgRecordingPanelVC

@synthesize dataModel=_dataModel;
@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        grabando=false;
        
        // Envio el estado de grabación al delegado
        [self.delegate recordingEcg:grabando];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


// Se ejecuta cada vez que hay que incrementar la barra de proceso de grabacion
-(void)actualizaProgressBar{
    self.progressBarSeconds.progress= self.progressBarSeconds.progress+0.1;
    if (self.progressBarSeconds.progress==1){
        [timerActualizacion invalidate];
    }
}


// Programación de tiempo (segundos) en stepper
- (IBAction)stepperSecondsChanged:(id)sender {
    UIStepper *stepper = (UIStepper *)sender;
    self.fieldSecondsToRecord.text = [@(stepper.value) stringValue];
}


- (IBAction)ButtonRecordPressed:(id)sender {
    //Borro señal capturada previa antes de empezar a grabar
    [self.dataModel borraSenialCapturada];
    
    grabando=YES;
    // Envio el estado de grabación al delegado
    [self.delegate recordingEcg:grabando];
    
    self.buttonStop.enabled=YES;
    self.buttonRecord.enabled=NO;
    
    float tiempo = [@(self.stepperSecondsToRecord.value) floatValue];
    timerGrabacionECG=[NSTimer scheduledTimerWithTimeInterval:tiempo
                                                       target:self
                                                     selector:@selector(ButtonStopPressed:)
                                                     userInfo:nil
                                                      repeats:NO];
    
    //Reseteo la barra de progreso a 0
    self.progressBarSeconds.progress=0.0;
    //Hago 10 actualizaciones de la barra de progreso
    periodoActualizacion = tiempo/10;
    //Creo un timer que se repite cada "periodoActualizacion"
    timerActualizacion = [NSTimer scheduledTimerWithTimeInterval:periodoActualizacion
                                                          target:self
                                                        selector:@selector(actualizaProgressBar)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (IBAction)ButtonStopPressed:(id)sender {
    grabando=NO;
    
    // Envio el estado de grabación al delegado
    [self.delegate recordingEcg:grabando];
    
    // Actualizamos estado de los botones
    self.buttonStop.enabled=NO;
    self.buttonRecord.enabled=YES;
    
    //para el Timer (para el caso que manualmente le dio a STOP
    [timerGrabacionECG invalidate];
    
    // Invalido el Timer que actualiza la barra de progreso
    [timerActualizacion invalidate];
    
    // Reseteo la barra de progreso
    self.progressBarSeconds.progress=0.0;

    
    self.buttonShowRecordedEcg.enabled = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"¡Tiempo de grabación agotado!"
                                                    message:@"La grabación del ECG se ha parado"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    //[alert addButtonWithTitle:@"Yes"];
    [alert show];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if ([[segue identifier] isEqualToString:@"showRecordedECG"])
    {
        PDFViewControler *VC = (PDFViewControler*)[segue destinationViewController];
        //Paso el modelo de datos
        VC.dataModel = self.dataModel;
        VC.tipoPDF = @"recordedECG";
    }
}

@end
