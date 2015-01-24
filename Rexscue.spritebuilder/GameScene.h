//
//  GameScene.h
//  Rexscue
//
//  Created by Laura Breiman on 1/24/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Meteor.h"

@interface GameScene : CCNode {
    CGFloat screenWidth,screenHeight;
    CCPhysicsNode *_physicsNode;
}

@end
