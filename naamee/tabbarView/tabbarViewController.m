//
//  tabbarViewController.m
//  MYScores
//
//  Created by Apple on 05/09/16.
//  Copyright © 2016 SuperSports. All rights reserved.
//

#import "tabbarViewController.h"
#import "homeViewController.h"
#import "favoriateViewController.h"
#import "cameraViewController.h"
#import "notificationViewController.h"
#import "profileViewController.h"

@interface tabbarViewController ()

@end

@implementation tabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.viewControllers = [self initializeViewControllers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSArray *) initializeViewControllers
{
    
    homeViewController *hvc = [[homeViewController alloc]init];
    favoriateViewController *fvc = [[favoriateViewController alloc]init];
    cameraViewController *cvc = [[cameraViewController alloc]init];
    notificationViewController *nvc = [[notificationViewController alloc]init];
    profileViewController *pvc = [[profileViewController alloc]init];


    UIImage *img = [[UIImage imageNamed:@"home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *imgSelected = [[UIImage imageNamed:@"homeSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img1 = [[UIImage imageNamed:@"star"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected1 = [[UIImage imageNamed:@"star-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img2 = [[UIImage imageNamed:@"camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected2 = [[UIImage imageNamed:@"cameraSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img3 = [[UIImage imageNamed:@"notification"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
UIImage *imgSelected3 = [[UIImage imageNamed:@"bell"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *img4 = [[UIImage imageNamed:@"user"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected4 = [[UIImage imageNamed:@"profile-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //UIImage* tabBarBackground = [UIImage imageNamed:@"FullContact"];
    //[[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [UITabBar appearance].layer.borderWidth = 0.0f;
    [UITabBar appearance].clipsToBounds = true;
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:43/255.0 green:49/255.0 blue:53/255.0 alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:43/255.0 green:49/255.0 blue:53/255.0 alpha:1.0]];
    
    hvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img selectedImage:imgSelected];
    fvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img1 selectedImage:imgSelected1];
    cvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img2 selectedImage:imgSelected2];
    nvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img3 selectedImage:imgSelected3];
    pvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:img4 selectedImage:imgSelected4];

    
    hvc.navigationController.navigationBarHidden=true;
    fvc.navigationController.navigationBarHidden=true;
    cvc.navigationController.navigationBarHidden=true;
    nvc.navigationController.navigationBarHidden=true;
    pvc.navigationController.navigationBarHidden=true;

    hvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    fvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    cvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    nvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    pvc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:hvc];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:fvc];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:cvc];
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:nvc];
    UINavigationController *nav5=[[UINavigationController alloc]initWithRootViewController:pvc];

    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:nav1];
    [tabViewControllers addObject:nav2];
    [tabViewControllers addObject:nav3];
    [tabViewControllers addObject:nav4];
    [tabViewControllers addObject:nav5];

    
    return tabViewControllers;
   
}


@end
