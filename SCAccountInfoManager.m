/**
Copyright (C) 2012 Alessandro Sangiuliano
         
Author: Alessandro Sangiuliano <alex22_7@hotmail.com>
Date: January 2012        
License: Modified BSD
*/

#import "SCAccountInfoManager.h"

@implementation SCAccountInfoManager

- (id)init
{
	self = [super init];
	NSError *error;
	BOOL created = NO, isDir = YES;
		
    NSArray *libraryDirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	
    gPath = [[[libraryDirs objectAtIndex: 0]
                      stringByAppendingPathComponent: @"Addresses"] mutableCopy];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL exist = [fileManager fileExistsAtPath:gPath isDirectory:&isDir];
	if (!exist)
		created = [[NSFileManager defaultManager] createDirectoryAtPath: gPath
                                                 withIntermediateDirectories: YES
                                                                  attributes: nil
                                                                       error: &error];
    
    if (!created && !exist )
		NSLog(@"Create directory error: %@", error);
    
    /* This will create the correct path to save the waJID in the Addresses directory
    * otherwise the path created will be: <parentsDirectories...>/AddresseswaJID,
    * that's wrong
    */
    [gPath appendString:@"/"];
    
	fileName = @"waJID";
	filePath = [[NSMutableString alloc] initWithString:gPath];
	[filePath appendString:fileName];
	return self;
}

@synthesize filePath; 

-(NSString*)readJIDFromFileAtPath:(NSString*)aPath
{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSData *contents;
  
	if ([fileManager fileExistsAtPath:aPath] == YES)
	{
		NSFileHandle *fileHandler = [NSFileHandle fileHandleForReadingAtPath:aPath];
		contents = [fileHandler readDataToEndOfFile];
		[fileHandler closeFile];
	}
	else
	{
		[fileManager createFileAtPath:aPath contents:nil attributes:nil];
		return @"N";
	}
  
	if ([contents length] == 0)
	{
		return @"N";
	}
  
	NSString *jid = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
	return jid;
}

-(void)writeJIDToFile:(JID*)aJID atPath:(NSString*)aPath
{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
  
	if ([fileManager fileExistsAtPath:aPath] == YES)
	{
		NSString *jid = [aJID jidString];
		BOOL done = [jid writeToFile:aPath 
                          atomically:NO 
                            encoding:NSUTF8StringEncoding 
                               error:NULL];

		if (done == NO)
		{
			[NSAlert alertWithMessageText:@"Can't write to file"
                            defaultButton:@"OK"
                          alternateButton:nil
                              otherButton:nil
                informativeTextWithFormat:@""];
		}
	}
	else
	{
		[fileManager createFileAtPath:aPath contents:nil attributes:nil];
		NSString *jid = [aJID jidString];
		BOOL done = [jid writeToFile:aPath 
                          atomically:NO 
                            encoding:NSUTF8StringEncoding 
                               error:NULL];
    
		if (done == NO)
		{
			[NSAlert alertWithMessageText:@"Can't write to file"
                            defaultButton:@"OK"
                          alternateButton:nil
                              otherButton:nil
                informativeTextWithFormat:@""];
		}
	}
}

@end
    
