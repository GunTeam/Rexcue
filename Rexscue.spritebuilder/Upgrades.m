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
    mittenPrice = 5;
    hatPrice = 5;
    needleUpgradePrice = 300;
    
    [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];
    
    if(numNeedles > 10){
        _playMorePrompt.visible = false;
    }
    
    mittenSelected = false;
    hatSelected = false;
    
    [_mittenPriceLabel setString:[NSString stringWithFormat:@"Price: %i Needles", mittenPrice]];
    [_hatPriceLabel setString:[NSString stringWithFormat:@"Price: %i Needles", hatPrice]];
  
    dinotypeToSelector = [NSDictionary dictionaryWithObjectsAndKeys:
                          _TrexSelector, @"Trex", _PterodactylSelector, @"Pterodactyl",_AllosaurusSelector, @"Allosaurus",_TriceratopsSelector, @"Triceratops",_StegosaurusSelector, @"Stegosaurus", nil];
    
    ourdinos = @[_stegosaurus,_pterodactyl,_allosaurus,_trex,_triceratops];
    for (dinosaur *dino in ourdinos){
        [dino setIsStationary:true];
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
        CCParticleSystem *select = [dinotypeToSelector objectForKey: [dino getType]];
        select.visible = false;
        dino.visible = false;
    }
    _needleButton.visible = false;
    _needleDescription.visible = false;
    _upgradePrompt.visible = false;
    
    _selector.visible = false;
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
}

-(void) mittenUpgrade{
    if(!mittenSelected){
        if(numNeedles > mittenPrice){
            _selector.position = _mittenButton.position;
            _selector.visible = true;
            for (dinosaur *dino in ourdinos){
                dino.visible = true;
            }
            _upgradePrompt.visible = true;
            
            mittenSelected = true;
            hatSelected = false;
            
            for (dinosaur *dino in ourdinos){
                CCParticleSystem *select = [dinotypeToSelector objectForKey: [dino getType]];
                if(![dino hasMittens]){
                    select.visible = true;
                }
                else{
                    select.visible = false;
                }
            }
        }
        else{
            _playMorePrompt.visible = true;
            CCAction *animation1 = [CCActionScaleTo actionWithDuration:0.5 scale:1.5];
            CCAction *animation2 = [CCActionScaleTo actionWithDuration:0.5 scale:1];
            
            [_playMorePrompt runAction:[CCActionSequence actionWithArray:@[animation1, animation2]]];
        }
    }
    else{
        _selector.visible = false;
        mittenSelected = false;
        _upgradePrompt.visible = false;
        for (dinosaur *dino in ourdinos){
            CCParticleSystem *select = [dinotypeToSelector objectForKey: [dino getType]];
            select.visible = false;
            dino.visible = false;
        }
    }

    
}
-(void) hatUpgrade{
    if(!hatSelected){
        if(numNeedles > hatPrice){
            _selector.position = _hatButton.position;
            _selector.visible = true;
            for (dinosaur *dino in ourdinos){
                dino.visible = true;
            }
            _upgradePrompt.visible = true;
            
            mittenSelected = false;
            hatSelected = true;
            
            for (dinosaur *dino in ourdinos){
                CCParticleSystem *select = [dinotypeToSelector objectForKey: [dino getType]];
                if([dino hasMittens] && ![dino hasHat]){
                    select.visible = true;
                }
                else{
                    select.visible = false;
                }
            }
        }
        else{
            _playMorePrompt.visible = true;
            CCAction *animation1 = [CCActionScaleTo actionWithDuration:0.5 scale:1.5];
            CCAction *animation2 = [CCActionScaleTo actionWithDuration:0.5 scale:1];
            
            [_playMorePrompt runAction:[CCActionSequence actionWithArray:@[animation1, animation2]]];
        }
        
    }
    else{
        _selector.visible = false;
        hatSelected = false;
        _upgradePrompt.visible = false;
        for (dinosaur *dino in ourdinos){
            CCParticleSystem *select = [dinotypeToSelector objectForKey: [dino getType]];
            select.visible = false;
            dino.visible = false;
        }
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
    dinosaur *thisdino;
    for (dinosaur *whichDino in ourdinos){
        NSString *dinoType = [whichDino getType];
        if([dino isEqualToString:dinoType]){
            thisdino = whichDino;
        }
    }
    
    if(![thisdino hasMittens]){
        NSString *key = [NSString stringWithFormat:@"%@Mittens", dino];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:key];
        
        numNeedles -= mittenPrice;
        [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];

        [[NSUserDefaults standardUserDefaults] setInteger:numNeedles forKey:@"NumNeedles"];
        
        if(numNeedles < mittenPrice){
            mittenSelected = false;
            _selector.visible = false;
        }
        
        CCParticleSystem *select = [dinotypeToSelector objectForKey:[thisdino getType]];
        select.visible = false;
        _upgradePrompt.visible = false;
        
        [thisdino putOnMittens];
    }

}

-(void) buyHatForDino: (NSString*)dino{
    dinosaur *thisdino;
    for (dinosaur *whichDino in ourdinos){
        NSString *dinoType = [whichDino getType];
        if([dino isEqualToString:dinoType]){
            thisdino = whichDino;
        }
    }
    
    
    if([thisdino hasMittens]){
        NSString *key = [NSString stringWithFormat:@"%@Hat", dino];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:key];
        
        numNeedles -= hatPrice;
        [_numNeedleLabel setString:[NSString stringWithFormat:@"Total Needles: %li", numNeedles]];
        
        [[NSUserDefaults standardUserDefaults] setInteger:numNeedles forKey:@"NumNeedles"];
        
        CCParticleSystem *select = [dinotypeToSelector objectForKey:[thisdino getType]];
        select.visible = false;
        _upgradePrompt.visible = false;
        
        if(numNeedles < hatPrice){
            hatSelected = false;
            _selector.visible = false;
        }
        
        [thisdino putOnHat];
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
        [self buyMittensForDino:@"Allosaurus"];
    }
    else if(hatSelected){
        [self buyHatForDino:@"Allosaurus"];
    }
}

-(void) stegoUpgrade{
    if(mittenSelected){
        [self buyMittensForDino:@"Stegosaurus"];
    }
    else if(hatSelected){
        [self buyHatForDino:@"Stegosaurus"];
    }
}

-(void) trexUpgrade{
    if(mittenSelected){
        [self buyMittensForDino:@"Trex"];
    }
    else if(hatSelected){
        [self buyHatForDino:@"Trex"];
    }
}

-(void) tricUpgrade{
    if(mittenSelected){
        [self buyMittensForDino:@"Triceratops"];
    }
    else if(hatSelected){
        [self buyHatForDino:@"Triceratops"];
    }
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

-(void) resetUpgrades{
    CCLOG(@"RESETTING");
    for (dinosaur *whichDino in ourdinos){
        NSString *dinoType = [whichDino getType];
        NSString *key = [NSString stringWithFormat:@"%@Mittens", dinoType];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:key];
        key = [NSString stringWithFormat:@"%@Hat", dinoType];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:key];
    }
    
}



@end
