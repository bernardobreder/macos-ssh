//
//  AppDelegate.m
//  Ssh
//
//  Created by Bernardo Breder on 6/2/15.
//  Copyright (c) 2015 Tecgraf. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *disconnectButton;
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSTextField *username;
@property (weak) IBOutlet NSTextField *url1;
@property (weak) IBOutlet NSTextField *url2;
@property (weak) IBOutlet NSTextField *url3;
@property (weak) IBOutlet NSTextField *url4;
@property (weak) IBOutlet NSTextField *url5;
@property (weak) IBOutlet NSTextField *url6;
@property (weak) IBOutlet NSTextField *url7;
@property (weak) IBOutlet NSTextField *url8;
@property (weak) IBOutlet NSTextField *url9;
@property (weak) IBOutlet NSTextField *url10;
@property (nonatomic, strong) NSTask *task;
@property (nonatomic, strong) NSPipe *inPipe;
@property (nonatomic, strong) NSPipe *outPipe;
@property (nonatomic, strong) NSPipe *errPipe;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self loadUserPreferences];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [self storeUserPreferences];
    if (_task) [_task terminate];
}

- (IBAction)showHelp:(NSMenuItem*)menu
{
    NSString *username = [_username.stringValue stringByAppendingString:@"@ssh.tecgraf.puc-rio.br"];
    if (_username.stringValue.length == 0) {
        username = @"<<username>>@ssh.tecgraf.puc-rio.br";
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"How to connect to SSH without Password in Terminal:";
    alert.informativeText = [NSString stringWithFormat:@"cd ~\n\nssh-keygen -t rsa\n\nssh %@ mkdir -p .ssh\n\ncat .ssh/id_rsa.pub | ssh %@ 'cat >> .ssh/authorized_keys'", username, username];
    [alert addButtonWithTitle:@"Ok"];
    [alert beginSheetModalForWindow:_window completionHandler:nil];
}

- (IBAction)showPreference:(NSMenuItem*)menu
{
    [self showHelp:menu];
}

- (IBAction)onDisconnectAction:(NSButton*)button
{
    [self storeUserPreferences];
    if (_task) {
        [_inPipe.fileHandleForWriting writeData:[@"logout\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [_task terminate];
        _task = nil;
    }
    _disconnectButton.enabled = false;
}

- (IBAction)onConnectAction:(NSButton*)button
{
    [self storeUserPreferences];
    if (_task) [_task terminate];
    if (_username.stringValue.length == 0) return;
    
    NSString *username = [_username.stringValue stringByAppendingString:@"@ssh.tecgraf.puc-rio.br"];
    NSString *url1 = _url1.stringValue;
    NSString *url2 = _url2.stringValue;
    NSString *url3 = _url3.stringValue;
    NSString *url4 = _url4.stringValue;
    NSString *url5 = _url5.stringValue;
    NSString *url6 = _url6.stringValue;
    NSString *url7 = _url7.stringValue;
    NSString *url8 = _url8.stringValue;
    NSString *url9 = _url9.stringValue;
    NSString *url10 = _url10.stringValue;
    
    _task = [[NSTask alloc] init];
    _inPipe = [NSPipe pipe];
    _outPipe = [NSPipe pipe];
    _errPipe = [NSPipe pipe];
    [_task setStandardInput:_inPipe];
    [_task setStandardInput:_outPipe];
    [_task setStandardInput:_errPipe];
    [_task setLaunchPath: @"/bin/sh"];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    [arguments addObject:@"-c"];
    NSMutableString *command = [[NSMutableString alloc] init];
    [command appendString:@"ssh"];
    if (url1.length > 0) [command appendString:([@" -L5000:" stringByAppendingString:url1])];
    if (url2.length > 0) [command appendString:([@" -L5001:" stringByAppendingString:url2])];
    if (url3.length > 0) [command appendString:([@" -L5002:" stringByAppendingString:url3])];
    if (url4.length > 0) [command appendString:([@" -L5003:" stringByAppendingString:url4])];
    if (url5.length > 0) [command appendString:([@" -L5004:" stringByAppendingString:url5])];
    if (url6.length > 0) [command appendString:([@" -L5005:" stringByAppendingString:url6])];
    if (url7.length > 0) [command appendString:([@" -L5006:" stringByAppendingString:url7])];
    if (url8.length > 0) [command appendString:([@" -L5007:" stringByAppendingString:url8])];
    if (url9.length > 0) [command appendString:([@" -L5008:" stringByAppendingString:url9])];
    if (url10.length > 0) [command appendString:([@" -L5009:" stringByAppendingString:url10])];
    [command appendString:@" "];
    [command appendString:username];
    [arguments addObject:command];
    [_task setArguments: arguments];
    [_task launch];
//    AppDelegate *app = self;
//    _task.terminationHandler = ^(NSTask* task) {
//        [NSOperationQueue.mainQueue addOperationWithBlock:^() {
//            [app showHelp:nil];
//        }];
//    };
    _disconnectButton.enabled = true;
}

- (void)loadUserPreferences
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    if ([defaults stringForKey:@"username"]) _username.stringValue = [defaults stringForKey:@"username"];
    if ([defaults stringForKey:@"url1"]) _url1.stringValue = [defaults stringForKey:@"url1"];
    if ([defaults stringForKey:@"url2"]) _url2.stringValue = [defaults stringForKey:@"url2"];
    if ([defaults stringForKey:@"url3"]) _url3.stringValue = [defaults stringForKey:@"url3"];
    if ([defaults stringForKey:@"url4"]) _url4.stringValue = [defaults stringForKey:@"url4"];
    if ([defaults stringForKey:@"url5"]) _url5.stringValue = [defaults stringForKey:@"url5"];
    if ([defaults stringForKey:@"url6"]) _url6.stringValue = [defaults stringForKey:@"url6"];
    if ([defaults stringForKey:@"url7"]) _url7.stringValue = [defaults stringForKey:@"url7"];
    if ([defaults stringForKey:@"url8"]) _url8.stringValue = [defaults stringForKey:@"url8"];
    if ([defaults stringForKey:@"url9"]) _url9.stringValue = [defaults stringForKey:@"url9"];
    if ([defaults stringForKey:@"url10"]) _url10.stringValue = [defaults stringForKey:@"url10"];
}

- (void)storeUserPreferences
{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    [defaults setValue:_username.stringValue forKey:@"username"];
    [defaults setValue:_url1.stringValue forKey:@"url1"];
    [defaults setValue:_url2.stringValue forKey:@"url2"];
    [defaults setValue:_url3.stringValue forKey:@"url3"];
    [defaults setValue:_url4.stringValue forKey:@"url4"];
    [defaults setValue:_url5.stringValue forKey:@"url5"];
    [defaults setValue:_url6.stringValue forKey:@"url6"];
    [defaults setValue:_url7.stringValue forKey:@"url7"];
    [defaults setValue:_url8.stringValue forKey:@"url8"];
    [defaults setValue:_url9.stringValue forKey:@"url9"];
    [defaults setValue:_url10.stringValue forKey:@"url10"];
    [defaults synchronize];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return true;
}

@end