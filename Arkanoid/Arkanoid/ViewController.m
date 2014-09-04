//
//  ViewController.m
//  Arkanoid
//
//  Created by Arcilite on 29.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "ViewController.h"
#import "GameManager.h"
#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)
#define RANDOM_FLOAT_BETWEEN(x, y) (((float) rand() / RAND_MAX) * (y - x) + x)

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};



@interface ViewController () {
    
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) GameManager *gameManager;

- (void)setupGL;
- (void)tearDownGL;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    [self setupGL];
   
    [self setupGesturesRecognition];
    
    [self setupGameManager];
}




- (void)setupGL
{
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];

    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, [[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.height, -1024, 1024);
	self.effect.transform.projectionMatrix = projectionMatrix;


}

-(void)setupGesturesRecognition{
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureFrom:)];
	[self.view addGestureRecognizer:panRecognizer];
	[self.view addGestureRecognizer:tapRecognizer];
    
}

-(void)setupGameManager{
    
    _gameManager = [[GameManager alloc] initWithEffect:self.effect];
    self.gameManager.ball.position = GLKVector2Make(160, 30);

}


#pragma mark - GLKView and GLKViewController delegate methods

- (void)update{
    
    [self.gameManager changeDirectionIfBallGoOutOfBouds:  [[UIScreen mainScreen] bounds]];
    [self.gameManager changeDirectionIfBallPunchPlayerBat];
    [self.gameManager changeDirectionIfBallPunchPlayerBricks];
    [self.gameManager.playerBat update:self.timeSinceLastUpdate];
    [self.gameManager.ball update:self.timeSinceLastUpdate];
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(1.f, 1.f, 1.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
      
    [self.gameManager.ball render];
    [self.gameManager.playerBat render];
    
    for (GameSprite *brick in self.gameManager.bricks){
		[brick render];
	}
}


#pragma mark - gesture Actions
- (void)handleTapGestureFrom:(UITapGestureRecognizer *)recognizer{
    
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
	if (self.gameManager.isGameRunning)
	{
		GLKVector2 target = GLKVector2Make(touchLocation.x, self.gameManager.playerBat.position.y);
		self.gameManager.playerBat.position = target;
	}
	else {
		[self.gameManager startGame];
	}
}

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer{
    
	CGPoint touchLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
//    if (self.gameRunning)
//	{
		GLKVector2 target = GLKVector2Make(touchLocation.x, self.gameManager.playerBat.position.y);
        self.gameManager.playerBat.position = target;
//	}
}


- (void)dealloc{
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)tearDownGL{
    
   [EAGLContext setCurrentContext:self.context];
    self.effect = nil;
}

@end
