/*
THClientPresetsGenerator.m
Interactex Designer

Created by Juan Haladjian on 10/07/2013.

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

#import "THClientPresetsGenerator.h"
#import "THLilyPad.h"
#import "THLed.h"
#import "THiPhoneButton.h"
#import "THLabel.h"
#import "THBoardPin.h"
#import "THElementPin.h"
#import "THiPhone.h"
#import "THButton.h"
#import "THBuzzer.h"
#import "THTouchpad.h"
#import "THLightSensor.h"
#import "THCompass.h"
#import "THClientProject.h"
#import "THClientProjectProxy.h"

@implementation THClientPresetsGenerator

NSString * const kDigitalOutputProjectName = @"Digital Output";
NSString * const kDigitalInputProjectName = @"Digital Input";
NSString * const kBuzzerProjectName = @"Buzzer";
NSString * const kAnalogOutputProjectName = @"Analog Output";
NSString * const kAnalogInputProjectName = @"Analog Input";
NSString * const kCompassProjectName = @"Compass";

-(id) init{
    
    self = [super init];
    if(self){
       
        
    }
    return self;
}
/*
-(void) loadPresets{
    
    NSString *filePath = [TFFileUtils dataFile:kProjectProxiesFileName inDirectory:@""];
    _presets = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}*/

-(void) generatePresets{
    
    _presets = [NSMutableArray array];
    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:[self digitalOutputProject]];
    [array addObject:[self digitalInputProject]];
    [array addObject:[self buzzerProject]];
    //[array addObject:[self analogOutputProject]];
    [array addObject:[self analogInputProject]];
    [array addObject:[self compassProject]];
    
    
    NSMutableArray * imagesArray = [NSMutableArray array];
    [imagesArray addObject:[UIImage imageNamed:@"led.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"button.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"buzzer.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"lightSensor.png"]];
    [imagesArray addObject:[UIImage imageNamed:@"accelerometer.png"]];
    
    for (int i = 0 ; i < array.count ; i++) {
        
        THClientProject * project = [array objectAtIndex:i];
        [project saveToDirectory:kPresetsDirectory];
        
        THClientProjectProxy * proxy = [[THClientProjectProxy alloc] initWithName:project.name];
        
        UIImage * image = [imagesArray objectAtIndex:i];
        proxy.image = image;
        
        [_presets addObject:proxy];
    }
}

/*
-(THClientProject*) projectNamed:(NSString *)name{
    
    if([name isEqualToString:kDigitalOutputSceneName]){
        return [self digitalOutputProject];
    } else if([name isEqualToString:kDigitalInputSceneName]){
        return [self digitalInputProject];
    } else if([name isEqualToString:kBuzzerSceneName]){
        return [self buzzerProject];
    } else if([name isEqualToString:kAnalogOutputSceneName]){
        return [self analogOutputProject];
    } else if([name isEqualToString:kAnalogInputSceneName]){
        return [self analogInputProject];
    } else if([name isEqualToString:kCompassSceneName]){
        return [self compassProject];
    }
    return nil;
}*/

-(THClientProject*) defaultClientProject{
    
    THClientProject * project = [THClientProject emptyProject];
    project.iPhone = [[THiPhone alloc] init];
    project.iPhone.currentView = [[THView alloc] init];
    project.iPhone.currentView.backgroundColor = [UIColor whiteColor];
    return project;
}

-(THClientProject*) digitalOutputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kDigitalOutputProjectName;
    
    THLed * led = [[THLed alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObject:led];
    
    THiPhoneButton * button = [[THiPhoneButton alloc] init];
    button.text = @"turnOn";
    button.position = CGPointMake(100, 200);
    
    THiPhoneButton * button2 = [[THiPhoneButton alloc] init];
    button2.text = @"turnOff";
    button2.position = CGPointMake(200, 200);
    
    
    TFMethod * method = [led methodNamed:@"turnOn"];
    TFMethodInvokeAction * turnOn = [[TFMethodInvokeAction alloc] initWithTarget:led method:method];
    TFEvent * event = [button.events objectAtIndex:0];
    turnOn.source = button;
    [project registerAction:turnOn forEvent:event];
    
    TFMethod * method2 = [led methodNamed:@"turnOff"];
    TFMethodInvokeAction * turnOff = [[TFMethodInvokeAction alloc] initWithTarget:led method:method2];
    TFEvent * event2 = [button.events objectAtIndex:0];
    turnOff.source = button2;
    [project registerAction:turnOff forEvent:event2];
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a LED to pin 4";
    label.position = CGPointMake(150, 100);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button,button2,label,nil];
    
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:4];
    lilypinled.mode = kPinModeDigitalOutput;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    return project;
}

-(THClientProject*) digitalInputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kDigitalInputProjectName;
    
    THLed * led = [[THLed alloc] init];
    THButton * lilybutton = [[THButton alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObjects:led, lilybutton,nil];
    
    THiPhoneButton * button = [[THiPhoneButton alloc] init];
    button.text = @"turnOn";
    button.position = CGPointMake(100, 200);
    
    TFMethod * method = [led.methods objectAtIndex:2];
    TFMethodInvokeAction * turnOn = [[TFMethodInvokeAction alloc] initWithTarget:led method:method];
    TFEvent * event = [button.events objectAtIndex:0];
    turnOn.source = button;
    [project registerAction:turnOn forEvent:event];
    
    THiPhoneButton * button2 = [[THiPhoneButton alloc] init];
    button2.text = @"turnOff";
    button2.position = CGPointMake(200, 200);
    
    TFMethod * method2 = [led.methods objectAtIndex:3];
    TFMethodInvokeAction * turnOff = [[TFMethodInvokeAction alloc] initWithTarget:led method:method2];
    turnOff.source = button2;
    [project registerAction:turnOff forEvent:event];
    
    TFMethod * method3 = [led.methods objectAtIndex:3];
    TFMethodInvokeAction * turnOff2 = [[TFMethodInvokeAction alloc] initWithTarget:led method:method3];
    turnOff2.source = lilybutton;
    TFEvent * event2 = [lilybutton.events objectAtIndex:0];
    [project registerAction:turnOff2 forEvent:event2];
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a LED to pin 4 and a button to pin 5";
    label.position = CGPointMake(150, 100);
    label.width = 200;
    label.height = 100;
    label.numLines = 2;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button,button2,label, nil];
    
    //pins
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:4];
    lilypinled.mode = kPinModeDigitalOutput;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    THBoardPin * lilypinButton = [lilypad digitalPinWithNumber:5];
    lilypinButton.mode = kPinModeDigitalInput;
    THElementPin * buttonpin = [lilybutton.pins objectAtIndex:0];
    [lilypinButton attachPin:buttonpin];
    [buttonpin attachToPin:lilypinButton];
    
    return project;
}

-(THClientProject*) buzzerProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kBuzzerProjectName;
    
    THBuzzer * buzzer = [[THBuzzer alloc] init];
    
    project.hardwareComponents = [NSMutableArray arrayWithObject:buzzer];
    
    THiPhoneButton * button1 = [[THiPhoneButton alloc] init];
    button1.text = @"turnOn";
    button1.position = CGPointMake(100, 150);
    
    THiPhoneButton * button2 = [[THiPhoneButton alloc] init];
    button2.text = @"turnOff";
    button2.position = CGPointMake(200, 150);
    
    THTouchpad * touchpad = [[THTouchpad alloc] init];
    touchpad.position = CGPointMake(150, 300);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a PWM element to pin 9";
    label.position = CGPointMake(150, 50);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:button1, button2, touchpad, label, nil];
    
    TFEvent * event = [button1.events objectAtIndex:0];
    
    TFMethod * turnOnMethod = [buzzer.methods objectAtIndex:2];
    TFMethodInvokeAction * turnOn = [[TFMethodInvokeAction alloc] initWithTarget:buzzer method:turnOnMethod];
    turnOn.source = button1;
    [project registerAction:turnOn forEvent:event];
    
    TFMethod * turnOffMethod = [buzzer.methods objectAtIndex:3];
    TFMethodInvokeAction * turnOff = [[TFMethodInvokeAction alloc] initWithTarget:buzzer method:turnOffMethod];
    turnOff.source = button2;
    [project registerAction:turnOff forEvent:event];
    
    TFEvent * dxEvent = [touchpad.events objectAtIndex:0];
    TFMethod * varyFreqMethod = [buzzer.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke = [TFMethodInvokeAction actionWithTarget:buzzer method:varyFreqMethod];
    TFProperty * property = [touchpad.properties objectAtIndex:0];
    methodInvoke.firstParam = [TFPropertyInvocation invocationWithProperty:property target:touchpad];
    methodInvoke.source = touchpad;
    [project registerAction:methodInvoke forEvent:dxEvent];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    
    THBoardPin * lilypinBuzzer = [lilypad digitalPinWithNumber:9];
    lilypinBuzzer.mode = kPinModePWM;
    THElementPin * buzzerPin = [buzzer.pins objectAtIndex:0];
    [lilypinBuzzer attachPin:buzzerPin];
    [buzzerPin attachToPin:lilypinBuzzer];
        
    return project;
}

-(THClientProject*) analogOutputProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kAnalogOutputProjectName;
    
    THLed * led = [[THLed alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObjects:led,nil];
    
    //pins
    THBoardPin * lilypinled = [lilypad digitalPinWithNumber:9];
    lilypinled.mode = kPinModePWM;
    THElementPin * ledpin = [led.pins objectAtIndex:1];
    [lilypinled attachPin:ledpin];
    [ledpin attachToPin:lilypinled];
    
    THTouchpad * touchpad = [[THTouchpad alloc] init];
    touchpad.position = CGPointMake(150, 200);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a LED to pin 9";
    label.position = CGPointMake(150, 50);
    label.width = 200;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:touchpad,label,nil];
    
    TFEvent * dxEvent = [touchpad.events objectAtIndex:0];
    TFMethod * varyIntensityMethod = [led.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke = [TFMethodInvokeAction actionWithTarget:led method:varyIntensityMethod];
    TFProperty * property = [touchpad.properties objectAtIndex:0];
    methodInvoke.firstParam = [TFPropertyInvocation invocationWithProperty:property target:touchpad];
    methodInvoke.source = touchpad;
    [project registerAction:methodInvoke forEvent:dxEvent];
    
    return project;
}

-(THClientProject*) analogInputProject{
    THClientProject * project = [self defaultClientProject];
    
    project.name = kAnalogInputProjectName;
    
    THLightSensor * lightSensor = [[THLightSensor alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSMutableArray arrayWithObjects:lightSensor,nil];
    
    THLabel * sensorLabel = [[THLabel alloc] init];
    sensorLabel.position = CGPointMake(150, 200);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a Light Sensor to analog pin 0";
    label.position = CGPointMake(170, 50);
    label.width = 300;
    
    project.iPhoneObjects = [NSMutableArray arrayWithObjects:label,sensorLabel,nil];
    
    //method
    TFEvent * lightChangeEvent = [lightSensor.events objectAtIndex:0];
    TFMethod * setTextMethod = [sensorLabel.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke = [TFMethodInvokeAction actionWithTarget:sensorLabel method:setTextMethod];
    TFProperty * property = [lightSensor.properties objectAtIndex:0];
    methodInvoke.firstParam = [TFPropertyInvocation invocationWithProperty:property target:lightSensor];
    methodInvoke.source = lightSensor;
    [project registerAction:methodInvoke forEvent:lightChangeEvent];
    
    //pins
    THBoardPin * lilypinLightSensor = [lilypad analogPinWithNumber:0];
    lilypinLightSensor.mode = kPinModeAnalogInput;
    THElementPin * lightSensorPin = [lightSensor.pins objectAtIndex:1];
    [lilypinLightSensor attachPin:lightSensorPin];
    [lightSensorPin attachToPin:lilypinLightSensor];
    
    return project;
}

-(THClientProject*) compassProject{
    
    THClientProject * project = [self defaultClientProject];
    
    project.name = kCompassProjectName;
    
    /*
    THCompass * compass = [[THCompass alloc] init];
    
    THLilyPad * lilypad = [[THLilyPad alloc] init];
    project.lilypad = lilypad;
    project.hardwareComponents = [NSArray arrayWithObjects:compass,nil];
    
    THLabel * label1 = [[THLabel alloc] init];
    label1.position = CGPointMake(100, 150);
    
    THLabel * label2 = [[THLabel alloc] init];
    label2.position = CGPointMake(200, 150);
    
    THLabel * label3 = [[THLabel alloc] init];
    label3.position = CGPointMake(150, 250);
    
    THLabel * label = [[THLabel alloc] init];
    label.text = @"connect a Compass to the I2C pins";
    label.position = CGPointMake(150, 50);
    label.width = 300;
    
    project.iPhoneObjects = [NSArray arrayWithObjects:label1,label2,label3,label,nil];
    
    //method x
    TFEvent * xEvent = [compass.events objectAtIndex:0];
    TFMethod * setTextMethod = [label1.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke1 = [TFMethodInvokeAction actionWithTarget:label1 method:setTextMethod];
    TFProperty * property1 = [compass.viewableProperties objectAtIndex:0];
    methodInvoke1.firstParam = [TFPropertyInvocation invocationWithProperty:property1 target:compass];
    methodInvoke1.source = compass;
    [project registerAction:methodInvoke1 forEvent:xEvent];
    
    //method y
    TFEvent * yEvent = [compass.events objectAtIndex:1];
    TFMethod * setTextMethod2 = [label2.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke2 = [TFMethodInvokeAction actionWithTarget:label2 method:setTextMethod2];
    TFProperty * property2 = [compass.viewableProperties objectAtIndex:1];
    methodInvoke2.firstParam = [TFPropertyInvocation invocationWithProperty:property2 target:compass];
    methodInvoke2.source = compass;
    [project registerAction:methodInvoke2 forEvent:yEvent];
    
    //heading
    TFEvent * headingEvent = [compass.events objectAtIndex:1];
    TFMethod * setTextMethod3 = [label3.methods objectAtIndex:0];
    TFMethodInvokeAction * methodInvoke3 = [TFMethodInvokeAction actionWithTarget:label3 method:setTextMethod3];
    TFProperty * property3 = [compass.viewableProperties objectAtIndex:3];
    methodInvoke3.firstParam = [TFPropertyInvocation invocationWithProperty:property3 target:compass];
    methodInvoke3.source = compass;
    [project registerAction:methodInvoke3 forEvent:headingEvent];
    
    //pins
    THElementPin * compassPin = compass.pin5;
    THBoardPin * pin5 = [lilypad analogPinWithNumber:5];
    NSLog(@"");
    [pin5 attachPin:compassPin];
    [compassPin attachToPin:pin5];
    */
    return project;
}

-(NSInteger) numFakeScenes{
    return _presets.count;
}

@end