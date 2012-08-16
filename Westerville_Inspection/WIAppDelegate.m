/*
 WIAppDelegate.m
 Westerville Inspection Demo -- Esri 2012 Dev Summit
 Copyright © 2012 Esri
 
 All rights reserved under the copyright laws of the United States
 and applicable international laws, treaties, and conventions.
 
 You may freely redistribute and use this sample code, with or
 without modification, provided you include the original copyright
 notice and use restrictions.
 
 See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
 
 */

#import "WIAppDelegate.h"
#import "WIDeskViewController.h"
#import "Reachability.h"

@implementation WIAppDelegate

@synthesize window              = _window;
@synthesize deskViewController  = _deskViewController;
@synthesize wifiReachability    = _wifiReachability;

- (void)dealloc
{
    self.window             = nil;
    self.deskViewController = nil;
    self.wifiReachability   = nil;

    [super dealloc];
}

-(BOOL)application:(UIApplication *)application 
           openURL:(NSURL *)url 
 sourceApplication:(NSString *)sourceApplication 
        annotation:(id)annotation 
{    
    // Make sure url indicates a file (as opposed to, e.g., http://)
    if (url != nil) {
        if([url isFileURL])
        {
            [self.deskViewController handleDocumentOpenURL:url];
        }
        else
        {
            [self.deskViewController handleApplicationURL:url];
        }
    }

    // Indicate that we have successfully opened the URL
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    
    //Wifi Connectivity
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
    
    
    self.deskViewController = [[[WIDeskViewController alloc] init] autorelease];
    
    self.window.rootViewController = self.deskViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
