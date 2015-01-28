//
//  sicdEcgVCViewController.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 28/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Timer.h"
#import "SimulatorDataModel.h"


@interface sicdEcgVCViewController : UIViewController<CPTPlotDataSource>{
    float VELOCIDAD_ECG;//Tiempo en segundo de escritura en la grafica
    int indiceGrafica;
    int longitudSenial;
    int offsetIndice;
    int indiceMuestra;
    int test;
    int timerDispatchStatus;
    
    int factorEcg1;
    int factorEcg2;
    int factorEcg3;
}


- (IBAction)capturaEcgPushed:(id)sender;

@property (strong, nonatomic) SimulatorDataModel *dataModel;

@property (strong, nonatomic) NSMutableArray *senialMutable;

@property (strong, nonatomic)   Timer *timer;


//Core Plot
//----------------------------------------------------------------
- (void)inicializaGrafico:(CPTGraphHostingView *)grafico conPlot:(CPTXYGraph *)elPlot eID:(NSString *)nombre;

//Grafico 1
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *grafico1;
@property (strong, nonatomic) NSMutableArray *dataForPlot1;
@property (strong, nonatomic) CPTXYGraph *plot1;

//Grafico 2
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *grafico2;
@property (strong, nonatomic) NSMutableArray *dataForPlot2;
@property (strong, nonatomic) CPTXYGraph *plot2;

//Grafico 3
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *grafico3;
@property (strong, nonatomic) NSMutableArray *dataForPlot3;
@property (strong, nonatomic) CPTXYGraph *plot3;
//----------------------------------------------------------------

- (float) filtraMuestra: (float)muestra tipoFiltro:(int)tipo;

@end
