//
//  SettingsWindowDelegate.m
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "SettingsWindowDelegate.h"

@implementation SettingsWindowDelegate

@synthesize settings_;
@synthesize receiver;

@synthesize targetURLField, settingsURLField, passwordRequiredCheckbox, passwordField, autostartOnCheckbox, autostartIntoKioskModeCheckbox;

- (void)windowDidBecomeKey:(NSNotification *)notification {
    [self loadSettingsIntoUI];
}

- (void)setSettings:(Settings *)settings {
    settings_ = settings;
    [self loadSettingsIntoUI];
}

- (void)loadSettingsIntoUI {
    NSLog(@"%@", settings_);
    [targetURLField setStringValue:settings_.targetURL];
    [settingsURLField setStringValue:settings_.settingsURL];
    [passwordField setStringValue:settings_.password];
    [passwordRequiredCheckbox setState: settings_.passwordRequired ? NSOnState : NSOffState];
    if ([settings_.password length] == 0){
        [passwordRequiredCheckbox setEnabled:NO];
    }
    [autostartOnCheckbox setState: settings_.autostartOn ? NSOnState : NSOffState];
    [autostartIntoKioskModeCheckbox setState: settings_.autostartIntoKioskMode ? NSOnState : NSOffState];
}

-(IBAction)autostartChanged:(id)sender {
//    if (autostartOnCheckbox.state == NSOnState){
//        [autostartIntoKioskModeCheckbox setEnabled:YES];
//    } else {
//        [autostartIntoKioskModeCheckbox setEnabled:NO];
//    }
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    [self passwordChanged:[aNotification object]];
}
-(IBAction)passwordChanged:(id)sender {
    if (sender == passwordField){
        if ([[passwordField stringValue] isEqualToString:@""]){
            [passwordRequiredCheckbox setState:NSOffState];
            [passwordRequiredCheckbox setEnabled:NO];
        } else if (![passwordRequiredCheckbox isEnabled]) {
            [passwordRequiredCheckbox setState:NSOnState];
            [passwordRequiredCheckbox setEnabled:YES];
        }
    }
}

-(IBAction)saveSettings:(id)sender {
    
//    if (![[passwordField stringValue] isEqualToString:[passwordConfirmField stringValue]]){
//        NSLog(@"passwords not matching");
//        return;
//    }
    
    settings_.targetURL = [targetURLField stringValue];
    settings_.settingsURL = [settingsURLField stringValue];
    settings_.passwordRequired = [passwordRequiredCheckbox state] == NSOnState;
    settings_.password = [passwordField stringValue];
    settings_.autostartOn = [autostartOnCheckbox state] == NSOnState;
    settings_.autostartIntoKioskMode = [autostartIntoKioskModeCheckbox state] == NSOnState;
    
    if ([settings_ saveToResource:@"Settings"]){
        [receiver settingsChanged];
        NSLog(@"settings save");
    } else {
        NSLog(@"settings not saved");
    }
}


- (IBAction)resetSettings:(id)sender {
    [self loadSettingsIntoUI];
}

- (IBAction)clearSettings:(id)sender {
    settings_.targetURL = @"";
    settings_.password = @"";
    settings_.autostartOn = NO;
    settings_.autostartIntoKioskMode = NO;
    
    
    if ([settings_ saveToResource:@"Settings"]){
        [receiver settingsChanged];
        NSLog(@"settings save");
        [self loadSettingsIntoUI];
    } else {
        NSLog(@"settings not saved");
    }
}

- (BOOL)windowShouldClose:(id)sender {
    
//    if (![[passwordField stringValue] isEqualToString:[passwordConfirmField stringValue]]){
//        NSLog(@"passwords not matching");
//        return NO;
//    }
    
    settings_.targetURL = [targetURLField stringValue];
    settings_.settingsURL = [settingsURLField stringValue];
    settings_.password = [passwordField stringValue];
    settings_.passwordRequired = [passwordRequiredCheckbox state] == NSOnState;
    settings_.autostartOn = [autostartOnCheckbox state] == NSOnState;
    settings_.autostartIntoKioskMode = [autostartIntoKioskModeCheckbox state] == NSOnState;
    
    if (![settings_ saveToResource:@"Settings"]){
        NSLog(@"settings not saved");
        return NO;
    }
    
    return YES;
}

@end
