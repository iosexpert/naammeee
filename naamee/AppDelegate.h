//
//  AppDelegate.h
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *actualLocation;
- (CLLocation *)getlocation;
-(void)showLocationAlert;
@end

