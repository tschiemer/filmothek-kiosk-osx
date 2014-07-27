//
//  AppDelegate.m
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window,aboutWindow, preferencesWindow;
@synthesize passwordWindow, passwordText, passwordView;
@synthesize webView;
@synthesize menuItemKioskMode,menuItemNormalMode;
@synthesize settings,settingsWindowDelegate;


typedef enum {ModeNormal,ModeKiosk} Mode;

Mode viewMode = ModeNormal;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    settings = [[Settings alloc] init];
    
    if (![settings loadFromResource:@"Settings"]){
        NSLog(@"settings not loaded");
    } else {
        NSLog(@"settings loaded");
    }
    
    if ( [settings.targetURL length] == 0){
        [self menuPreferences:self];
    } else {
        [webView setMainFrameURL:settings.targetURL];
    }
    
    viewMode = settings.autostartIntoKioskMode ? ModeKiosk : ModeNormal;
    
    if (viewMode == ModeKiosk){
        [self menuKioskMode:nil];
//        [menuItemKioskMode set]
    }

}

-(void)settingsChanged {
    
    if ( [settings.targetURL length] == 0){
//        [webView ]
    } else {
        [self menuReload:self];
    }
}


-(IBAction)menuAbout:(id)sender {
    
}


-(IBAction)menuPreferences:(id)sender {
    settingsWindowDelegate.receiver = self;
    [preferencesWindow makeKeyAndOrderFront:self];
    
    settingsWindowDelegate.settings = settings;
}


-(IBAction)menuWebPreferences:(id)sender {
    if ( [settings.settingsURL length] == 0){
        [self menuPreferences:self];
    } else {
        [webView setMainFrameURL:settings.settingsURL];
    }
}

-(IBAction)menuReload:(id)sender {
    
    if ( [settings.targetURL length] == 0){
        [self menuPreferences:self];
    } else {
        [webView setMainFrameURL:settings.targetURL];
    }
}


- (IBAction)menuNormalMode:(id)sender {
    
    if (viewMode == ModeNormal){
        return;
    }
    
    if (settings.passwordRequired){
        NSLog(@"password required");
        [passwordWindow makeKeyAndOrderFront:self];
//        [passwordWindow setLevel:1000];
        [[passwordWindow contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
    } else {
        NSLog(@"password not required");
        [[window contentView] exitFullScreenModeWithOptions:nil];
        viewMode = modeNormal;
    }
}

- (IBAction)menuKioskMode:(id)sender {
    if (viewMode == ModeKiosk){
        return;
    }
    NSApplicationPresentationOptions options = NSApplicationPresentationFullScreen;
    
    [NSApp setPresentationOptions:options];
    
    [[window contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
    
    viewMode = ModeKiosk;
}

- (IBAction)cancelAuthentication:(id)sender {
    [[passwordWindow contentView] exitFullScreenModeWithOptions:nil];
    [passwordWindow close];
}

- (IBAction)authenticate:(id)sender {
    if ([settings.password isEqualToString:[passwordText stringValue]]){
        
        [[passwordWindow contentView] exitFullScreenModeWithOptions:nil];
        [passwordWindow close];
        
        [[window contentView] exitFullScreenModeWithOptions:nil];
        
        viewMode = ModeNormal;
    }
}


@end
