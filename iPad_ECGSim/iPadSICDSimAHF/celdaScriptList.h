//
//  celdaScriptList.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 22/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface celdaScriptList : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *celdaScriptListImg;
@property (strong, nonatomic) IBOutlet UILabel *celdaScriptsListNombre;
@property (strong, nonatomic) IBOutlet UILabel *celdaScriptListDescription;
@property (strong, nonatomic) IBOutlet UILabel *celdaScriptAuthor;
@property (strong, nonatomic) IBOutlet UILabel *celdaScriptDate;

@end
