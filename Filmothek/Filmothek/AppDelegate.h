//
//  AppDelegate.h
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "SettingsWindowDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, SettingsClient>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;

@property (assign) IBOutlet NSWindow *aboutWindow;
@property (assign) IBOutlet NSWindow *preferencesWindow;
@property (assign) IBOutlet NSWindow *passwordWindow;
@property (assign) IBOutlet NSView *passwordView;
@property (assign) IBOutlet NSSecureTextField *passwordText;

@property (assign) IBOutlet NSMenuItem *menuItemNormalMode;
@property (assign) IBOutlet NSMenuItem *menuItemKioskMode;

@property (assign) IBOutlet SettingsWindowDelegate *settingsWindowDelegate;
@property (retain) Settings * settings;

@end
