//
//  dinosaur.h
//  dinogame
//
//  Created by Laura Breiman on 1/7/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface dinosaur : CCSprite {
    int ATTACK_THRESHOLD;
    int KNOCKBACK_THRESHOLD;
    int MAX_HEALTH; //maximum health
    CCLabelTTF *_healthLabel;
    CGFloat screenWidth,screenHeight;
}

-(void) didLoadFromCCB;
-(void) moveDinoForward;
-(void) moveDinoBackward;
-(Boolean) collidesWith:(dinosaur *)enemyDino;
-(void) attackDino:(dinosaur *)enemyDino;
-(Boolean) attackedByDino:(dinosaur *)enemyDino;
-(void) knockback;
-(void) die;
-(Boolean) isEnemyNest;
-(void) reverseHealthLabel;
-(void) changeLevelMultiplier: (double) newMultiplier;
-(void) setHealthLabel;
-(void) reverseDinoDirection;
-(void) setHealthInvisible;
-(Boolean) hitByMeteor;
-(void) knockforward;

@property float health;
@property double speed;
@property float attack;
@property Boolean inAir;
@property Boolean readyToAttack;
@property Boolean isEnemy;
@property Boolean isStationary;
@property int attackCounter;
@property int killBonus;
@property int afterAttackDelay; //how many frames the dino waits between attacks
@property int price;
@property double levelMultiplier;
@property int direction;
@property int turnWait;
@end
