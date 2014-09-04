//
//  Helper.m
//  Arkanoid
//
//  Created by Arcilite on 04.09.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(BOOL) getYesOrNo{
    
    int tmp = (arc4random() % 30)+1;
    if(tmp % 5 == 0)
        return YES;
    return NO;

}

@end
