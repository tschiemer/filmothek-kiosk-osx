//
//  NSTransparentView.m
//  Filmothek
//
//  Created by Filou on 27/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "NSTransparentView.h"

@implementation NSTransparentView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
}

@end
