//
//  otherUserProfileView.m
//  naamee
//
//  Created by mac on 17/12/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "otherUserProfileView.h"
#import "AsyncImageView.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "NSDate+NVTimeAgo.h"
#import "otherFollowingListView.h"
#import "otherFollowerListView.h"
#import "otherImageView.h"
#import "GoogleMapViewController.h"
#import "hashtagScreenView.h"
@interface otherUserProfileView ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    AsyncImageView *userImage;
    UILabel *followersLbl,*followingLbl,*postsLbl,*repeatLbl,*namelbl;
    UITextView *userDetail,*userwebsite;
    UICollectionView *imageScrollView;
    UIButton *gridBtn,*listBtn,*likeAction,*usertag;
    NSMutableArray *userImagesArr,*userLikedArr;
    int followingOrNot,followedOrNot;
    UIButton *folowBtn,*repostBtn;
    UITableView *fTable;
    NSMutableDictionary *userdetaildict;
    int sendRequest;
    NSMutableArray *userrepostArr;
    int selectedButton;
    UIButton *nameBtn;
    NSURL *webLink;

    NSDictionary *userAllDetail;
    
    int selectedButtonIndax;
     int gridButtonSelection;
     
     UIView *highlightView;
}
@end

@implementation otherUserProfileView

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedButton=0;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.navigationController.navigationBarHidden=true;
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 69, 100, 100)];
    userImage.layer.borderWidth=0.5;
    userImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    userImage.clipsToBounds=YES;
    [self.view addSubview:userImage];
    
    namelbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 170,310, 30)];
    namelbl.text = @"";
    namelbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:namelbl];
    
    nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, navigationView.frame.size.height-44, 200, 44);
    nameBtn.backgroundColor=[UIColor clearColor];
    [nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationView addSubview:nameBtn];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
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
    
    folowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    folowBtn.frame = CGRectMake(self.view.frame.size.width-110, 70, 95, 65);
    [folowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [folowBtn setTitle:@"Follow" forState:UIControlStateNormal];
    UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [folowBtn setImage:image2 forState:UIControlStateNormal];
    folowBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    folowBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 47, 0, 0);
    folowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -50, 0);
    [folowBtn addTarget:self action:@selector(follow_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:folowBtn];
    
    
    userDetail=[[UITextView alloc]initWithFrame:CGRectMake(10, 205,self.view.frame.size.width-20, 50)];
    userDetail.layer.cornerRadius=5.0;
    userDetail.layer.borderWidth=0.0;
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
    followingOrNot=0;

    
  
    
    
    gridBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    gridBtn.frame = CGRectMake(0, 280, self.view.frame.size.width/4, 40);
    [gridBtn addTarget:self action:@selector(grid_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gridBtn];
    
    
    UIImageView *img4=[[UIImageView alloc]initWithFrame:CGRectMake(gridBtn.frame.size.width/2-10, gridBtn.frame.size.height/2-10, 20, 20)];
    img4.image=[UIImage imageNamed:@"9-Dotted-Icon"];
    img4.contentMode=UIViewContentModeScaleAspectFit;
    img4.userInteractionEnabled=false;
    [gridBtn addSubview:img4];
    
    listBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    listBtn.frame = CGRectMake(self.view.frame.size.width/4, 280, self.view.frame.size.width/4, 40);
    //[listBtn setImage:[[UIImage imageNamed:@"3-line-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [listBtn addTarget:self action:@selector(list_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBtn];
    
    UIImageView *img5=[[UIImageView alloc]initWithFrame:CGRectMake(listBtn.frame.size.width/2-10, listBtn.frame.size.height/2-10, 20, 20)];
    img5.image=[UIImage imageNamed:@"3-line-Icon"];
    img5.contentMode=UIViewContentModeScaleAspectFit;
    img5.userInteractionEnabled=false;
    [listBtn addSubview:img5];
    
    
    repostBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    repostBtn.frame = CGRectMake((self.view.frame.size.width/4)*2, 280, self.view.frame.size.width/4, 40);
    //[listBtn setImage:[[UIImage imageNamed:@"3-line-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [repostBtn addTarget:self action:@selector(grid_Action1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repostBtn];
    
    UIImageView *img6=[[UIImageView alloc]initWithFrame:CGRectMake(listBtn.frame.size.width/2-10, listBtn.frame.size.height/2-10, 20, 20)];
    img6.image=[UIImage imageNamed:@"repost"];
    img6.contentMode=UIViewContentModeScaleAspectFit;
    img6.userInteractionEnabled=false;
    [repostBtn addSubview:img6];
    
    
    likeAction = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    likeAction.frame = CGRectMake((self.view.frame.size.width/4)*3, 280, self.view.frame.size.width/4, 40);
    //[likeAction setImage:[[UIImage imageNamed:@"like-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [likeAction addTarget:self action:@selector(liked_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeAction];
    
    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/4)/2-10, 10, 20, 20)];
    img2.image=[UIImage imageNamed:@"like-icon"];
    img2.contentMode=UIViewContentModeScaleAspectFit;
    img2.userInteractionEnabled=false;
    [likeAction addSubview:img2];
    
    
    [self getLikedPost];
    
    [highlightView removeFromSuperview];
           highlightView=[[UIView alloc]initWithFrame:CGRectMake(gridBtn.frame.size.width/2-5, gridBtn.frame.size.height-10, 10, 7.5)];
           highlightView.backgroundColor=[UIColor greenColor];
           [gridBtn addSubview:highlightView];
      
    
}
-(void)getLikedPost
{
    NSLog(@"uid_totalLikePostByUser: %@", [[NSUserDefaults standardUserDefaults]stringForKey:@"uid"]);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"totalLikePostByUser",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
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
-(void)liked_Action
{
    selectedButton=3;

         [highlightView removeFromSuperview];
         highlightView=[[UIView alloc]initWithFrame:CGRectMake(likeAction.frame.size.width/2, likeAction.frame.size.height-10, 10, 7.5)];
         highlightView.backgroundColor=[UIColor greenColor];
         [likeAction addSubview:highlightView];
    
  
    self->imageScrollView.hidden=false;
    self->fTable.hidden=true;
    [imageScrollView reloadData];
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    
    
    [[UIApplication sharedApplication] openURL:webLink];

}
-(void)getRpeatPost
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"totalrePostByUser",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
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
-(void)followerBtn:(UITapGestureRecognizer *)gesture
{
    [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"] forKey:@"otherUserIdd"];
    otherFollowerListView *smvc = [[otherFollowerListView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)followingBtn:(UITapGestureRecognizer *)gesture
{
    [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"] forKey:@"otherUserIdd"];
    otherFollowingListView *smvc = [[otherFollowingListView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:false];
    

    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"otherUserProfile",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"otheruserid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
                             @"device"       :[NSString stringWithFormat:@"%0.0f", self.view.frame.size.width],

                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            
            self->userAllDetail=[json mutableCopy];
            [self getAllPosts];
            [self getRpeatPost];

            NSDictionary *dict=[[[json valueForKey:@"userdetails"]objectAtIndex:0]mutableCopy];
           
            if([[dict valueForKey:@"viewYourAction"]intValue]==0)
            {
            
                self->sendRequest=0;

            //viewYourAction
            self->followingOrNot=[[json objectForKey:@"following"]intValue];
            self->followedOrNot=[[json objectForKey:@"followed"]intValue];
            if([[json objectForKey:@"following"]intValue]==0)
            {
                UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                [self->folowBtn setTitle:@"Follow" forState:UIControlStateNormal];

            }
            else
            {
                UIImage *image2 = [[UIImage imageNamed:@"another_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                [self->folowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];

            }
            NSLog(@"%@",[json objectForKey:@"myfollowers"]);
            self->followersLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"totalFollowed"]integerValue] ];
            self->followingLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"totalFollowing"]integerValue] ];
            self->repeatLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"totalRepost"]integerValue] ];

            
            
            self->userdetaildict=[[[json valueForKey:@"userdetails"]objectAtIndex:0]mutableCopy];

            self->userwebsite.text=[dict valueForKey:@"website"];
                if ([[dict valueForKey:@"website"] rangeOfString:@"http"].location == NSNotFound) {
                                self->webLink=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[dict valueForKey:@"website"]]];
                            }
                        else
                        {
                            self->webLink=[NSURL URLWithString:[dict valueForKey:@"website"]];

                        }
            self->namelbl.text=[dict valueForKey:@"fullname"];
                [self->nameBtn setTitle:[dict objectForKey:@"username"] forState:UIControlStateNormal];

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
                
                
                
                
            //self->userDetail.text=[dict valueForKey:@"description"];
            
            self->userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[dict valueForKey:@"profile_pic"]]];
            
            
            
         
            
            self->userImage.layer.cornerRadius=self->userImage.frame.size.width/2;
            }
            else
            {
                
                
                //viewYourAction
                self->followingOrNot=[[json objectForKey:@"following"]intValue];
                self->followedOrNot=[[json objectForKey:@"followed"]intValue];
                if([[json objectForKey:@"following"]intValue]==0)
                {
                    UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                    [self->folowBtn setTitle:@"Follow" forState:UIControlStateNormal];
                    
                }
                else
                {
                    UIImage *image2 = [[UIImage imageNamed:@"another_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                    [self->folowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
                    
                }
                NSLog(@"%@",[json objectForKey:@"myfollowers"]);
                self->followersLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"totalFollowed"]integerValue] ];
                self->followingLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"totalFollowing"]integerValue] ];
                self->repeatLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"totalRepost"]integerValue] ];
                
                
                
                self->userdetaildict=[[[json valueForKey:@"userdetails"]objectAtIndex:0]mutableCopy];
                
                self->userwebsite.text=[dict valueForKey:@"website"];
                self->userwebsite.textColor=[UIColor blueColor];
                self->namelbl.text=[dict valueForKey:@"fullname"];
                
                
                
                
                
                
               // self->userDetail.text=[dict valueForKey:@"description"];
                
                self->userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[dict valueForKey:@"profile_pic"]]];
                
                [self->folowBtn setTitle:@"Request Sent" forState:UIControlStateNormal];

                
                self->sendRequest=2;
                
                self->userImage.layer.cornerRadius=self->userImage.frame.size.width/2;
            }
        }
        else
        {
            [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
        }
        

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
}
-(void)getAllPosts
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"otherUserPost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"otheruserid"  : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
                             @"page"         :@"1",
                             @"device"       :[NSString stringWithFormat:@"%0.0f", self.view.frame.size.width],

                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            
           
        self->postsLbl.text=[NSString stringWithFormat:@"%ld",[[json objectForKey:@"postDetails"] count] ];
            self->userImagesArr=[[json valueForKey:@"postDetails"]mutableCopy];
            
            if([[self->userAllDetail valueForKey:@"public_private_status"]intValue]==1 && [[self->userAllDetail valueForKey:@"following"]intValue]==0)
                       {
                           
                           self->followersLbl.userInteractionEnabled=false;
                           self->followingLbl.userInteractionEnabled=false;
                           self->repeatLbl.userInteractionEnabled=false;
                           self->postsLbl.userInteractionEnabled=false;

                           
                           UIView *privateView;
                           
                           privateView =[[UIView alloc]initWithFrame:CGRectMake(0, 275, self.view.frame.size.width, self.view.frame.size.height-275)];
                           privateView.backgroundColor=[UIColor whiteColor];
                           [self.view addSubview:privateView];
                           
                           UIImageView *iii = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 30, 60, 60)];
                           iii.image=[UIImage imageNamed:@"lock1"];
                           [privateView addSubview: iii];
                           
                           
                           UILabel *plbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 25)];
                           plbl.text = @"This Account is Private";
                           plbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
                           plbl.backgroundColor = [UIColor clearColor];
                           plbl.textColor = [UIColor lightGrayColor];
                           plbl.textAlignment = NSTextAlignmentCenter;
                           [privateView addSubview:plbl];
                           
                           UILabel *plbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 145, self.view.frame.size.width, 25)];
                              plbl1.text = @"Follow to see the photos";
                              plbl1.font=[UIFont fontWithName:@"Arial-BoldMT" size:17.0f];
                              plbl1.backgroundColor = [UIColor clearColor];
                              plbl1.textColor = [UIColor blackColor];
                              plbl1.textAlignment = NSTextAlignmentCenter;
                              [privateView addSubview:plbl1];
                           
                       }
                       else
                       {
                           if(self->imageScrollView)
                        {
                            [self->imageScrollView reloadData];
                            [self->fTable reloadData];
                        }
                        else
                        {

                            if(self->userImagesArr.count>0)
                            {
                                self->fTable = [[UITableView alloc] initWithFrame:CGRectMake(0,self->listBtn.frame.size.height+self->listBtn.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height-self->listBtn.frame.size.height-self->listBtn.frame.origin.y ) style:UITableViewStylePlain];
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

                                self->imageScrollView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,self->listBtn.frame.size.height+self->listBtn.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height-self->listBtn.frame.size.height-self->listBtn.frame.origin.y ) collectionViewLayout:layout];
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
                              }
                       }
            
            
            
            
            
           
            
            
        }
        else
        {
            [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
}
-(void)usertag_Action
{
    
}
-(void)follow_Action
{
    
    if(self->sendRequest==1)
    {
        [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"sendRequest"       : @"addFollowers",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"otheruserid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
                                 
                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            [Helper hideIndicatorFromView:self.view];
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                self->followingOrNot=1;
                
                UIImage *image2 = [[UIImage imageNamed:@"another_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                [self->folowBtn setTitle:@"Request Sent" forState:UIControlStateNormal];
                
                
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
    }
    else if(self->sendRequest==2)
    {
        
    }
    else
    {
    if(followingOrNot==0)
    {
    [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"addFollowers",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"toWhomFollow"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
                             
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        [Helper hideIndicatorFromView:self.view];
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
                self->followingOrNot=1;

            UIImage *image2 = [[UIImage imageNamed:@"another_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                    [self->folowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
            
           
        }
        else
        {
            [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    }
    else
    {
        [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
        self->followingOrNot=0;

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"unFollowUser",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"toWhomFollow"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserId"],
                                 
                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            [Helper hideIndicatorFromView:self.view];
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                        [self->folowBtn setImage:image2 forState:UIControlStateNormal];
                        [self->folowBtn setTitle:@"Follow" forState:UIControlStateNormal];
                
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
    }
    }
}
-(void)grid_Action
{
    
    [highlightView removeFromSuperview];
         highlightView=[[UIView alloc]initWithFrame:CGRectMake(gridBtn.frame.size.width/2-5, gridBtn.frame.size.height-10, 10, 7.5)];
         highlightView.backgroundColor=[UIColor greenColor];
         [gridBtn addSubview:highlightView];
       
    
    
    self->imageScrollView.hidden=false;
    self->fTable.hidden=true;
    selectedButton=0;
    [imageScrollView reloadData];

}
-(void)grid_Action1
{
    
    [highlightView removeFromSuperview];
         highlightView=[[UIView alloc]initWithFrame:CGRectMake(gridBtn.frame.size.width/2-5, gridBtn.frame.size.height-10, 10, 7.5)];
         highlightView.backgroundColor=[UIColor greenColor];
         [repostBtn addSubview:highlightView];
       
    
    
    self->imageScrollView.hidden=false;
    self->fTable.hidden=true;
    selectedButton=1;
    [imageScrollView reloadData];
}

-(void)list_Action
{
    [highlightView removeFromSuperview];
    highlightView=[[UIView alloc]initWithFrame:CGRectMake(listBtn.frame.size.width/2-5, listBtn.frame.size.height-10, 10, 7.5)];
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
    if(selectedButton==0)
    return [self->userImagesArr count];
    if(selectedButton==3)
        return [self->userLikedArr count];
    else
        return self->userrepostArr.count;
    
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
    if(selectedButton==0)
    url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->userImagesArr objectAtIndex:indexPath.row]valueForKey:@"postImage"]];
    if(selectedButton==3)
        url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->userLikedArr objectAtIndex:indexPath.row]valueForKey:@"postImage"]];
    else
        url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->userrepostArr objectAtIndex:indexPath.row]valueForKey:@"postImage"]];

    postImage.imageURL=[NSURL URLWithString:url];
    postImage.contentMode=UIViewContentModeScaleAspectFill;
    postImage.clipsToBounds = true;
    [cell addSubview:postImage];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if(selectedButton==0)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromProfile"];

    dic=[self->userImagesArr objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"explore"];
        
        if([dic objectForKey:@"post_id"]!= nil)
            [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"post_id"] forKey:@"postid"];
        else if([dic objectForKey:@"postid"]!= nil)
            [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"postid"] forKey:@"postid"];
        else
            [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"sharePostid"] forKey:@"postid"];

    }
    if(selectedButton==3)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromProfile"];
        dic=[self->userLikedArr objectAtIndex:indexPath.row];
        if([dic objectForKey:@"post_id"]!= nil)
            [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"post_id"] forKey:@"postid"];
        else if([dic objectForKey:@"postid"]!= nil)
            [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"postid"] forKey:@"postid"];
        else
        [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"sharePostid"] forKey:@"postid"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromProfile"];

        dic=[self->userrepostArr objectAtIndex:indexPath.row];
        if([dic objectForKey:@"post_id"]!= nil)
                   [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"post_id"] forKey:@"postid"];
               else if([dic objectForKey:@"postid"]!= nil)
                   [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"postid"] forKey:@"postid"];
               else
               [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"sharePostid"] forKey:@"postid"];
    }
    otherImageView *smvc = [[otherImageView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.view.frame.size.width/3,self.view.frame.size.width/3);

}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- TableView Delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self->userImagesArr count];
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
    
    
    AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    NSString *url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->userImagesArr objectAtIndex:indexPath.section]valueForKey:@"postImage"]];
    postImage.imageURL=[NSURL URLWithString:url];
    postImage.contentMode=UIViewContentModeScaleAspectFit;
    [cell addSubview:postImage];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width+5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic=[userImagesArr objectAtIndex:section];
    
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    mainView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.7];
    
    AsyncImageView *userCover=[[AsyncImageView alloc]initWithFrame:mainView.bounds];
    
    
    userCover.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[userdetaildict valueForKey:@"coverPic"]]];
    
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha=0.50;
    
    
    
    AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, 10, 40, 40)];
    userImage.layer.cornerRadius=userImage.frame.size.width/2;
    userImage.clipsToBounds=YES;
    
    
    userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[userdetaildict valueForKey:@"profile_pic"]]];
    
    //  userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"profilePic"]]];
    
    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(56, 4, self.view.frame.size.width, 20)];
    username.text=[dic objectForKey:@"fullname"];
    username.textColor=[Helper colorFromHexString:@"1b73b1"];
    username.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:15];
    //username.backgroundColor = [UIColor whiteColor];
    [username sizeToFit];
    
    
    
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(75, 28, self.view.frame.size.width-120, 40)];
    address.text=[dic objectForKey:@"address"];
    address.numberOfLines=2;
    address.textAlignment=NSTextAlignmentCenter;
    address.textColor=[Helper colorFromHexString:@"d0d0d0"];
    address.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
    address.lineBreakMode = NSLineBreakByWordWrapping;
    //address.backgroundColor = [UIColor whiteColor];
    [address sizeToFit];
    
    UIView *addressView;
    if (![[dic objectForKey:@"address"] isKindOfClass:[NSNull class]] && [[dic objectForKey:@"address"] length]>0)
    {
        addressView = [[UIView alloc]initWithFrame:CGRectMake(56, 28, 15+4+address.frame.size.width+2, 40)];
        //addressView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *addressIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        addressIcon.image=[UIImage imageNamed:@"marker.png"];
        
        address.frame=CGRectMake(19, 0, address.frame.size.width, 20);
        
        [addressView addSubview:addressIcon];
        [addressView addSubview:address];
    }
    addressView.tag=section;
    addressView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gestureloc=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLocation:)];
    [addressView addGestureRecognizer:gestureloc];
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 20)];
    time.text=[NSDate mysqlDatetimeFormattedAsTimeAgo:[dic objectForKey:@"created"]];
    time.textColor=[Helper colorFromHexString:@"8c95a1"];
    time.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    //time.backgroundColor = [UIColor whiteColor];
    [time sizeToFit];
    
    UIView *timeView;
    
    timeView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, userImage.frame.origin.y, 15+5+time.frame.size.width+2, 20)];
    //timeView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *timeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
    timeIcon.image=[UIImage imageNamed:@"time"];
    
    time.frame=CGRectMake(20, 0, time.frame.size.width, 20);
    
    [timeView addSubview:timeIcon];
    [timeView addSubview:time];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    lineView.alpha=0.5;
    
    [mainView addSubview:userCover];
    [mainView addSubview:blackView];
    [mainView addSubview:userImage];
    [mainView addSubview:username];
    //[mainView addSubview:addressIcon];
    //[mainView addSubview:address];
    // [mainView addSubview:addressView];
    // [mainView addSubview:timeView];
    //[mainView addSubview:time];
    [mainView addSubview:lineView];
    
    mainView.userInteractionEnabled=YES;
    mainView.tag=section;
    UITapGestureRecognizer *gesture  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewProfile:)];
    //[mainView addGestureRecognizer:gesture];
    
    return mainView;
}
-(void)addressLocation:(UITapGestureRecognizer *)gesture
{
//    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
//    //    NSLog(@"locationtag %ld",gesture.view.tag);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    //    [userDefaults setObject:[dic valueForKey:@"latitude"] forKey:@"mapLat"];
//    //    [userDefaults setObject:[dic valueForKey:@"longitude"]  forKey:@"mapLong"];
//    
//    [userDefaults setObject:[dic valueForKey:@"address"] forKey:@"address"];
//    [userDefaults synchronize];
//    GoogleMapViewController *smvc = [[GoogleMapViewController alloc]init];
//    smvc.hidesBottomBarWhenPushed=NO;
//    [self.navigationController pushViewController:smvc animated:YES];
    
}
@end
