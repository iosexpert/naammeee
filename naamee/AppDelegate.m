//
//  AppDelegate.m
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <TwitterCore/TwitterCore.h>
//#import <TwitterKit/TWTRKit.h>
#import "ViewController.h"
#import "tabbarViewController.h"
@import GoogleMaps;
@import GooglePlaces;

//#import <TwitterKit/TwitterKit.h>

@interface AppDelegate ()
{
    
}
@end

@implementation AppDelegate
@synthesize locationManager, actualLocation;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"exploreWord"];
    [[NSUserDefaults standardUserDefaults] setObject:@"12345678" forKey:@"token"];

    
   // [[Twitter sharedInstance] startWithConsumerKey:@"xt0ksfzfNpIEqdCZKMwc3ap9D" consumerSecret:@"ut3yOYxVawBvg54diR80bPKhuCqM89Od4fKUcXWU4kGKL7sgbM"];
    
    
    // Intialize Location Manager Delagate
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.headingFilter = 1;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    // Change status bar color to white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Register Push notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
   
    [GMSServices provideAPIKey:@"AIzaSyCp_5j5XgNymoXiDeJ2Aqe_IzwiE2taGFE"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCp_5j5XgNymoXiDeJ2Aqe_IzwiE2taGFEQ"];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark  Push Notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"]==nil)
    {
        NSLog(@"My token is: %@", deviceToken);
        const unsigned *tokenBytes = [deviceToken bytes];
        NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
        NSLog(@"Hex=%@",hexToken);
        [defaults setObject:hexToken forKey:@"token"];
        [defaults synchronize];
    }
    else
    {
        NSLog(@"Already has token");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Notification %@",userInfo);
    
    if ( application.applicationState == UIApplicationStateActive )
    {
        
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    if ([[options valueForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.facebook.Facebook"])
//    {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
     return handled;
//    }
//    else
//    {
//        return [[Twitter sharedInstance] application:application openURL:url options:options];
//    }
    return true;
}
#pragma mark  Location Manager Delegate

- (CLLocation *)getlocation
{
    if (actualLocation.coordinate.latitude!=0.0 && actualLocation.coordinate.longitude!=0.0)
    {
        return actualLocation;
    }
    else
    {
        locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestAlwaysAuthorization];
        }
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
    }
    return actualLocation;
}

- (void)locationManager:(CLLocationManager*)aManager didFailWithError:(NSError*)anError
{
    switch([anError code])
    {
        case kCLErrorLocationUnknown: // location is currently unknown, but LM will keep trying
            break;
            
        case kCLErrorDenied: // CL access has been denied (eg, user declined location use)
        {
            NSLog(@"user has denied");
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLocationServceEnabled"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
            
        case kCLErrorNetwork: // general, network-related error
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Status %u",status);
    if (status==2)
    {
        NSLog(@"Denied");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLocationServceEnabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (status==3 || status==4)
    {
        NSLog(@"Accepted");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLocationServceEnabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    actualLocation=locations[0];
    [locationManager stopUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"heading" object:newHeading];
    [locationManager stopUpdatingHeading];
}

-(void)showLocationAlert
{
    [[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You don't have Location Service enabled for this app. For optimal use of this app please enable location service. Go to Settings-> Privacy-> Location Service-> Naamee on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
