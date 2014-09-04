//
//  GameManager.h
//  Arkanoid
//
//  Created by Arcilite on 31.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameSprite.h"

typedef NS_ENUM(NSInteger, GameState) {
    GameStateNone = 0,
    GameStateLose,
    GameStateWon
};

@interface GameManager : NSObject

@property (strong, nonatomic) GameSprite *playerBat;
@property (strong, nonatomic) GameSprite *ball;

@property (strong, nonatomic) NSMutableArray *bricks;
@property (strong, nonatomic) GLKTextureInfo *bgTextureInfo;

@property (assign) GameState gameState;
@property (assign) BOOL isGameRunning;

-(id)initWithEffect:(GLKBaseEffect*)effect;

- (void)startGame;

- (void)changeDirectionIfBallGoOutOfBouds:(CGRect)bounds;

- (void)changeDirectionIfBallPunchPlayerBat;

- (void)changeDirectionIfBallPunchPlayerBricks;

@end
