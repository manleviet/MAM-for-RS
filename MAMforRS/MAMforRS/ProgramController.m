//
//  ProgramController.m
//  TestOpenGL
//
//  Created by MAC PRO on 3/14/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "ProgramController.h"
#import "ViewWindowController.h"
#import "BasicOpenGLView.h"
@class BasicOpenGLView;
@implementation ProgramController

- (IBAction)selectMatrix:(id)sender {
    
    NSLog(@"%d",  [BasicOpenGLView basicResX]);

    if([_matrixBased selectedTag] == 1){
        //NSLog(@"%@", );
    }
    else if ([_matrixBased selectedTag] == 2){
        //start = false;
    }
}
@end
