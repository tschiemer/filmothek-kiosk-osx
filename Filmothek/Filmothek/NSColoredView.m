//
//  NSColoredView.m
//  Filmothek
//
//  Created by Filou on 27/07/14.
//  Copyright (c) 2014 filou.se. All rights reserved.
//

#import "NSColoredView.h"

@implementation NSColoredView

@synthesize backgroundColor;

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//    }
//    return self;
//}

- (void)drawRect:(NSRect)dirtyRect
{
    [backgroundColor set];
    NSRectFill(dirtyRect);
//
//    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSetRGBFillColor(context, [backgroundColor redComponent],[backgroundColor greenComponent],[backgroundColor blueComponent],[backgroundColor alphaComponent]);
//    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
}

@end
