//
//  ProgramController.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "ProgramController.h"
@class Program;
@implementation ProgramController

- (IBAction)createItemData:(id)sender {
    if(pro == NULL) pro = [[Program alloc] init];
    [pro initWithArrayItem:[self getArrayFromFile]];
}

- (IBAction)createUserData:(id)sender {
    if(pro == NULL) pro = [[Program alloc] init];
    [pro initWithArrayUser:[self getArrayFromFile]];
}

- (IBAction)createRateData:(id)sender {
    if(pro == NULL) pro = [[Program alloc] init];
    [pro initWithArrayRate:[self getArrayFromFile]];
}

- (IBAction)letsStart:(id)sender {
    if(pro == NULL) pro = [[Program alloc] init];
    if([_matrixBased selectedTag] == 1){
        [pro loadItemData];
    }else{
        [pro loadUserData];
    }
}

- (NSMutableArray *)getArrayFromFile{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:NO];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:NO];
    
    // Display the dialog. If the OK button was pressed,
    // process the files.
    NSString *filePath;
    if ( [openDlg runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        filePath = (NSString *)[openDlg URL];
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:0 error:&error];
        
        if (error){
            NSLog(@"Error reading file: %@", error.localizedDescription); return NULL;}
        return (NSMutableArray *) [fileContents componentsSeparatedByString:@"\n"];
    }
    return NULL;
}
@end
