//
//  ViewController.m
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "ViewController.h"
#import "loginViewController.h"
#import "registerViewController.h"
#import "forgotPasswordViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

//#import <TwitterCore/TwitterCore.h>
//#import <TwitterKit/TWTRKit.h>


#import "Helper.h"
#import "AFNetworking.h"
#import "tabbarViewController.h"

@interface ViewController ()
{
    UIImageView *backgroundImage;
}
@end

@implementation ViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
    
    
    
    NSString *title=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    
    if ( (title == (id)[NSNull null] || title.length == 0 ))
    {
        
       
        
    }
    else
    {
       
        tabbarViewController *fpvc=[[tabbarViewController alloc]init];
        UINavigationController *navControl=[[UINavigationController alloc]initWithRootViewController:fpvc];
        navControl.navigationBarHidden=true;
        [[[UIApplication sharedApplication] delegate] window].rootViewController=navControl;
        
    }
    
    
    
    
    
    
    
    
    
    self.navigationController.navigationBarHidden=YES;
    
    NSArray *animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"bg1.jpg"],[UIImage imageNamed:@"bg2.jpg"],[UIImage imageNamed:@"bg3.jpg"],[UIImage imageNamed:@"bg4.jpg"],[UIImage imageNamed:@"bg5.jpg"], nil];
    backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.animationImages=animationImages;
    [backgroundImage setAnimationDuration:6.0];
    backgroundImage.animationRepeatCount = 0;
    [self.view addSubview:backgroundImage];
    [backgroundImage startAnimating];
    
    
    
    UIImageView *logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 60, 200, 65)];
    logoimage.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:logoimage];
    
    
    
    UIFont * myFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    CGRect labelFrame = CGRectMake (20, 135, self.view.frame.size.width-40, 55);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=2;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    [label setText:@"Connect with like-minded people all over the world."];
    [self.view addSubview:label];
    
    UIButton *namelogin = [UIButton buttonWithType:UIButtonTypeCustom];
    namelogin.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    namelogin.layer.cornerRadius=3;
    [namelogin setTitle:@"Log In" forState:UIControlStateNormal];
    [namelogin addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    namelogin.frame = CGRectMake(30, self.view.frame.size.height/2-60, self.view.frame.size.width-60, 50);
    [self.view addSubview:namelogin];
    
    UIImageView *nlogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    nlogo.image=[UIImage imageNamed:@"n-logo"];
    UIImage *image = [nlogo.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [nlogo setTintColor:[UIColor whiteColor]];
    [nlogo setImage:image];
    [namelogin addSubview:nlogo];
    
    UIButton *fbLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLogin.layer.cornerRadius=3;
    [fbLogin setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [fbLogin addTarget:self action:@selector(FBLogin:) forControlEvents:UIControlEventTouchUpInside];
    fbLogin.backgroundColor=[UIColor colorWithRed:48/255.0 green:72/255.0 blue:118/255.0 alpha:1.0];
    fbLogin.frame = CGRectMake(30, self.view.frame.size.height/2, self.view.frame.size.width-60, 50);
    [self.view addSubview:fbLogin];
    
    UIImageView *fblogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    fblogo.image=[UIImage imageNamed:@"fb_start"];
    UIImage *image1 = [fblogo.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [fblogo setTintColor:[UIColor whiteColor]];
    [fblogo setImage:image1];
    [fbLogin addSubview:fblogo];
    
    
    
    UIButton *twiterLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [twiterLogin addTarget:self action:@selector(TWLogin:) forControlEvents:UIControlEventTouchUpInside];
    twiterLogin.layer.cornerRadius=3;
    [twiterLogin setTitle:@"Login with Twitter" forState:UIControlStateNormal];
    twiterLogin.backgroundColor=[UIColor colorWithRed:66/255.0 green:138/255.0 blue:186/255.0 alpha:1.0];
    twiterLogin.frame = CGRectMake(30, self.view.frame.size.height/2+60, self.view.frame.size.width-60, 50);
    [self.view addSubview:twiterLogin];

    UIImageView *twlogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    twlogo.image=[UIImage imageNamed:@"twitter_star"];
    UIImage *image2 = [twlogo.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [twlogo setTintColor:[UIColor whiteColor]];
    [twlogo setImage:image2];
    [twiterLogin addSubview:twlogo];
    
    UIButton *signUP = [UIButton buttonWithType:UIButtonTypeCustom];
    signUP.layer.cornerRadius=3;
    [signUP setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUP.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.35];
    [signUP addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    signUP.frame = CGRectMake(30, self.view.frame.size.height/2+120, self.view.frame.size.width-60, 50);
    [self.view addSubview:signUP];
    
    
    
    UILabel *fotterlabel = [[UILabel alloc] initWithFrame:CGRectMake (20, self.view.frame.size.height-75, self.view.frame.size.width-40, 55)];
    [fotterlabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    fotterlabel.lineBreakMode=NSLineBreakByWordWrapping;
    fotterlabel.numberOfLines=2;
    fotterlabel.textColor=[UIColor whiteColor];
    fotterlabel.textAlignment=NSTextAlignmentCenter;
    fotterlabel.backgroundColor=[UIColor clearColor];
    [fotterlabel setText:@"By signing in you are agree to our Privacy Policy and Terms of Services"];
    [self.view addSubview:fotterlabel];
    
    
    
}

- (IBAction)Login:(id)sender
{
    loginViewController *lvc=[[loginViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
}
- (IBAction)FBLogin:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [self getFacebookDetails];

    }
    else
    {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self getFacebookDetails];
         }
     }];
    }
}
- (IBAction)TWLogin:(id)sender
{
    
//    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
//        if (session) {
//            NSLog(@"signed in as %@", [session userName]);
//        } else {
//            NSLog(@"error: %@", [error localizedDescription]);
//        }
//    }];
//    
//    
//    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
//    [client requestEmailForCurrentUser:^(NSString *email, NSError *error) {
//        if (email) {
//            NSLog(@"signed in as %@", email);
//        } else {
//            NSLog(@"error: %@", [error localizedDescription]);
//        }
//        
//    }];
}
- (IBAction)signup:(id)sender
{
    registerViewController *lvc=[[registerViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
}
-(void)getFacebookDetails
{
    //[Helper showIndicatorWithText:@"Embarking..." inView:self.view];
    FBSDKAccessToken *access_token=[FBSDKAccessToken currentAccessToken];
    NSString  *token = access_token.tokenString;
    NSLog(@"FB Token: %@", token);
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email" forKey:@"fields"];
    FBSDKGraphRequest *request=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:parameters];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (result)
         {

             NSLog(@"Result: %@", result);
             NSString *email=@"";
             if ([result objectForKey:@"email"])
             {
                 email=[result objectForKey:@"email"];
             }
             NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"token"]);
             NSDictionary *paramss=@{
                                     @"method"     :@"socialLogin",
                                     @"email"      :email,
                                     @"fullname"   :[result objectForKey:@"name"],
                                     //@"twit_id"    :@"",
                                     @"face_id"    :[result objectForKey:@"id"],
                                     @"deviceType" :@"0",
                                     @"deviceToken":@"1234567890",
                                     };
             
             [Helper showIndicatorWithText:@"Signing up..." inView:self.view];
             
             NSLog(@"Request: %@", paramss);
             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
             manager.responseSerializer = [AFHTTPResponseSerializer serializer];
             manager.responseSerializer.acceptableContentTypes = nil;
             [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:paramss progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                 NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:kNilOptions
                                                                        error:nil];
                 NSLog(@"JSON: %@", json);
                 [Helper hideIndicatorFromView:self.view];
                 if ([[json objectForKey:@"code"]integerValue]==1)
                 {
                     NSString *uid = [json objectForKey:@"uid"];
                     [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"userid"];
                     [[NSUserDefaults standardUserDefaults] synchronize];

                     tabbarViewController *fpvc=[[tabbarViewController alloc]init];
                     [fpvc setSelectedIndex:4];
                     [[[UIApplication sharedApplication] delegate] window].rootViewController=fpvc;
                 }
                 else
                 {
                     
                     [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
                     
                 }
                 
                 
             } failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
                 
                 [Helper hideIndicatorFromView:self.view];
                 
             }];
         }
         else
         {
//             [Helper hideIndicatorFromView:self.view];
             [[[UIAlertView alloc]initWithTitle:@"failed" message:@"Facebook authentication failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         }
     }];
}
@end
