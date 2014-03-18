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

#include "Item.h"
#include "User.h"
#include "SectionArray.h"
typedef struct {
    GLdouble x,y,z;
} recVec;
@class ViewWindowController;

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
    
    //coding +
    
    
    
    //bool resHasChanged;
    //int resX_buf;
    //int resY_buf;
    
    //int histo_delai;
    //bool running;
    //bool guiEnabled;
    //int Rotation;
    
    NSImage *img;
    
    //GLuint textureGlobal;
    
    //NSMutableArray *items;
    //NSMutableArray *users;
    //
    //Item *infoSelectedItem;
    //Item *requestSelectedItem;
    //NSMutableArray *slectedItems;
    //NSMutableArray *requestItems;
    //NSMutableArray *itemsToDelete;
    
    //User *infoSelectedUser;
    //User *requestSelectedUser;
    //NSMutableArray *slectedUsers;
    //NSMutableArray *requestUsers;
    //NSMutableArray *usersToDelete;
    
    int colorClass[10][4];
    //int basic_it_number;//not use
    //int basic_poids_requete;//use in init_params
    //int basic_factorRepultion;//sức đẩy
    //int basic_nb_agent_touche_bord;//not use, nb agent key bord
    
    //in init_params
    //static float factorDesc[TAILLE_DESC];
    //static float factorDescTag[TAILLE_DESC_TAG];
    //static float rsDesc[TAILLE_DESC];
    //static float rsDescTag[TAILLE_DESC_TAG];
    
    //int basic_nb_to_reach;//use in trackbar
    //bool basic_nb_agent_changed;
    
    //int basic_nombre_voisins_min;//use in params
    //int basic_porte_minimum;//use in trackbar
    //int basic_porte_maximum;//use in trackbar
    
    //int basic_wander_force;//use in trackbar and params
    //int basic_inertie_attenuation;//use in trackbar and params
    
    //int basic_puissance_refoulement;//nt
    //int basic_puissance_refoulement_com;//nt
    
    //static int mode_global;//nt
    //static int mode_local;//nt
    //static int mode_requete;//nt
    //static int mode_structurel;//nt
    
    //static int epaisseur_rotative;//nt ->basicRotativeThickness
    
    //int puissance_rot;//nt
    //int nb_voisin_rot;//nt
    //int freq_voisin_rot;//nt
    //int disparite_rot;//nt
    
    //int basic_force_attraction_centre;//nt
    
    //bool basic_force_move;//no need
    
    //double basic_selection_nb;//nt
    
    //double basic_pourcentage_att_rep;//nt
    
    
    //int tailleXGrille; ->static int basicXGrille;
    //int tailleYGrille; ->static int basicYGrille;
    //list<Agent*>** grille;
    
    bool start;
    ViewWindowController *viewWindowController;
    __weak NSPathControl *_path;
}

+ (bool) basicResHasChanged; +(void) setBasicResHasChanged:(bool)value;
+ (int) resX_buf;            +(void) setResX_buf:(int)value;
+ (int) resY_buf;            +(void) setResY_buf:(int)value;

+ (int) histo_delai; +(void) set_histo_delai:(int)value;
+ (bool) running;
+ (bool) basicGuiEnabled;
+ (int) basicRotation;
+ (GLuint) basicTextureGlobal;

+ (NSMutableArray *) basicItems;
+ (NSMutableArray *) basicUsers;
//
+ (Item *) basicInfoSelectedItem;
+ (Item *)basicRequestSelectedItem;
+ (NSMutableArray *)basicSelectedItems;
+ (NSMutableArray *)basicRequestItems;
+ (NSMutableArray *)basicItemsToDelete;

+ (User *)basicInfoSelectedUser;
+ (User *)basicRequestSelectedUser;
+ (NSMutableArray *)basicSelectedUsers;
+ (NSMutableArray *)basicRequestUsers;
+ (NSMutableArray *)basicUsersToDelete;

+ (int) basicXGrille;
+ (int) basicYGrille;
+ (SectionArray *)basicGrille;
+ (double) basicSizeOfGrille;//cỡ lưới
+ (int) basic_it_number;//not use

+ (int) basicResX;
+ (int) basicResY;
+ (void) setBasicResX:(int)value;
+ (void) setBasicResY:(int)value;
+ (int) numberOfAgents;
+ (int) basic_poids_requete;//use in init_params
+ (int) basic_factorRepultion;//sức đẩy
+ (int) basic_nb_agent_touche_bord;
//in init_params
+ (NSMutableArray *) basicFactorDesc;
+ (NSMutableArray *) basicFactorDescTag;
+ (NSMutableArray *) basicrsDesc;
+ (NSMutableArray *) basicrsDescTag;

+ (int) basic_nb_to_reach;//use in trackbar
+ (bool) basic_nb_agent_changed;

+ (int) basic_nombre_voisins_min;//use in params
+ (int) basic_porte_minimum;//use in trackbar
+ (int) basic_porte_maximum;//use in trackbar

+ (int) basic_wander_force;//use in trackbar and params
+ (int) basic_inertie_attenuation;//use in trackbar and params

+ (int) basic_puissance_refoulement;//nt
+ (int) basic_puissance_refoulement_com;//nt
+ (int) basic_mode_global;//nt
+ (int) basic_mode_local;//nt
+ (int) basic_mode_requete;//nt
+ (int) basic_mode_structurel;//nt
//độ dày của vòng quay
+ (int) basicRotativeThickness;//nt

+ (int) basic_puissance_rot;//nt
+ (int) basic_nb_voisin_rot;//nt
+ (int) basic_freq_voisin_rot;//nt
+ (int) basic_disparite_rot;//nt

+ (int) basic_force_attraction_centre;//nt

+ (bool) basic_force_move;//no need

+ (double) basic_selection_nb;//nt

+ (double) basic_pourcentage_att_rep;//nt


- (IBAction)test:(id)sender;
- (IBAction)selectPath:(id)sender;
- (IBAction)start:(id)sender;
- (GLuint)loadTexture:(NSString*)name;
@property (weak) IBOutlet NSPathControl *path;
@end
