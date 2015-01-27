//
//  Menu.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Menu.h"


@implementation Menu
@synthesize soundEffectsOn, musicOn;

-(void) didLoadFromCCB{
    self.soundEffectsOn = true;
    self.musicOn = true;
}

-(void) toggleSoundEffects{
    if(self.soundEffectsOn){
        self.soundEffectsOn = false;
        [_toggleSoundButton setTitle:@"Effects On"];
    }
    else{
        self.soundEffectsOn = true;
        [_toggleSoundButton setTitle:@"Effects Off"];
    }
}

-(void) toggleMusic{
    if(self.musicOn){
        self.musicOn = false;
        [_toggleMusicButton setTitle:@"Music On"];
    }
    else{
        self.musicOn = true;
        [_toggleMusicButton setTitle:@"Music Off"];
    }
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}


@end
