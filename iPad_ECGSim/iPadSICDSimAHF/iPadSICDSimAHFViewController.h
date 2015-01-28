//
//  iPadSICDSimAHFViewController.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "RscMgr.h"
#import "LogViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "ritmos.h"
#import "Timer.h"
#import "SimulatorDataModel.h"
#import "senial.h"
#include "constantes.h"
#include "communicationDM.h"
#include "monitorEcgVC.h"
#include "EcgRecordingPanelVC.h"
#import "PDFViewControler.h"


//Por convención, aquí pondría las variables de instancia públicas (en el .h)
//Las variables de instancia privadas los pongo en el .m

// Implementar el protocolo commu... permite recibir eventos como cuando ha llegado un choque
@interface iPadSICDSimAHFViewController : UIViewController <EcgRecordingProtocol,communicationDMprotocol>{

}

@property (strong, nonatomic) communicationDM *comModel;
@property (strong, nonatomic) SimulatorDataModel *dataModel;
@property (nonatomic,strong) monitorEcgVC* monitorECG;
@property (nonatomic,strong) EcgRecordingPanelVC* panelGrabacionECG;

@property (strong, nonatomic) NSMutableArray *senialMutable;
@property (strong, nonatomic) NSMutableArray *senialMutableSecundary;
@property (strong, nonatomic) NSMutableArray *senialMutableAlternate;

//@property (strong, nonatomic)   Timer *timer;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITextField *textEntry;
@property (strong, nonatomic) IBOutlet UITextView *serialView;

@property (strong, nonatomic) IBOutlet UILabel *ECGtitle;

@property (strong, nonatomic) IBOutlet UIToolbar *mainToolBar;

@property (strong, nonatomic) IBOutlet UILabel *PminimumValue;
@property (strong, nonatomic) IBOutlet UILabel *PmaximumValue;
@property (strong, nonatomic) IBOutlet UILabel *PwaveLabel;

@property (strong, nonatomic) IBOutlet UILabel *QRSminimumValue;
@property (strong, nonatomic) IBOutlet UILabel *QRSmaximumValue;
@property (strong, nonatomic) IBOutlet UILabel *QRSWaveLabel;

@property (strong, nonatomic) IBOutlet UILabel *TminimumValue;
@property (strong, nonatomic) IBOutlet UILabel *TmaximumValue;
@property (strong, nonatomic) IBOutlet UILabel *TWaveLabel;

@property (strong, nonatomic) IBOutlet UILabel *HRminimumLabel;
@property (strong, nonatomic) IBOutlet UILabel *HRmaximumLabel;
@property (strong, nonatomic) IBOutlet UILabel *HeartRateLabel;

@property (strong, nonatomic) IBOutlet UILabel *PRminimumLabel;
@property (strong, nonatomic) IBOutlet UILabel *PRmaximumLabel;
@property (strong, nonatomic) IBOutlet UILabel *PRintervalLabel;

@property (strong, nonatomic) IBOutlet UILabel *STminimumLabel;
@property (strong, nonatomic) IBOutlet UILabel *STmaximumLabel;
@property (strong, nonatomic) IBOutlet UILabel *STIntervalLabel;

@property (strong, nonatomic) IBOutlet UILabel *senialMinimumLabel;
@property (strong, nonatomic) IBOutlet UILabel *senialMaximumLabel;
@property (strong, nonatomic) IBOutlet UILabel *senialValueLabel;

//Rafaga 50Hz
@property (strong, nonatomic) IBOutlet UIImageView *RafagaEnabledImg;
@property (strong, nonatomic) IBOutlet UILabel *RafagaSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *RafagaLastDateLabel;
//Choque
@property (strong, nonatomic) IBOutlet UIImageView *ChoqueEnabledImg;
@property (strong, nonatomic) IBOutlet UILabel *ChoqueEnergiaLabel;
@property (strong, nonatomic) IBOutlet UILabel *ChoquePolaridadLabel;
@property (strong, nonatomic) IBOutlet UILabel *ChoqueLastDateLabel;
//Post-Shock pacing
@property (strong, nonatomic) IBOutlet UIImageView *PSPacingEnabledImg;
@property (strong, nonatomic) IBOutlet UILabel *PSPacingSecondsLabel;
@property (strong, nonatomic) IBOutlet UILabel *PSPacingLastDateLabel;


@property (strong, nonatomic) IBOutlet UISlider *HRslider;
@property (strong, nonatomic) IBOutlet UISlider *PRslider;
@property (strong, nonatomic) IBOutlet UISlider *QTslider;
@property (strong, nonatomic) IBOutlet UISlider *PwaveAmplitude;
@property (strong, nonatomic) IBOutlet UISlider *QRSwaveAmplitude;
@property (strong, nonatomic) IBOutlet UISlider *TwaveAmplitude;
@property (strong, nonatomic) IBOutlet UISlider *senialAmplitude;


- (IBAction)sliderPot0Changed:(id)sender;
- (IBAction)sliderPot0TouchedUp:(id)sender;
- (IBAction)sliderPot0TouchedUpOut:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *sliderPot0;
@property (strong, nonatomic) IBOutlet UILabel *Pot0Label;


- (IBAction)sliderPot1Changed:(id)sender;
- (IBAction)sliderPot1TouchedUp:(id)sender;
- (IBAction)sliderPot1TouchedUpOut:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *sliderPot1;
@property (strong, nonatomic) IBOutlet UILabel *Pot1Label;


- (IBAction)sliderPwaveChanged:(id)sender;
- (IBAction)sliderPwaveTouchedUp:(id)sender;
- (IBAction)sliderPwaveTouchedUpOut:(id)sender;

- (IBAction)sliderQRSWaveChanged:(id)sender;
- (IBAction)sliderQRSTouchedUP:(id)sender;
- (IBAction)sliderQRSwaveTouchedUpOut:(id)sender;

- (IBAction)sliderTwaveChanged:(id)sender;
- (IBAction)sliderTwaveTouchedUp:(id)sender;
- (IBAction)sliderTwaveTouchedUpOut:(id)sender;

- (IBAction)sliderHearRateChanged:(id)sender;
- (IBAction)sliderHearRateTouchedUp:(id)sender;
- (IBAction)sliderHeartRateTouchedUpOut:(id)sender;

- (IBAction)sliderPRintervalChanged:(id)sender;
- (IBAction)sliderPRIntervalTouchedUp:(id)sender;
- (IBAction)sliderPRintervalTouchedUpOut:(id)sender;

- (IBAction)sliderSTintervalChanged:(id)sender;
- (IBAction)sliderSTintervalTouchedUp:(id)sender;
- (IBAction)sliderSTintervalTouchedUpOut:(id)sender;

- (IBAction)sliderAmplitudRSchanged:(id)sender;
- (IBAction)sliderAmplitudRSTouchedUP:(id)sender;
- (IBAction)sliderAmplitudRSTouchedUpOut:(id)sender;


- (IBAction)setSinusRhythm:(id)sender;
- (IBAction)setAF1:(id)sender;
- (IBAction)setAF2:(id)sender;
- (IBAction)setTV1:(id)sender;
- (IBAction)setTV2:(id)sender;
- (IBAction)setTV3:(id)sender;
- (IBAction)setVF1:(id)sender;
- (IBAction)setVF2:(id)sender;
- (IBAction)setPVC:(id)sender;
- (IBAction)setPAC:(id)sender;
- (IBAction)setAT:(id)sender;
- (IBAction)setEscV:(id)sender;
- (IBAction)setAsistolia:(id)sender;
- (IBAction)setRafaga:(id)sender;


- (IBAction)primarySelected:(id)sender;
- (IBAction)secundarySelected:(id)sender;
- (IBAction)alternateSelected:(id)sender;


//- (int) sendCommand:(int)command withValue:(int)value;

@end
