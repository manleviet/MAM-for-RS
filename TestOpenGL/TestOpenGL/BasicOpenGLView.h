//
//  BasicOpenGLView.h
//  TestOpenGL
//
//  Created by MAC PRO on 2/13/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <GLUT/glut.h>

#import <OpenGL/glext.h>
#import <OpenGL/glu.h>
typedef struct {
    GLdouble x,y,z;
} recVec;

typedef struct {
	recVec viewPos; // View position
	recVec viewDir; // View direction vector
	recVec viewUp; // View up direction
	recVec rotPoint; // Point to rotate about
	GLdouble aperture; // pContextInfo->camera aperture
	GLint viewWidth, viewHeight; // current window/screen height and width
} recCamera;

@interface BasicOpenGLView : NSOpenGLView{
    // string attributes
	NSMutableDictionary * stanStringAttrib;
	
	// string textures
	//GLString * helpStringTex;
	//GLString * infoStringTex;
	//GLString * camStringTex;
	//GLString * capStringTex;
	//GLString * msgStringTex;
	CFAbsoluteTime msgTime; // message posting time for expiration
	
	NSTimer* timer;
    
    bool fAnimate;
	IBOutlet NSMenuItem * animateMenuItem;
    bool fInfo;
	IBOutlet NSMenuItem * infoMenuItem;
	bool fDrawHelp;
	bool fDrawCaps;
	
	CFAbsoluteTime time;
    
	// spin - quay
	GLfloat rRot [3];
	GLfloat rVel [3];
	GLfloat rAccel [3];
	
	// camera handling
	recCamera camera;
	GLfloat worldRotation [4];
	GLfloat objectRotation [4];
	GLfloat shapeSize;
    GLuint token;
}
- (GLuint)loadTexture:(NSString*)name;

@end
