//
//  monitorEcgVC.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 03/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "SimulatorDataModel.h"

@interface monitorEcgVC : UIViewController <CPTPlotDataSource>

@property (nonatomic,strong) SimulatorDataModel* dataModel;

//Grafico 1
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graficoECG;
@property (strong, nonatomic) NSMutableArray *dataForPlot1;
@property (strong, nonatomic) CPTXYGraph *plot1;

- (void) inicializaECG;
- (void) setSenialForECG:(NSMutableArray *)signal;
- (void) recordingECGstatus:(BOOL)status;

@end
