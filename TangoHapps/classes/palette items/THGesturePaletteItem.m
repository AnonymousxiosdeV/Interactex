//
//  THGesture.m
//  TangoHapps
//
//  Created by Timm Beckmann on 02/04/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THGesturePaletteItem.h"
#import "THGesture.h"

@implementation THGesturePaletteItem

- (void)dropAt:(CGPoint)location {
    
    THGesture* gesture = [[THGesture alloc] initWithName:self.name];
    gesture.position = location;
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addGesture:gesture];
}

@end