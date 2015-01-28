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
#import "dinosaur.h"
#import "TRex.h"
#import "Stegosaurus.h"
#import "Triceratops.h"
#import "Allosaurus.h"
#import "Pterodactyl.h"
#import "MainScene.h"
#import "Smoke.h"
#import "Explosion.h"
#import "ObjectAL.h"

@interface GameScene : CCNode <CCPhysicsCollisionDelegate>{
    CGFloat screenWidth,screenHeight;
    CCPhysicsNode *_physicsNode;
    CCNodeColor *_ground;
    int NUM_STARTING_DINOS, SECONDS_TO_LEVEL_UPDATE;
    CCLabelTTF *_scoreLabel, *_levelLabel, *_timeLabel;
    CCParticleSystem *_volcanoSmoke;
    NSMutableArray *ourDinos;
    OALAudioTrack *musicPlayer;
    int meteorsToSpawnAtOnce;
}

-(void) addPointsToScore: (int) points;

@property int score;
@property int meteorSpeed;
@property int timeElapsed;
@property int numDinos;
@property int level;
@property int meteorHittingGroundBonus;
@property double secondsBetweenMeteors;
@property Boolean soundEffectsOn;
@property double meteorScale;

@end
