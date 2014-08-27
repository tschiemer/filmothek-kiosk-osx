//
//  Settings.h
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject {
    NSString * targetURL;
    NSString * settingsURL;
    
    Boolean passwordRequired;
    NSString * password;
    
    Boolean autostartOn;
    Boolean autostartIntoKioskMode;
    
    NSString * startupScriptPath;
    NSString * shutdownScriptPath;
}

@property (copy,atomic) NSString * targetURL;
@property (copy,atomic) NSString * settingsURL;

@property (assign,atomic) Boolean passwordRequired;
@property (copy,atomic) NSString * password;

@property (assign,atomic) Boolean autostartOn;
@property (assign,atomic) Boolean autostartIntoKioskMode;

@property (copy,atomic) NSString * startupScriptPath;
@property (copy,atomic) NSString * shutdownScriptPath;

- (Boolean) loadFromResource:(NSString *)resourceName;
- (Boolean) saveToResource:(NSString *)resourceName;


- (Boolean) hasTargetURL;
- (Boolean) hasSettingsURL;
- (Boolean) requiresPassword;
- (Boolean) hasStartupScriptPath;
- (Boolean) hasShutdownScriptPath;

@end
