
//
//  Meteor.h
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@interface Meteor : CCSprite {
    CGFloat screenWidth,screenHeight;
}

@property double speed;

-(void)launch;

@end
