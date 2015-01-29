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
    numNeedles = [[NSUserDefaults standardUserDefaults] integerForKey:@"NumNeedles"];
    mittenPrice = 100;
    hatPrice = 200;
    needleUpgradePrice = 300;
    
    [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];
    
    if(numNeedles > 10){
        _playMorePrompt.visible = false;
    }
    
    ourdinos = @[_stegosaurus,_pterodactyl,_allosaurus,_trex,_triceratops];
    for (dinosaur *dino in ourdinos){
        [dino setIsStationary:true];
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
        [dino setHealthInvisible];
        _selector.visible = false;
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
}
-(void) mittenUpgrade{
    _selector.position = _mittenButton.position;
    _selector.visible = true;
}
-(void) hatUpgrade{
    _selector.position = _hatButton.position;
    _selector.visible = true;
}
-(void) needleUpgrade{
    _selector.position = _needleButton.position;
    _selector.visible = true;
}

-(void) pteroUpgrade{
    _selector.position = _pteroButton.position;
    _selector.visible = true;
}
-(void) alloUpgrade{
    _selector.position = _alloButton.position;
    _selector.visible = true;
}
-(void) stegoUpgrade{
    _selector.position = _stegoButton.position;
    _selector.visible = true;
}
-(void) trexUpgrade{
    _selector.position = _trexButton.position;
    _selector.visible = true;
}
-(void) tricUpgrade{
    _selector.position = _tricButton.position;
    _selector.visible = true;
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

@end
