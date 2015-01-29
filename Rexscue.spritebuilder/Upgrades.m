//
//  Upgrades.m
//  Rexscue
//
//  Created by Anna Neuman on 1/28/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Upgrades.h"


@implementation Upgrades
-(void) didLoadFromCCB{
    ourdinos = @[_stegosaurus,_pterodactyl,_allosaurus,_trex,_triceratops];
    for (dinosaur *dino in ourdinos){
        [dino panic];
        [dino setHealthInvisible];
        _selector.visible = false;
        
    }
}
-(void) mittenUpgrade{
    _selector.position = mittenUpgrade.position;
    _selector.visible = true;
}
-(void) hatUpgrade{
    _selector.position = hatUpgrade.position;
    _selector.visible = true;
}
-(void) needleUpgrade{
    _selector.position = needleUpgrade.position;
    _selector.visible = true;
}

-(void) pteroUpgrade{
    _selector.position = pteroUpgrade.position;
    _selector.visible = true;
}
-(void) alloUpgrade{
    _selector.position = alloUpgrade.position;
    _selector.visible = true;
}
-(void) stegoUpgrade{
    _selector.position = stegoUpgrade.position;
    _selector.visible = true;
}
-(void) trexUpgrade{
    _selector.position = trexUpgrade.position;
    _selector.visible = true;
}
-(void) tricUpgrade{
    _selector.position = tricUpgrade.position;
    _selector.visible = true;
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

@end
