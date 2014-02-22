//
//  ProgramController.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"

@interface ProgramController : NSObject{
    Program *pro;
    __weak NSMatrix *_matrixBased;
}
- (IBAction)createItemData:(id)sender;
- (IBAction)createUserData:(id)sender;
- (IBAction)createRateData:(id)sender;
- (IBAction)letsStart:(id)sender;

@property (weak) IBOutlet NSMatrix *matrixBased;
@end
