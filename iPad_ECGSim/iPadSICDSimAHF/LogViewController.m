//
//  LogViewController.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end


@implementation LogViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //self.logWindow.text=@"TEST";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];
    
    if(firstOpen==NO){
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:log];
        //Seek to end of file so that logs from previous application launch are not visible
        [fh seekToEndOfFile];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getData:)
                                                     name:@"NSFileHandleReadCompletionNotification"
                                                   object:fh];
        [fh readInBackgroundAndNotify];
        firstOpen = YES;
    }
    
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *log = [[paths objectAtIndex:0] stringByAppendingPathComponent: @"ns.log"];
    NSLog(@"Opened log window.");
    if ( firstOpen ) {
        NSString* content = [NSString stringWithContentsOfFile:log encoding:NSUTF8StringEncoding error:NULL];
        self.logWindow.editable=TRUE;
		self.logWindow.text = [self.logWindow.text stringByAppendingString: content];
		self.logWindow.editable = FALSE;
        firstOpen = NO;
    }
    
}


#pragma mark - NSLog Redirection Methods

- (void) getData: (NSNotification *)aNotification {
    NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    if ([data length]) {
        NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		self.logWindow.editable = TRUE;
		self.logWindow.text = [self.logWindow.text stringByAppendingString: aString];
		self.logWindow.editable = FALSE;
        
		[self setWindowScrollToVisible];
		[[aNotification object] readInBackgroundAndNotify];
    } else {
		[self performSelector:@selector(refreshLog:) withObject:aNotification afterDelay:1.0];
	}
}

- (void) refreshLog: (NSNotification *)aNotification {
	[[aNotification object] readInBackgroundAndNotify];
}

-(void)setWindowScrollToVisible {
	NSRange txtOutputRange;
	txtOutputRange.location = [[self.logWindow text] length];
	txtOutputRange.length = 0;
    self.logWindow.editable = TRUE;
	[self.logWindow scrollRangeToVisible:txtOutputRange];
	[self.logWindow setSelectedRange:txtOutputRange];
    self.logWindow.editable = FALSE;
}


@end
