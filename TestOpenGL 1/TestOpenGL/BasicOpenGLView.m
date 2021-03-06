//
//  BasicOpenGLView.m
//  TestOpenGL
//
//  Created by MAC PRO on 2/13/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "BasicOpenGLView.h"
#import "trackball.h"

// simple cube data
GLint cube_num_vertices = 8;

GLfloat cube_vertices [8][3] = {
    {1.0, 1.0, 1.0}, {1.0, -1.0, 1.0}, {-1.0, -1.0, 1.0}, {-1.0, 1.0, 1.0},
    {1.0, 1.0, -1.0}, {1.0, -1.0, -1.0}, {-1.0, -1.0, -1.0}, {-1.0, 1.0, -1.0} };

GLfloat cube_vertex_colors [8][3] = {
    {1.0, 1.0, 1.0}, {1.0, 1.0, 0.0}, {0.0, 1.0, 0.0}, {0.0, 1.0, 1.0},
    {1.0, 0.0, 1.0}, {1.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 1.0} };

GLint num_faces = 6;

short cube_faces [6][4] = {
    {3, 2, 1, 0}, {2, 3, 7, 6}, {0, 1, 5, 4}, {3, 0, 4, 7}, {1, 2, 6, 5}, {4, 5, 6, 7} };

recVec gOrigin = {0.0, 0.0, 0.0};

// single set of interaction flags and states
GLint gDollyPanStartPoint[2] = {0, 0};
GLfloat gTrackBallRotation [4] = {0.0f, 0.0f, 0.0f, 0.0f};
GLboolean gDolly = GL_FALSE;
GLboolean gPan = GL_FALSE;
GLboolean gTrackball = GL_FALSE;
BasicOpenGLView * gTrackingViewInfo = NULL;

// time and message info
CFAbsoluteTime gMsgPresistance = 10.0f;

// error output
//GLString * gErrStringTex;
float gErrorTime;

// ==================================


#pragma mark ---- Utilities ----

static CFAbsoluteTime gStartTime = 0.0f;

// set app start time
static void setStartTime (void)
{
	gStartTime = CFAbsoluteTimeGetCurrent ();
}

// ---------------------------------

// return float elpased time in seconds since app start
static CFAbsoluteTime getElapsedTime (void)
{
	return CFAbsoluteTimeGetCurrent () - gStartTime;
}

#pragma mark ---- Error Reporting ----

// error reporting as both window message and debugger string
void reportError (char * strError)
{
    NSMutableDictionary *attribs = [NSMutableDictionary dictionary];
    [attribs setObject: [NSFont fontWithName: @"Monaco" size: 9.0f] forKey: NSFontAttributeName];
    [attribs setObject: [NSColor whiteColor] forKey: NSForegroundColorAttributeName];
    
	gErrorTime = getElapsedTime ();
	NSString * errString = [NSString stringWithFormat:@"Error: %s (at time: %0.1f secs).", strError, gErrorTime];
	NSLog (@"%@\n", errString);
	//if (gErrStringTex)
		//[gErrStringTex setString:errString withAttributes:attribs];
	//else {
		//gErrStringTex = [[GLString alloc] initWithString:errString withAttributes:attribs withTextColor:[NSColor colorWithDeviceRed:1.0f green:1.0f blue:1.0f alpha:1.0f] withBoxColor:[NSColor colorWithDeviceRed:1.0f green:0.0f blue:0.0f alpha:0.3f] withBorderColor:[NSColor colorWithDeviceRed:1.0f green:0.0f blue:0.0f alpha:0.8f]];
	//}
}

// ---------------------------------

// if error dump gl errors to debugger string, return error
GLenum glReportError (void)
{
	GLenum err = glGetError();
	if (GL_NO_ERROR != err)
		reportError ((char *) gluErrorString (err));
	return err;
}

#pragma mark ---- OpenGL Utils ----

// ---------------------------------

// draw our simple cube based on current modelview and projection matrices
 void drawCube (GLfloat fSize)
{

    
    
    //NSURL *_myURL = [NSURL fileURLWithPath:@"</Volumes/DATA/video ERP>"];
    //CIImage *_imageCIImage = [CIImage imageWithContentsOfURL:_myURL];
    
    
   //NSRect _rectFromCIImage = [_imageCIImage extent];
    
    //NSLog(@"Width from CIImage: %f",_rectFromCIImage.size.width);
    //NSLog(@"Height from CIImage: %f",_rectFromCIImage.size.height);
    //GLuint width = _rectFromCIImage.size.width;
    //GLuint height = _rectFromCIImage.size.height;
    
    //
    //CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:@"/Users/macpro/Downloads/Button.png"];
    //CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(url, NULL);
    //CGImageRef myImageRef = CGImageSourceCreateImageAtIndex (myImageSourceRef, 0, NULL);
    //CGImageRef myImageRef = [[NSImage imageNamed:@"logott.jpg"] CGImage];
    //GLuint myTextureName;
    //GLint width = (int)CGImageGetWidth(myImageRef);
    //GLint height = (int)CGImageGetHeight(myImageRef);
    //NSLog(@"Width from CIImage: %d",width);
    //NSLog(@"Height from CIImage: %d",height);
    //GLint width = 1;
    //GLint height = 1;
    //CGRect rect = {{0, 0}, {width, height}};
    //void * myData = calloc(width * 4, height);
    //CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    //CGContextRef myBitmapContext = CGBitmapContextCreate (myData, width, height, 8, width*4, space, kCGBitmapByteOrder32Host |kCGImageAlphaPremultipliedFirst);
    //CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    //CGContextDrawImage(myBitmapContext, rect, myImageRef);
    //CGContextRelease(myBitmapContext);
    //glPixelStorei(GL_UNPACK_ROW_LENGTH, width);
    //glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    //glGenTextures(1, &myTextureName);
    //glBindTexture(GL_TEXTURE_RECTANGLE_ARB, myTextureName);
    ///glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    //glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGBA8, width, height, 0, GL_BGRA_EXT, GL_UNSIGNED_INT_8_8_8_8_REV, myData);
    //free(myData);
//
    //glTranslatef (3.0, 0.0, 0.0);
    //NSImage *img = [[NSImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMTgwMjI4MzU5N15BMl5BanBnXkFtZTcwMTMyNTk3OA@@._V1_SY317_CR12,0,214,317_.jpg"]]];

    //glTranslatef (-1000,-1000,0);
    
    
    //glColor3f (0.0, 0.9, 0.0); /* thiết lập màu vẽ: màu trắng */
    //glBegin(GL_LINE_LOOP); /* bắt đầu vẽ đa giác */
    //glVertex3f (2, 2, 0); /* xác định các đỉnh của đa giác */
    //glVertex3f (2, -2, 0);
    //glVertex3f (-2, -2, 0);
    //glVertex3f (-2, 2, 0);
    //glEnd();
    
    //glPushMatrix(); // lưu lại ma trận hiện hành
    //glColor3f (1.0, 0, 0); // thiết lập màu vẽ là màu đỏ
    // vẽ mặt trời là một lưới cầu có tâm tại
    //gốc tọa độ
    //glutWireSphere(1.0, 20, 16);
    /* di chuyển đến vị trí mới để vẽ trái đất */
    //glRotatef ((GLfloat) 10, 0.0, 1.0, 0.0); // quay một góc tương ứng với thời gian trong năm
    //glTranslatef (3.0, 0.0, 0.0); // tịnh tiến đến vị trí hiện tại của trái đất trên quỹ đạo quanh mặt trời
    //glRotatef ((GLfloat) 1, 0.0, 1.0, 0.0); // quay trái đất tương ứng với thời gian trong ngày
    //glColor3f (0, 0, 1.0); // thiết lập màu vẽ là màu blue
    //glutWireSphere(0.2, 10, 8); // vẽ trái đất
    //glPopMatrix(); // phục hồi lại ma trận hiện hành cũ: tương ứng với quay
    //lại vị trí ban đầu
    //glutSwapBuffers();
    
}

int ranNum (int m)
{
    return rand()%m;
}
CGImageRef CGImageCreateWithNSImage2(NSImage *image) {
    NSSize imageSize = [image size];
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
    [image drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    return cgImage;
}
@implementation BasicOpenGLView

// pixel format definition
+ (NSOpenGLPixelFormat*) basicPixelFormat
{
    NSOpenGLPixelFormatAttribute attributes [] = {
        NSOpenGLPFAWindow,
        NSOpenGLPFADoubleBuffer,	// double buffered
        NSOpenGLPFADepthSize, (NSOpenGLPixelFormatAttribute)16, // 16 bit depth buffer
        (NSOpenGLPixelFormatAttribute)nil
    };
    return [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
}
- (void)drawImage{
    NSString *documents = [@"/Users/manleviet/Dropbox/Tai lieu cho Duc/PicMovieLens/100K/0.3" stringByExpandingTildeInPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [fileManager enumeratorAtPath:documents];
    NSString *tString;
    while ((tString = [direnum nextObject] ))
    {
        if ([tString hasSuffix:@".png"])
        {
            //glTranslatef (ranNum(1000),ranNum(1000),0);
            NSString *fileAbsPath = [NSString stringWithFormat:@"%@/%@",documents,tString];
            //Do something with the file
            NSImage *img = [[NSImage alloc] initWithContentsOfFile:fileAbsPath];
            //NSImage *img = [NSImage imageNamed:@"Result.jpg"];
            NSSize imageSize = [img size];
            
            CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
            
            [NSGraphicsContext saveGraphicsState];
            [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
            [img drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
            [NSGraphicsContext restoreGraphicsState];
            
            CGImageRef myImageRef = CGBitmapContextCreateImage(bitmapContext);
            CGContextRelease(bitmapContext);
            
            int ww = (int) CGImageGetWidth(myImageRef);
            int hh = (int) CGImageGetHeight(myImageRef);
            
            CGRect rect = CGRectMake(0.0, 0.0, (CGFloat)ww, (CGFloat)hh);
            GLubyte *data = (GLubyte *) calloc(ww * hh, 4);
            CGContextRef ctx = CGBitmapContextCreate(data, ww, hh, 8, ww * 4,
                                                     CGImageGetColorSpace(myImageRef),
                                                     kCGBitmapByteOrder32Host |kCGImageAlphaPremultipliedFirst);
            [self drawImage:&ctx andRect:&rect andImageRef:&myImageRef andData:data andToken:NULL];
            
        }
    }

            //NSLog(@"%u",token);
}
- (GLuint) drawImage: (CGContextRef *)contextRef andRect:(CGRect *)rect andImageRef:(CGImageRef *)imageRef andData: (GLubyte *)data andToken: (GLuint *)toke{
    int ww = (int) CGImageGetWidth(*imageRef);
    int hh = (int) CGImageGetHeight(*imageRef);
    CGContextDrawImage(*contextRef, *rect, *imageRef);
    
    glGenTextures(1, &token);
    glBindTexture(GL_TEXTURE_2D, token);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, ww, hh, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, data);
    free(data);
    glBindTexture(GL_TEXTURE_2D, token);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glEnable(GL_BLEND);
    glEnable(GL_TEXTURE_2D);
    
    //float vbfr[] = {0,hh, 0,0, ww,0, ww,hh};
    float vbfr[] = {0, hh, 0, 0, ww,0, ww,hh};
    
    float tbfr[] = { 0,-1, 0,0, -1,0, -1,-1};
    
    float x = ranNum(1000);
    float y = ranNum(1000);
    
    glPushMatrix();
    glTranslatef( -hh/2 + x, -ww/2 + y, 0 );
    glVertexPointer(2, GL_FLOAT, 0, vbfr);
    glTexCoordPointer(2, GL_FLOAT, 0, tbfr);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendEquationEXT(GL_MAX_EXT);
    glPopMatrix();
    
    glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
    return token;
}
// ---------------------------------
// ---------------------------------
- (GLuint)loadTexture :  (NSString *)name{
    NSBitmapImageRep    *bitmap;
    NSImage                *image;
    
    GLuint texID;
    
    image = [NSImage imageNamed:name];
    bitmap = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
    
    if(bitmap == nil)
    {
        NSLog(@"Couldn't open image: %@",name);
        return 0;
    }
    
    int bitsPerPixel = (int)[bitmap bitsPerPixel];
    
    GLenum internal_format;
    GLenum img_format, img_type;
    
    switch(bitsPerPixel)
    {
        case 32:
            img_format = GL_RGBA;
            img_type = GL_UNSIGNED_BYTE;
            internal_format = GL_RGBA8;
            break;
        case 24:
            img_format = GL_RGB;
            img_type = GL_UNSIGNED_BYTE;
            internal_format = GL_RGB8;
            break;
        case 16:
            img_format = GL_RGBA;
            img_type = GL_UNSIGNED_SHORT_5_5_5_1;
            internal_format = GL_RGB5_A1;
            break;
        default:
            img_format = GL_LUMINANCE;
            img_type = GL_UNSIGNED_BYTE;
            internal_format=GL_LUMINANCE8;
            break;
    }
    
    glGenTextures(1,&texID);
    
    glBindTexture(GL_TEXTURE_2D,texID);
    
    glPixelStorei(GL_UNPACK_ALIGNMENT,1);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glTexImage2D(GL_TEXTURE_2D,0,internal_format,
                 [bitmap size].width,[bitmap size].height,0,
                 img_format,img_type, [bitmap bitmapData]);
    
    
    return texID;
}

// update the projection matrix based on camera and view info
- (void) updateProjection
{
	GLdouble ratio, radians, wd2;
	GLdouble left, right, top, bottom, near, far;
    
    [[self openGLContext] makeCurrentContext];
    
	// set projection
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity ();
	near = -camera.viewPos.z - shapeSize * 0.5;
	if (near < 0.00001)
		near = 0.00001;
	far = -camera.viewPos.z + shapeSize * 0.5;
	if (far < 1.0)
		far = 1.0;
	radians = 0.0174532925 * camera.aperture / 2; // half aperture degrees to radians
	wd2 = near * tan(radians);
	ratio = camera.viewWidth / (float) camera.viewHeight;
	if (ratio >= 1.0) {
		left  = -ratio * wd2;
		right = ratio * wd2;
		top = wd2;
		bottom = -wd2;
	} else {
		left  = -wd2;
		right = wd2;
		top = wd2 / ratio;
		bottom = -wd2 / ratio;
	}
	glFrustum (left, right, bottom, top, near, far);
	//[self updateCameraString];
}

// ---------------------------------

// updates the contexts model view matrix for object and camera moves
- (void) updateModelView
{
    [[self openGLContext] makeCurrentContext];
	
	// move view
	glMatrixMode (GL_MODELVIEW);
	glLoadIdentity ();
	gluLookAt (camera.viewPos.x, camera.viewPos.y, camera.viewPos.z,
			   camera.viewPos.x + camera.viewDir.x,
			   camera.viewPos.y + camera.viewDir.y,
			   camera.viewPos.z + camera.viewDir.z,
			   camera.viewUp.x, camera.viewUp.y ,camera.viewUp.z);
    
	// if we have trackball rotation to map (this IS the test I want as it can be explicitly 0.0f)
	if ((gTrackingViewInfo == self) && gTrackBallRotation[0] != 0.0f)
		glRotatef (gTrackBallRotation[0], gTrackBallRotation[1], gTrackBallRotation[2], gTrackBallRotation[3]);
	else {
	}
	// accumlated world rotation via trackball
	glRotatef (worldRotation[0], worldRotation[1], worldRotation[2], worldRotation[3]);
	// object itself rotating applied after camera rotation
	glRotatef (objectRotation[0], objectRotation[1], objectRotation[2], objectRotation[3]);
	rRot[0] = 0.0f; // reset animation rotations (do in all cases to prevent rotating while moving with trackball)
	rRot[1] = 0.0f;
	rRot[2] = 0.0f;
	//[self updateCameraString];
}

// ---------------------------------

// handles resizing of GL need context update and if the window dimensions change, a
// a window dimension update, reseting of viewport and an update of the projection matrix
- (void) resizeGL
{
	NSRect rectView = [self bounds];
	
	// ensure camera knows size changed
	if ((camera.viewHeight != rectView.size.height) ||
	    (camera.viewWidth != rectView.size.width)) {
		camera.viewHeight = rectView.size.height;
		camera.viewWidth = rectView.size.width;
		
		glViewport (0, 0, camera.viewWidth, camera.viewHeight);
		[self updateProjection];  // update projection matrix
		//[self updateInfoString];
	}
}

// ---------------------------------

// move camera in z axis
-(void)mouseDolly: (NSPoint) location
{
	GLfloat dolly = (gDollyPanStartPoint[1] -location.y) * -camera.viewPos.z / 300.0f;
	camera.viewPos.z += dolly;
	if (camera.viewPos.z == 0.0) // do not let z = 0.0
		camera.viewPos.z = 0.0001;
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
}

// ---------------------------------

// move camera in x/y plane
- (void)mousePan: (NSPoint) location
{
	GLfloat panX = (gDollyPanStartPoint[0] - location.x) / (900.0f / -camera.viewPos.z);
	GLfloat panY = (gDollyPanStartPoint[1] - location.y) / (900.0f / -camera.viewPos.z);
	camera.viewPos.x -= panX;
	camera.viewPos.y -= panY;
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
}

// ---------------------------------

// sets the camera data to initial conditions
- (void) resetCamera
{
    camera.aperture = 100;
    camera.rotPoint = gOrigin;
    
    camera.viewPos.x = 0.0;
    camera.viewPos.y = 0.0;
    camera.viewPos.z = -1000.0;
    camera.viewDir.x = -camera.viewPos.x;
    camera.viewDir.y = -camera.viewPos.y;
    camera.viewDir.z = -camera.viewPos.z;
    
    camera.viewUp.x = 0;
    camera.viewUp.y = 1;
    camera.viewUp.z = 0;
}

// ---------------------------------

// given a delta time in seconds and current rotation accel, velocity and position, update overall object rotation
- (void) updateObjectRotationForTimeDelta:(CFAbsoluteTime)deltaTime
{
	// update rotation based on vel and accel
	float rotation[4] = {0.0f, 0.0f, 0.0f, 0.0f};
	GLfloat fVMax = 2.0;
	short i;
	// do velocities
	for (i = 0; i < 3; i++) {
		rVel[i] += rAccel[i] * deltaTime * 30.0;
		
		if (rVel[i] > fVMax) {
			rAccel[i] *= -1.0;
			rVel[i] = fVMax;
		} else if (rVel[i] < -fVMax) {
			rAccel[i] *= -1.0;
			rVel[i] = -fVMax;
		}
		
		rRot[i] += rVel[i] * deltaTime * 30.0;
		
		while (rRot[i] > 360.0)
			rRot[i] -= 360.0;
		while (rRot[i] < -360.0)
			rRot[i] += 360.0;
	}
	rotation[0] = rRot[0];
	rotation[1] = 1.0f;
	addToRotationTrackball (rotation, objectRotation);
	rotation[0] = rRot[1];
	rotation[1] = 0.0f; rotation[2] = 1.0f;
	addToRotationTrackball (rotation, objectRotation);
	rotation[0] = rRot[2];
	rotation[2] = 0.0f; rotation[3] = 1.0f;
	addToRotationTrackball (rotation, objectRotation);
}

// ---------------------------------

// per-window timer function, basic time based animation preformed here
- (void)animationTimer:(NSTimer *)timer
{
	BOOL shouldDraw = NO;
	if (fAnimate) {
		CFTimeInterval deltaTime = CFAbsoluteTimeGetCurrent () - time;
        
		if (deltaTime > 10.0) // skip pauses
			return;
		else {
			// if we are not rotating with trackball in this window
			if (!gTrackball || (gTrackingViewInfo != self)) {
				[self updateObjectRotationForTimeDelta: deltaTime]; // update object rotation
			}
			shouldDraw = YES; // force redraw
		}
	}
	time = CFAbsoluteTimeGetCurrent (); //reset time in all cases
	// if we have current messages
	if (((getElapsedTime () - msgTime) < gMsgPresistance) || ((getElapsedTime () - gErrorTime) < gMsgPresistance))
		shouldDraw = YES; // force redraw
	if (YES == shouldDraw)
		[self drawRect:[self bounds]]; // redraw now instead dirty to enable updates during live resize
}

#pragma mark ---- Method Overrides ----

-(void)keyDown:(NSEvent *)theEvent
{
    NSString *characters = [theEvent characters];
    if ([characters length]) {
        unichar character = [characters characterAtIndex:0];
		switch (character) {
			case 'h':
				// toggle help
				fDrawHelp = 1 - fDrawHelp;
				[self setNeedsDisplay: YES];
				break;
			case 'c':
				// toggle caps
				fDrawCaps = 1 - fDrawCaps;
				[self setNeedsDisplay: YES];
				break;
		}
	}
}

// ---------------------------------

- (void)mouseDown:(NSEvent *)theEvent // trackball
{
    if ([theEvent modifierFlags] & NSControlKeyMask) // send to pan
		[self rightMouseDown:theEvent];
	else if ([theEvent modifierFlags] & NSAlternateKeyMask) // send to dolly
		[self otherMouseDown:theEvent];
	else {
		NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		location.y = camera.viewHeight - location.y;
		gDolly = GL_FALSE; // no dolly
		gPan = GL_FALSE; // no pan
		gTrackball = GL_TRUE;
		startTrackball (location.x, location.y, 0, 0, camera.viewWidth, camera.viewHeight);
		gTrackingViewInfo = self;
	}
}

// ---------------------------------

- (void)rightMouseDown:(NSEvent *)theEvent // pan
{
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = camera.viewHeight - location.y;
	if (gTrackball) { // if we are currently tracking, end trackball
		if (gTrackBallRotation[0] != 0.0)
			addToRotationTrackball (gTrackBallRotation, worldRotation);
		gTrackBallRotation [0] = gTrackBallRotation [1] = gTrackBallRotation [2] = gTrackBallRotation [3] = 0.0f;
	}
	gDolly = GL_FALSE; // no dolly
	gPan = GL_TRUE;
	gTrackball = GL_FALSE; // no trackball
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
	gTrackingViewInfo = self;
}

// ---------------------------------

- (void)otherMouseDown:(NSEvent *)theEvent //dolly
{
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = camera.viewHeight - location.y;
	if (gTrackball) { // if we are currently tracking, end trackball
		if (gTrackBallRotation[0] != 0.0)
			addToRotationTrackball (gTrackBallRotation, worldRotation);
		gTrackBallRotation [0] = gTrackBallRotation [1] = gTrackBallRotation [2] = gTrackBallRotation [3] = 0.0f;
	}
	gDolly = GL_TRUE;
	gPan = GL_FALSE; // no pan
	gTrackball = GL_FALSE; // no trackball
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
	gTrackingViewInfo = self;
}

// ---------------------------------

- (void)mouseUp:(NSEvent *)theEvent
{
	if (gDolly) { // end dolly
		gDolly = GL_FALSE;
	} else if (gPan) { // end pan
		gPan = GL_FALSE;
	} else if (gTrackball) { // end trackball
		gTrackball = GL_FALSE;
		if (gTrackBallRotation[0] != 0.0)
			addToRotationTrackball (gTrackBallRotation, worldRotation);
		gTrackBallRotation [0] = gTrackBallRotation [1] = gTrackBallRotation [2] = gTrackBallRotation [3] = 0.0f;
	}
	gTrackingViewInfo = NULL;
}

// ---------------------------------

- (void)rightMouseUp:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

// ---------------------------------

- (void)otherMouseUp:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

// ---------------------------------

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = camera.viewHeight - location.y;
	if (gTrackball) {
		rollToTrackball (location.x, location.y, gTrackBallRotation);
		[self setNeedsDisplay: YES];
	} else if (gDolly) {
		[self mouseDolly: location];
		[self updateProjection];  // update projection matrix (not normally done on draw)
		[self setNeedsDisplay: YES];
	} else if (gPan) {
		[self mousePan: location];
		[self setNeedsDisplay: YES];
	}
}

// ---------------------------------

- (void)scrollWheel:(NSEvent *)theEvent
{
	float wheelDelta = [theEvent deltaX] +[theEvent deltaY] + [theEvent deltaZ];
	if (wheelDelta)
	{
		GLfloat deltaAperture = wheelDelta * -camera.aperture / 200.0f;
		camera.aperture += deltaAperture;
		if (camera.aperture < 0.1) // do not let aperture <= 0.1
			camera.aperture = 0.1;
		if (camera.aperture > 179.9) // do not let aperture >= 180
			camera.aperture = 179.9;
		[self updateProjection]; // update projection matrix
		[self setNeedsDisplay: YES];
	}
}

// ---------------------------------

- (void)rightMouseDragged:(NSEvent *)theEvent
{
	[self mouseDragged: theEvent];
}

// ---------------------------------

- (void)otherMouseDragged:(NSEvent *)theEvent
{
	[self mouseDragged: theEvent];
}

// ---------------------------------

- (void)drawRect:(NSRect)nrect
{
	// setup viewport and prespective
	[self resizeGL]; // forces projection matrix update (does test for size changes)
	[self updateModelView];  // update model view matrix for object
    
	// clear our drawable
	glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// model view and projection matricies already set
    
	//drawCube (1.5f); // draw scene
    [self drawImage];
    //if (fInfo)
		//[self drawInfo];
	if ([self inLiveResize] && !fAnimate)
		glFlush ();
	else
		[[self openGLContext] flushBuffer];
	//glReportError ();
}

// ---------------------------------

// set initial OpenGL state (current context is set)
// called after context is created
- (void) prepareOpenGL
{
    GLint swapInt = 1;
    
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval]; // set to vbl sync
    
	// init GL stuff here
	glEnable(GL_DEPTH_TEST);
	glShadeModel(GL_SMOOTH);
	//glEnable(GL_CULL_FACE);
	glFrontFace(GL_CCW);
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	[self resetCamera];
	shapeSize = 7.0f; // max radius of of objects
    
	// init fonts for use with strings
	NSFont * font =[NSFont fontWithName:@"Helvetica" size:12.0];
	//stanStringAttrib = [[NSMutableDictionary dictionary] retain];
	[stanStringAttrib setObject:font forKey:NSFontAttributeName];
	[stanStringAttrib setObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
	//[font release];
	
	// ensure strings are created
	//[self createHelpString];
	//[self createMessageString];
    
}
// ---------------------------------

// this can be a troublesome call to do anything heavyweight, as it is called on window moves, resizes, and display config changes.  So be
// careful of doing too much here.
- (void) update // window resizes, moves and display changes (resize, depth and display config change)
{
    //msgTime	= getElapsedTime ();
    //[msgStringTex setString:[NSString stringWithFormat:@"update at %0.1f secs", msgTime]  withAttributes:stanStringAttrib];
	[super update];
	//if (![self inLiveResize])  {// if not doing live resize
	//	[self updateInfoString]; // to get change in renderers will rebuld string every time (could test for early out)
	//	getCurrentCaps (); // this call checks to see if the current config changed in a reasonably lightweight way to prevent expensive re-allocations
	//}
}

// ---------------------------------

- (id)initWithFrame:(NSRect)frame
{
    NSOpenGLPixelFormat * pf = [BasicOpenGLView basicPixelFormat];
    self = [super initWithFrame:frame pixelFormat: pf];
    
    return self;
}
- (BOOL)acceptsFirstResponder
{
    return YES;
}

// ---------------------------------

- (BOOL)becomeFirstResponder
{
    return  YES;
}

// ---------------------------------

- (BOOL)resignFirstResponder
{
    return YES;
}

// ---------------------------------

- (void) awakeFromNib
{
	setStartTime (); // get app start time
	//getCurrentCaps (); // get current GL capabilites for all displays
	
	// set start values...
	rVel[0] = 0.3; rVel[1] = 0.1; rVel[2] = 0.2;
	rAccel[0] = 0.003; rAccel[1] = -0.005; rAccel[2] = 0.004;
	fInfo = 1;
	fAnimate = 0;
	time = CFAbsoluteTimeGetCurrent ();  // set animation time start time
	fDrawHelp = 1;
    
	// start animation timer
	timer = [NSTimer timerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(animationTimer:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode]; // ensure timer fires during resize
    
}

@end
