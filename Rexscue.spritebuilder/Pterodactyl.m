//
//  Pterodactyl.m
//  dinogame
//
//  Created by Laura Breiman on 1/12/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Pterodactyl.h"


@implementation Pterodactyl

-(void) didLoadFromCCB{
    [super didLoadFromCCB];
    
    self.levelMultiplier = 1;
    self.isEnemy = false;
    
    //last sound is the panicking sound
    sounds = @[@"uhOh2.mp3", @"MeteorHit2.mp3",@"UhHahh.mp3", @"whyMe.mp3",@"run.mp3"];

    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    self.speed = 0.01; //default
    self.inAir =true; //default
    ATTACK_THRESHOLD = 0; //number of pix between this dino and its attack target. ptero attacks right over it
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    self.price = 200;
    
    [self setHealthLabel];
}

-(void) die{
    self.physicsBody.collisionMask = @[];
    [self.animationManager runAnimationsForSequenceNamed:@"Dying"];
    CCActionMoveBy *stringMover = [CCActionMoveBy actionWithDuration:2 position:ccp(0,screenHeight-(1./2)*self.contentSize.height)];
    [_leftString runAction:stringMover];
    [_rightString runAction:stringMover];

    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:2 position:ccp(0,-screenHeight+(1./2)*self.contentSize.height)];
    [self runAction:mover];
    
    int randomSound = arc4random()%(sounds.count-1);
    
    [audioPlayer playEffect:[sounds objectAtIndex:randomSound]];

    [self scheduleOnce:@selector(removeFromParent) delay:2];
}


@end
