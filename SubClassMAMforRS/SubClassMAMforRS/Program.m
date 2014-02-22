//
//  Program.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "Program.h"
@implementation Program
@class User;
@class Item;
- (void) initWithArrayItem:(NSMutableArray *)theArrayItem{
    arrayItem = [[NSMutableArray alloc] initWithArray: theArrayItem];
    arrayItemID = [[NSMutableArray alloc] init];
    arrayItemName = [[NSMutableArray alloc] init];
    for(int i=0; i < [arrayItem count]; i++)
    {
        [arrayItemID addObject:[[[arrayItem objectAtIndex:i] componentsSeparatedByString:@"|"] objectAtIndex:0]];
        [arrayItemName addObject:[[[arrayItem objectAtIndex:i] componentsSeparatedByString:@"|"] objectAtIndex:1]];
    }
    NSLog(@"%@",arrayItemID);
}
- (void) initWithArrayUser:(NSMutableArray *)theArrayUser{
    arrayUser = [[NSMutableArray alloc] initWithArray: theArrayUser];
    arrayUserID = [[NSMutableArray alloc] init];
    for(int i=0; i < [arrayUser count]; i++)
    {
        [arrayUserID addObject:[[[arrayUser objectAtIndex:i] componentsSeparatedByString:@"|"] objectAtIndex:0]];
    }
}
- (void) initWithArrayRate:(NSMutableArray *)theArrayRate{
    arrayRate = [[NSMutableArray alloc] initWithArray:theArrayRate];
    //e định sắp xếp lại file u.data nhưng có lẽ thôi :D
    //NSString *ex = [[NSString alloc] init];
    //for(int i=0; i < [arrayRate count]-1; i++)
    //    for(int j=i+1; j < [arrayRate count] - 2; j++)
    //    {
    //        if ( [[[[arrayRate objectAtIndex:i] componentsSeparatedByString:@"|"] objectAtIndex:0] intValue] < [[[[arrayRate objectAtIndex:j] componentsSeparatedByString:@"|"] objectAtIndex:0] intValue] )
    //        {
    //            ex = [arrayRate objectAtIndex:i];
    //            [arrayRate replaceObjectAtIndex:i withObject:[arrayRate objectAtIndex:j]];
    //            [arrayRate replaceObjectAtIndex:j withObject:ex];
    //        }
    //    }
    //NSLog(@"%@",arrayRate);
    

}
- (void)loadItemData{
    
}

- (void)loadUserData{
    //if([self checkData] == false) return;
    NSUInteger n = [arrayItem count];
    id numbers[n];
    for (int x = 0; x < n; x++)
        numbers[x] = [NSNumber numberWithInt:0];
    
        //NSLog(@"%@",arrayItemRate);
    //NSLog(@"%lu",(unsigned long)[arrayItemRate count]);
    for(int i=0; i < [arrayUserID count]-1680; i++)
    {
        arrayItemRate = [NSMutableArray arrayWithObjects:numbers count:n];
        for(int j=0; j < [arrayRate count]; j++)
        {
            NSArray *rateDetail = [[arrayRate objectAtIndex:j] componentsSeparatedByString:@"|"];
            NSUInteger indexItemID = [arrayItem indexOfObject:[rateDetail objectAtIndex:1]];
            if([arrayUserID objectAtIndex:i] == [rateDetail objectAtIndex:0])
            {
                [arrayItemRate replaceObjectAtIndex:indexItemID withObject:[rateDetail objectAtIndex:2]];
            }
        }
        User *u1 = [[User alloc] initWithUserID:[arrayUserID objectAtIndex:i] arrayItemRate:arrayItemRate];
        [u1 toString];
    }
    
}

- (int)indexOfObject:(NSObject *)obj array:(NSMutableArray *)array{
    for (int i = 0; i< [array count]; i++) {
        if([array objectAtIndex:i]==obj) return i;
    }
    return -1;
}
- (void)loadRateData{
    
}
- (bool)checkData{
    if (arrayItem == NULL){
        alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Item Data is NULL"]; [alert runModal];return false;
    }
    else if (arrayUser == NULL){
        alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"User Data is NULL"];[alert runModal];return false;
    }else if (arrayRate == NULL){
        alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Rate Data is NULL"];[alert runModal];return false;
    }
    return true;
}
@end
