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
    
    //last sound is the panicking sound
    sounds = @[@"help.mp3", @"owAndStuff.mp3",@"WhaOh.mp3",@"ImPanicking2.mp3"];
    
    self.levelMultiplier = 1;
    self.isEnemy = false;

    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    self.speed = 0.02; //default
    ATTACK_THRESHOLD = 10; //number of pix between this dino and its attack target. e.g. some dinosaurs get closer than others to their enemy
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    self.attackCounter = 0;
    self.price = 200;
    
    [self setHealthLabel];
}

@end
