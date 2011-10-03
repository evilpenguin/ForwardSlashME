// Appname: ForwardSlashME
// Creator: EvilPenguin && Maximus
// Creation Date: 9/20/2011
// Copyright (c) 2011 EvilPenguin && Maximus
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#define forwardSlashME_PLIST @"/var/mobile/Library/Preferences/com.understruction.forwardslashme.plist"
#define listenToNotification$withCallBack(notification, callback); 	\
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), \
        NULL, \
        (CFNotificationCallback)&callback, \
        CFSTR(notification), \
        NULL, \
        CFNotificationSuspensionBehaviorHold);

@interface CKSMSService  
 	- (id)_newSMSMessageWithText:(id)text forConversation:(id)conversation;
@end

static NSMutableDictionary *plistDict;
static BOOL isEnabled;
static void loadSettings(void) {
	NSLog(@"ForwardSlashME: just updating some settings. Nothing to see here, move along.");
	if (plistDict) {
		[plistDict release];
		plistDict = nil;
	}
	plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:forwardSlashME_PLIST];
	if (plistDict == nil) { plistDict = [[NSMutableDictionary alloc] init]; }
	isEnabled = [plistDict objectForKey:@"ForwardSlashMEEnabled"] ? [[plistDict objectForKey:@"ForwardSlashMEEnabled"] boolValue] : YES;
}

%hook CKSMSService
- (id)_newSMSMessageWithText:(id)text forConversation:(id)conversation {
	NSLog(@"ForwardSlashME: I take cookies, and I replace them with brownies: '%@'", text); 
	NSString *forwardSlashText = text;
	if (isEnabled) {
		if ([forwardSlashText hasPrefix:@"/me"]) {
			NSString *userName = [plistDict objectForKey:@"ForwardSlashMEUsername"] ? [plistDict objectForKey:@"ForwardSlashMEUsername"] : @"";
			forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@"/me" withString:[NSString stringWithFormat:@"*%@ ", userName]];
			forwardSlashText = [forwardSlashText stringByAppendingString:@"*"];
			forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@"  " withString:@" "];
			forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@"* " withString:@"*"];
			forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@" *" withString:@"*"];
		}
	}
	return %orig(forwardSlashText, conversation);
}
%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	listenToNotification$withCallBack("com.understruction.forwardslashme.update", loadSettings);
	loadSettings();
	[pool drain];
}