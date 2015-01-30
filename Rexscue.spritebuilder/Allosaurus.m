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
    
    self.hasMittens = [[NSUserDefaults standardUserDefaults]boolForKey:@"AllosaurusMittens"];
    self.hasHat = [[NSUserDefaults standardUserDefaults]boolForKey:@"AllosaurusHat"];
    self.isEnemy = false;
    
    //last sound is the panicking sound
    sounds = @[@"oohh.mp3", @"ohhhh.mp3",@"MeteorHit4.mp3", @"ooh.mp3",@"ow.mp3",@"aaaah.mp3"];
    
    self.speed = 0.01; //default
    self.readyToAttack = true;
    self.afterAttackDelay = 50;
    self.attackCounter = 0;
        
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
    return @"Allosaurus";
}


@end
