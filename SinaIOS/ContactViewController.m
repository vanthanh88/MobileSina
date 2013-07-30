//
//  ContactViewController.m
//  sinaIos
//
//  Created by macos on 18/12/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"

@implementation ContactViewController

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView{
    [super loadView];
    aTextView = [[UITextView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:aTextView];
    [aTextView becomeFirstResponder];
}
#pragma mark - Textview delegate
- (void)textViewDidChange:(UITextView *)textView{
    
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
