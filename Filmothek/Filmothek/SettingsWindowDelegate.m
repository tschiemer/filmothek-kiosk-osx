//
//  SettingsWindowDelegate.m
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "SettingsWindowDelegate.h"
#import "LaunchAtLoginHelper.h"

@implementation SettingsWindowDelegate

@synthesize settings_;
@synthesize receiver;

@synthesize targetURLField, settingsURLField, passwordRequiredCheckbox, passwordField, autostartOnCheckbox, autostartIntoKioskModeCheckbox;
@synthesize startupScriptPathField, shutdownScriptPathField;

- (void)windowDidBecomeKey:(NSNotification *)notification {
    [self loadSettingsIntoUI];
}

- (IBAction)selectStartupScript:(id)sender {
    
}

- (IBAction)selectShutdownScript:(id)sender {
    
}

- (void)setSettings:(Settings *)settings {
    settings_ = settings;
    [self loadSettingsIntoUI];
}

- (void)loadSettingsIntoUI {
    NSLog(@"%@", settings_);
    if ([LaunchAtLoginHelper willLaunchAtStartup]){
        NSLog(@"autostart YES");
    } else {
        NSLog(@"autostart NO");
    }
    [targetURLField setStringValue:settings_.targetURL];
    [settingsURLField setStringValue:settings_.settingsURL];
    [passwordField setStringValue:settings_.password];
    [passwordRequiredCheckbox setState: settings_.passwordRequired ? NSOnState : NSOffState];
    if ([settings_.password length] == 0){
        [passwordRequiredCheckbox setEnabled:NO];
    }
    [autostartOnCheckbox setState: [LaunchAtLoginHelper willLaunchAtStartup] ? NSOnState : NSOffState];
    [autostartIntoKioskModeCheckbox setState: settings_.autostartIntoKioskMode ? NSOnState : NSOffState];
    
    [startupScriptPathField setStringValue:settings_.startupScriptPath];
    [shutdownScriptPathField setStringValue:settings_.shutdownScriptPath];
}

-(IBAction)autostartChanged:(id)sender {
    if ([LaunchAtLoginHelper willLaunchAtStartup]){//autostartOnCheckbox.state == NSOnState){
        [LaunchAtLoginHelper setLaunchAtStartup:NO];
//        [autostartIntoKioskModeCheckbox setEnabled:YES];
    } else {
        [LaunchAtLoginHelper setLaunchAtStartup:YES];
//        [autostartIntoKioskModeCheckbox setEnabled:NO];
    }
    if ([LaunchAtLoginHelper willLaunchAtStartup]){
        NSLog(@"autostart YES");
    } else {
        NSLog(@"autostart NO");
    }
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
//    settings_.autostartOn = [autostartOnCheckbox state] == NSOnState;
    settings_.autostartIntoKioskMode = [autostartIntoKioskModeCheckbox state] == NSOnState;
    
    settings_.startupScriptPath = [startupScriptPathField stringValue];
    settings_.shutdownScriptPath = [shutdownScriptPathField stringValue];
    
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
//    settings_.autostartOn = NO;
    settings_.autostartIntoKioskMode = NO;
    
    settings_.startupScriptPath = @"";
    settings_.shutdownScriptPath = @"";
    
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
//    settings_.autostartOn = [autostartOnCheckbox state] == NSOnState;
    settings_.autostartIntoKioskMode = [autostartIntoKioskModeCheckbox state] == NSOnState;
    
    settings_.startupScriptPath = [startupScriptPathField stringValue];
    settings_.shutdownScriptPath = [shutdownScriptPathField stringValue];
    
    if (![settings_ saveToResource:@"Settings"]){
        NSLog(@"settings not saved");
        return NO;
    }
    
    return YES;
}

@end
