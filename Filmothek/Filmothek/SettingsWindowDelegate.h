//
//  SettingsWindowDelegate.h
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@protocol SettingsClient <NSObject>

-(void)settingsChanged;

@end

@interface SettingsWindowDelegate : NSObject<NSWindowDelegate,NSTextFieldDelegate>

@property (assign,atomic, setter=setSettings:) Settings * settings_;

@property (assign,atomic) id<SettingsClient> receiver;

@property (assign) IBOutlet NSTextField *targetURLField;
@property (assign) IBOutlet NSTextField *settingsURLField;
@property (assign) IBOutlet NSButton *passwordRequiredCheckbox;
@property (assign) IBOutlet NSTextField *passwordField;
@property (assign) IBOutlet NSButton *autostartOnCheckbox;
@property (assign) IBOutlet NSButton *autostartIntoKioskModeCheckbox;


- (void)setSettings:(Settings*)settings;
- (void)loadSettingsIntoUI;
- (IBAction)saveSettings:(id)sender;
- (IBAction)resetSettings:(id)sender;
- (IBAction)clearSettings:(id)sender;

- (BOOL)windowShouldClose:(id)sender;

@end
