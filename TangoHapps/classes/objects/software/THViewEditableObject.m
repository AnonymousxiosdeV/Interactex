/*
THViewEditableObject.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THViewEditableObject.h"
#import "THiPhoneViewProperties.h"
#import "THView.h"
#import "THEditor.h"
#import "THiPhoneEditableObject.h"

@implementation THViewEditableObject

@dynamic width;
@dynamic height;
@dynamic opacity;
@dynamic position;
@dynamic backgroundColor;

+(id) newView{
    THViewEditableObject * view = [[THViewEditableObject alloc] init];
    view.simulableObject = [THView newView];
    //view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
    
    return view;
}

-(id)init {
    self = [super init];
    if(self){
        
        [self loadView];
    }
    return self;
}

-(void) loadView {
    
    self.canBeResized = NO;
    self.canChangeBackgroundColor = YES;
    self.canBeScaled = NO;
    self.canBeRootView = YES;
    self.minSize = kDefaultViewMinSize;
    self.maxSize = kDefaultViewMaxSize;
    _subviews = [NSMutableArray array];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        [self loadView];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

-(id)copyWithZone:(NSZone *)zone {
    THViewEditableObject * copy = [super copyWithZone:zone];
    copy.width = self.width;
    copy.height = self.height;
    copy.backgroundColor = self.backgroundColor;
    
    return copy;
}

#pragma mark - Property Controller

-(NSArray*)propertyControllers{
    NSMutableArray *controllers = [NSMutableArray array];
    _properties = [THiPhoneViewProperties properties];
    [controllers addObject:_properties];
    [controllers addObjectsFromArray:[super propertyControllers]];
    return controllers;
}

#pragma mark - Methods

-(BOOL) canBeMovedBy:(CGPoint)d{
    return self.canBeMoved;
}

-(void) setVisible:(BOOL)visible{
    if(visible != self.visible){
        for (THViewEditableObject * view in _subviews) {
            view.visible = visible;
        }
        [super setVisible:visible];
    }
}

-(CGSize) contentSize{
    THView * view = (THView*) self.simulableObject;
    return CGSizeMake(view.width,view.height);
}

-(void) addSubview:(THViewEditableObject*) object{
    [_subviews addObject:object];
    
    THView * view = (THView*) self.simulableObject;
    [view addSubview:(THView*)object.simulableObject];
}

-(void) removeSubview:(THViewEditableObject*) object{
    [_subviews removeObject:object];
    
    THView * view = (THView*) self.simulableObject;
    [view removeSubview:(THView*)object.simulableObject];
}

-(UIColor*) backgroundColor{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.backgroundColor;
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.backgroundColor = backgroundColor;
}

-(BOOL) canResizeToWidth:(float) width{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    CGPoint center = iPhoneObject.view.center;
    CGRect newBoundingBox = CGRectMake(center.x - width/2, center.y - self.height/2, width, self.height);
    
    THViewEditableObject * rootView = [THDirector sharedDirector].currentProject.iPhone.currentView;
    CGRect rootViewRect = rootView.boundingBox;
    
    return (CGRectGetMinX(rootViewRect) < CGRectGetMinX(newBoundingBox) && CGRectGetMaxX(rootViewRect) > CGRectGetMaxX(newBoundingBox));
}

-(BOOL) canResizeToHeight:(float) height{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    CGPoint center = iPhoneObject.view.center;
    CGRect newBoundingBox = CGRectMake(center.x - self.width/2, center.y - height/2 - 44, self.width, height);//check here
    
    THViewEditableObject * rootView = [THDirector sharedDirector].currentProject.iPhone.currentView;
    CGRect rootViewRect = rootView.boundingBox;
    
    return (CGRectGetMinY(rootViewRect) < CGRectGetMinY(newBoundingBox) && CGRectGetMaxY(rootViewRect) > CGRectGetMaxY(newBoundingBox));
}

-(float) width{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.width;
}

-(void) setWidth:(float)width{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    
    iPhoneObject.width = width;
    
    [_properties reloadState];
    
    [super setWidth:width];
}

-(float) height{
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.height;
}

-(void) setHeight:(float)height{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.height = height;
    
    [_properties reloadState];
    
    [super setHeight:height];
}

-(void) displaceBy:(CGPoint)displacement{
    
    THViewEditableObject * rootView = [THDirector sharedDirector].currentProject.iPhone.currentView;
    CGRect currentBoundingBox = self.boundingBox;
    CGRect newBoundingBox = currentBoundingBox;
    newBoundingBox.origin = ccpAdd(currentBoundingBox.origin, displacement);
    CGRect rootViewRect = rootView.boundingBox;
    
    if(CGRectContainsRect(rootViewRect, currentBoundingBox)){//only apply this if it was inside (to prevent it to leave the root views canvas. If it was outside (in case it was dropped half outside from the palette, just move it freely)
        
        if(CGRectGetMinX(rootViewRect) > CGRectGetMinX(newBoundingBox) || CGRectGetMaxX(rootViewRect) < CGRectGetMaxX(newBoundingBox)){
            displacement.x = 0;
        }
        
        if(CGRectGetMinY(rootViewRect) > CGRectGetMinY(newBoundingBox) || CGRectGetMaxY(rootViewRect) < CGRectGetMaxY(newBoundingBox)){
            displacement.y = 0;
        }
    }
    
    displacement = [TFHelper ConvertToCocos2d:displacement];
    self.position = ccpAdd(self.position, displacement);
}

-(void) scaleBy:(CGFloat)scale{
    
    if(self.canBeResized){
        THView * iPhoneObject = (THView*) self.simulableObject;
        
        CGPoint origin = iPhoneObject.view.frame.origin;
        CGSize size = iPhoneObject.view.frame.size;
        size = CGSizeMake(size.width*scale, size.height*scale);
        
        CGRect newFrame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        iPhoneObject.view.frame = newFrame;
        [super scaleBy:scale];
        
    }
}

-(CGRect) boundingBox{
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    CGPoint origin = iPhoneObject.view.frame.origin;
    CGSize size = iPhoneObject.view.frame.size;
    origin = [TFHelper ConvertToCocos2dView:origin];
    CGRect boundingBox = CGRectMake(origin.x, origin.y - size.height, size.width, size.height);
    return boundingBox;
}

-(CGPoint) position{
    THView * iPhoneObject = (THView*) self.simulableObject;
    
    if(iPhoneObject.view == nil){
        return [super position];
    } else {
        return iPhoneObject.position;
    }
}

-(CGPoint) absolutePosition{
    CGPoint absPos = [TFHelper ConvertToCocos2dView:self.position];
    return absPos;
}

-(void) setPosition:(CGPoint)position{
    
    CGPoint diff = ccpSub(position,self.position);
    
    [super setPosition:position];
    
    for (THViewEditableObject * subview in _subviews) {
        subview.position = ccpAdd(subview.position,diff);
    }
    
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.position = position;
}

-(void) setOpacity:(float)opacity{
    THView * iPhoneObject = (THView*) self.simulableObject;
    iPhoneObject.view.alpha = opacity;
}

-(float) opacity{
    THView * iPhoneObject = (THView*) self.simulableObject;
    return iPhoneObject.view.alpha;
}

-(BOOL) canBeDeleted{
    return !self.canBeRootView;
}

#pragma mark - Project interaction

-(void) addToLayer:(TFLayer*) layer{
    
    THView * view = (THView*) self.simulableObject;
    
    [view addToView:[CCDirector sharedDirector].view];
    
    [layer addEditableObject:self];
    
    [super addToLayer:layer];
}

-(void) removeFromLayer:(THEditor*) editor{
    
    [editor removeEditableObject:self];
    
    THView * view = (THView*) self.simulableObject;
    
    [view removeFromSuperview];
}

-(void) addToWorld{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project addiPhoneObject:self];
}

-(void) removeFromWorld{
    
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    [project removeiPhoneObject:self];
    
    NSArray * copy = [NSArray arrayWithArray:_subviews];
    for (THViewEditableObject * view in copy) {
        [view removeFromWorld];
    }
    
    [super removeFromWorld];
}


#pragma mark - Lifecycle

-(void) willStartSimulation{
    self.opacity = 1.0f;
    [super willStartSimulation];
}

-(NSString*) description{
    return @"View";
}

-(void) prepareToDie{
    _subviews = nil;
    _properties = nil;
    [super prepareToDie];
}

@end
