//
//  OAuthClientController.m
//  MPOAuthConnection
//
//  Created by Karl Adam on 08.12.05.
//  Copyright 2008 matrixPointer. All rights reserved.
//

#import "OAuthClientController.h"

@implementation OAuthClientController

- (id)init {
	if (self = [super init]) {		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenReceived:) name:MPOAuthNotificationRequestTokenReceived object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:MPOAuthNotificationAccessTokenReceived object:nil];
	}
	return self;
}

- (oneway void)dealloc {
	[_oauthAPI release];
	
	[super dealloc];
}

- (void)awakeFromNib {
	if (_oauthAPI) {
		[tokenProgressIndicator setHidden:NO];
		[tokenProgressIndicator startAnimation:self];
	}
}

- (void)requestTokenReceived:(NSNotification *)inNotification {
	[tokenProgressIndicator stopAnimation:self];
}

- (void)accessTokenReceived:(NSNotification *)inNotification {
	[accessProgressIndicator stopAnimation:self];
}

- (IBAction)performAuthentication:(id)sender {
	if (!_oauthAPI) {
		NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:	[consumerKeyField stringValue], kMPOAuthCredentialConsumerKey,
																				[consumerSecretField stringValue], kMPOAuthCredentialConsumerSecret,
																				nil];
		_oauthAPI = [[MPOAuthAPI alloc] initWithCredentials:credentials
										  authenticationURL:[NSURL URLWithString:[authenticationURLField stringValue]]
												 andBaseURL:[NSURL URLWithString:[baseURLField stringValue]]];	
		id authMethod = _oauthAPI.authenticationMethod;
		if ( [authMethod isKindOfClass: [MPOAuthAuthenticationMethodOAuth class]] )
			[authMethod setDelegate: self];
	} else {
		[_oauthAPI authenticate];
	}
}

- (IBAction)getUserAccess:(id)sender {
	if (!_oauthAPI) {
		NSAlert * alert = [[NSAlert alertWithMessageText: NSLocalizedString(@"Not Initialized", @"")
										   defaultButton: NSLocalizedString(@"OK", @"")
										 alternateButton: @""
											 otherButton: @""
							   informativeTextWithFormat: NSLocalizedString(@"Please enter credentials and click Request Token first.", @"")] retain];
		[NSApp beginSheetModalForWindow: [alert window] completionHandler: ^(NSInteger result) {
			[alert autorelease];
		}];
		return;
	}
	
	[pinField resignFirstResponder];	// ensure it's not still in the middle of editing
	if ( [[pinField stringValue] length] == 0 )
	{
		NSAlert * alert = [[NSAlert alertWithMessageText: NSLocalizedString(@"No PIN", @"")
										   defaultButton: NSLocalizedString(@"OK", @"")
										 alternateButton: @""
											 otherButton: @""
							   informativeTextWithFormat: NSLocalizedString(@"Please enter your verifier/PIN code in the provided field.", @"")] retain];
		[NSApp beginSheetModalForWindow: [alert window] completionHandler: ^(NSInteger result) {
			[alert autorelease];
		}];
		return;
	}
	
	[_oauthAPI authenticate];
}

- (IBAction)performMethod:(id)sender {
	[_oauthAPI performMethod:[methodField stringValue] withTarget:self andAction:@selector(performedMethodLoadForURL:withResponseBody:)];
}

- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody {
	[responseBodyView setString:inResponseBody];
}

#pragma mark -
#pragma mark MPOAuthAuthenticationMethodOAuthDelegate Protocol

- (NSString *) oauthVerifierForCompletedUserAuthorization
{
	return ( [pinField stringValue] );
}

@end
