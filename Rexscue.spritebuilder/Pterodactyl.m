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
    
    self.isEnemy = false;
    
    self.hasMittens = [[NSUserDefaults standardUserDefaults]boolForKey:@"PterodactylMittens"];
    self.hasHat = [[NSUserDefaults standardUserDefaults]boolForKey:@"PterodactylHat"];
    
    //last sound is the panicking sound
    sounds = @[@"uhOh2.mp3", @"MeteorHit2.mp3",@"UhHahh.mp3", @"whyMe.mp3",@"run.mp3"];

    self.speed = 0.01; //default
    self.inAir =true; //default
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    
    if(self.hasMittens){
        [self putOnMittens];
    }
    else{
        self.isWearingTheirMittens = false;
    }
    
    if(self.hasHat){
        [self putOnHat];
    }
    else{
        self.isWearingTheirHat = false;
    }
}

-(NSString*) getType{
    return @"Pterodactyl";
}

-(void) die{
    self.physicsBody.collisionMask = @[];
    [self.animationManager runAnimationsForSequenceNamed:@"Dying"];

    [self scheduleOnce:@selector(dieHelper) delay:0];
    
    [self playHurtSound];

    [self scheduleOnce:@selector(removeFromParent) delay:2];
}

-(void) dieHelper{
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:2 position:ccp(0,-screenHeight+(1./2)*self.contentSize.height)];
    [self runAction:mover];
}


@end
