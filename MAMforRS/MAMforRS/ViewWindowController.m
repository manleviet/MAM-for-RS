//
//  ViewWindowController.m
//  MAMforRS
//
//  Created by MAC PRO on 3/17/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "ViewWindowController.h"

@interface ViewWindowController ()

@end

@implementation ViewWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (BOOL)isReleasedWhenClosed{
    return true;
}
@end
