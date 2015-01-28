//
//  PDFViewControler.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 31/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "SimulatorDataModel.h"

@interface PDFViewControler : UIViewController <UIPrintInteractionControllerDelegate>

@property (strong, nonatomic) SimulatorDataModel *dataModel;
@property (strong, nonatomic) NSString *tipoPDF;

- (IBAction)buttonBarPrintPressed:(id)sender;
- (IBAction)imprimirPushed:(id)sender;
- (IBAction)backPushed:(id)sender;

@end
