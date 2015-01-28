//
//  Tutorial.h
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@interface Tutorial : CCNode {
    dinosaur *_demoTrex, *_demoEnemy;
    Meteor *_demoMeteor;
    CCButton *_playButton;
    CCLabelTTF *_evilInstructions, *_demoDone;
    CCParticleSystem *_flame, *_flame1;
}

-(void) addPointsToScore: (int) points;

@end
