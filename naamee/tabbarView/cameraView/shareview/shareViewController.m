//
//  shareViewController.m
//  naamee
//
//  Created by mac on 05/10/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "shareViewController.h"
#import "AppDelegate.h"
#import "Helper.h"
#import <Social/Social.h>
#import "AFNetworking.h"
#import "locationSearchViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKShareKit/FBSDKShareKit.h>
@interface shareViewController ()<UITextViewDelegate>
{
    UIImageView *mainImageView;
    UITextView *captionView;
    UIButton *moodBtn,*locationBtn,*wearingBtn,*watchingBtn,*listeningBtn,*whereBtn;
    UIButton *fbShare,*twiterShare,*folowersBtn,*youBtn,*shareBtn;
    UIView *selectionViewShown;
    int selectedShareMethod,isAddLocation;
    
    NSString *moodStr, *wearing, *listening, *watching, *where, *hashtags,*adressString,*lat,*lon;
    
    UILabel *moodlbl, *wearinglbl, *listeninglbl, *watchinglbl, *wherelbl, *hashtagslbl;

    int hashh;
    
}
@end

@implementation shareViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    adressString=[[NSUserDefaults standardUserDefaults]valueForKey:@"loc"];
    lat=[[NSUserDefaults standardUserDefaults]valueForKey:@"loclat"];
    lon=[[NSUserDefaults standardUserDefaults]valueForKey:@"loclng"];
    
    if(![self->adressString  isEqual: @""]){
        isAddLocation=1;
    }else{
        isAddLocation=0;
    }
    
    if (isAddLocation==1)
    {
        [locationBtn setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [locationBtn setTintColor:[UIColor whiteColor]];
        [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [locationBtn setBackgroundColor:[UIColor colorWithRed:231/255.0 green:234/255.0 blue:238/255.0 alpha:1]];
        [locationBtn setTintColor:[UIColor blackColor]];
        [locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"loc"];
     [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"loclat"];
     [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"loclng"];
    selectedShareMethod=0;
    isAddLocation=0;
    adressString=@"";
    lat=@"";
    lon=@"";
    hashh=0;
    self.view.backgroundColor=[UIColor whiteColor];
        [self.tabBarController.tabBar setHidden:false];

    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
    navigationView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:navigationView];
    
    
    UIButton *shareWith = [UIButton buttonWithType:UIButtonTypeCustom];
    shareWith.backgroundColor=[UIColor clearColor];
    [shareWith setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareWith setTitle:@"SHARE WITH" forState:UIControlStateNormal];
    shareWith.frame = CGRectMake(self.view.frame.size.width/2-100, 20, 200, 25);
    [navigationView addSubview:shareWith];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(10, 20, 30, 30);
    UIImage *imag=[[UIImage imageNamed:@"backArrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setImage:imag forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back_Action) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    
    UIView *selectionView=[[UIView alloc]initWithFrame:CGRectMake(0,54, self.view.frame.size.width, 50)];
    selectionView.backgroundColor=[UIColor colorWithRed:28/255.0 green:128/255.0 blue:190/255.0 alpha:1.0];
    [self.view addSubview:selectionView];
    
    folowersBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    folowersBtn.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 50);
    folowersBtn.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    [folowersBtn setTitle:@"FOLLOWERS" forState:UIControlStateNormal];
    [folowersBtn setTintColor:[UIColor whiteColor]];
    [folowersBtn addTarget:self action:@selector(followers_action) forControlEvents:UIControlEventTouchUpInside];
    [selectionView addSubview:folowersBtn];
    
    
    youBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    youBtn.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 50);
    youBtn.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    [youBtn setTitle:@"YOU" forState:UIControlStateNormal];
    [youBtn setTintColor:[UIColor lightGrayColor]];
    [youBtn addTarget:self action:@selector(you_action) forControlEvents:UIControlEventTouchUpInside];
    [selectionView addSubview:youBtn];
    
    
    
    
    
    selectionViewShown=[[UIView alloc]initWithFrame:CGRectMake(10, 37, self.view.frame.size.width/2-20, 15)];
    selectionViewShown.backgroundColor=[UIColor clearColor];
    [selectionView addSubview:selectionViewShown];
    
    
    UIView *greenv=[[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width/2-20, 5)];
    greenv.backgroundColor=[UIColor greenColor];
    [selectionViewShown addSubview:greenv];
    
    UIView *redv=[[UIView alloc]initWithFrame:CGRectMake(selectionViewShown.frame.size.width/2-2.5, 0, 10, 10)];
    redv.backgroundColor=[UIColor redColor];
    [selectionViewShown addSubview:redv];
    
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-62.5, 110, 125 ,125)];
    mainImageView.image=image;
    mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:mainImageView];

    UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(0, 237, self.view.frame.size.width, 1)];
    sepView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:sepView];
    
    captionView=[[UITextView alloc]initWithFrame:CGRectMake(10, 243, 240, 100)];
    captionView.layer.cornerRadius=5.0;
    captionView.layer.borderWidth=0.5;
    captionView.font= [UIFont fontWithName:@"Arial" size:12.0f];
    captionView.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    captionView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:captionView];
    captionView.text=@"Caption";
    captionView.delegate=self;
    
    
    moodlbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 243, self.view.frame.size.width-260, 20)];
    moodlbl.font= [UIFont fontWithName:@"Arial" size:12.0f];
    [self.view addSubview:moodlbl];

    wearinglbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 263, self.view.frame.size.width-260, 20)];
    wearinglbl.font= [UIFont fontWithName:@"Arial" size:12.0f];
    [self.view addSubview:wearinglbl];
    
    
    listeninglbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 283, self.view.frame.size.width-260, 20)];
    listeninglbl.font= [UIFont fontWithName:@"Arial" size:12.0f];
    [self.view addSubview:listeninglbl];
    
    
    watchinglbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 303, self.view.frame.size.width-260, 20)];
    watchinglbl.font= [UIFont fontWithName:@"Arial" size:12.0f];
    [self.view addSubview:watchinglbl];
    
    
    wherelbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 323, self.view.frame.size.width-260, 20)];
    wherelbl.font= [UIFont fontWithName:@"Arial" size:12.0f];
    [self.view addSubview:wherelbl];
    
    
    hashtagslbl=[[UILabel alloc]initWithFrame:CGRectMake(255, 343, self.view.frame.size.width-260, 20)];;
    hashtagslbl.font= [UIFont fontWithName:@"Arial" size:12.0f];
    [self.view addSubview:hashtagslbl];
    
    
    
    moodBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moodBtn.layer.cornerRadius=5.0;
    moodBtn.frame = CGRectMake(5, 350, self.view.frame.size.width/3-10, 40);
    UIImage *imageee=[[UIImage imageNamed:@"mood_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [moodBtn setTintColor:[UIColor blackColor]];
    moodBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    moodBtn.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    [moodBtn setTitle:@"Mood #" forState:UIControlStateNormal];
    [moodBtn setImage:imageee forState:UIControlStateNormal];
    [moodBtn addTarget:self action:@selector(mood_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moodBtn];
    
    wearingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wearingBtn.frame = CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width/3)/2, 350, self.view.frame.size.width/3-10, 40);
    wearingBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    wearingBtn.layer.cornerRadius=5.0;
    wearingBtn.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    UIImage *imaga=[[UIImage imageNamed:@"wearing_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [wearingBtn setTintColor:[UIColor blackColor]];
    [wearingBtn setTitle:@"Wearing #" forState:UIControlStateNormal];
    [wearingBtn setImage:imaga forState:UIControlStateNormal];
    [wearingBtn addTarget:self action:@selector(wearing_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wearingBtn];
    
    
    listeningBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    listeningBtn.frame = CGRectMake(self.view.frame.size.width-self.view.frame.size.width/3-5, 350, self.view.frame.size.width/3-10, 40);
    listeningBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    listeningBtn.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    listeningBtn.layer.cornerRadius=5.0;
    [listeningBtn setTitle:@"Listening #" forState:UIControlStateNormal];
    [listeningBtn setTintColor:[UIColor blackColor]];
    [listeningBtn setImage:[[UIImage imageNamed:@"listning_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [listeningBtn addTarget:self action:@selector(listen_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listeningBtn];
    
    
    watchingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    watchingBtn.frame = CGRectMake(5, 395, self.view.frame.size.width/3-10, 40);
    [watchingBtn setTintColor:[UIColor blackColor]];
    watchingBtn.layer.cornerRadius=5.0;
    watchingBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    watchingBtn.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    [watchingBtn setTitle:@"Watching #" forState:UIControlStateNormal];
    [watchingBtn setImage:[[UIImage imageNamed:@"watching_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [watchingBtn addTarget:self action:@selector(watching_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:watchingBtn];
    
    
    locationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationBtn.frame = CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width/3)/2, 395, self.view.frame.size.width/3-10, 40);
    locationBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    locationBtn.layer.cornerRadius=5.0;
    locationBtn.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    [locationBtn setTitle:@"Add Location" forState:UIControlStateNormal];
    [locationBtn setTintColor:[UIColor blackColor]];
    [locationBtn setImage:[[UIImage imageNamed:@"location_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(location_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    
    whereBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    whereBtn.frame = CGRectMake(self.view.frame.size.width-self.view.frame.size.width/3-5, 395, self.view.frame.size.width/3-10, 40);
    whereBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    whereBtn.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    whereBtn.layer.cornerRadius=5.0;
    [whereBtn setTitle:@"Where #" forState:UIControlStateNormal];
    [whereBtn setTintColor:[UIColor blackColor]];
    [whereBtn setImage:[[UIImage imageNamed:@"where_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [whereBtn addTarget:self action:@selector(where_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whereBtn];
    
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.frame = CGRectMake(self.view.frame.size.width-200, 455, 120, 120);
    shareBtn.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    shareBtn.layer.cornerRadius=60.0;
    [shareBtn setTitle:@"SHARE" forState:UIControlStateNormal];
    [shareBtn setTintColor:[UIColor blackColor]];
    [shareBtn addTarget:self action:@selector(share_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    fbShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fbShare.frame = CGRectMake(15, 460, 100, 40);
    fbShare.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    [fbShare setImage:[[UIImage imageNamed:@"fb_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    fbShare.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    fbShare.layer.cornerRadius=5;
    [fbShare addTarget:self action:@selector(fbshare_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbShare];
    
    twiterShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    twiterShare.frame = CGRectMake(15, 505, 100, 40);
    twiterShare.backgroundColor=[UIColor colorWithRed:236/255.0 green:238/255.0 blue:241/255.0 alpha:1.0];
    twiterShare.layer.cornerRadius=5;
    [twiterShare setImage:[[UIImage imageNamed:@"twitter_share"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    twiterShare.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);

    [twiterShare addTarget:self action:@selector(twshare_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twiterShare];
    
    moodStr=@"";
    wearing=@"";
    watching=@"";
    listening=@"";
    where=@"";
    hashtags=@"";
}

-(void)followers_action
{
    selectedShareMethod=0;
    CGRect f = selectionViewShown.frame;
    f.origin.x = 10;
    selectionViewShown.frame = f;
    [folowersBtn setTintColor:[UIColor whiteColor]];
    [youBtn setTintColor:[UIColor lightGrayColor]];

}
-(void)you_action
{
    [youBtn setTintColor:[UIColor whiteColor]];
    [folowersBtn setTintColor:[UIColor lightGrayColor]];

    selectedShareMethod=1;
    CGRect f = selectionViewShown.frame;
    f.origin.x = self.view.frame.size.width/2;
    selectionViewShown.frame = f;
}
-(void)share_action
{


    if(hashh==0)
    [self calculateHashtags];
    else
    {
    [Helper showIndicatorWithText:@"Uploading..." inView:self.view];

    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://naamee.com/api/webservices/index.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",@"addPost"] dataUsingEncoding:NSUTF8StringEncoding] name:@"method"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]] dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
        
        
        NSString *capString=self->captionView.text;
        if([capString isEqualToString:@"Caption"])
           {
               capString=@"";
           }
        
        
        NSString *uniText = [NSString stringWithUTF8String:[capString UTF8String]];
        NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
        
        
        NSString *uniText1 = [NSString stringWithUTF8String:[self->moodStr UTF8String]];
        NSData *msgData1 = [uniText1 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg1 = [[NSString alloc] initWithData:msgData1 encoding:NSUTF8StringEncoding];
        
        NSString *uniText2 = [NSString stringWithUTF8String:[self->wearing UTF8String]];
        NSData *msgData2 = [uniText2 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg2 = [[NSString alloc] initWithData:msgData2 encoding:NSUTF8StringEncoding];
        
        NSString *uniText3 = [NSString stringWithUTF8String:[self->listening UTF8String]];
        NSData *msgData3 = [uniText3 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg3 = [[NSString alloc] initWithData:msgData3 encoding:NSUTF8StringEncoding];
        
        
        NSString *uniText4 = [NSString stringWithUTF8String:[self->watching UTF8String]];
        NSData *msgData4 = [uniText4 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg4 = [[NSString alloc] initWithData:msgData4 encoding:NSUTF8StringEncoding];
        
        
        NSString *uniText5 = [NSString stringWithUTF8String:[self->where UTF8String]];
        NSData *msgData5 = [uniText5 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg5 = [[NSString alloc] initWithData:msgData5 encoding:NSUTF8StringEncoding];
        
        NSString *uniText6 = [NSString stringWithUTF8String:[self->hashtags UTF8String]];
        NSData *msgData6= [uniText6 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        NSString *goodMsg6 = [[NSString alloc] initWithData:msgData6 encoding:NSUTF8StringEncoding];
        
        
        
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg] dataUsingEncoding:NSUTF8StringEncoding] name:@"caption"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",self->adressString] dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",self->lat] dataUsingEncoding:NSUTF8StringEncoding] name:@"lat"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",self->lon] dataUsingEncoding:NSUTF8StringEncoding] name:@"lon"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",self->selectedShareMethod] dataUsingEncoding:NSUTF8StringEncoding] name:@"onlyMe"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg1] dataUsingEncoding:NSUTF8StringEncoding] name:@"mood"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg2] dataUsingEncoding:NSUTF8StringEncoding] name:@"wearing"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg3] dataUsingEncoding:NSUTF8StringEncoding] name:@"listening"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg4] dataUsingEncoding:NSUTF8StringEncoding] name:@"watching"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg5] dataUsingEncoding:NSUTF8StringEncoding] name:@"where"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",goodMsg6] dataUsingEncoding:NSUTF8StringEncoding] name:@"hashTag"];
        
        NSData *imageData = UIImageJPEGRepresentation(self->mainImageView.image,0.2);
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"testimage.jpeg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/plain"];

    
    manager.responseSerializer = serializer;

    

    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                         // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:nil];
                          NSLog(@"%@",jsonResponse);
                          [Helper hideIndicatorFromView:self.view];

                          if([[jsonResponse valueForKey:@"code"]intValue]==1)
                          {
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTop" object:nil];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"updateScreen" object:nil];

                          self.tabBarController.selectedIndex=0;
                          [self.navigationController popToRootViewControllerAnimated:YES];
                          }
                      }
                  }];
    
    [uploadTask resume];
    }
}
-(void)fbshare_action
{
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logOut];
//    if ([FBSDKAccessToken currentAccessToken]) {
//
//        [self getFacebookDetails];
//
//    }
//    else
//    {
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        [login
//         logInWithReadPermissions: @[@"public_profile",@"email"]
//         fromViewController:self
//         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//             if (error) {
//                 NSLog(@"Process error");
//             } else if (result.isCancelled) {
//                 NSLog(@"Cancelled");
//             } else {
//                 NSLog(@"Logged in");
//                 [self getFacebookDetails];
//             }
//         }];
//    }
//
    
    SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString *capString=self->captionView.text;
    if([capString isEqualToString:@"Caption"])
    {
        capString=@"";
    }
    if(self->moodStr.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,moodStr];
    }
    if(self->wearing.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,wearing];
    }
    if(self->watching.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,watching];
    }
    if(self->listening.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,listening];
    }
    if(self->where.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,where];
    }
    if(self->hashtags.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,hashtags];
    }
    
    
    
    [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"%@",capString] ];
    [mySLComposerSheet addImage:mainImageView.image];
    //[mySLComposerSheet addURL:[NSURL URLWithString:strURL]];
    
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Post Canceled");
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Post Sucessful");
                break;
                
            default:
                break;
        }
    }];
    
    [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
//    {
//        SLComposeViewController *socialPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        
//        [socialPostVC addImage:mainImageView.image];
//        [socialPostVC setInitialText:captionView.text];
//        
//        [socialPostVC setCompletionHandler:^(SLComposeViewControllerResult result) {
//            switch (result) {
//                case SLComposeViewControllerResultCancelled:
//                    NSLog(@"Post Canceled");
//                    break;
//                case SLComposeViewControllerResultDone:
//                    NSLog(@"Post Sucessful");
//                    break;
//                default:
//                    break;
//            }
//        }];
//        [self presentViewController:socialPostVC animated:YES completion:nil];
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Unavailable" message:@"Please add facebook account in your device settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//    }
}
-(void)twshare_action
{
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
        SLComposeViewController *socialPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *capString=self->captionView.text;
    if([capString isEqualToString:@"Caption"])
    {
        capString=@"";
    }
    if(self->moodStr.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,moodStr];
    }
    if(self->wearing.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,wearing];
    }
    if(self->watching.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,watching];
    }
    if(self->listening.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,listening];
    }
    if(self->where.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,where];
    }
    if(self->hashtags.length>0)
    {
        capString=  [NSString stringWithFormat:@"%@ %@",capString,hashtags];
    }
    

        [socialPostVC addImage:mainImageView.image];
        [socialPostVC setInitialText:capString];
        
        [socialPostVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        [self presentViewController:socialPostVC animated:YES completion:nil];
//    }
//    else
//    {
//        [[[UIAlertView alloc] initWithTitle:@"Unavailable" message:@"Please add twitter account in your device settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//    }
}
-(void)where_Action
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Where" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag=3;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"#where"];
    if (where.length==0)
    {
        [[alert textFieldAtIndex:0] setText:@"#"];
    }
    else
    {
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%@ #", where]];
    }
    [alert show];
}
-(void)location_Action
{
    UIImage *image = [UIImage imageNamed:@"location_share.png"];
    UIImageView *smileImage = [[UIImageView alloc]init];
    smileImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [locationBtn setImage:smileImage.image forState:UIControlStateNormal];
    if (isAddLocation==1)
    {
        isAddLocation=0;
        [locationBtn setBackgroundColor:[UIColor colorWithRed:231/255.0 green:234/255.0 blue:238/255.0 alpha:1]];
        [locationBtn setTintColor:[UIColor blackColor]];
        [locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        isAddLocation=1;
        [locationBtn setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [locationBtn setTintColor:[UIColor whiteColor]];
        [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    locationSearchViewController *fpvc=[[locationSearchViewController alloc]init];
    [self.navigationController pushViewController:fpvc animated:true];
    
}
-(void)watching_Action
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Watching" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag=5;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"#watching"];
    if (watching.length==0)
    {
        [[alert textFieldAtIndex:0] setText:@"#"];
    }
    else
    {
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%@ #", watching]];
    }
    [alert show];
}
-(void)listen_Action
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Listening" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag=4;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"#listening"];
    if (listening.length==0)
    {
        [[alert textFieldAtIndex:0] setText:@"#"];
    }
    else
    {
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%@ #", listening]];
    }
    [alert show];
}
-(void)wearing_Action
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Wearing" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag=2;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"#wearing"];
    if (wearing.length==0)
    {
        [[alert textFieldAtIndex:0] setText:@"#"];
    }
    else
    {
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%@ #", wearing]];
    }
    [alert show];
}
-(void)mood_Action
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Mood" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag=1;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"Set your mood"];
    if (moodStr.length==0)
    {
        [[alert textFieldAtIndex:0] setText:@"#"];
    }
    else
    {
        [[alert textFieldAtIndex:0] setText:[NSString stringWithFormat:@"%@ #", moodStr]];
    }
    [alert show];
}
-(void)back_Action
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        UITextField *field=[alertView textFieldAtIndex:0];
        if (field.text.length==0)
        {
            moodStr=field.text;
            moodlbl.text=moodStr;

        
        }
        else
        {
            if ([field.text characterAtIndex:field.text.length-1] == '#')
            {
                moodStr=[field.text substringToIndex:field.text.length-1];
                moodlbl.text=moodStr;
                
            }
            else
            {
                moodStr=field.text;
                moodlbl.text=moodStr;

                
            }
        }
    }
    else if (alertView.tag==2)
    {
        UITextField *field=[alertView textFieldAtIndex:0];
        if (field.text.length==0)
        {
            wearing=field.text;
            wearinglbl.text=wearing;

            
        }
        else
        {
            if ([field.text characterAtIndex:field.text.length-1] == '#')
            {
                wearing=[field.text substringToIndex:field.text.length-1];
                wearinglbl.text=wearing;
           }
            else
            {
                wearing=field.text;
                wearinglbl.text=wearing;
            }
        }
    }
    else if (alertView.tag==3)
    {
        UITextField *field=[alertView textFieldAtIndex:0];
        if (field.text.length==0)
        {
            where=field.text;
            wherelbl.text=where;
        }
        else
        {
            if ([field.text characterAtIndex:field.text.length-1] == '#')
            {
                where=[field.text substringToIndex:field.text.length-1];
                wherelbl.text=where;
            }
            else
            {
                where=field.text;
                wherelbl.text=where;
            }
        }
    }
    else if (alertView.tag==4)
    {
        UITextField *field=[alertView textFieldAtIndex:0];
        if (field.text.length==0)
        {
            listening=field.text;
            listeninglbl.text=listening;
        }
        else
        {
            if ([field.text characterAtIndex:field.text.length-1] == '#')
            {
                listening=[field.text substringToIndex:field.text.length-1];
                listeninglbl.text=listening;
               }
            else
            {
                listening=field.text;
                listeninglbl.text=listening;
             }
        }
    }
    else if (alertView.tag==5)
    {
        UITextField *field=[alertView textFieldAtIndex:0];
        if (field.text.length==0)
        {
            watching=field.text;
            watchinglbl.text=watching;
           }
        else
        {
            if ([field.text characterAtIndex:field.text.length-1] == '#')
            {
                watching=[field.text substringToIndex:field.text.length-1];
                watchinglbl.text=watching;
          }
            else
            {
                watching=field.text;
                watchinglbl.text=watching;
            }
        }
    }
    
    
}
#pragma mark - Text view deligates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"Caption";
        }
        
        [textView resignFirstResponder];
        [captionView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"Caption"])
    {
        textView.text=@"";
    }
    
    return YES;
}
-(void)calculateHashtags
{
    hashh=1;
    hashtags=@"";
    NSString *completeString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@", moodStr, wearing, where, listening, watching];
    for (int i=0; i<[completeString length]; i++)
    {
        if ([completeString characterAtIndex:i]=='#')
        {
            int index=0;
            while ([completeString length]>index)
            {
                if ([completeString characterAtIndex:i+index]==' ')
                {
                    NSRange srcRange = NSMakeRange(i+1, index-1);
                    hashtags=[NSString stringWithFormat:@"%@%@,", hashtags, [completeString substringWithRange:srcRange]];
                    i+= srcRange.length;
                    break;
                }
                else if ([completeString length]==i+index+1)
                {
                    NSRange srcRange = NSMakeRange(i+1, index);
                    hashtags=[NSString stringWithFormat:@"%@%@,", hashtags, [completeString substringWithRange:srcRange]];
                    i+= srcRange.length;
                    break;
                }
                else
                {
                    index++;
                }
            }
        }
    }
    if (hashtags.length>0)
    {
        if ([hashtags characterAtIndex:hashtags.length-1] == ',')
        {
            hashtags=[hashtags substringToIndex:hashtags.length-1];
        }
    }
    [self share_action];
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
             
             UIImage *someImage = self->mainImageView.image;
//             FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//             content.photos = @[[FBSDKSharePhoto photoWithImage:someImage userGenerated:YES] ];
//
//             // Assuming self implements <FBSDKSharingDelegate>
//             [FBSDKShareAPI shareWithContent:content delegate:self];

         }
         else
         {
             //             [Helper hideIndicatorFromView:self.view];
             [[[UIAlertView alloc]initWithTitle:@"failed" message:@"Facebook authentication failed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
         }
     }];
}
@end
