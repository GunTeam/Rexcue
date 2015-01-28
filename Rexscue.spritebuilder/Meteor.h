
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
#import "DisappearingLabel.h"

@interface Meteor : CCSprite {
    CGFloat screenWidth,screenHeight;
    OALSimpleAudio *audioPlayer;
    Boolean soundsOn;
}

@property Boolean isDemo;
@property double speed;

-(void)launch;

@end
