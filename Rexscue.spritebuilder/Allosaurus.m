//
//  Allosaurus.m
//  dinogame
//
//  Created by Laura Breiman on 1/12/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Allosaurus.h"


@implementation Allosaurus

-(void) didLoadFromCCB{
    [super didLoadFromCCB];

    self.levelMultiplier = 1;
    self.isEnemy = false;
    
    //last sound is the panicking sound
    sounds = @[@"oohh.mp3", @"ohhhh.mp3",@"MeteorHit4.mp3", @"ooh.mp3",@"ow.mp3",@"aaaah.mp3"];
    
    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    self.speed = 0.01; //default
    ATTACK_THRESHOLD = 10; //number of pix between this dino and its attack target. e.g. some dinosaurs get closer than others to their enemy
    self.readyToAttack = true;
    self.afterAttackDelay = 50;
    self.attackCounter = 0;
    self.price = 200;
    
    [self setHealthLabel];
}


@end
