//
//  GameSprite.h
//  Arkanoid
//
//  Created by Arcilite on 31.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameSprite : NSObject

- (id)initWithTexture:(GLKTextureInfo *)textureInfo effect:(GLKBaseEffect *)effect;
- (id)initWithImage:(UIImage *)image effect:(GLKBaseEffect *)effect;
- (void)render;
- (void)update:(float)dt;
- (CGRect)boundingRect;

@property (assign) GLKVector2 position;
@property (assign) CGSize contentSize;
@property (assign) GLKVector2 moveVelocity; // points/sec
@property (assign) float rotation;
@property (assign) float rotationVelocity; // degrees/sec

@end
