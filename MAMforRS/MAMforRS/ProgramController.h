//
//  ProgramController.h
//  TestOpenGL
//
//  Created by MAC PRO on 3/14/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewWindowController;
@interface ProgramController : NSObject{
    ViewWindowController *viewWindowController;
    __weak NSPathControl *_selectedPath;
    __weak NSMatrix *_matrixBased;
}


@property (weak) IBOutlet NSPathControl *selectedPath;
- (IBAction)selectMatrix:(id)sender;
@property (weak) IBOutlet NSMatrix *matrixBased;
@end
