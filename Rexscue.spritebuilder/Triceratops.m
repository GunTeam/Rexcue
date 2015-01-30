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

    self.isEnemy = false;
    //last sound is the panicking sound
    sounds = @[@"uhOh.mp3",@"ohhh.mp3", @"awMan.mp3",@"uhOhGuys.mp3"];
    self.speed = 0.01; //default
    self.readyToAttack = true;
    self.afterAttackDelay = 70;
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
    return @"Triceratops";
}

@end
