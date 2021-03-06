//
//  dinosaur.h
//  dinogame
//
//  Created by Laura Breiman on 1/7/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectAL.h"
#import "Explosion.h"
#import "Smoke.h"

@interface dinosaur : CCSprite {
    int MAX_HEALTH; //maximum health
    CGFloat screenWidth,screenHeight;
    OALSimpleAudio *audioPlayer;
    NSArray *sounds;
    NSArray *evilSounds;
    Boolean soundsOn;
    CCNode *_frontMitten, *_backMitten, *_hat;
    CCParticleSystem *_enemyParticles;
}

-(void) didLoadFromCCB;
-(void) moveDinoForward;
-(void) moveDinoBackward;
-(void) attackDino:(dinosaur *)enemyDino;
-(Boolean) attackedByDino:(dinosaur *)enemyDino;
-(void) knockback;
-(void) die;
-(Boolean) hurt;
-(void) knockforward;
-(void) panic;
-(void) playAttackSound;
-(void) playHurtSound;
-(void) putOnMittens;
-(void) putOnHat;
-(void) loseHat;
-(void) loseMittens;
-(NSString*) getType;

@property float health;
@property double speed;
@property float attack;
@property Boolean inAir;
@property Boolean readyToAttack;
@property Boolean isEnemy;
@property Boolean isStationary;
@property Boolean isDead;
@property int attackCounter;
@property int killBonus;
@property int afterAttackDelay; //how many frames the dino waits between attacks
@property int direction;
@property int turnWait;
@property Boolean hasMittens;
@property Boolean hasHat;
@property Boolean isWearingTheirMittens;
@property Boolean isWearingTheirHat;
@property int tapsToKillEnemy;

@end
