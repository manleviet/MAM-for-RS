//
//  Vector.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 3/3/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "PointInGlobal.h"
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import <OpenGL/glu.h>

@interface Vector : PointInGlobal{
    
}
-(void) multiplyTheVector:(float)i;
-(void) devideTheVector:(float)i;
-(Vector *) multiplyVector:(int)i;
-(Vector *) devideVector:(int)i;
-(int) getLength;
-(int) getDirectionOfFreeman;
-(bool) isMore:(Vector *)anotherVector;
-(bool) isLess:(Vector *)anotherVector;
-(bool) isMoreOrEqual:(Vector *)anotherVector;
-(bool) isLessOrEqual:(Vector *)anotherVector;
-(void) draw:(const int) x1 andx2:(const int) x2;
@end
