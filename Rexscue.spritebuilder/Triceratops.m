//
//  Triceratops.m
//  dinogame
//
//  Created by Laura Breiman on 1/12/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Triceratops.h"


@implementation Triceratops

-(void) didLoadFromCCB{
    [super didLoadFromCCB];

    self.hasMittens = [[NSUserDefaults standardUserDefaults]boolForKey:@"TriceratopsMittens"];
    self.hasHat = [[NSUserDefaults standardUserDefaults]boolForKey:@"TriceratopsHat"];

    self.levelMultiplier = 1;
    self.isEnemy = false;
    
    //last sound is the panicking sound
    sounds = @[@"uhOh.mp3",@"ohhh.mp3", @"awMan.mp3",@"uhOhGuys.mp3"];

    KNOCKBACK_THRESHOLD = MAX_HEALTH/2; //point at which the dino gets knocked back
    self.speed = 0.01; //default
    ATTACK_THRESHOLD = 5; //number of pix between this dino and its attack target. e.g. some dinosaurs get closer than others to their enemy
    self.readyToAttack = true;
    self.afterAttackDelay = 70;
    self.attackCounter = 0;
    self.price = 200;
    
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
    return @"Triceratops";
}

@end
