/**
 Copyright (C) 2013 Alessandro Sangiuliano
 
 Author: Alessandro Sangiuliano <alex22_7@hotmail.com>
 Date: 7 November 2013
 License: Modified BSD
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <XMPPKit/XMPPServiceDiscovery.h>
#import <XMPPKit/XMPPDiscoInfo.h>
#import <XMPPKit/XMPPDiscoItems.h>


@interface DiscoDebugController : NSWindowController
{
	IBOutlet NSTextView *discoInfoBox;
	IBOutlet NSTextView *discoItemBox;
	XMPPServiceDiscovery *disco;
	XMPPDiscoInfo *info;
	XMPPDiscoItems *discoItems;
	NSNotificationCenter *center;
}

- (IBAction) showWindow:(id)_sender;
- (IBAction) serviceDiscovery:(id)sender;
- (IBAction) closeWindow:(id)sender;
@end
