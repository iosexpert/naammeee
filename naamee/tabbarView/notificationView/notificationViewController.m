//
//  notificationViewController.m
//  naamee
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "notificationViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "Helper.h"
#import "AsyncImageView.h"
#import "otherUserProfileView.h"
#import "otherImageView.h"
@interface notificationViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *folowersBtn,*youBtn;
    NSMutableArray *notificationArr,*younotificationArr;
    UITableView *fTable;
    int selectedIndex;
    UIView *selectionViewShown;
    int selectedTab;

}
@end

@implementation notificationViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self->fTable = [[UITableView alloc] initWithFrame:CGRectMake(0,64 , self.view.frame.size.width,self.view.frame.size.height-64 ) style:UITableViewStylePlain];
    self->fTable.delegate = self;
    self->fTable.dataSource = self;
    self->fTable.tag=0;
    self->fTable.backgroundColor = [UIColor clearColor];
    self->fTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self->fTable];
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:31/255.0 green:142/255.0 blue:212/255.0 alpha:1.0];
    [self.view addSubview: navigationView];
    
    
    folowersBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    folowersBtn.frame = CGRectMake(0, 20, self.view.frame.size.width/2, 44);
    folowersBtn.backgroundColor=[UIColor clearColor];
    [folowersBtn setTitle:@"FOLLOWING" forState:UIControlStateNormal];
    [folowersBtn setTintColor:[UIColor whiteColor]];
    [folowersBtn addTarget:self action:@selector(followers_action) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:folowersBtn];
    
    selectedTab=0;
    youBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    youBtn.frame = CGRectMake(self.view.frame.size.width/2, 20, self.view.frame.size.width/2, 44);
    youBtn.backgroundColor=[UIColor clearColor];
    [youBtn setTitle:@"NOTIFICATIONS" forState:UIControlStateNormal];
    [youBtn setTintColor:[UIColor whiteColor]];
    [youBtn addTarget:self action:@selector(you_action) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:youBtn];
    
    selectionViewShown=[[UIView alloc]initWithFrame:CGRectMake(10, 59, self.view.frame.size.width/2-20, 5)];
    selectionViewShown.backgroundColor=[UIColor clearColor];
    [self.view addSubview:selectionViewShown];
    
    
    UIView *greenv=[[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/2-20, 5)];
    greenv.backgroundColor=[UIColor greenColor];
    [selectionViewShown addSubview:greenv];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=true;
    self.view.backgroundColor= [UIColor whiteColor];
    [self.tabBarController.tabBar setHidden:false];
    [self getfollowingNotification];

}
-(void)getNotification
{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"getNotification",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
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
            
            self->notificationArr=[[json objectForKey:@"notification"]mutableCopy];
            [self->fTable reloadData];
        }
        else
        {

            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
}
-(void)getfollowingNotification
{
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"getFollowingNotification",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
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
            
            self->younotificationArr=[[json objectForKey:@"notification"]mutableCopy];
            [self->fTable reloadData];
            [self getNotification];

        }
        else
        {
            
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
}

-(void)followers_action
{
    [folowersBtn setTintColor:[UIColor whiteColor]];
    [youBtn setTintColor:[UIColor lightGrayColor]];
    selectedTab=0;
    CGRect f = selectionViewShown.frame;
    f.origin.x = 10;
    selectionViewShown.frame = f;
    [fTable reloadData];
}
-(void)you_action
{
    [youBtn setTintColor:[UIColor whiteColor]];
    [folowersBtn setTintColor:[UIColor lightGrayColor]];
    selectedTab=1;
    CGRect f = selectionViewShown.frame;
    f.origin.x = self.view.frame.size.width/2;;
    selectionViewShown.frame = f;
    [fTable reloadData];

}
#pragma mark -- TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(selectedTab==1)
    return notificationArr.count;
    else
    return younotificationArr.count;

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
    NSDictionary *dic;
    if(selectedTab==1)
    dic=[notificationArr objectAtIndex:indexPath.section];
    else
        dic=[younotificationArr objectAtIndex:indexPath.section];
 if(selectedTab==1)
 {
    if([[dic valueForKey:@"notificationtype"]isEqualToString:@"like"])
    {
        AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
        userImage.userInteractionEnabled=YES;
        NSString *url;
        url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"userImage"]];
        userImage.imageURL=[NSURL URLWithString:url];
        userImage.contentMode=UIViewContentModeScaleAspectFill;
        userImage.layer.cornerRadius=40;
        userImage.clipsToBounds = true;
        [cell addSubview:userImage];
        
        UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nameBtn.frame = CGRectMake(90, 20, 200, 30);
        nameBtn.backgroundColor=[UIColor clearColor];
        [nameBtn setTitle:[dic valueForKey:@"userName"] forState:UIControlStateNormal];
        [nameBtn setTintColor:[UIColor blackColor]];
        nameBtn.tag=indexPath.section;
        [nameBtn addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];
        nameBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:13];
        [nameBtn sizeToFit];
        [cell addSubview:nameBtn];
        
        UIButton *likedLbl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        likedLbl.frame = CGRectMake(nameBtn.frame.origin.x+nameBtn.frame.size.width+5, 23, 200, 30);
        likedLbl.backgroundColor=[UIColor clearColor];
        [likedLbl setTitle:@"liked your post." forState:UIControlStateNormal];
        [likedLbl setTintColor:[UIColor blackColor]];
        likedLbl.tag=indexPath.section;
        likedLbl.userInteractionEnabled=false;
        likedLbl.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
        [likedLbl sizeToFit];
        [cell addSubview:likedLbl];
        
        AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85, 10, 80, 80)];
        postImage.userInteractionEnabled=YES;
        NSString *url22;
        url22=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"postImage"]];
        postImage.imageURL=[NSURL URLWithString:url22];
        postImage.contentMode=UIViewContentModeScaleAspectFill;
        postImage.clipsToBounds = true;
        postImage.tag=indexPath.section;
        [cell addSubview:postImage];
        postImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPost:)];
        gesture.numberOfTapsRequired=1;
        [postImage addGestureRecognizer:gesture];
        
    }
    if([[dic valueForKey:@"notificationtype"]isEqualToString:@"comment"])
    {
        AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
        userImage.userInteractionEnabled=YES;
        NSString *url;
        url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"userImage"]];
        userImage.imageURL=[NSURL URLWithString:url];
        userImage.contentMode=UIViewContentModeScaleAspectFill;
        userImage.clipsToBounds = true;
        userImage.layer.cornerRadius=40;
        [cell addSubview:userImage];
        
        UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        nameBtn.frame = CGRectMake(90, 20, 200, 30);
        nameBtn.backgroundColor=[UIColor clearColor];
        nameBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:12];
        [nameBtn setTitle:[dic valueForKey:@"userName"] forState:UIControlStateNormal];
        [nameBtn setTintColor:[UIColor blackColor]];
        nameBtn.tag=indexPath.section;
        [nameBtn sizeToFit];
        [nameBtn addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:nameBtn];
        
        UIButton *commentLbl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        commentLbl.frame = CGRectMake(nameBtn.frame.origin.x+nameBtn.frame.size.width+5, 23, 200, 30);
        commentLbl.backgroundColor=[UIColor clearColor];
        commentLbl.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
        [commentLbl setTitle:@"comment on your post." forState:UIControlStateNormal];
        [commentLbl setTintColor:[UIColor blackColor]];
        commentLbl.tag=indexPath.section;
        [commentLbl sizeToFit];
        commentLbl.userInteractionEnabled=false;
        [cell addSubview:commentLbl];
        
        AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85, 10, 80, 80)];
        postImage.userInteractionEnabled=YES;
        NSString *url22;
        url22=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"postImage"]];
        postImage.imageURL=[NSURL URLWithString:url22];
        postImage.contentMode=UIViewContentModeScaleAspectFill;
        postImage.clipsToBounds = true;
        postImage.tag=indexPath.section;
        [cell addSubview:postImage];
        postImage.userInteractionEnabled=YES;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPost:)];
        gesture.numberOfTapsRequired=1;
        [postImage addGestureRecognizer:gesture];

        
    }
 }
    else
    {
        if([[dic valueForKey:@"notificationtype"]isEqualToString:@"like"])
        {
            AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
            userImage.userInteractionEnabled=YES;
            NSString *url;
            url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"userImage"]];
            userImage.imageURL=[NSURL URLWithString:url];
            userImage.contentMode=UIViewContentModeScaleAspectFill;
            userImage.layer.cornerRadius=40;
            userImage.clipsToBounds = true;
            [cell addSubview:userImage];
            
            UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nameBtn.frame = CGRectMake(90, 20, 200, 30);
            nameBtn.backgroundColor=[UIColor clearColor];
            [nameBtn setTitle:[dic valueForKey:@"userName"] forState:UIControlStateNormal];
            [nameBtn setTintColor:[UIColor blackColor]];
            nameBtn.tag=indexPath.section;
            [nameBtn addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];
            nameBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:13];
            [nameBtn sizeToFit];
            [cell addSubview:nameBtn];
            
            UIButton *likedLbl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            likedLbl.frame = CGRectMake(nameBtn.frame.origin.x+nameBtn.frame.size.width+5, 23, 200, 30);
            likedLbl.backgroundColor=[UIColor clearColor];
            [likedLbl setTitle:@"liked" forState:UIControlStateNormal];
            [likedLbl setTintColor:[UIColor blackColor]];
            likedLbl.tag=indexPath.section;
            likedLbl.userInteractionEnabled=false;
            likedLbl.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
            [likedLbl sizeToFit];
            [cell addSubview:likedLbl];
            
            UIButton *nameotherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nameotherBtn.frame = CGRectMake(likedLbl.frame.origin.x+likedLbl.frame.size.width+5, 20, 200, 30);
            nameotherBtn.backgroundColor=[UIColor clearColor];
            [nameotherBtn setTitle:[dic valueForKey:@"otheruserName"] forState:UIControlStateNormal];
            [nameotherBtn setTintColor:[UIColor blackColor]];
            nameotherBtn.tag=indexPath.section;
            [nameotherBtn addTarget:self action:@selector(profileotherAction:) forControlEvents:UIControlEventTouchUpInside];
            nameotherBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:13];
            [nameotherBtn sizeToFit];
            [cell addSubview:nameotherBtn];
            
            UIButton *likedLbl1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            likedLbl1.frame = CGRectMake(nameotherBtn.frame.origin.x+nameotherBtn.frame.size.width+5, 23, 200, 30);
            likedLbl1.backgroundColor=[UIColor clearColor];
            [likedLbl1 setTitle:@"post." forState:UIControlStateNormal];
            [likedLbl1 setTintColor:[UIColor blackColor]];
            likedLbl1.tag=indexPath.section;
            likedLbl1.userInteractionEnabled=false;
            likedLbl1.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
            [likedLbl1 sizeToFit];
            [cell addSubview:likedLbl1];
            
            AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85, 10, 80, 80)];
            postImage.userInteractionEnabled=YES;
            NSString *url22;
            url22=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"postImage"]];
            postImage.imageURL=[NSURL URLWithString:url22];
            postImage.contentMode=UIViewContentModeScaleAspectFill;
            postImage.clipsToBounds = true;
            postImage.tag=indexPath.section;
            [cell addSubview:postImage];
            postImage.userInteractionEnabled=YES;
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPost:)];
            gesture.numberOfTapsRequired=1;
            [postImage addGestureRecognizer:gesture];
            
        }
        if([[dic valueForKey:@"notificationtype"]isEqualToString:@"comment"])
        {
            AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
            userImage.userInteractionEnabled=YES;
            NSString *url;
            url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"userImage"]];
            userImage.imageURL=[NSURL URLWithString:url];
            userImage.contentMode=UIViewContentModeScaleAspectFill;
            userImage.clipsToBounds = true;
            userImage.layer.cornerRadius=40;
            [cell addSubview:userImage];
            
            UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nameBtn.frame = CGRectMake(90, 20, 200, 30);
            nameBtn.backgroundColor=[UIColor clearColor];
            nameBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:12];
            [nameBtn setTitle:[dic valueForKey:@"userName"] forState:UIControlStateNormal];
            [nameBtn setTintColor:[UIColor blackColor]];
            nameBtn.tag=indexPath.section;
            [nameBtn sizeToFit];
            [nameBtn addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:nameBtn];
            
            UIButton *commentLbl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            commentLbl.frame = CGRectMake(nameBtn.frame.origin.x+nameBtn.frame.size.width+5, 23, 200, 30);
            commentLbl.backgroundColor=[UIColor clearColor];
            commentLbl.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
            [commentLbl setTitle:@"comment on" forState:UIControlStateNormal];
            [commentLbl setTintColor:[UIColor blackColor]];
            commentLbl.tag=indexPath.section;
            [commentLbl sizeToFit];
            commentLbl.userInteractionEnabled=false;
            [cell addSubview:commentLbl];
            
            UIButton *nameotherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nameotherBtn.frame = CGRectMake(90, 50, 200, 30);
            nameotherBtn.backgroundColor=[UIColor clearColor];
            nameotherBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:12];
            [nameotherBtn setTitle:[dic valueForKey:@"otheruserName"] forState:UIControlStateNormal];
            [nameotherBtn setTintColor:[UIColor blackColor]];
            nameotherBtn.tag=indexPath.section;
            [nameotherBtn sizeToFit];
            [nameotherBtn addTarget:self action:@selector(profileotherAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:nameotherBtn];
            
            UIButton *commentLbl1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            commentLbl1.frame = CGRectMake(nameotherBtn.frame.origin.x+nameotherBtn.frame.size.width+5, 51, 200, 30);
            commentLbl1.backgroundColor=[UIColor clearColor];
            commentLbl1.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
            [commentLbl1 setTitle:@"post." forState:UIControlStateNormal];
            [commentLbl1 setTintColor:[UIColor blackColor]];
            commentLbl1.tag=indexPath.section;
            [commentLbl1 sizeToFit];
            commentLbl1.userInteractionEnabled=false;
            [cell addSubview:commentLbl1];
            
            AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85, 10, 80, 80)];
            postImage.userInteractionEnabled=YES;
            NSString *url22;
            url22=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"postImage"]];
            postImage.imageURL=[NSURL URLWithString:url22];
            postImage.contentMode=UIViewContentModeScaleAspectFill;
            postImage.clipsToBounds = true;
            postImage.tag=indexPath.section;
            [cell addSubview:postImage];
            postImage.userInteractionEnabled=YES;
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPost:)];
            gesture.numberOfTapsRequired=1;
            [postImage addGestureRecognizer:gesture];
            
            
        }
        if([[dic valueForKey:@"notificationtype"]isEqualToString:@"following"])
        {
            AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
            userImage.userInteractionEnabled=YES;
            NSString *url;
            url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"userImage"]];
            userImage.imageURL=[NSURL URLWithString:url];
            userImage.contentMode=UIViewContentModeScaleAspectFill;
            userImage.clipsToBounds = true;
            userImage.layer.cornerRadius=40;
            [cell addSubview:userImage];
            
            UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nameBtn.frame = CGRectMake(90, 20, 200, 30);
            nameBtn.backgroundColor=[UIColor clearColor];
            nameBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:12];
            [nameBtn setTitle:[dic valueForKey:@"userName"] forState:UIControlStateNormal];
            [nameBtn setTintColor:[UIColor blackColor]];
            nameBtn.tag=indexPath.section;
            [nameBtn sizeToFit];
            [nameBtn addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:nameBtn];
            
            UIButton *commentLbl = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            commentLbl.frame = CGRectMake(nameBtn.frame.origin.x+nameBtn.frame.size.width+5, 20, 200, 30);
            commentLbl.backgroundColor=[UIColor clearColor];
            commentLbl.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:15];
            [commentLbl setTitle:@"start following" forState:UIControlStateNormal];
            [commentLbl setTintColor:[UIColor blackColor]];
            commentLbl.tag=indexPath.section;
            [commentLbl sizeToFit];
            commentLbl.userInteractionEnabled=false;
            [cell addSubview:commentLbl];
            
            UIButton *nameotherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            nameotherBtn.frame = CGRectMake(90, 50, 200, 30);
            nameotherBtn.backgroundColor=[UIColor clearColor];
            nameotherBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:12];
            [nameotherBtn setTitle:[dic valueForKey:@"otheruserName"] forState:UIControlStateNormal];
            [nameotherBtn setTintColor:[UIColor blackColor]];
            nameotherBtn.tag=indexPath.section;
            [nameotherBtn sizeToFit];
            [nameotherBtn addTarget:self action:@selector(profileotherAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:nameotherBtn];
            
//            UIButton *commentLbl1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            commentLbl1.frame = CGRectMake(nameotherBtn.frame.origin.x+nameotherBtn.frame.size.width+5, 51, 200, 30);
//            commentLbl1.backgroundColor=[UIColor clearColor];
//            commentLbl1.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
//            [commentLbl1 setTitle:@"post." forState:UIControlStateNormal];
//            [commentLbl1 setTintColor:[UIColor blackColor]];
//            commentLbl1.tag=indexPath.section;
//            [commentLbl1 sizeToFit];
//            commentLbl1.userInteractionEnabled=false;
//            [cell addSubview:commentLbl1];
            
            AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85, 10, 80, 80)];
            postImage.userInteractionEnabled=YES;
            NSString *url22;
            url22=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic valueForKey:@"otheruserImage"]];
            postImage.imageURL=[NSURL URLWithString:url22];
            postImage.contentMode=UIViewContentModeScaleAspectFill;
            postImage.clipsToBounds = true;
            postImage.tag=indexPath.section;
            [cell addSubview:postImage];
            postImage.userInteractionEnabled=YES;
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPost:)];
            gesture.numberOfTapsRequired=1;
            [postImage addGestureRecognizer:gesture];
            
            
        }
    }
     if([[dic valueForKey:@"isread"]intValue]==0)
        cell.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:0.3];
    else
        cell.backgroundColor=[UIColor whiteColor];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    mainView.backgroundColor=[UIColor whiteColor];
    
    return mainView;
}
-(void)profileAction:(UIButton*)btn
{
    NSDictionary *dic=[notificationArr objectAtIndex:btn.tag];
    [self markRead:[dic valueForKey:@"notificationid"]];

    if([[dic valueForKey:@"user_id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        self.tabBarController.selectedIndex=4;
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
-(void)profileotherAction:(UIButton*)btn
{
    NSDictionary *dic=[notificationArr objectAtIndex:btn.tag];
    [self markRead:[dic valueForKey:@"notificationid"]];
    
    if([[dic valueForKey:@"otheruserid"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        self.tabBarController.selectedIndex=4;
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[dic valueForKey:@"otheruserid"] forKey:@"otherUserId"];
        [userDefaults synchronize];
        
        otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
    }
}

-(void)openPost:(UITapGestureRecognizer *)gesture
{
    AsyncImageView *postImage=(AsyncImageView *)[gesture view];
    selectedIndex=(int)postImage.tag;
    NSDictionary *dic=[notificationArr objectAtIndex:selectedIndex];

    [self markRead:[dic valueForKey:@"notificationid"]];
    [[NSUserDefaults standardUserDefaults]setValue:[dic objectForKey:@"postid"] forKey:@"postid"];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFromProfile"];
    [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"explore"];
    otherImageView *smvc = [[otherImageView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];

}
-(void)markRead:(NSString*)st
{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"updateNotificationStatus",
                             @"notificationId"       :st,
                             @"notificationStatus":@"1"
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
            [self getNotification];
        }
        else
        {
            
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
}
@end
