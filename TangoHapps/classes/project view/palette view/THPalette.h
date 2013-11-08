/*
THPalette.h
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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "THPaletteItem.h"

@class THCustomPaletteItem;
@class THPaletteItem;
@class THPalette;

@protocol THPaletteDragDelegate <NSObject>
-(void)palette:(THPalette*)palette didStartDraggingItem:(THPaletteItem*)item withRecognizer:(UIPanGestureRecognizer*)recognizer;
-(void)palette:(THPalette*)palette didDragItem:(THPaletteItem*)item withRecognizer:(UIPanGestureRecognizer*)recognizer;
-(void)palette:(THPalette*)palette didDropItem:(THPaletteItem*)item withRecognizer:(UIPanGestureRecognizer*)recognizer;
-(void)palette:(THPalette*)palette didLongPressItem:(THPaletteItem*)item withRecognizer:(UILongPressGestureRecognizer*)recognizer;
-(void) didTapPalette:(THPalette*) palette;
@end

@protocol THPaletteEditionDelegate <NSObject>
-(void)palette:(THPalette*)palette didRemoveItem:(THCustomPaletteItem*)item;
-(void)palette:(THPalette*)palette didSelectItem:(THCustomPaletteItem*)item;
@end

@protocol TFPaletteSizeDelegate <NSObject>
-(void) palette:(THPalette*) palette didChangeSize:(CGSize) newSize;
@end

@interface THPalette : UIScrollView
< TFPaletteItemDelegate>
{
    NSMutableArray * _paletteItems;
    UIImageView * _dragView;
    THPaletteItem * _tempPaletteItem;
}

@property (nonatomic,weak) id<THPaletteDragDelegate> dragDelegate;
@property (nonatomic,weak) id<THPaletteEditionDelegate> editionDelegate;
@property (nonatomic,weak) id<TFPaletteSizeDelegate> sizeDelegate;
@property (nonatomic) BOOL editing;

//adding, removing, searching palette items
-(void)addPaletteItem:(THPaletteItem*)paletteItem;
-(void)addDragablePaletteItem:(THPaletteItem*)paletteItem;
-(THPaletteItem*)paletteItemAtIndex:(NSInteger)index;
-(THPaletteItem*)paletteItemAtLocation:(CGPoint)location;
-(void) removePaletteItem:(THPaletteItem*) paletteItem;
-(void)removeAllPaletteItems;

//temporary palette item
-(void) temporaryAddPaletteItem:(THPaletteItem*) paletteItem;
-(void) removeTemporaryPaletteItem;

-(void)dragItem:(UIPanGestureRecognizer*)sender;
-(void)resizeToFitContents;

@end