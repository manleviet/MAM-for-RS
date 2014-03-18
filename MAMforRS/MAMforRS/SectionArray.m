//
//  SectionArray.m
//  TestOpenGL
//
//  Created by MAC PRO on 3/5/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "SectionArray.h"

@implementation SectionArray
- initWithSections:(NSUInteger)s rows:(NSUInteger)r {
    if ((self = [self init])) {
        sections = [[NSMutableArray alloc] initWithCapacity:s];
        NSUInteger i,j;
        for (i=0; i<s; i++) {
            NSMutableArray *a = [NSMutableArray arrayWithCapacity:r];
            for (j=0; j<r; j++) {
                [a setObject:[NSNull null] atIndexedSubscript:j];
            }
            [sections addObject:a];
        }
    }
    return self;
}
+ sectionArrayWithSections:(NSUInteger)s rows:(NSUInteger)r {
    return [[self alloc] initWithSections:s rows:r];
}
- objectInSection:(NSUInteger)s row:(NSUInteger)r {
    return [[sections objectAtIndex:s] objectAtIndex:r];
}
- (void)setObject:o inSection:(NSUInteger)s row:(NSUInteger)r {
    [[sections objectAtIndex:s] replaceObjectAtIndex:r withObject:0];
}
@end
