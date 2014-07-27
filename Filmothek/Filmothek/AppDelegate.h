//
//  AppDelegate.h
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Quartz/Quartz.h>

#import "SettingsWindowDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, SettingsClient, NSTextFieldDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSMenuItem *menuItemQuit;
@property (assign) IBOutlet NSMenuItem *menuItemNormalMode;
@property (assign) IBOutlet NSMenuItem *menuItemKioskMode;

@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSImageView *webFreezeView;

@property (assign) IBOutlet NSView *aboutView;

@property (assign) IBOutlet NSWindow *preferencesWindow;
@property (assign) IBOutlet SettingsWindowDelegate *settingsWindowDelegate;
@property (retain) Settings * settings;


@property (assign) IBOutlet NSView *passwordView;
@property (assign) IBOutlet NSSecureTextField *passwordText;


@end
