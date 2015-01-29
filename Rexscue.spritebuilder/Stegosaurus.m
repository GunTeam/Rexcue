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
    
    self.hasMittens = [[NSUserDefaults standardUserDefaults]boolForKey:@"StegosaurusMittens"];
    self.hasHat = [[NSUserDefaults standardUserDefaults]boolForKey:@"StegosaurusHat"];
    
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
    
    //last sound is the panicking sound
    sounds = @[@"WhaOh2.mp3", @"MeteorHit.mp3",@"huh.mp3", @"whaaaat.mp3",@"ooooh.mp3"];
    
    [self setHealthLabel];
    
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
    return @"Stegosaurus";
}

-(void) loseSpikes{
    [self playHurtSound];
    
    [self.animationManager runAnimationsForSequenceNamed:@"SpikeOff"];
    _spikes.cascadeOpacityEnabled = true;
    [_spikes runAction:[CCActionFadeOut actionWithDuration:1]];
    _spikes1.cascadeOpacityEnabled = true;
    [_spikes1 runAction:[CCActionFadeOut actionWithDuration:1]];
    [self scheduleOnce:@selector(invisibleSpikes) delay:1];
    self.hasSpikes = false;
}

-(void) invisibleSpikes{
    _spikes.visible = false;
    _spikes1.visible = false;
}

-(void) knockback{
    int knockbackAmount = self.contentSize.width;
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp(-(0.5)*knockbackAmount,0)];
    [self runAction:mover];
    [self.animationManager runAnimationsForSequenceNamed:@"SpikeOff"];
}

-(void) knockforward{
    int knockbackAmount = self.contentSize.width;
    
    CCActionMoveBy *mover = [CCActionMoveBy actionWithDuration:1 position:ccp((0.5)*knockbackAmount,0)];
    [self runAction:mover];
    [self.animationManager runAnimationsForSequenceNamed:@"SpikeOff"];
}


-(Boolean) hurt{
    if(self.isWearingTheirHat){
        [self loseHat];
        return false;
    }
    else if(self.isWearingTheirMittens){
        [self loseMittens];
        return false;
    }
    else if(self.hasSpikes){
        [self loseSpikes];
        return false;
    }
    else{
        [self die];
        return true;
    }

//    if(self.hasSpikes){
//        [self loseSpikes];
//        return false;
//    }
//    else{
//        [self die];
//        return true;
//    }
}

-(Boolean) attackedByDino:(dinosaur *)otherDino{
    [otherDino.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    [otherDino playAttackSound];
    otherDino.readyToAttack = false;
    
    self.health -= MAX_HEALTH/2.;
    [self setHealthLabel];
    
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
    
    if(self.health <= 0){
        return [self hurt];
    }
    
    return false;
}

@end
