#import "MainScene.h"

@implementation MainScene

-(void) didLoadFromCCB{
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"ReturningUser"]){
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"HighScore"];
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
    
    [self spawnClouds];
}

-(void) menu{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.1];
    [[CCDirector sharedDirector] pushScene:[CCBReader loadAsScene:@"Menu"] withTransition:transition];
}

-(void) spawnClouds{
    for(int i =1; i<4; i++){
        int upperBound = screenHeight;
        int lowerBound = (3./4)*screenHeight;
        int positionY = lowerBound + arc4random() % (upperBound - lowerBound);
        
        int positionX = arc4random()%2;
        int direction = positionX;
        positionX *= screenWidth;
        
        NSString *cloudFile = [NSString stringWithFormat:@"Cloud%i",i];
        Cloud *cloud = (Cloud*)[CCBReader load:cloudFile];
        
        [cloud setPosition:ccp(positionX,positionY)];
        cloud.direction = direction;
        cloud.speed = (arc4random()%3+1)/150.0;
        cloud.scale = 2;
        [self addChild: cloud];
    }

}



-(void) playGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}


@end
