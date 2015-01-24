//
//  Raptor.m
//  dinogame
//
//  Created by Laura Breiman on 1/14/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "TRex.h"


@implementation TRex

-(void) didLoadFromCCB{
    [super didLoadFromCCB];

    self.levelMultiplier = 1;
    self.isEnemy = false;
    MAX_HEALTH = 100;
    self.health = MAX_HEALTH;
    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    self.attack = 10;
    self.speed = 0.02; //default
    ATTACK_THRESHOLD = 10; //number of pix between this dino and its attack target. e.g. some dinosaurs get closer than others to their enemy
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    self.attackCounter = 0;
    self.price = 200;
    self.killBonus = 10;
    
    [self setHealthLabel];
}

@end
