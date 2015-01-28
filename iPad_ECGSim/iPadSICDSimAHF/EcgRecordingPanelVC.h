//
//  EcgRecordingPanelVC.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 11/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimulatorDataModel.h"
#import "PDFViewControler.h"

// Protocolo que se encargara de avisar al bojeto que le implemente de
// cuando se está grabando el ECG
@protocol EcgRecordingProtocol <NSObject>

@optional

- (void) recordingEcg:(BOOL)started;

@end


@interface EcgRecordingPanelVC : UIViewController

// Properties
@property (strong, nonatomic) SimulatorDataModel* dataModel;

// Property delegate
@property (weak, nonatomic) id<EcgRecordingProtocol> delegate;

// Properties Outlets
@property (strong, nonatomic) IBOutlet UIStepper *stepperSecondsToRecord;
@property (strong, nonatomic) IBOutlet UITextField *fieldSecondsToRecord;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBarSeconds;
@property (strong, nonatomic) IBOutlet UIButton *buttonRecord;
@property (strong, nonatomic) IBOutlet UIButton *buttonStop;
@property (strong, nonatomic) IBOutlet UIButton *buttonShowRecordedEcg;

// Actions
- (IBAction)ButtonRecordPressed:(id)sender;
- (IBAction)ButtonStopPressed:(id)sender;
- (IBAction)stepperSecondsChanged:(id)sender;


@end
