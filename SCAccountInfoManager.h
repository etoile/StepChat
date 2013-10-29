/**
Copyright (C) 2012 Alessandro Sangiuliano
         
Author: Alessandro Sangiuliano <alex22_7@hotmail.com>
Date: January 2012        
License: Modified BSD
*/



#import <Foundation/Foundation.h>
#import <XMPPKit/XMPPAccount.h>

@interface SCAccountInfoManager : NSObject
{
	NSMutableString *__strong filePath;
	NSString *fileName;
	NSMutableString *gPath;
}

/**
 * The SCAccountInfoManager is a class to handle user account information,
 * like the JID. It also is used to store these informations.
 */
 
 /* This class is temporary. It was implemented to replace the AddressesKit
  * code, that at the time did work bad on Linux and FreeBSD, with 
  * not predictable behavior on 64 bit version of the two systems.
  * (this comment will be removed soon) <- FIXME
  */  
 

@property (strong, nonatomic, readonly) NSString *filePath; 

/**
 * Read the JID from a file and returns it.
 */
- (NSString*) readJIDFromFileAtPath:(NSString*)aPath;
/**
 * Write a JID to a file at a given path
 */
- (void) writeJIDToFile:(JID*)aJID atPath:(NSString*)aPath;
/**
 * Compose a new JID from an old one
 */
- (NSString*) composeNewJIDWithOldJID:(JID*)oldJID withServer:(NSString*)aServer;

@end
