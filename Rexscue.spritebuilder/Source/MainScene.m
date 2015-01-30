#import "MainScene.h"

@implementation MainScene
@synthesize musicOn, soundEffectsOn;

-(void) didLoadFromCCB{
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"ReturningUser"]){
        [self resetSettingsToDefault];
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
    
    dinos = @[_stego, _ptero, _trex,_trice,_allosaurus];
    
    for(dinosaur *dino in dinos){
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
        [dino setIsStationary:true];
    }
    
    musicOn =[[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"];
    
    if(musicOn){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
    self.numNeedles = [[NSUserDefaults standardUserDefaults] integerForKey:@"NumNeedles"];
    
    _smopocalypse.visible = false;
    
    [self spawnClouds];
}

-(void) menu{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.1];
    
    [musicPlayer stop];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Menu"] withTransition:transition];
}

-(void) upgrades{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.1];
    
    [musicPlayer stop];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"UpgradeScene"] withTransition:transition];
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
    [self.animationManager runAnimationsForSequenceNamed:@"Apocalypse"];
    _smopocalypse.visible = true;
    for(dinosaur *dino in dinos){
        [dino panic];
    }
    [self scheduleOnce:@selector(play) delay:1];
}

-(void) play{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) onEnter{
    [super onEnter];
    
    if(musicOn){
        [musicPlayer play];
    }
    
    [[CCDirector sharedDirector] resume];

}

-(void) resetSettingsToDefault{
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"playTutorial"];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"NumNeedles"];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"HighScore"];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"BestLevel"];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"MeteorsDestroyed"];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"DinosLost"];
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"EffectsOn"];
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"SandboxMode"];
}

@end
