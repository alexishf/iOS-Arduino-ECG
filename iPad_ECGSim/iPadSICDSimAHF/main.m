//
//  main.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iPadSICDSimAHFAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        // Direccionamiento del LOG a un archivo y a la pantalla del iPad
        //----------------------------------------------------
        /*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        [fileMgr removeItemAtPath:log error:nil];
        
        freopen([log fileSystemRepresentation], "a", stderr);
         */
        //-----------------------------------------------------
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([iPadSICDSimAHFAppDelegate class]));
    }
}
