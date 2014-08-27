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
@synthesize menuItemQuit,menuItemKioskMode,menuItemNormalMode, menuRunStartupScript, menuRunShutdownScript, menuOpenWebPreferences, viewRunningScript, runningScriptField;
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
    
    if ( [settings hasStartupScriptPath]){
        [menuRunStartupScript setEnabled:YES];
    } else {
        [menuRunStartupScript setEnabled:NO];
    }
    if ( [settings hasShutdownScriptPath]){
        [menuRunShutdownScript setEnabled:YES];
    } else {
        [menuRunShutdownScript setEnabled:NO];
    }
    
    
    
    viewMode = settings.autostartIntoKioskMode ? ModeKiosk : ModeNormal;
    
    if (viewMode == ModeKiosk){
        [self activateKioskMode];
    } else {
        [self activateNormalMode];
    }
    
//    if ( ![settings hasTargetURL]){
//        [self menuPreferences:self];
//    } else {
//        
//        [webView setMainFrameURL:settings.targetURL];
//    }
    
    dispatch_queue_t taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(taskQueue, ^{
        if ([settings hasStartupScriptPath]){
            [self runStartupScript:YES];
        }
        [self performSelectorOnMainThread:@selector(menuReload:) withObject:nil waitUntilDone:NO];
    });
    

}
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    if (viewMode == ModeKiosk){
        return NSTerminateCancel;
    } else {
        
        [self runShutdownScript:YES];
        
        return NSTerminateNow;
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

-(void)settingsChanged {
    
    if ( ![settings hasTargetURL]){
//        [webView ]
    } else {
        [self menuReload:self];
    }
    
    if ( [settings hasStartupScriptPath]){
        [menuRunStartupScript setEnabled:YES];
    } else {
        [menuRunStartupScript setEnabled:NO];
    }
    if ( [settings hasShutdownScriptPath]){
        [menuRunShutdownScript setEnabled:YES];
    } else {
        [menuRunShutdownScript setEnabled:NO];
    }
}


-(IBAction)showAbout:(id)sender {
    [aboutView setHidden:NO];
}

-(IBAction)hideAbout:(id)sender {
    [aboutView setHidden:YES];
}


-(IBAction)menuRunStartupScript:(id)sender {
    if (viewMode != ModeNormal){
        return;
    }
    [self runStartupScript:true];
}


-(void)runStartupScript:(BOOL)waitForExit {
    if (![settings hasStartupScriptPath]){
        return;
    }
    NSLog(@"Running startup script: START");
    
    
    //1
    NSTask *task = [[NSTask alloc] init];
    
    //2
    task.launchPath = @"/bin/bash";
    task.arguments = @[@"-c",settings.startupScriptPath];
//    task.launchPath = settings.startupScriptPath;
    
    //3
//    NSString* speakingPhrase = self.phraseField.stringValue;
//    task.arguments  = @[speakingPhrase];
    [runningScriptField setStringValue:@"Running startup script.."];
    [viewRunningScript setHidden:NO];
    
    //4
    [task launch];
    
    
    //5
    if (waitForExit){
        [task waitUntilExit];
    }

    [viewRunningScript setHidden:YES];
    
    NSLog(@"Running startup script: EXIT");
}

-(IBAction)menuRunShutdownScript:(id)sender {
    if (viewMode != ModeNormal){
        return;
    }
    [self runShutdownScript:true];
}

-(void)runShutdownScript:(BOOL)waitForExit {
    if (![settings hasShutdownScriptPath]){
        return;
    }
    
    NSLog(@"Running shutdown script: START");
    
    //1
    NSTask *task = [[NSTask alloc] init];
    
    //2
    
    
    [runningScriptField setStringValue:@"Running shutdown script.."];
    [viewRunningScript setHidden:NO];
    
    task.launchPath = @"/bin/bash";
    task.arguments = @[@"-c",settings.shutdownScriptPath];
//    task.launchPath = settings.shutdownScriptPath;
    
    //3
    //    NSString* speakingPhrase = self.phraseField.stringValue;
    //    task.arguments  = @[speakingPhrase];
    
//    [windowShutdownScript makeKeyAndOrderFront:self];
    
    //4
    [task launch];
    
    //5
    if (waitForExit){
        [task waitUntilExit];
    }

        [viewRunningScript setHidden:YES];
    
//    [windowShutdownScript orderOut:self];
//    
//    [window orderFront:self];
    
    NSLog(@"Running shutdown script: EXIT");
    
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
    
    if ( ![settings hasSettingsURL]){
        [self menuPreferences:self];
    } else {
        [webView setMainFrameURL:settings.settingsURL];
    }
}

-(IBAction)menuReload:(id)sender {
    
    if ( ![settings hasTargetURL]){
        [self menuPreferences:self];
    } else {
        [webView setMainFrameURL:settings.targetURL];
    }
}


- (IBAction)menuNormalMode:(id)sender {
    
    if (viewMode == ModeNormal){
        return;
    }
    
    if ([settings requiresPassword]){
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
