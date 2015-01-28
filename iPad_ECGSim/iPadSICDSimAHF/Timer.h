//
//  Timer.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 24/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject {
    NSDate *start;
    NSDate *end;
}

- (void) startTimer;
- (void) stopTimer;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;


@end
