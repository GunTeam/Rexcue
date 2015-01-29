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
    int NUM_STARTING_DINOS, SECONDS_TO_LEVEL_UPDATE,PROBABILITY_OF_ENEMY_SPAWN, numBackgroundsToFade,meteorsToSpawnAtOnce,backgroundIndex, meteorIndex;
    CCLabelTTF *_scoreLabel, *_levelLabel, *_timeLabel;
    CCParticleSystem *_volcanoSmoke;
    NSMutableArray *ourDinos;
    OALAudioTrack *musicPlayer;
    CCNode *_background1,*_background2,*_background3,*_background4,*_background5,*_background6;
    NSArray *backgrounds;
    
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
@property Boolean sandboxMode;
@property double meteorScale;
@property int multiplier;

@end
