#import "MainScene.h"

@implementation MainScene

-(void) didLoadFromCCB{
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"ReturningUser"]){
        
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"NumNeedles"];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"HighScore"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"EffectsOn"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
    }
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    //adjust for ipad sizing:
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        screenWidth = screenWidth/2;
        screenHeight = screenHeight/2;
    }
    
    NSArray *dinos = @[_stego, _ptero, _trex,_trice,_allosaurus];
    
    for(dinosaur *dino in dinos){
        [dino setHealthInvisible];
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
        [dino setIsStationary:true];
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
    self.numNeedles = [[NSUserDefaults standardUserDefaults] integerForKey:@"NumNeedles"];
    
    [self spawnClouds];
}

-(void) menu{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.1];
    
    [musicPlayer stop];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Menu"] withTransition:transition];
}

-(void) spawnClouds{
    _cloud1.direction = 1;
    _cloud1.speed = (arc4random()%3+1)/150.0;
    _cloud1.scale = 2;
    
    _cloud2.direction = 0;
    _cloud2.speed = (arc4random()%3+1)/150.0;
    _cloud2.scale = 2;
    
    _cloud3.direction = 0;
    _cloud3.speed = (arc4random()%3+1)/150.0;
    _cloud3.scale = 2;
}

-(void) runTutorial{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Tutorial"]];
}


-(void) playGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) onEnter{
    [super onEnter];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        [musicPlayer play];
    }
}


@end
