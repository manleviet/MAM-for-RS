//
//  SectionArray.h
//  TestOpenGL
//
//  Created by MAC PRO on 3/5/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionArray : NSObject{
    NSMutableArray *sections;
}
- initWithSections:(NSUInteger)s rows:(NSUInteger)r;
+ sectionArrayWithSections:(NSUInteger)s rows:(NSUInteger)r;
- objectInSection:(NSUInteger)s row:(NSUInteger)r;
- (void)setObject:o inSection:(NSUInteger)s row:(NSUInteger)r;
@end
