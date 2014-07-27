//
//  AppDelegate.m
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize menuItemQuit,menuItemKioskMode,menuItemNormalMode;
@synthesize aboutView;
@synthesize preferencesWindow,settings,settingsWindowDelegate;
@synthesize webView, webFreezeView;
@synthesize passwordText, passwordView;


typedef enum {ModeNormal,ModeKiosk} Mode;

Mode viewMode = ModeNormal;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [aboutView setHidden:YES];
    [passwordView setHidden:YES];
    [webFreezeView setHidden:YES];
//    [webView setHidden:YES];
    
    
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
        [self activateKioskMode];
    } else {
        [self activateNormalMode];
    }

}
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    if (viewMode == ModeKiosk){
        return NSTerminateCancel;
    } else {
        return NSTerminateNow;
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

-(void)settingsChanged {
    
    if ( [settings.targetURL length] == 0){
//        [webView ]
    } else {
        [self menuReload:self];
    }
}


-(IBAction)showAbout:(id)sender {
    [aboutView setHidden:NO];
}

-(IBAction)hideAbout:(id)sender {
    [aboutView setHidden:YES];
}


-(IBAction)menuPreferences:(id)sender {
    if (viewMode != ModeNormal){
        return;
    }
    
    settingsWindowDelegate.receiver = self;
    [preferencesWindow makeKeyAndOrderFront:self];
    
    settingsWindowDelegate.settings = settings;
}


- (void)controlTextDidChange:(NSNotification *)aNotification {
//    [self passwordChanged:[aNotification object]];
}


-(IBAction)menuWebPreferences:(id)sender {
    if (viewMode != ModeNormal){
        return;
    }
    
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
        [passwordView setHidden:NO];
        [self freezeWebView];
        [window makeFirstResponder:passwordText];
    } else {
        [self activateNormalMode];
    }
}

- (IBAction)menuKioskMode:(id)sender {
    if (viewMode == ModeKiosk){
        return;
    }
    
    [self activateKioskMode];
}

- (IBAction)cancelAuthentication:(id)sender {
    [passwordView setHidden:YES];
    [self unfreezeWebView];
}

- (IBAction)authenticate:(id)sender {
    if ([settings.password isEqualToString:[passwordText stringValue]]){
        [passwordView setHidden:YES];
        [passwordText setStringValue:@""];
        [self unfreezeWebView];
        
        [self activateNormalMode];
    } else {
        [passwordText setStringValue:@""];
        static int numberOfShakes = 8;
        static float durationOfShake = 0.5f;
        static float vigourOfShake = 0.05f;
        
        CGRect frame=[passwordView frame];
        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
        
        CGMutablePathRef shakePath = CGPathCreateMutable();
        CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
        int index;
        for (index = 0; index < numberOfShakes; ++index)
        {
            CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
            CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
        }
        CGPathCloseSubpath(shakePath);
        shakeAnimation.path = shakePath;
        shakeAnimation.duration = durationOfShake;
        
        [passwordView setAnimations:[NSDictionary dictionaryWithObject: shakeAnimation forKey:@"frameOrigin"]];
        [[passwordView animator] setFrameOrigin:[passwordView frame].origin];
    }
}

-(void)freezeWebView {
//    [webFreezeView setImage:[[NSImage alloc] initWithData:[webView dataWithPDFInsideRect:[webView bounds]]]];
//    [webFreezeView setHidden:NO];
//    [webView setHidden:YES];
}
-(void)unfreezeWebView {
//    [webView setHidden:NO];
//    [webFreezeView setHidden:YES];
}


-(void)activateKioskMode {
    
    NSApplicationPresentationOptions options = NSApplicationPresentationFullScreen
//    + NSApplicationPresentationDisableProcessSwitching
//        + NSApplicationPresentationDisableForceQuit
    ;
    
    [NSApp setPresentationOptions:options];
    
    [[window contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];
    
    viewMode = ModeKiosk;
    
    [menuItemQuit setEnabled:NO];
    [menuItemNormalMode setState:NSOnState];
    [menuItemKioskMode setState:NSOffState];
}

-(void)activateNormalMode {
    
    NSApplicationPresentationOptions options = NSApplicationPresentationFullScreen;
    
    [NSApp setPresentationOptions:options];
    
    
    [[window contentView] exitFullScreenModeWithOptions:nil];
    
    viewMode = ModeNormal;
    
    [menuItemQuit setEnabled:YES];
    [menuItemNormalMode setState:NSOnState];
    [menuItemKioskMode setState:NSOffState];
}


@end
