//
//  addInstructionVC.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 31/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "addInstructionVC.h"

@interface addInstructionVC ()

@end

@implementation addInstructionVC

@synthesize instruction=_instruction;
@synthesize delegate=_delegate;
@synthesize listaInstrucciones=_listaInstrucciones;
@synthesize segundosMinutos=_segundosMinutos;

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
    // Do any additional setup after loading the view.
    
    //Inicializo el vector de segundos
    self.segundosMinutos = [[NSMutableArray alloc] init];
    for(int i=0;i<60;i++){
        //obtengo la cifra con dos dígitos en formato string
        NSString *cifra = [NSString stringWithFormat:@"%02d", i];
        //la añado al vector que alimenta el pickerTime
        [self.segundosMinutos addObject:cifra];
    }
    
    //Creo el objeto que contendrá el listado de intrucciones posibles
    //a programar en el script
    self.listaInstrucciones = [[instruccionesPosibles alloc] init];
    
    //Inicializo
    self.instruction = [[instructionElementDM alloc] init];
    
    //Pongo borde al picker de descripcion del script
    [self.pickerInstruction.layer setBorderWidth:1.0],
    [self.pickerInstruction.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
    [self.pickerTime.layer setBorderWidth:1.0],
    [self.pickerTime.layer setBorderColor:[[UIColor lightGrayColor]CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark pickerView protocol implementation

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(pickerView==self.pickerInstruction){
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView==self.pickerInstruction){
        return  self.listaInstrucciones.listaPosiblesIns.count;
    }else{
        return  self.segundosMinutos.count;
    }

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView==self.pickerInstruction){
      //Paso a un NSArray todos los nombres de las instrucciones
      NSArray *values = [self.listaInstrucciones.listaPosiblesIns allValues];
      //Selecciono la que corresponda segun el valor de row
      return [values objectAtIndex:row];
    }else{
        return [self.segundosMinutos objectAtIndex:row];
    }
}


- (IBAction)savePressed:(id)sender {
    
    //Compruebo si todos los campos están rellenos adecuadamente
    //...
    
    NSArray *values = [self.listaInstrucciones.listaPosiblesIns allValues];
    
    //NSInteger row1 = [self.segundosMinutos objectAtIndex:[self.pickerInstruction selectedRowInComponent:0]];;
    self.instruction.name = [values objectAtIndex:[self.pickerInstruction selectedRowInComponent:0]];
    self.instruction.parameter1 = self.fieldParam1.text;
    self.instruction.parameter2 = self.fieldParam2.text;
    
    NSString* min=[self.segundosMinutos objectAtIndex:[self.pickerTime selectedRowInComponent:0]];
    NSString* seg=[self.segundosMinutos objectAtIndex:[self.pickerTime selectedRowInComponent:1]];
    self.instruction.inMinute=[NSNumber numberWithInt:[min intValue]];
    self.instruction.inSecond=[NSNumber numberWithInt:[seg intValue]];
        
    [self.delegate saveInstructionPressed:self.instruction];
    
}

@end
