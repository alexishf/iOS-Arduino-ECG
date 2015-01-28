//
//  LogViewController.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController{
        BOOL firstOpen;
}

@property (strong, nonatomic) IBOutlet UITextView *logWindow;


@end
