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
    
    self.hasMittens = [[NSUserDefaults standardUserDefaults]boolForKey:@"TrexMittens"];
    self.hasHat = [[NSUserDefaults standardUserDefaults]boolForKey:@"TrexHat"];
    //last sound is the panicking sound
    sounds = @[@"help.mp3", @"owAndStuff.mp3",@"WhaOh.mp3",@"ImPanicking2.mp3"];
    
    self.isEnemy = false;
    self.speed = 0.02; //default
    self.readyToAttack = true;
    self.afterAttackDelay = 60;
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
    return @"Trex";
}

@end
