//
//  celdaInstruccion.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 26/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface celdaInstruccion : UITableViewCell

//Elementos de la celda prototipo del TableView
@property (strong, nonatomic) IBOutlet UILabel *labelNInstruccion;
@property (strong, nonatomic) IBOutlet UILabel *labelNombreInstruccion;
@property (strong, nonatomic) IBOutlet UILabel *labelParam1Instruccion;
@property (strong, nonatomic) IBOutlet UILabel *labelParam2Instruccion;
@property (strong, nonatomic) IBOutlet UILabel *labelMinutoInstruccion;
@property (strong, nonatomic) IBOutlet UILabel *labelMomentoIntruccion;


@end
