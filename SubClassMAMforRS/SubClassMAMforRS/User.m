//
//  User.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "User.h"

@implementation User
- (id) initWithUserID:(NSString *)theUserID
   arrayItemRate:(NSMutableArray *)theArrayItemRate{
    userID = [[NSString alloc] initWithString:theUserID];
    arrayItemRate = [[NSMutableArray alloc] initWithArray:theArrayItemRate];
    return self;
}

- (void)toString{
    NSLog(@"%@/n%@",userID, arrayItemRate);
}

@end
