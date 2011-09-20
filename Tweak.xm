// Appname: ForwardSlashME
// Creator: EvilPenguion && Maximus
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

@interface CKSMSService 
 	- (id)_newSMSMessageWithText:(id)text forConversation:(id)conversation;
@end

%hook CKSMSService
- (id)_newSMSMessageWithText:(id)text forConversation:(id)conversation {
	NSLog(@"ForwardSlashME: I take cookies, and I replace them with brownies: '%@'", text); 
	NSString *forwardSlashText = text;
	if ([forwardSlashText hasPrefix:@"/me"]) {
		forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@"/me" withString:@"*"];
		forwardSlashText = [forwardSlashText stringByAppendingString:@"*"];
		forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@"* " withString:@"*"];
		forwardSlashText = [forwardSlashText stringByReplacingOccurrencesOfString:@" *" withString:@"*"];
	}
	return %orig(forwardSlashText, conversation);
}

%end