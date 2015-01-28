//
//  addInstructionVC.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 31/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "instructionElementDM.h"
#import "instruccionesPosibles.h"

@protocol addInstructionDelegate <NSObject,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

-(void)saveInstructionPressed:(instructionElementDM*)script;

@end


@interface addInstructionVC : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *pickerInstruction;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerTime;
@property (strong, nonatomic) IBOutlet UITextField *fieldParam1;
@property (strong, nonatomic) IBOutlet UITextField *fieldParam2;

@property (nonatomic,weak) id<addInstructionDelegate> delegate;
@property (nonatomic,strong) instructionElementDM *instruction;
@property (nonatomic,strong) instruccionesPosibles *listaInstrucciones;
@property (nonatomic,strong) NSMutableArray *segundosMinutos;

- (IBAction)savePressed:(id)sender;


@end
