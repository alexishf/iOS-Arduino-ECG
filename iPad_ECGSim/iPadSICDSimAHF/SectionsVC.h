//
//  SectionsVC.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 18/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimulatorDataModel.h"

#import "iPadSICDSimAHFViewController.h"
#import "communicationDM.h"

//Implemento el protocolo de la clase que gestiona las comunicaciones
@interface SectionsVC : UIViewController <communicationDMprotocol> //<RscMgrDelegate>

@property (strong, nonatomic) communicationDM *comModel;
@property (strong, nonatomic) SimulatorDataModel *dataModel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButtonHardware;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *batButtonOptions;
@property (strong, nonatomic) IBOutlet UIToolbar *mainToolBar;
- (IBAction)initializeHardwarePressed:(id)sender;



@end
