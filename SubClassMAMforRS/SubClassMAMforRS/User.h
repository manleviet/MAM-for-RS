//
//  User.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSString *userID;
    NSMutableArray *arrayItemRate;
}
- (id) initWithUserID:(NSString *)theUserID
        arrayItemRate:(NSMutableArray *)theArrayItemRate;
- (void)toString;
@end
