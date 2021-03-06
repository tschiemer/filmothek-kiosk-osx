//
//  Settings.m
//  Filmothek
//
//  Created by Filou on 23/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "Settings.h"

@implementation Settings


const NSString * targetURLKey = @"targetURL";
const NSString * settingsURLKey = @"settingsURL";
const NSString * passwordRequiredKey = @"passwordRequired";
const NSString * passwordKey = @"password";
const NSString * autostartOnKey = @"autostartOn";
const NSString * autostartIntoKioskModeKey = @"autostartIntoKioskMode";
const NSString * startupScriptPathKey = @"startupScriptPath";
const NSString * shutdownScriptPathKey = @"shutdownScriptPath";


@synthesize targetURL, settingsURL, password, passwordRequired, autostartOn, autostartIntoKioskMode, startupScriptPath, shutdownScriptPath;

- (Boolean) hasTargetURL {
    return [targetURL length] > 0;
}

- (Boolean) hasSettingsURL {
    return [settingsURL length] > 0;
}

- (Boolean) requiresPassword {
    return passwordRequired && [password length] > 0;
}

- (Boolean) hasStartupScriptPath {
    return [startupScriptPath length] > 0;
}

- (Boolean) hasShutdownScriptPath {
    return [shutdownScriptPath length] > 0;
}


- (Boolean) loadFromResource:(NSString *)resourceName {
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString  *plistPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"plist"];
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return false;
    }
    
    self.targetURL = [temp objectForKey:targetURLKey];
    self.settingsURL = [temp objectForKey:settingsURLKey];
    self.passwordRequired = [[temp objectForKey:passwordRequiredKey]  boolValue];
    self.password = [temp objectForKey:passwordKey];
    self.autostartOn = [[temp objectForKey:autostartOnKey]  boolValue];
    self.autostartIntoKioskMode = [[temp objectForKey:autostartIntoKioskModeKey]  boolValue];
    self.startupScriptPath = [temp objectForKey:startupScriptPathKey];
    self.shutdownScriptPath = [temp objectForKey:shutdownScriptPathKey];
    
    return true;
}


- (Boolean)saveToResource:(NSString*)resourceName {
    NSString * error;
    NSString  *plistPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"plist"];
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                                   targetURL, settingsURL, [NSNumber numberWithBool:passwordRequired], password, [NSNumber numberWithBool:autostartOn], [NSNumber numberWithBool:autostartIntoKioskMode], startupScriptPath, shutdownScriptPath,nil
                                                                   ]
                                                          forKeys:[NSArray arrayWithObjects:
                                                                   targetURLKey, settingsURLKey,passwordRequiredKey, passwordKey, autostartOnKey, autostartIntoKioskModeKey, startupScriptPathKey, shutdownScriptPathKey,nil
                                                                   ]];
    
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
        return true;
    }
    else {
        NSLog(error);
        return false;
    }
}


@end
