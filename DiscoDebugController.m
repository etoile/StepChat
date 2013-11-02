#import "DiscoDebugController.h"
#import "JabberApp.h"
#import <XMPPKit/JID.h>

@implementation DiscoDebugController
- (IBAction) showWindow:(id)_sender
{
	/*addObserver for features */

	center = [NSNotificationCenter defaultCenter];	
	[center addObserver:self
		       selector:@selector(receivedInfoNotification:)
			       name:@"XMPPDiscoFeaturesFound"
				 object:nil];

	/*addObserver for items*/

	[center addObserver:self
		       selector:@selector(receivedItemsNotification:)
			       name:@"XMPPDiscoItemsFound"
				 object:nil];

	disco = [[[[NSApp delegate] account] roster] disco];
	[super showWindow:_sender];
}

- (void) discoFeaturesLog:(XMPPDiscoInfo*)anInfo
{
	NSInteger index = 0;
	NSArray *features = [info features];
	NSTextStorage *storage = [discoInfoBox textStorage];
	[storage beginEditing];
	for(index=0; index < [features count]; index++)
	{
		[[storage mutableString] appendString:[features objectAtIndex:index]];
		[[storage mutableString] appendString:@"\n"];
	}
	[storage endEditing];
}

- (void) discoItemsLog:(XMPPDiscoItems*)anItem
{
	NSInteger index = 0;
	NSTextStorage *storage = [discoItemBox textStorage];
	NSArray *itemsSet = [anItem items];
	[storage beginEditing];
	for (index=0; index < [itemsSet count]; index++)
	{
		NSEnumerator *enumerator = [[itemsSet objectAtIndex:index] objectEnumerator];
		id value;
		while ((value = [enumerator nextObject]))
		{
			[[storage mutableString] appendString:value];
			[[storage mutableString] appendString:@"\n"];
		}
	}
	[storage endEditing];
}

- (IBAction) serviceDiscovery:(id)sender
{
	NSString * xmlnsXMPPDiscoInfo = @"http://jabber.org/protocol/disco#info";
	NSString * xmlnsXMPPDiscoItems = @"http://jabber.org/protocol/disco#items";
	info = [disco info];
	discoItems = [disco items];
	XMPPConnection *connection;

	if (discoItems == nil)
	{
		connection = [[[NSApp delegate] account] connection];
		NSString *server = [connection server];
		[disco sendQueryToJID:server node:nil inNamespace:xmlnsXMPPDiscoItems];
	}
	else
	{
		[self discoItemsLog:discoItems];
	}

	if (info == nil)
	{
		connection = [[[NSApp delegate] account] connection];
		NSString *server = [connection server];
		[disco sendQueryToJID:server node:nil inNamespace:xmlnsXMPPDiscoInfo];
	}
	else
	{
		[self  discoFeaturesLog: info];
	}

}

- (void) receivedItemsNotification:(NSNotification*) aNotification
{
	discoItems = [disco items];
	[self discoItemsLog:discoItems];
}

- (void) receivedInfoNotification:(NSNotification*) aNotification
{
	info = [disco info];
	[self discoFeaturesLog:info];
}

- (IBAction) closeWindow:(id)sender
{
	[discoItemBox setString:@""];
	[discoInfoBox setString:@""];
	[center removeObserver:self
		              name:@"XMPPDiscoFeaturesFound"
					object:nil];
	[center removeObserver:self
		              name:@"XMPPDiscoItemsFound"
					object:nil];

	if ([[self window] isVisible])
		[[self window] orderOut:self];
}

@end
