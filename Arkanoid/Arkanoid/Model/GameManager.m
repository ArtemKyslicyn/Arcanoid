//
//  GameManager.m
//  Arkanoid
//
//  Created by Arcilite on 31.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "GameManager.h"
@interface GameManager()
@property (strong, nonatomic) GLKBaseEffect *effect;
@end

@implementation GameManager

-(id)initWithEffect:(GLKBaseEffect*)effect{
    
    self = [super init];
    
    if (self) {
        _effect = effect;
    }
    
    return self;
}


-(GameSprite*)playerBat{
    
    if (!_playerBat) {
      
         _playerBat = [[GameSprite alloc] initWithImage:[UIImage imageNamed:@"BlackRectangle"] effect:self.effect];
         self.playerBat.position = GLKVector2Make(160, 35);
        
    }
    
    return _playerBat;
}

-(GameSprite*)ball{
    if (!_ball) {
        
        _ball = [[GameSprite alloc] initWithImage:[UIImage imageNamed:@"ball1"] effect:self.effect];
        _ball.position = GLKVector2Make(160, 80);
        _ball.rotationVelocity = 180.f;
    
    }
    return _ball;
}


- (void)startGame{
    [self createBricksSprites];
	self.isGameRunning = YES;
	self.gameState = GameStateNone;
    
    self.ball.position = GLKVector2Make(160, 80);
	self.ball.moveVelocity = GLKVector2Make(120, 240);

}

-(void)changeDirectionIfBallGoOutOfBouds:(CGRect)bounds{
    
    if (self.ball.boundingRect.origin.x <= bounds.origin.x)
	{
		self.ball.moveVelocity = GLKVector2Make(-self.ball.moveVelocity.x, self.ball.moveVelocity.y);
		self.ball.position = GLKVector2Make(self.ball.position.x - self.ball.boundingRect.origin.x, self.ball.position.y);
	}
    
	// right
	if (self.ball.boundingRect.origin.x + self.ball.boundingRect.size.width >= bounds.size.width)
	{
		self.ball.moveVelocity = GLKVector2Make(-self.ball.moveVelocity.x, self.ball.moveVelocity.y);
		self.ball.position = GLKVector2Make(self.ball.position.x - (self.ball.boundingRect.size.width + self.ball.boundingRect.origin.x - 320), self.ball.position.y);
	
    }
	// top
	if (self.ball.boundingRect.origin.y + self.ball.boundingRect.size.height >= bounds.size.height)
	{
		self.ball.moveVelocity = GLKVector2Make(self.ball.moveVelocity.x, - self.ball.moveVelocity.y);
		self.ball.position = GLKVector2Make(self.ball.position.x,self.ball.position.y - (self.ball.boundingRect.origin.y + self.ball.boundingRect.size.height - 480));
	}
    
    if (self.ball.boundingRect.origin.y + self.ball.boundingRect.size.height <= 70)
	{
		[self endGameWithWin:NO];
	}
    
}

-(void)changeDirectionIfBallPunchPlayerBat{
    
    if (CGRectIntersectsRect(self.ball.boundingRect, self.playerBat.boundingRect))
	{
		float angleCoef = (self.ball.position.x - self.playerBat.position.x) / (self.playerBat.contentSize.width / 2);
		float newAngle = 90.f - angleCoef * 80.f;
		
        GLKVector2 ballDirection = GLKVector2Normalize(GLKVector2Make(1 / tanf(GLKMathDegreesToRadians(newAngle)), 1));
		
        float ballSpeed = GLKVector2Length(self.ball.moveVelocity);
		
        self.ball.moveVelocity = GLKVector2MultiplyScalar(ballDirection, ballSpeed);
		
        self.ball.position = GLKVector2Make(self.ball.position.x, self.ball.position.y + (self.playerBat.boundingRect.origin.y + self.playerBat.boundingRect.size.height - self.ball.boundingRect.origin.y));
	}
}

-(void)changeDirectionIfBallPunchPlayerBricks{
    NSMutableArray *brokenBricks = [NSMutableArray array];
	GLKVector2 initialBallVelocity = self.ball.moveVelocity;
	for (GameSprite *brick in self.bricks)
	{
        if (CGRectIntersectsRect(self.ball.boundingRect, brick.boundingRect))
		{
			[brokenBricks addObject: brick];
			if ((self.ball.position.y < brick.position.y - brick.contentSize.height / 2) || (self.ball.position.y > brick.position.y + brick.contentSize.height / 2))
			{
				self.ball.moveVelocity = GLKVector2Make(initialBallVelocity.x, -initialBallVelocity.y);
			}
			else
			{
				self.ball.moveVelocity = GLKVector2Make(-initialBallVelocity.x, initialBallVelocity.y);
			}
		}
    }
	
	// removing them
	for (GameSprite *brick in brokenBricks)
	{
		[self.bricks removeObject:brick];
	}
    
   
    
    if (self.bricks.count == 0) {
        [self endGameWithWin:YES];
    }
    
   
}

- (void)createBricksSprites
{

	NSError *error;
    
    NSMutableArray *loadedBricks = [NSMutableArray array];
	
    UIImage *brickImage = [UIImage imageNamed:@"brick1"];
    
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
	GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:brickImage.CGImage options:options error:&error];
	if (textureInfo == nil)
	{
		NSLog(@"Error loading image: %@", [error localizedDescription]);
		return;
	}
    
	for (int i = 0; i < 6; i++)
	{
		for (int j = 0; j < 6; j++)
		{
			if ([Helper getYesOrNo])
			{
				GameSprite *brickSprite = [[GameSprite alloc] initWithTexture:textureInfo effect:self.effect];
				brickSprite.position = GLKVector2Make((j + 1) * 50.f - 15.f, 480.f - (i + 1) * 10.f - 15.f);
				[loadedBricks addObject:brickSprite];
			}
		}
	}
	self.bricks = loadedBricks;
}

- (void)endGameWithWin:(BOOL)win
{
	self.isGameRunning = NO;
	self.gameState = win ? GameStateWon : GameStateLose;
}

@end
