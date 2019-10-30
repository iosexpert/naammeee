//
//  profileViewController.m
//  naamee
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "profileViewController.h"
#import "AsyncImageView.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "editProfileView.h"
#import "myFollowerViewController.h"
#import "myFollowingViewController.h"
#import "NSDate+NVTimeAgo.h"
#import "commentViewController.h"
#import "imageViewController.h"
#import "otherUserProfileView.h"
#import "hashtagScreenView.h"
#import "ViewController.h"
#import "findFriendViewController.h"
#import "otheImageWithIdViewController.h"
#import "otherImageView.h"
#import "GoogleMapViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "smileViewController.h"
#import  "editPostFilterView.h"

#import  "FiltersViewController.h"
@interface profileViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    AsyncImageView *userImage;
    UILabel *followersLbl,*followingLbl,*postsLbl,*repeatLbl,*namelbl;
    UITextView *userDetail,*userwebsite;
    UICollectionView *imageScrollView;
    UIButton *gridBtn,*listBtn,*likeAction,*usertag,*repostbtn;;
    NSMutableArray *userImagesArr,*userImagesArr1;
    UITableView *fTable;
    NSMutableArray *postList,*userLikedArr,*userrepostArr;
    NSMutableDictionary *userdetaildict;
    UILabel *numberOfLikes;
    
    NSDictionary *detailDict;
    int selectedButtonIndax;
    int gridButtonSelection;
    
    UIView *highlightView;
    NSURL *webLink;
    
    NSDictionary *detailDictForShare;

}
@end

@implementation profileViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex=-1;
    gridButtonSelection=0;

    userImagesArr1=[NSMutableArray new];
    self.view.backgroundColor= [UIColor whiteColor];
    self.navigationController.navigationBarHidden=true;
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor blackColor];
    [self.view addSubview: navigationView];
    
    UIButton *settingButn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingButn.frame = CGRectMake(self.view.frame.size.width-40, 27, 30, 30);
    [settingButn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *imagef = [UIImage imageNamed:@"Log-out"];
    [settingButn setTintColor:[UIColor whiteColor]];
    [settingButn setImage:imagef forState:UIControlStateNormal];
    [settingButn addTarget:self action:@selector(naVsetting_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButn];
    
    userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 69, 100, 100)];
    userImage.layer.borderWidth=0.5;
    userImage.layer.cornerRadius=50;
    userImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    userImage.clipsToBounds=YES;
    [self.view addSubview:userImage];
    userImage.contentMode=UIViewContentModeScaleAspectFit;

    
    namelbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 170,310, 30)];
    namelbl.text = @"";
    namelbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:namelbl];
    
    
    
    followersLbl = [[UILabel alloc]initWithFrame:CGRectMake(130, 69, 60, 25)];
    followersLbl.text = @"";
    followersLbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
    followersLbl.backgroundColor = [UIColor clearColor];
    followersLbl.textColor = [UIColor blackColor];
    followersLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followersLbl];
    followersLbl.userInteractionEnabled=true;
    UITapGestureRecognizer *gesture  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followerBtn:)];
    [followersLbl addGestureRecognizer:gesture];
    
    
    UILabel *followerlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 93, 80, 20)];
    followerlabel.text = @"FOLLOWERS";
    followerlabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    followerlabel.backgroundColor = [UIColor clearColor];
    followerlabel.textColor = [UIColor blackColor];
    followerlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followerlabel];
    
    followingLbl = [[UILabel alloc]initWithFrame:CGRectMake(220, 69, 60, 25)];
    followingLbl.text = @"";
    followingLbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
    followingLbl.backgroundColor = [UIColor clearColor];
    followingLbl.textColor = [UIColor blackColor];
    followingLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followingLbl];
    
    followingLbl.userInteractionEnabled=true;
    UITapGestureRecognizer *gesture1  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followingBtn:)];
    [followingLbl addGestureRecognizer:gesture1];
    
    UILabel *followinglabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 93, 75, 20)];
    followinglabel.text = @"FOLLOWING";
    followinglabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    followinglabel.backgroundColor = [UIColor clearColor];
    followinglabel.textColor = [UIColor blackColor];
    followinglabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followinglabel];
    
    repeatLbl = [[UILabel alloc]initWithFrame:CGRectMake(130, 120, 60, 25)];
    repeatLbl.text = @"";
    repeatLbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
    repeatLbl.backgroundColor = [UIColor clearColor];
    repeatLbl.textColor = [UIColor blackColor];
    repeatLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:repeatLbl];
    
    UILabel *repeatlabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 143, 80, 20)];
    repeatlabel.text = @"REPEAT";
    repeatlabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    repeatlabel.backgroundColor = [UIColor clearColor];
    repeatlabel.textColor = [UIColor blackColor];
    repeatlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:repeatlabel];
    
    
    postsLbl = [[UILabel alloc]initWithFrame:CGRectMake(220, 120, 60, 25)];
    postsLbl.text = @"";
    postsLbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
    postsLbl.backgroundColor = [UIColor clearColor];
    postsLbl.textColor = [UIColor blackColor];
    postsLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:postsLbl];
    
UILabel *postsLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 143, 80, 20)];
    postsLabel.text = @"POSTS";
    postsLabel.font=[UIFont fontWithName:@"Arial" size:12.0f];
    postsLabel.backgroundColor = [UIColor clearColor];
    postsLabel.textColor = [UIColor blackColor];
    postsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:postsLabel];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingBtn.frame = CGRectMake(self.view.frame.size.width-100, 70, 95, 65);
    [settingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [settingBtn setTitle:@"Edit Profile" forState:UIControlStateNormal];
    //UIImage *imagek = [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //[settingBtn setImage:imagek forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    settingBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 47, 0, 0);
    settingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -50, 0);
    [settingBtn addTarget:self action:@selector(setting_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    
    UIImageView *img4=[[UIImageView alloc]initWithFrame:CGRectMake(settingBtn.frame.size.width/2-10, settingBtn.frame.size.height/2-10, 20, 20)];
    img4.image=[UIImage imageNamed:@"settings"];
    img4.contentMode=UIViewContentModeScaleAspectFit;
    img4.userInteractionEnabled=false;
    [settingBtn addSubview:img4];
    
    userDetail=[[UITextView alloc]initWithFrame:CGRectMake(10, 205,310, 50)];
    userDetail.layer.cornerRadius=5.0;
    userDetail.layer.borderWidth=0.0;
    userDetail.delegate=self;
       userDetail.editable=false;
       userDetail.scrollEnabled=false;
       userDetail.dataDetectorTypes = UIDataDetectorTypeLink;
    userDetail.backgroundColor=[UIColor clearColor];
    userDetail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:userDetail];
    userDetail.text=@"";
    userDetail.delegate=self;
    
    userwebsite=[[UITextView alloc]initWithFrame:CGRectMake(0, 250,self.view.frame.size.width, 25)];
    userwebsite.textAlignment=NSTextAlignmentCenter;
    userwebsite.userInteractionEnabled=true;
    userwebsite.scrollEnabled=false;
    userwebsite.editable=false;
    userwebsite.backgroundColor=[UIColor clearColor];
    userwebsite.layer.borderColor=[UIColor blueColor].CGColor;
    [self.view addSubview:userwebsite];
    userwebsite.text=@"";
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [userwebsite addGestureRecognizer:letterTapRecognizer];
    
    
    gridBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    gridBtn.frame = CGRectMake(0, 280, self.view.frame.size.width/5, 40);
    //[gridBtn setImage:[[UIImage imageNamed:@"9-Dotted-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [gridBtn setContentMode:UIViewContentModeScaleAspectFit];
    [gridBtn addTarget:self action:@selector(grid_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gridBtn];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/5)/2-10, 10, 20, 20)];
    img.image=[UIImage imageNamed:@"9-Dotted-Icon"];
    img.contentMode=UIViewContentModeScaleAspectFit;
    img.userInteractionEnabled=false;
    [gridBtn addSubview:img];
    
    highlightView=[[UIView alloc]initWithFrame:CGRectMake(gridBtn.frame.size.width/2-5, gridBtn.frame.size.height-10, 10, 7.5)];
    highlightView.backgroundColor=[UIColor greenColor];
    [gridBtn addSubview:highlightView];
    
    listBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    listBtn.frame = CGRectMake(self.view.frame.size.width/5, 280, self.view.frame.size.width/5, 40);
    //[listBtn setImage:[[UIImage imageNamed:@"3-line-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(list_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/4)/2-10, 10, 20, 20)];
    img1.image=[UIImage imageNamed:@"3-line-Icon"];
    img1.contentMode=UIViewContentModeScaleAspectFit;
    img1.userInteractionEnabled=false;
    [listBtn addSubview:img1];
    
    
    likeAction = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    likeAction.frame = CGRectMake(self.view.frame.size.width/5+self.view.frame.size.width/5, 280, self.view.frame.size.width/5, 40);
    //[likeAction setImage:[[UIImage imageNamed:@"like-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [likeAction addTarget:self action:@selector(liked_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeAction];
    
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/4)/2-10, 10, 20, 20)];
    img2.image=[UIImage imageNamed:@"like-icon"];
    img2.contentMode=UIViewContentModeScaleAspectFit;
    img2.userInteractionEnabled=false;
    [likeAction addSubview:img2];
    
    
    usertag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    usertag.frame = CGRectMake(self.view.frame.size.width/5+self.view.frame.size.width/5+self.view.frame.size.width/5+self.view.frame.size.width/5, 280, self.view.frame.size.width/5, 40);
   // [usertag setImage:[[UIImage imageNamed:@"user_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [usertag addTarget:self action:@selector(usertag_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:usertag];
    //[usertag setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
   
    UIImage *image = [UIImage imageNamed:@"user_search"];
    
    UIImageView *img3=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/5)/2-15, 5, 30, 30)];
    img3.image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [img3 setTintColor:[UIColor blackColor]];
    img3.contentMode=UIViewContentModeScaleAspectFit;
    img3.userInteractionEnabled=false;
    [usertag addSubview:img3];
    
    
    repostbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    repostbtn.frame = CGRectMake(self.view.frame.size.width/5+self.view.frame.size.width/5+self.view.frame.size.width/5, 280, self.view.frame.size.width/5, 40);
    // [usertag setImage:[[UIImage imageNamed:@"user_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [repostbtn addTarget:self action:@selector(repost_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repostbtn];
    //[usertag setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    UIImage *image1 = [UIImage imageNamed:@"repost"];
    
    UIImageView *img5=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/5)/2-15, 5, 30, 30)];
    img5.image=[image1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [img5 setTintColor:[UIColor blackColor]];
    img5.contentMode=UIViewContentModeScaleAspectFit;
    img5.userInteractionEnabled=false;
    [repostbtn addSubview:img5];
    
    
    
    self->fTable = [[UITableView alloc] initWithFrame:CGRectMake(0,self->usertag.frame.size.height+self->usertag.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height-self->usertag.frame.size.height-self->usertag.frame.origin.y ) style:UITableViewStylePlain];
           self->fTable.delegate = self;
           self->fTable.dataSource = self;
           self->fTable.tag=0;
           self->fTable.backgroundColor = [UIColor clearColor];
           self->fTable.separatorStyle = UITableViewCellSeparatorStyleNone;
           [self.view addSubview:self->fTable];
           self->fTable.hidden=true;
       
    
       UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
       [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
           layout.minimumInteritemSpacing = 0;
           layout.minimumLineSpacing = 0;
       self->imageScrollView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,self->usertag.frame.size.height+self->usertag.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height-self->usertag.frame.size.height-self->usertag.frame.origin.y ) collectionViewLayout:layout];
       [self->imageScrollView setCollectionViewLayout:layout];
       [self->imageScrollView setDataSource:self];
       [self->imageScrollView setDelegate:self];
       self->imageScrollView.pagingEnabled=false;
       [self->imageScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
       [self->imageScrollView setBackgroundColor:[UIColor clearColor]];
       self->imageScrollView.showsVerticalScrollIndicator=false;
       self->imageScrollView.showsHorizontalScrollIndicator=false;
       [self.view addSubview:self->imageScrollView];
                   
    
    
    
    
    
    
    
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    
    
    [[UIApplication sharedApplication] openURL:webLink];

}

-(void)followerBtn:(UITapGestureRecognizer *)gesture
{
    myFollowerViewController *smvc = [[myFollowerViewController alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)followingBtn:(UITapGestureRecognizer *)gesture
{
    myFollowingViewController *smvc = [[myFollowingViewController alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)getLikedPost
{
    NSLog(@"uid_totalLikePostByUser: %@", [[NSUserDefaults standardUserDefaults]stringForKey:@"uid"]);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"totalLikePostByUser",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"],
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON totalLikePostByUser: %@", json);
        [Helper hideIndicatorFromView:self.view];
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            self->userLikedArr=[json valueForKey:@"postDetails"];
            [self->fTable reloadData];
            [self getRpeatPost];

        }
        else
        {
            [self getRpeatPost];
            [self->fTable reloadData];
        }
        
        }
          failure:^(NSURLSessionTask *operation, NSError *error)
           {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
          }];

}
-(void)getRpeatPost
{
    NSLog(@"totalrePostByUser: %@", [[NSUserDefaults standardUserDefaults]stringForKey:@"uid"]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"totalrePostByUser",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]stringForKey:@"userid"],
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON totalrePostByUser: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            self->userrepostArr=[[json valueForKey:@"postDetails"] mutableCopy];
            [self->imageScrollView reloadData];
        }
        else
        {
            [self->imageScrollView reloadData];
        }
        
    }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [Helper hideIndicatorFromView:self.view];
         
     }];
    
}
-(void)liked_Action
{
//    [self getLikedPost];
    gridButtonSelection=2;

         [highlightView removeFromSuperview];
         highlightView=[[UIView alloc]initWithFrame:CGRectMake(likeAction.frame.size.width/2+6, likeAction.frame.size.height-10, 10, 7.5)];
         highlightView.backgroundColor=[UIColor greenColor];
         [likeAction addSubview:highlightView];
    
    userImagesArr1=[userLikedArr mutableCopy];
    if(userImagesArr1.count == 0)
    {
        [Helper showAlertViewWithTitle:OOPS message:@"No Post Found"];
    }
    self->imageScrollView.hidden=false;
    self->fTable.hidden=true;
    [imageScrollView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:false];
    NSLog(@"uid_userDetails: %@", [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"userDetails",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"device"       :[NSString stringWithFormat:@"%0.0f", self.view.frame.size.width]};

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON userDetails: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            [[NSUserDefaults standardUserDefaults]setValue:json forKey:@"myProfile"];
//            NSLog(@"myfollowers %@",[json objectForKey:@"myfollowers"]);
            self->followersLbl.text=[NSString stringWithFormat:@"%ld",[[[json objectForKey:@"allDetails"][0]valueForKey:@"totalFollower"]integerValue] ];
            self->followingLbl.text=[NSString stringWithFormat:@"%ld",[[[json objectForKey:@"allDetails"][0]valueForKey:@"totalFollowing"]integerValue] ];
            self->repeatLbl.text=[NSString stringWithFormat:@"%ld",[[[json objectForKey:@"allDetails"][0]valueForKey:@"totalRepeat"]integerValue] ];
            self->postsLbl.text=[NSString stringWithFormat:@"%ld",[[[json objectForKey:@"allDetails"][0]valueForKey:@"totalPost"]integerValue] ];

            self->userdetaildict=[[[json objectForKey:@"userDetails"]objectAtIndex:0]mutableCopy];
            
            NSDictionary *dict=[[json objectForKey:@"userDetails"]objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults]setValue:[dict valueForKey:@"fullname"] forKey:@"name"];
            self->userwebsite.text=[dict valueForKey:@"website"];
                if ([[dict valueForKey:@"website"] rangeOfString:@"http"].location == NSNotFound) {
                    self->webLink=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict valueForKey:@"website"]]];
                }
            else
            {
                self->webLink=[NSURL URLWithString:[dict valueForKey:@"website"]];

            }
            self->namelbl.text=[dict valueForKey:@"fullname"];
            
            NSData *data = [NSData dataWithBytes: [[dict valueForKey:@"description"] UTF8String] length:strlen([[dict valueForKey:@"description"] UTF8String])];
            NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
            
            
             NSArray *components=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
               NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
               for(int i=0;i<components.count;i++)
               {
                   if([components[i] length]>1)
                   {
                       if([[components[i] substringToIndex:1] isEqualToString:@"#"])
                       {
                           NSString *sttt=msg;
                           NSRange rangee= [sttt rangeOfString: components[i]];
                           [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                           [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
                       }
                   }
                   
               }
            
            
            self->userDetail.attributedText=string;
            
            self->userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[dict valueForKey:@"profile_pic"]]];
            
            self->userwebsite.textColor=[UIColor blueColor];

            
            self->userImagesArr=[[json valueForKey:@"allPost"]mutableCopy];
            self->postList=[[json valueForKey:@"allPost"]mutableCopy];
            if(self->userImagesArr.count>0)
            {
                if(self->imageScrollView)
                {
                    if(self->gridButtonSelection==0)
                       [self grid_Action];
                    if(self->gridButtonSelection==1)
                            [self list_Action];
                    if(self->gridButtonSelection==2)
                            [self liked_Action];
                    if(self->gridButtonSelection==3)
                        [self repost_Action];
                    
                    [self->imageScrollView reloadData];
                    [self->fTable reloadData];
                }
                else
                {
                    self->userImagesArr1 = [self->userImagesArr mutableCopy];
                    [self->imageScrollView reloadData];

                   
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dict valueForKey:@"profile_pic"]] forKey:@"profilePic"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", [dict valueForKey:@"coverPic"]] forKey:@"coverPic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                
            }
            
            self->userImage.layer.cornerRadius=self->userImage.frame.size.width/2;
        }
        else
        {
                [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    [self getLikedPost];
}
-(void)usertag_Action
{
    findFriendViewController *smvc = [[findFriendViewController alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];

}
-(void)setting_Action
{
    editProfileView *smvc = [[editProfileView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)grid_Action
{
    gridButtonSelection=0;
    [highlightView removeFromSuperview];
      highlightView=[[UIView alloc]initWithFrame:CGRectMake(gridBtn.frame.size.width/2-5, gridBtn.frame.size.height-10, 10, 7.5)];
      highlightView.backgroundColor=[UIColor greenColor];
      [gridBtn addSubview:highlightView];
    
    userImagesArr1 = [userImagesArr mutableCopy];
    self->imageScrollView.hidden=false;
     self->fTable.hidden=true;
     [imageScrollView reloadData];
}
-(void)repost_Action
{
    gridButtonSelection=3;

    [highlightView removeFromSuperview];
    highlightView=[[UIView alloc]initWithFrame:CGRectMake(repostbtn.frame.size.width/2-5, repostbtn.frame.size.height-10, 10, 7.5)];
    highlightView.backgroundColor=[UIColor greenColor];
    [repostbtn addSubview:highlightView];
    
    userImagesArr1 = [userrepostArr mutableCopy];
    self->imageScrollView.hidden=false;
    self->fTable.hidden=true;
    [imageScrollView reloadData];
}
-(void)list_Action
{
    gridButtonSelection=1;

    [highlightView removeFromSuperview];
       highlightView=[[UIView alloc]initWithFrame:CGRectMake(listBtn.frame.size.width/2+5, listBtn.frame.size.height-10, 10, 7.5)];
       highlightView.backgroundColor=[UIColor greenColor];
       [listBtn addSubview:highlightView];
    
    self->imageScrollView.hidden=true;
    self->fTable.hidden=false;
}
#pragma mark - Text view deligates
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    
    NSLog(@"%@",[textView.text substringWithRange: characterRange]);
    
    NSString *testString = textView.text;
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detect matchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
   
    if (matches.count == 0){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[[textView.text substringWithRange: characterRange] substringFromIndex:1] forKey:@"hashtag"];
        [userDefaults synchronize];
        hashtagScreenView *smvc = [[hashtagScreenView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
        return NO;
        
    }else{
        return true;
    }
    
    
    
    
}- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if([textView.text isEqualToString:@""])
        {
            textView.text=@"Caption";
        }
        
        [textView resignFirstResponder];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSArray * copy = [[array reverseObjectEnumerator] allObjects];
        return [self->userImagesArr1 count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    for(UIView *view in cell.subviews)
    {
        for(UIView *subView in view.subviews)
        {
            [subView removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    
    AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-2, self.view.frame.size.width/3-2)];
    postImage.userInteractionEnabled=YES;
    
    NSString *url;
    
    if([[self->userImagesArr1 objectAtIndex:indexPath.row]valueForKey:@"post_image"])
    url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->userImagesArr1 objectAtIndex:indexPath.row]valueForKey:@"post_image"]];
    else
    {
        NSDictionary *dict=[self->userImagesArr1 objectAtIndex:indexPath.row];
        NSLog(@"%@",[dict valueForKey:@"postImage"]);
        url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dict valueForKey:@"postImage"]];
    }

    postImage.imageURL=[NSURL URLWithString:url];
    postImage.contentMode=UIViewContentModeScaleAspectFill;
    postImage.clipsToBounds = true;
    [cell addSubview:postImage];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    NSLog(@"indexpath : %d",(int)indexPath.item);
    dic=[self->userImagesArr1 objectAtIndex:indexPath.item];
    NSLog(@"dic : %@",[dic objectForKey:@"post_id"]);
   
    if([dic objectForKey:@"post_id"]!= nil)
        [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"post_id"] forKey:@"postid"];
    else if([dic objectForKey:@"postid"]!= nil)
        [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"postid"] forKey:@"postid"];
    else
    [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"sharePostid"] forKey:@"postid"];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromProfile"];
  
    otherImageView *smvc = [[otherImageView alloc]init];
    
    [self.navigationController pushViewController:smvc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
            return CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);
    
}


#pragma mark -- TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return postList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    NSDictionary *dic=[postList objectAtIndex:indexPath.section];
    
    AsyncImageView *postImage;
    if([[dic valueForKey:@"postImage_width"]intValue]<self.view.frame.size.width)
    {
        postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, [[dic valueForKey:@"postImage_height"]intValue])];
    }
    else
    {
        postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,[[dic valueForKey:@"postImage_width"]intValue], [[dic valueForKey:@"postImage_height"]intValue])];
    }
    //NSString *postImage_width = [dic objectForKey:@"postImage_width"];
    //NSString *postImage_height = [dic objectForKey:@"postImage_height"];
    //AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, [postImage_width floatValue], [postImage_height floatValue])];
    
    postImage.tag=1000+indexPath.section;
    postImage.userInteractionEnabled=YES;
    postImage.backgroundColor = UIColor.whiteColor;
//    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like:)];
//    gesture.numberOfTapsRequired=2;
//    [postImage addGestureRecognizer:gesture];
    
    //    UITapGestureRecognizer *gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDetailView:)];
    //    gesture.numberOfTapsRequired=1;
    //    [postImage addGestureRecognizer:gesture1];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                               initWithTarget:self
//                                               action:@selector(handleLongPress:)];
//    longPress.minimumPressDuration = 2.0;
//    [postImage addGestureRecognizer:longPress];
    
    
    NSString *url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"postImage"]];
    [postImage sd_setImageWithURL:[NSURL URLWithString:url]
                        completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            postImage.image = image;
                            if([[dic valueForKey:@"postImage_width"]intValue]<self.view.frame.size.width)
                            {
                                postImage.contentMode=UIViewContentModeScaleAspectFill;
                            }
                            else
                                postImage.contentMode=UIViewContentModeScaleAspectFit;
                            postImage.clipsToBounds=YES;
                            [self->fTable reloadSectionIndexTitles];
                        }];
    
    //postImage.imageURL=[NSURL URLWithString:url];
    
    if(![[dic objectForKey:@"shareduserfullname"]isEqualToString:@""])
    {
        UIImageView *vv=[[UIImageView alloc]initWithFrame:CGRectMake(5, postImage.frame.origin.y+postImage.frame.size.height+3, 15, 15)];
        vv.image=[UIImage imageNamed:@"repeatt"];
        [cell.contentView addSubview:vv];
        
        UILabel *reshareView=[[UILabel alloc]initWithFrame:CGRectMake(20, postImage.frame.origin.y+postImage.frame.size.height, self.view.frame.size.width-90, 20)];
        reshareView.textColor=[UIColor blueColor];
        reshareView.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
        NSString *st=[NSString stringWithFormat:@" By %@",[dic objectForKey:@"shareduserfullname"]];
        reshareView.text=st;
        [cell.contentView addSubview:reshareView];
        reshareView.tag=indexPath.section;
        
        reshareView.userInteractionEnabled=YES;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otheruserProfileOpen1:)];
        [reshareView addGestureRecognizer:gesture];
        
    }
    
    
    
    UILabel *numberOfRepeats=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, postImage.frame.origin.y+postImage.frame.size.height, 80, 25)];
    NSString *repeatStr=@"repeat";
    if ([[dic objectForKey:@"totalShares"] intValue]>1)
    {
        repeatStr=@"repeats";
    }
    
    numberOfRepeats.text=[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"totalShares"], repeatStr];
    numberOfRepeats.textColor=[Helper colorFromHexString:@"8c95a1"];
    numberOfRepeats.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    
    UIImageView *repeaticon=[[UIImageView alloc]initWithFrame:CGRectMake(numberOfRepeats.frame.origin.x-20, numberOfRepeats.frame.origin.y+5, 15, 15)];
    repeaticon.image=[UIImage imageNamed:@"repeat.png"];
    
    numberOfLikes=[[UILabel alloc]initWithFrame:CGRectMake(repeaticon.frame.origin.x-70, numberOfRepeats.frame.origin.y, 60, numberOfRepeats.frame.size.height)];
    
    NSString *likeStr=@"SMILE";
    if ([[dic objectForKey:@"totalLikes"] intValue]>1)
    {
        likeStr=@"SMILES";
    }
    
    numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"totalLikes"], likeStr];
    numberOfLikes.userInteractionEnabled=YES;
    UITapGestureRecognizer *gesturee=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(totalSmilesView:)];
    gesturee.numberOfTapsRequired=1;
    numberOfLikes.tag=indexPath.section;
    [numberOfLikes addGestureRecognizer:gesturee];
    numberOfLikes.textColor=[Helper colorFromHexString:@"8c95a1"];
    numberOfLikes.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    
    UIImageView *hearticon=[[UIImageView alloc]initWithFrame:CGRectMake(numberOfLikes.frame.origin.x-20, repeaticon.frame.origin.y, 15, 15)];
    hearticon.image=[UIImage imageNamed:@"smile.png"];
    hearticon.contentMode=UIViewContentModeScaleAspectFill;
    hearticon.clipsToBounds=YES;
    
    
    UITextView *caption=[[UITextView alloc]initWithFrame:CGRectMake(10, hearticon.frame.origin.y+hearticon.frame.size.height, self.view.frame.size.width-20, 20)];
    caption.delegate=self;
    caption.editable=false;
    caption.scrollEnabled=false;
    caption.dataDetectorTypes = UIDataDetectorTypeLink;
    caption.textColor=[Helper colorFromHexString:@"343536"];
    caption.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    
    NSString *text=@"";
    if (![[dic objectForKey:@"caption"] isKindOfClass:[NSNull class]])
    {
        
        text=[dic objectForKey:@"caption"];
        NSLog(@"text : %@", text);
    }
    
    
    NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"caption"] UTF8String] length:strlen([[dic objectForKey:@"caption"] UTF8String])];
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    NSArray *components=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
    for(int i=0;i<components.count;i++)
    {
        if([components[i] length]>1)
        {
            if([[components[i] substringToIndex:1] isEqualToString:@"#"])
            {
                NSString *sttt=msg;
                NSRange rangee= [sttt rangeOfString: components[i]];
                [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
            }
        }
        
    }
    
    caption.attributedText=string;
    
    
    //caption.text=msg;
    
    CGRect rect=[Helper calculateHeightForText:text fontName:@"Helvetica Neue" fontSize:15 maximumWidth:self.view.frame.size.width-20];
    
    CGRect frame=caption.frame;
    frame.origin.x=10;
    frame.origin.y=caption.frame.origin.y;
    frame.size.width=self.view.frame.size.width-20;
    frame.size.height=rect.size.height+8;
    caption.frame=frame;
    
    [caption sizeToFit];
    
    float yCoordinate=caption.frame.origin.y+caption.frame.size.height-4;
    UIImageView *moodimage;
    UITextView *moodhashtag;
    
    NSLog(@"%@",[dic valueForKey:@"mood"]);
    if ([[dic valueForKey:@"mood"] length]>0)
    {
        moodimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, yCoordinate, 20, 20)];
        moodimage.image=[UIImage imageNamed:@"mood_share.png"];
        
        
        
        moodhashtag=[[UITextView alloc]initWithFrame:CGRectMake(moodimage.frame.origin.x+moodimage.frame.size.width+8, moodimage.frame.origin.y-6, self.view.frame.size.width-moodimage.frame.origin.x+moodimage.frame.size.width+8+8, 28)];
        NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"mood"] UTF8String] length:strlen([[dic objectForKey:@"mood"] UTF8String])];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        moodhashtag.delegate=self;
        moodhashtag.editable=false;
        moodhashtag.scrollEnabled=false;
        
        moodhashtag.backgroundColor=[UIColor clearColor];
        
        NSArray *components1=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
        for(int i=0;i<components1.count;i++)
        {
            if([components1[i] length]>1)
            {
                if([[components1[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    NSString *sttt=msg;
                    NSRange rangee= [sttt rangeOfString: components1[i]];
                    [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
                    
                }
            }
            
        }
        
        moodhashtag.attributedText=string;
        moodhashtag.font=[UIFont systemFontOfSize:13];
        
        [cell.contentView addSubview:moodimage];
        [cell.contentView addSubview:moodhashtag];
        [moodhashtag sizeToFit];
        
        yCoordinate=yCoordinate+20;
    }
    
    UIImageView *wearingimage;
    UITextView *wearinghashtag;
    if ([[dic valueForKey:@"wearing"] length]>0)
    {
        wearingimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, yCoordinate, 20, 20)];
        wearingimage.image=[UIImage imageNamed:@"wearing_share.png"];
        
        wearinghashtag=[[UITextView alloc]initWithFrame:CGRectMake(wearingimage.frame.origin.x+wearingimage.frame.size.width+8, wearingimage.frame.origin.y-6, self.view.frame.size.width-wearingimage.frame.origin.x+wearingimage.frame.size.width+8+8, 28)];
        wearinghashtag.delegate=self;
        wearinghashtag.editable=false;
        wearinghashtag.scrollEnabled=false;
        
        wearinghashtag.backgroundColor=[UIColor clearColor];
        
        NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"wearing"] UTF8String] length:strlen([[dic objectForKey:@"wearing"] UTF8String])];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        NSArray *components1=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
        for(int i=0;i<components1.count;i++)
        {
            if([components1[i] length]>1)
            {
                if([[components1[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    NSString *sttt=msg;
                    NSRange rangee= [sttt rangeOfString: components1[i]];
                    [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
                    
                }
            }
            
        }
        
        wearinghashtag.attributedText=string;
        
        wearinghashtag.font=[UIFont systemFontOfSize:13];
        
        [cell.contentView addSubview:wearingimage];
        [cell.contentView addSubview:wearinghashtag];
        [wearinghashtag sizeToFit];

        
        yCoordinate=yCoordinate+20;
    }
    
    UIImageView *listeningimage;
    UITextView *listenhashtag;
    
    if ([[dic valueForKey:@"listening"] length]>0)
    {
        listeningimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, yCoordinate, 20, 20)];
        listeningimage.image=[UIImage imageNamed:@"listning_share.png"];
        
        listenhashtag=[[UITextView alloc]initWithFrame:CGRectMake(listeningimage.frame.origin.x+listeningimage.frame.size.width+8, listeningimage.frame.origin.y-6, self.view.frame.size.width-listeningimage.frame.origin.x+listeningimage.frame.size.width+8+8, 28)];
        
        listenhashtag.delegate=self;
        listenhashtag.editable=false;
        listenhashtag.backgroundColor=[UIColor clearColor];
        listenhashtag.scrollEnabled=false;
        
        NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"listening"] UTF8String] length:strlen([[dic objectForKey:@"listening"] UTF8String])];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        NSArray *components1=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
        for(int i=0;i<components1.count;i++)
        {
            if([components1[i] length]>1)
            {
                if([[components1[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    NSString *sttt=msg;
                    NSRange rangee= [sttt rangeOfString: components1[i]];
                    [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
                    
                }
            }
            
        }
        
        listenhashtag.attributedText=string;
        listenhashtag.font=[UIFont systemFontOfSize:13];
        
        [cell.contentView addSubview:listeningimage];
        [cell.contentView addSubview:listenhashtag];
        [listenhashtag sizeToFit];

        yCoordinate=yCoordinate+20;
    }
    
    UIImageView *watchimage;
    UITextView *watchhashtag;
    if ([[dic valueForKey:@"watching"] length]>0)
    {
        watchimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, yCoordinate, 20, 20)];
        watchimage.image=[UIImage imageNamed:@"watching_share.png"];
        
        watchhashtag=[[UITextView alloc]initWithFrame:CGRectMake(watchimage.frame.origin.x+watchimage.frame.size.width+8, watchimage.frame.origin.y-6, self.view.frame.size.width-watchimage.frame.origin.x+watchimage.frame.size.width+8+8, 28)];
        watchhashtag.delegate=self;
        watchhashtag.editable=false;
        watchhashtag.backgroundColor=[UIColor clearColor];
        watchhashtag.scrollEnabled=false;
        
        NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"watching"] UTF8String] length:strlen([[dic objectForKey:@"watching"] UTF8String])];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        NSArray *components1=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
        for(int i=0;i<components1.count;i++)
        {
            if([components1[i] length]>1)
            {
                if([[components1[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    NSString *sttt=msg;
                    NSRange rangee= [sttt rangeOfString: components1[i]];
                    [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
                    
                }
            }
            
        }
        
        watchhashtag.attributedText=string;
        watchhashtag.font=[UIFont systemFontOfSize:13];
        [watchhashtag sizeToFit];

        [cell.contentView addSubview:watchimage];
        [cell.contentView addSubview:watchhashtag];
        
        yCoordinate=yCoordinate+20;
    }
    
    UIImageView *locationimage;
    UITextView *locationhashtag;
    
    if ([[dic valueForKey:@"location"] length]>0)
    {
        locationimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, yCoordinate, 20, 20)];
        locationimage.image=[UIImage imageNamed:@"where_share.png"];
        
        locationhashtag=[[UITextView alloc]initWithFrame:CGRectMake(locationimage.frame.origin.x+locationimage.frame.size.width+8, locationimage.frame.origin.y-6, self.view.frame.size.width-locationimage.frame.origin.x+locationimage.frame.size.width+8+8, 28)];
        locationhashtag.delegate=self;
        locationhashtag.editable=false;
        locationhashtag.scrollEnabled=false;
        locationhashtag.backgroundColor=[UIColor clearColor];
        
        NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"location"] UTF8String] length:strlen([[dic objectForKey:@"location"] UTF8String])];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        NSArray *components1=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];
        
        for(int i=0;i<components1.count;i++)
        {
            if([components1[i] length]>1)
            {
                if([[components1[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    //                        NSString *sttt=[dic valueForKey:@"location"];
                    NSString *sttt=msg;
                    NSRange rangee= [sttt rangeOfString: components1[i]];
                    [string addAttribute:NSLinkAttributeName value:@"click" range:rangee];
                    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangee];
                    
                }
            }
            
        }
        
        locationhashtag.attributedText=string;
        
        locationhashtag.font=[UIFont systemFontOfSize:13];
        
        [cell.contentView addSubview:locationimage];
        [cell.contentView addSubview:locationhashtag];
        [locationhashtag sizeToFit];

        yCoordinate=yCoordinate+20;
    }
    
    UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160/2-10, yCoordinate+10, 170, 40)];
    buttonView.backgroundColor=[UIColor whiteColor];
    
    UIView *likeBtnView = [[UIView alloc]initWithFrame:CGRectMake(32.5, 7.5, 25, 25)];
    UIImageView *smileImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
    
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([[dic objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor whiteColor]];
    }
    
    smileImage.contentMode=UIViewContentModeScaleAspectFill;
    smileImage.clipsToBounds=YES;
    [likeBtnView addSubview:smileImage];
    
    UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
    [likeBtn setBackgroundColor:[UIColor clearColor]];
    [likeBtn addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag=indexPath.section;
    
    UIButton *commentBtn =[[UIButton alloc]initWithFrame:CGRectMake(70, 0, 40, buttonView.frame.size.height)];
    [commentBtn setImage:[UIImage imageNamed:@"comment_btn.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentPost:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.tag=indexPath.section;
    
    UIButton *repeatBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 0, 40, buttonView.frame.size.height)];
    [repeatBtn setImage:[UIImage imageNamed:@"repeat_btn.png"] forState:UIControlStateNormal];
    [repeatBtn addTarget:self action:@selector(repeatPost:) forControlEvents:UIControlEventTouchUpInside];
    repeatBtn.tag=indexPath.section;
    
    [buttonView addSubview:likeBtnView];
    [buttonView addSubview:likeBtn];
    
    
    if ([[dic objectForKey:@"commentOnPost"] integerValue]==0)
    {
        [buttonView addSubview:commentBtn];
    }
    
    if ([[dic objectForKey:@"isShare"] integerValue]==0)
    {
        [buttonView addSubview:repeatBtn];
    }
    
    
    //    [repeaticon setBackgroundColor:UIColor.redColor];
    //    [numberOfLikes setBackgroundColor:UIColor.redColor];
    //    [hearticon setBackgroundColor:UIColor.redColor];
    //    [caption setBackgroundColor:UIColor.redColor];
    //    [buttonView setBackgroundColor:UIColor.redColor];
    NSLog(@"%f", postImage.frame.size.height);
    NSLog(@"%f", numberOfRepeats.frame.size.height);
    NSLog(@"%f", repeaticon.frame.size.height);
    NSLog(@"%f", numberOfLikes.frame.size.height);
    NSLog(@"%f", hearticon.frame.size.height);
    NSLog(@"%f", caption.frame.size.height);
    NSLog(@"%f", buttonView.frame.size.height);
    
    [cell.contentView addSubview:postImage];
    [cell.contentView addSubview:numberOfRepeats];
    [cell.contentView addSubview:repeaticon];
    [cell.contentView addSubview:numberOfLikes];
    [cell.contentView addSubview:hearticon];
    [cell.contentView addSubview:caption];
    [cell.contentView addSubview:buttonView];
    
    //    if ([[dic objectForKey:@"islike"] integerValue]==1)
    //    {
    //        UIImageView *smileyImage = [[UIImageView alloc]initWithFrame:CGRectMake(postImage.frame.size.width/2-40, postImage.frame.size.height/2-40, 80, 80)];
    //        [smileyImage setImage:[UIImage imageNamed:@"smiley.png"]];
    //        [cell.contentView addSubview:smileyImage];
    //        if (selectedIndex==indexPath.section)
    //        {
    //
    //            selectedIndex=-1;
    //            smileyImage.hidden=NO;
    //            smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    //            [UIView animateWithDuration:1.0
    //                             animations:^{
    //                                 smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    //                             } completion:^(BOOL finished) {
    //                                 smileyImage.hidden=YES;
    //                             }];
    //        }
    //        else
    //        {
    //            smileyImage.hidden=YES;
    //        }
    //   }
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *dic=[postList objectAtIndex:indexPath.section];
    //    [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"details"];
    //
    //    imageViewController *smvc = [[imageViewController alloc]init];
    //    [self.navigationController pushViewController:smvc animated:YES];
    
    
    
    
    //[self getLikedUserList:dic];
}
-  (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (gesture.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        UIImageView *postImage=(UIImageView *)[gesture view];
        selectedIndex=postImage.tag;
        NSDictionary *dic=[postList objectAtIndex:selectedIndex];
        [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"details"];
        
        imageViewController *smvc = [[imageViewController alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
    }
}
-(void)imageDetailView:(UITapGestureRecognizer *)gesture
{
    
}
-(void)getLikedUserList:(NSDictionary*)dic
{
    //    SearchUserViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"searchUser"];
    //    controller.isLiked=YES;
    //    controller.details=dic;
    //    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=[postList objectAtIndex:indexPath.section];
    
    NSString *text=@"";
    float height = 0.0;
    float width = 0.0;
    
    if (![[dic objectForKey:@"postImage_height"] isKindOfClass:[NSNull class]])
    {
        height = [[dic objectForKey:@"postImage_height"] floatValue];
    }
    
    if (![[dic objectForKey:@"postImage_width"] isKindOfClass:[NSNull class]])
    {
        width = [[dic objectForKey:@"postImage_width"] floatValue];
    }
    
    if (![[dic objectForKey:@"caption"] isKindOfClass:[NSNull class]])
    {
        text=[dic objectForKey:@"caption"];
    }
    CGRect rect=[Helper calculateHeightForText:text fontName:@"Helvetica Neue" fontSize:15 maximumWidth:self.view.frame.size.width-20];
    
    float yCoordinate= height+rect.size.height+10;
    
    
    if ([[dic objectForKey:@"mood"] length]>0)
    {
        yCoordinate=yCoordinate+20;
    }
    
    if ([[dic objectForKey:@"wearing"] length]>0)
    {
        yCoordinate=yCoordinate+20;
    }
    
    if ([[dic objectForKey:@"listening"] length]>0)
    {
        yCoordinate=yCoordinate+20;
    }
    
    if ([[dic objectForKey:@"watching"] length]>0)
    {
        yCoordinate=yCoordinate+20;
    }
    
    if ([[dic objectForKey:@"location"] length]>0)
    {
        yCoordinate=yCoordinate+20;
    }

    
    
    
    return yCoordinate+70;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic=[postList objectAtIndex:section];
    
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    mainView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.7];
    
    AsyncImageView *userCover=[[AsyncImageView alloc]initWithFrame:mainView.bounds];
    NSString *coverURL;
    if ([[dic objectForKey:@"coverPic"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"coverPic"] isEqualToString:@"<null>"])
    {
        
    }
    else
    {
        coverURL=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"coverPic"]];
    }
    
    if (coverURL)
    {
        //userCover.imageURL=[NSURL URLWithString:coverURL];
        
        [userCover sd_setImageWithURL:[NSURL URLWithString:coverURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            userCover.image = image;
            //[self->_tableV rectForHeaderInSection:section];
        }];
        
    }
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    //blackView.alpha=0.70;
    
    //userCover.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"coverPic"]]];
    
    
    AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, 10, 40, 40)];
    userImage.layer.cornerRadius=userImage.frame.size.width/2;
    userImage.clipsToBounds=YES;
    NSString *imageURL;
    if ([[dic objectForKey:@"userImage"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"userImage"] isEqualToString:@"<null>"])
    {
        
    }
    else
    {
        imageURL=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"userImage"]];
    }
    
    if (imageURL)
    {
        //userImage.imageURL=[NSURL URLWithString:imageURL];
        
        [userImage sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            userImage.image = image;
            //[self->_tableV rectForHeaderInSection:section];
        }];
        
    }
    //  userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"profilePic"]]];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"myProfile"]);
    
    NSDictionary *profileDict=[[[NSUserDefaults standardUserDefaults]valueForKey:@"myProfile"]valueForKey:@"userDetails"][0];
    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(56, 4, self.view.frame.size.width, 20)];
    username.text=[profileDict valueForKey:@"username"];
    username.textColor=[Helper colorFromHexString:@"1b73b1"];
    username.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    //username.backgroundColor = [UIColor whiteColor];
    [username sizeToFit];
    
    
    
//    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(75, 28, self.view.frame.size.width-120, 40)];
//    address.text=[profileDict valueForKey:@"address"];
//    address.numberOfLines=2;
//    address.textAlignment=NSTextAlignmentCenter;
//    address.textColor=[Helper colorFromHexString:@"d0d0d0"];
//    address.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
//    address.lineBreakMode = NSLineBreakByWordWrapping;
//    //address.backgroundColor = [UIColor whiteColor];
//    [address sizeToFit];
    
//    UIView *addressView;
//    if (![[profileDict valueForKey:@"address"] isKindOfClass:[NSNull class]] && [[profileDict valueForKey:@"address"] length]>0)
//    {
//        addressView = [[UIView alloc]initWithFrame:CGRectMake(56, 28, 15+4+address.frame.size.width+2, 40)];
//        //addressView.backgroundColor = [UIColor whiteColor];
//
//        UIImageView *addressIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
//        addressIcon.image=[UIImage imageNamed:@"marker.png"];
//
//        address.frame=CGRectMake(19, 0, address.frame.size.width, 20);
//
//        [addressView addSubview:addressIcon];
//        [addressView addSubview:address];
//    }
//    addressView.tag=section;
//    addressView.userInteractionEnabled=YES;
//    UITapGestureRecognizer *gestureloc=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLocation:)];
//    [addressView addGestureRecognizer:gestureloc];
//
//    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 20)];
//    NSLog(@"%@     %@",[NSDate mysqlDatetimeFormattedAsTimeAgo:[dic objectForKey:@"created"]],[dic objectForKey:@"created"]);
//    time.text=[NSDate mysqlDatetimeFormattedAsTimeAgo:[[[NSUserDefaults standardUserDefaults]valueForKey:@"myProfile"]valueForKey:@"created"]];
//    time.textColor=[Helper colorFromHexString:@"8c95a1"];
//    time.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
//    //time.backgroundColor = [UIColor whiteColor];
//    [time sizeToFit];
//
//    UIView *timeView;
//
//    timeView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, userImage.frame.origin.y, 15+5+time.frame.size.width+2, 20)];
//    //timeView.backgroundColor = [UIColor whiteColor];
//
//    UIImageView *timeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
//    timeIcon.image=[UIImage imageNamed:@"time"];
//
//    time.frame=CGRectMake(20, 0, time.frame.size.width, 20);
//
//    [timeView addSubview:timeIcon];
//    [timeView addSubview:time];
//
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    lineView.alpha=0.5;
//
    [mainView addSubview:userCover];
    [mainView addSubview:blackView];
    [mainView addSubview:userImage];
    [mainView addSubview:username];
    //[mainView addSubview:addressIcon];
    //[mainView addSubview:address];
//    [mainView addSubview:addressView];
//    [mainView addSubview:timeView];
    //[mainView addSubview:time];
    [mainView addSubview:lineView];

    mainView.userInteractionEnabled=YES;
    mainView.tag=section;
    UITapGestureRecognizer *gesture  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewProfile:)];
    [mainView addGestureRecognizer:gesture];
    
    
    UIButton *threeDot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    threeDot.frame = CGRectMake(self.view.frame.size.width-40, 0, 40, 40);
    [mainView addSubview:threeDot];
    [threeDot addTarget:self action:@selector(options:) forControlEvents:UIControlEventTouchUpInside];
    threeDot.tag=section;
    UIImageView *img4=[[UIImageView alloc]initWithFrame:CGRectMake(threeDot.frame.size.width/2-10,5, 20, 30)];
    img4.image=[UIImage imageNamed:@"td"];
    img4.contentMode=UIViewContentModeScaleAspectFit;
    img4.userInteractionEnabled=false;
    [threeDot addSubview:img4];
    
    return mainView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}-(void)naVsetting_Action
{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"NAAMEE"
                                 message:@"Do You Want to Logout?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                    [userDefaults setObject:@"" forKey:@"userid"];
                                    [userDefaults synchronize];
                                    ViewController *fpvc=[[ViewController alloc]init];
                                    UINavigationController *navControl=[[UINavigationController alloc]initWithRootViewController:fpvc];
                                    [[[UIApplication sharedApplication] delegate] window].rootViewController=navControl;
                                }];
    [alert addAction:yesButton];
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:@"CANCEL"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
//    settingViewController *smvc = [[settingViewController alloc]init];
//    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)addressLocation:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
    //    NSLog(@"locationtag %ld",gesture.view.tag);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[dic valueForKey:@"lat"] forKey:@"mapLat"];
    [userDefaults setObject:[dic valueForKey:@"lon"]  forKey:@"mapLong"];
    
    [userDefaults setObject:[dic valueForKey:@"address"] forKey:@"address"];
    [userDefaults synchronize];
    GoogleMapViewController *smvc = [[GoogleMapViewController alloc]init];
    smvc.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)scrollToTop
{
    if(self->postList.count>5)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [fTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)otheruserProfileOpen1:(UITapGestureRecognizer*)gesture
{
    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
    NSString *st;
    if([[dic objectForKey:@"sharePostid"]isEqualToString:@""])
    {
        st=[dic objectForKey:@"postid"];
    }
    else
    {
        st=[dic objectForKey:@"sharePostid"];
    }
    [[NSUserDefaults standardUserDefaults]setValue:st forKey:@"postid"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromProfile"];
    [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"explore"];
    otherImageView *smvc = [[otherImageView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)otheruserProfileOpen:(UITapGestureRecognizer*)gesture
{
    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
    if([[dic valueForKey:@"ownerid"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        self.tabBarController.selectedIndex=4;
    }
    else
    {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[dic valueForKey:@"ownerid"] forKey:@"otherUserId"];
        [userDefaults synchronize];
        
        otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
    }
}
-(void)totalSmilesView:(UITapGestureRecognizer*)gesture
{
    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
    NSLog(@"%@",dic);
    detailDictForShare=[dic mutableCopy];
    NSString *st;
    if([[dic objectForKey:@"sharePostid"]isEqualToString:@""])
    {
        st=[dic objectForKey:@"postid"];
    }
    else
    {
        st=[dic objectForKey:@"sharePostid"];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[dic valueForKey:@"postid"] forKey:@"likedpostid"];
    [userDefaults synchronize];
    smileViewController *smvc = [[smileViewController alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)options:(UIButton*)btn
{
    selectedButtonIndax=(int)btn.tag;
    NSDictionary *dic=[postList objectAtIndex:btn.tag];
    detailDict=[dic mutableCopy];
    if([[dic valueForKey:@"user_id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", @"Share", @"Delete", nil];
        sheet.tag=1;
        [sheet showInView:self.view];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Report", nil];
        sheet.tag=2;
        [sheet showInView:self.view];
    }
}
#pragma mark -- ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if (buttonIndex==0)
        {
            //edit


            editPostFilterView *smvc = [[editPostFilterView alloc]init];
            [[NSUserDefaults standardUserDefaults]setValue:detailDict forKey:@"postDdetails"];
            UIImageView *fullImage = (UIImageView *)[self.view viewWithTag:1000+selectedButtonIndax];
            
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(fullImage.image) forKey:@"currentImage"];
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isCommenting"];
            [self.navigationController pushViewController:smvc animated:YES];
            
            FiltersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"filter"];
            controller.details=detailDict;
            controller.capturedImage = fullImage.image;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (buttonIndex==1)
        {
            //share
            UIImageView *fullImage = (UIImageView *)[self.view viewWithTag:1000+selectedButtonIndax];
            
            
            NSString *capString=[detailDict valueForKey:@"caption"];
                                  capString=  [NSString stringWithFormat:@"%@ %@",capString,[detailDict valueForKey:@"mood"]];
                                  capString=  [NSString stringWithFormat:@"%@ %@",capString,[detailDict valueForKey:@"wearing"]];
                                  capString=  [NSString stringWithFormat:@"%@ %@",capString,[detailDict valueForKey:@"watching"]];
                                  capString=  [NSString stringWithFormat:@"%@ %@",capString,[detailDict valueForKey:@"listening"]];
                                  capString=  [NSString stringWithFormat:@"%@ %@",capString,[detailDict valueForKey:@"location"]];
            
            NSArray *objectsToShare = @[capString, fullImage.image];

            
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            NSArray *excludeActivities = @[UIActivityTypePrint,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList];
            
            activityVC.excludedActivityTypes = excludeActivities;
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:activityVC animated:YES completion:nil];
            }
            //if iPad
            else {
                // Change Rect to position Popover
                activityVC.popoverPresentationController.sourceView = usertag;
            }
        }
        else if (buttonIndex==2)
        {
            //delete
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you really want to delete this post?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag=3;
            [alert show];
        }
    }
    else if (actionSheet.tag==2)
    {
        
        [Helper showIndicatorWithText:@"Reporting Post..." inView:self.view];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"reportPost",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"       : [detailDict valueForKey:@"postid"]
                                 };
        NSLog(@"param home: %@",params);
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            NSLog(@"JSON: %@", json);
            [Helper hideIndicatorFromView:self.view];
            
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                //self->backScrollV.contentSize=CGSizeMake(0, 0);
                // [self getFirstTenPost];
                [Helper showAlertViewWithTitle:@"" message:[json objectForKey:@"message"]];
                
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            }
            
            
        }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [Helper hideIndicatorFromView:self.view];
         }];
    }
    
}
#pragma mark -- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==3)
    {
        if (buttonIndex==1)
        {
            [self deletePostByPostID:[detailDict valueForKey:@"postid"]];
        }
    }
}

#pragma mark -- Notification Methods

-(void)deletePost:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)deletePostByPostID:(NSString *)postID
{
    [Helper showIndicatorWithText:@"Deleting Post..." inView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"deletePost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"         :postID
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            [self viewWillAppear:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:self->detailDict];
            
            //[self.navigationController popViewControllerAnimated:YES];
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
-(void)like:(UITapGestureRecognizer *)gesture
{
    UIImageView *postImage=(UIImageView *)[gesture view];
    // Build the two index paths
    selectedIndex=postImage.tag;
    
    NSDictionary *dic=[postList objectAtIndex:postImage.tag];
    
    UIImageView *smileyImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-40, postImage.frame.size.height/2-40, 80, 80)];
    [smileyImage setImage:[UIImage imageNamed:@"smiley.png"]];
    [postImage addSubview:smileyImage];
    
    //smileyImage.hidden=NO;
    smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:1.0
                     animations:^{
                         smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         smileyImage.hidden=YES;
                         [smileyImage removeFromSuperview];
                     }];
    
    
    if ([[dic objectForKey:@"islike"] integerValue]==0)
    {
        //like
        long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
        totalLikes=totalLikes+1;
        NSMutableDictionary *details=[dic mutableCopy];
        [details setObject:@"1" forKey:@"islike"];
        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
        [postList insertObject:details atIndex:postImage.tag];
        [postList removeObjectAtIndex:postImage.tag+1];
     
        [fTable reloadData];
        
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"likePost",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"         :[dic objectForKey:@"postid"]
                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            NSLog(@"JSON: %@", json);
            [Helper hideIndicatorFromView:self.view];
            
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                
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
    
    
}


#pragma mark -- Button Action

-(void)likePost:(UIButton *)sender
{
    @try {
        if ([Helper isInternetConnected]==YES)
        {
            selectedIndex=sender.tag;
            NSDictionary *dic=[postList objectAtIndex:sender.tag];
            if ([[dic objectForKey:@"islike"] integerValue]==0)
            {
                
                //like
                long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
                totalLikes=totalLikes+1;
                NSMutableDictionary *details=[dic mutableCopy];
                [details setObject:@"1" forKey:@"islike"];
                [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
                [postList insertObject:details atIndex:sender.tag];
                [postList removeObjectAtIndex:sender.tag+1];
                
                [fTable reloadData];
                
                
                
                
                
                NSString *st;
                if([[dic objectForKey:@"sharePostid"]isEqualToString:@""])
                {
                    st=[dic objectForKey:@"postid"];
                }
                else
                {
                    st=[dic objectForKey:@"sharePostid"];
                }
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *params = @{
                                         @"method"       : @"likePost",
                                         @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                         @"postid"         :st
                                         };
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = nil;
                [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:kNilOptions
                                                                           error:nil];
                    NSLog(@"JSON: %@", json);
                    [Helper hideIndicatorFromView:self.view];
                    
                    if ([[json objectForKey:@"success"]integerValue]==1)
                    {
                        
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
                
                //like
                long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
                totalLikes=totalLikes-1;
                NSMutableDictionary *details=[dic mutableCopy];
                [details setObject:@"0" forKey:@"islike"];
                [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
                [postList insertObject:details atIndex:sender.tag];
                [postList removeObjectAtIndex:sender.tag+1];
                [fTable reloadData];
                
                //                NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
                //                NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
                //                // Launch reload for the two index path
                //                [_tableV reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                
                NSString *st;
                if([[dic objectForKey:@"sharePostid"]isEqualToString:@""])
                {
                    st=[dic objectForKey:@"postid"];
                }
                else
                {
                    st=[dic objectForKey:@"sharePostid"];
                }
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *params = @{
                                         @"method"       : @"unLikePost",
                                         @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                         @"postid"         :st
                                         };
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = nil;
                [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:kNilOptions
                                                                           error:nil];
                    NSLog(@"JSON: %@", json);
                    [Helper hideIndicatorFromView:self.view];
                    
                    if ([[json objectForKey:@"success"]integerValue]==1)
                    {
                        
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
            
            
            
            
            
            
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
}

-(void)commentPost:(UIButton *)sender
{
    @try {
        NSDictionary *dic=[postList objectAtIndex:sender.tag];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:dic forKey:@"postDetails"];
        [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)sender.tag] forKey:@"postcount"];
        [userDefaults setObject:@"ok" forKey:@"home"];
        
        [userDefaults synchronize];
        
        
        
        commentViewController *smvc = [[commentViewController alloc]init];
        smvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:smvc animated:YES];
        //        [self.navigationController presentViewController:smvc animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

-(void)repeatPost:(UIButton *)sender
{
    
    if([[[postList objectAtIndex:sender.tag]valueForKey:@"isShare"]intValue]==0)
    {
        [Helper showIndicatorWithText:@"updating Posts..." inView:self.view];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"sharePost",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"       : [[postList objectAtIndex:sender.tag]valueForKey:@"postid"]
                                 };
        NSLog(@"param home: %@",params);
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            NSLog(@"JSON: %@", json);
            [Helper hideIndicatorFromView:self.view];
            
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                [Helper showAlertViewWithTitle:@"" message:[json objectForKey:@"message"]];

                //self->backScrollV.contentSize=CGSizeMake(0, 0);
                //[self getFirstTenPost];
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            }
            
            
        }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [Helper hideIndicatorFromView:self.view];
         }];
    }
    
}

-(void)viewProfile:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
    if([[dic valueForKey:@"user_id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
       // self.tabBarController.selectedIndex=4;
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[dic valueForKey:@"user_id"] forKey:@"otherUserId"];
        [userDefaults synchronize];
        
        otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
    }
}
@end
