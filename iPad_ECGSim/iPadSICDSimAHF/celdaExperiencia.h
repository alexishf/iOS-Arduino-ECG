//
//  celdaExperiencia.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 21/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface celdaExperiencia : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelNombre;
@property (strong, nonatomic) IBOutlet UILabel *labelDescripcion;
@property (strong, nonatomic) IBOutlet UILabel *labelAreas;
@property (strong, nonatomic) IBOutlet UILabel *labelPuntos;
@property (strong, nonatomic) IBOutlet UILabel *labelEstado;
@property (strong, nonatomic) IBOutlet UIView *viewPantalla;

@end
