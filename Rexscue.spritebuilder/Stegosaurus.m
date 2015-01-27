//
//  Stegosaurus.m
//  dinogame
//
//  Created by Laura Breiman on 1/20/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Stegosaurus.h"


@implementation Stegosaurus

-(void) didLoadFromCCB{
    [super didLoadFromCCB];

    self.levelMultiplier = 1;
    self.isEnemy = false;
    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    self.speed = 0.02; //default
    ATTACK_THRESHOLD = 10; //number of pix between this dino and its attack target. e.g. some dinosaurs get closer than others to their enemy
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
    self.attackCounter = 0;
    self.price = 200;
    self.hasSpikes = true;
    
    [self setHealthLabel];
}

-(void) loseSpikes{
    [self.animationManager runAnimationsForSequenceNamed:@"SpikeOff"];
    _darkSpikes.visible = false;
    _brightSpikes.visible = false;
    self.hasSpikes = false;
    self.health -= MAX_HEALTH/2.;
    [self setHealthLabel];
}

-(void) knockback{
    int knockbackAmount = self.contentSize.width;
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp(-knockbackAmount,0)];
    [self runAction:mover];
    [self.animationManager runAnimationsForSequenceNamed:@"SpikeOff"];
}

-(void) knockforward{
    int knockbackAmount = self.contentSize.width;
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp(knockbackAmount,0)];
    [self runAction:mover];
    [self.animationManager runAnimationsForSequenceNamed:@"SpikeOff"];
}


-(Boolean) hitByMeteor{
    if(self.hasSpikes){
        [self loseSpikes];
        return false;
    }
    else{
        [self die];
        return true;
    }
}

-(Boolean) attackedByDino:(dinosaur *)otherDino{
    [otherDino.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    otherDino.readyToAttack = false;
    
    if(self.direction == 0 && otherDino.position.x > self.position.x){
        [self knockback];
    }
    else if(self.direction == 0 && otherDino.position.x < self.position.x){
        [self knockforward];
    }
    else if(self.direction == 1 && otherDino.position.x > self.position.x){
        [self knockback];
    }
    else if(self.direction == 1 && otherDino.position.x < self.position.x){
        [self knockforward];
    }
    
    if(self.hasSpikes){
        [self loseSpikes];
    }
    else{
        [self die];
        return true;
    }
    return false;
}

@end
