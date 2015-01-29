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
    mittenPrice = 40;
    hatPrice = 200;
    needleUpgradePrice = 300;
    
    [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];
    
    if(numNeedles > 10){
        _playMorePrompt.visible = false;
    }
    
    mittenSelected = false;
    hatSelected = false;
    
    [_mittenPriceLabel setString:[NSString stringWithFormat:@"Price: %i Needles", mittenPrice]];
    [_hatPriceLabel setString:[NSString stringWithFormat:@"Price: %i Needles", hatPrice]];
  
    ourdinos = @[_stegosaurus,_pterodactyl,_allosaurus,_trex,_triceratops];
    for (dinosaur *dino in ourdinos){
        [dino setIsStationary:true];
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
        [dino setHealthInvisible];
//        dino.visible = false;
    }
    _needleButton.visible = false;
    _needleDescription.visible = false;
    
    _selector.visible = false;
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
}
-(void) mittenUpgrade{
    if(numNeedles > mittenPrice){
        _selector.position = _mittenButton.position;
        _selector.visible = true;
        for (dinosaur *dino in ourdinos){
            dino.visible = true;
        }
        _upgradePrompt.visible = true;
        
        mittenSelected = true;
        hatSelected = false;
    }
    else{
        _playMorePrompt.visible = true;
        CCAction *animation1 = [CCActionScaleTo actionWithDuration:0.5 scale:1.5];
        CCAction *animation2 = [CCActionScaleTo actionWithDuration:0.5 scale:1];
        
        [_playMorePrompt runAction:[CCActionSequence actionWithArray:@[animation1, animation2]]];
    }
    
}
-(void) hatUpgrade{
    if(numNeedles > hatPrice){
        _selector.position = _hatButton.position;
        _selector.visible = true;
        for (dinosaur *dino in ourdinos){
            dino.visible = true;
        }
        _upgradePrompt.visible = true;
        
        mittenSelected = false;
        hatSelected = true;
    }
    else{
        _playMorePrompt.visible = true;
        CCAction *animation1 = [CCActionScaleTo actionWithDuration:0.5 scale:1.5];
        CCAction *animation2 = [CCActionScaleTo actionWithDuration:0.5 scale:1];
        
        [_playMorePrompt runAction:[CCActionSequence actionWithArray:@[animation1, animation2]]];
    }

}

//-(void) needleUpgrade{
//    _selector.position = _needleButton.position;
//    _selector.visible = true;
//    
//    for (dinosaur *dino in ourdinos){
//        dino.visible = false;
//    }
//    _upgradePrompt.visible = false;
//}

-(void) buyMittensForDino: (NSString*)dino{
    NSString *key = [NSString stringWithFormat:@"%@Mittens", dino];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:key];
    
    numNeedles -= mittenPrice;
    [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];

    [[NSUserDefaults standardUserDefaults] setInteger:numNeedles forKey:@"NumNeedles"];
    mittenSelected = false;
    
    for (dinosaur *whichDino in ourdinos){
        NSString *dinoType = [whichDino getType];
        if([dino isEqualToString:dinoType]){
            [whichDino putOnMittens];
        }
    }

}

-(void) buyHatForDino: (NSString*)dino{
    NSString *key = [NSString stringWithFormat:@"%@Hat", dino];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:key];
    
    numNeedles -= hatPrice;
    [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];
    
    [[NSUserDefaults standardUserDefaults] setInteger:numNeedles forKey:@"NumNeedles"];
    hatSelected = false;
    
    for (dinosaur *whichDino in ourdinos){
        NSString *dinoType = [whichDino getType];
        if([dino isEqualToString:dinoType]){
            [whichDino putOnHat];
        }
    }

}

-(void) pteroUpgrade{
    if(mittenSelected){
        [self buyMittensForDino:@"Pterodactyl"];
    }
    else if(hatSelected){
        [self buyHatForDino:@"Pterodactyl"];
    }
}

-(void) alloUpgrade{
    if(mittenSelected){
        
    }
    else if(hatSelected){
        
    }
}

-(void) stegoUpgrade{
    if(mittenSelected){
        
    }
    else if(hatSelected){
        
    }
}

-(void) trexUpgrade{
    if(mittenSelected){
        
    }
    else if(hatSelected){
        
    }
}

-(void) tricUpgrade{
    if(mittenSelected){
        
    }
    else if(hatSelected){
        
    }
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

@end
