#import "MainScene.h"

@implementation MainScene

-(void) didLoadFromCCB{
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
}

-(void) spawnClouds{
    for(int i =1; i<4; i++){
        int upperBound = screenHeight;
        int lowerBound = screenHeight/2;
        int positionY = lowerBound + arc4random() % (upperBound - lowerBound);
        
        int positionX = arc4random()%2;
        int direction = positionX;
        positionX *= screenWidth;
        
        NSString *cloudFile = [NSString stringWithFormat:@"Cloud%i",i];
        Cloud *cloud = (Cloud*)[CCBReader load:cloudFile];
        
        [cloud setPosition:ccp(positionX,positionY)];
        [self addChild: cloud];
    }

}


@end
