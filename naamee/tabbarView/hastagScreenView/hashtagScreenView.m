//
//  hashtagScreenView.m
//  naamee
//
//  Created by MAC on 11/01/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "hashtagScreenView.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "NSDate+NVTimeAgo.h"
#import "AsyncImageView.h"
#import "commentViewController.h"
#import "imageViewController.h"
#import "otherUserProfileView.h"
#import "smileViewController.h"
#import "GoogleMapViewController.h"

@interface hashtagScreenView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *postList, *postHeightList;
    UIImageView *NoPostimg;
    UILabel *NoPostText;
    int scrollOrNot;
}
@property (strong, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation hashtagScreenView

- (void)viewDidLoad {
    [super viewDidLoad];

    selectedIndex=-1;
    self.navigationController.navigationBarHidden=true;
    //self.tabBarController.selectedIndex=4;
    postList=[[NSMutableArray alloc]init];
    postHeightList=[[NSMutableArray alloc]init];
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 20, 200, 44);
    nameBtn.backgroundColor=[UIColor clearColor];
    [nameBtn setTitle:[NSString stringWithFormat:@"#%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"hashtag"]] forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    //[nameBtn.titleLabel setFont:[UIFont fontWithName:@"Chalkduster" size:15.0f]];
    [navigationView addSubview:nameBtn];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tag=110;
    
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV.backgroundColor = [UIColor clearColor];
    _tableV.bounces=false;
    [self.view addSubview:_tableV];
    
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
 
    
    NSString *str = [[[NSUserDefaults standardUserDefaults]valueForKey:@"hashtag"] stringByReplacingOccurrencesOfString:@"#" withString:@""];

    
    [self.tabBarController.tabBar setHidden:false];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"hasTagPost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"page"         :@"1",
                             @"hastag"       :str,
                             @"device"       :[NSString stringWithFormat:@"%0.0f", self.view.frame.size.width]
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
            if([[json objectForKey:@"message"]isEqualToString:@"No Data found"])
            {
                
                
                self->NoPostimg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height-150, 20, 40)];
                self->NoPostimg.image=[UIImage imageNamed:@"dowArr"];
                [self.view addSubview:self->NoPostimg];
                
                self->NoPostText = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100,self.view.frame.size.height-180,200, 20)];
                self->NoPostText.text = @"No Post yet, Be First To Post Here";
                self->NoPostText.font=[UIFont fontWithName:@"Arial-BoldMT" size:12.0f];
                self->NoPostText.backgroundColor = [UIColor clearColor];
                self->NoPostText.textColor = [UIColor blackColor];
                self->NoPostText.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:self->NoPostText];
                
            }
            else
            {
                [self->NoPostimg removeFromSuperview];
                [self->NoPostText removeFromSuperview];
                self->postList=[[json objectForKey:@"post"]mutableCopy];
                [self->_tableV reloadData];
            }
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
    
    
//    AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
    AsyncImageView *postImage;
    if([[dic valueForKey:@"postImage_width"]intValue]<self.view.frame.size.width)
    {
        postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, [[dic valueForKey:@"postImage_height"]intValue])];
        postImage.contentMode=UIViewContentModeScaleAspectFill;
        
    }
    else
    {
        postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,[[dic valueForKey:@"postImage_width"]intValue], [[dic valueForKey:@"postImage_height"]intValue])];
        postImage.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    
    
    postImage.tag=indexPath.section;
    postImage.clipsToBounds=YES;
    postImage.userInteractionEnabled=YES;
     postImage.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like:)];
    gesture.numberOfTapsRequired=2;
    [postImage addGestureRecognizer:gesture];
    
    //    UITapGestureRecognizer *gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDetailView:)];
    //    gesture.numberOfTapsRequired=1;
    //    [postImage addGestureRecognizer:gesture1];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2.0;
    [postImage addGestureRecognizer:longPress];
    
    
    NSString *url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"postImage"]];
    postImage.imageURL=[NSURL URLWithString:url];
   // postImage.contentMode=UIViewContentModeScaleAspectFit;
    
    
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
    
    UILabel *numberOfLikes=[[UILabel alloc]initWithFrame:CGRectMake(repeaticon.frame.origin.x-70, numberOfRepeats.frame.origin.y, 60, numberOfRepeats.frame.size.height)];
    NSString *likeStr=@"smile";
    if ([[dic objectForKey:@"totalLikes"] intValue]>1)
    {
        likeStr=@"smiles";
    }
    numberOfLikes.userInteractionEnabled=true;
    numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"totalLikes"], likeStr];
    numberOfLikes.textColor=[Helper colorFromHexString:@"8c95a1"];
    numberOfLikes.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    UITapGestureRecognizer *gesturee=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(totalSmilesView:)];
    gesturee.numberOfTapsRequired=1;
    [numberOfLikes addGestureRecognizer:gesturee];
    
    
    
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
        NSArray *components1=[[NSString stringWithFormat:@"%@",[dic valueForKey:@"location"]] componentsSeparatedByString:@" "];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[dic valueForKey:@"location"]];
        for(int i=0;i<components1.count;i++)
        {
            if([components1[i] length]>1)
            {
                if([[components1[i] substringToIndex:1] isEqualToString:@"#"])
                {
                    NSString *sttt=[dic valueForKey:@"location"];
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
    
    if ([[dic objectForKey:@"sharePost"] integerValue]==0)
    {
        [buttonView addSubview:repeatBtn];
    }
    
    
    [cell.contentView addSubview:postImage];
    [cell.contentView addSubview:numberOfRepeats];
    [cell.contentView addSubview:repeaticon];
    [cell.contentView addSubview:numberOfLikes];
    [cell.contentView addSubview:hearticon];
    [cell.contentView addSubview:caption];
    [cell.contentView addSubview:buttonView];
    
    if ([[dic objectForKey:@"islike"] integerValue]==1)
    {
        UIImageView *smileyImage = [[UIImageView alloc]initWithFrame:CGRectMake(postImage.frame.size.width/2-40, postImage.frame.size.height/2-40, 80, 80)];
        [smileyImage setImage:[UIImage imageNamed:@"smiley.png"]];
        [cell.contentView addSubview:smileyImage];
        if (selectedIndex==indexPath.section)
        {
            selectedIndex=-1;
            smileyImage.hidden=NO;
            smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            [UIView animateWithDuration:1.0
                             animations:^{
                                 smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                             } completion:^(BOOL finished) {
                                 smileyImage.hidden=YES;
                             }];
        }
        else
        {
            smileyImage.hidden=YES;
        }
    }
    
    
    
    
    
    
    
    
    
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
    
    //    CGRect screen = [[UIScreen mainScreen] bounds];
    //    CGFloat screenHeight = CGRectGetHeight(screen);
    //    CGFloat screenWidth = CGRectGetWidth(screen);
    //
    //    CGFloat newWidth = MIN(screenWidth, width);
    //    //CGFloat newHeight = MIN(screenHeight, height);
    //
    //    CGFloat total = (screenHeight*newWidth)/screenWidth;
    
    //return height + 70;
    
    
    return yCoordinate+70;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section==postList.count-1)
    //    {
    //        if (isMorePosts==YES)
    //        {
    //            [self getOlderPosts];
    //        }
    //    }
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
        userCover.imageURL=[NSURL URLWithString:coverURL];
        
    }
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
    blackView.backgroundColor = [UIColor whiteColor];
    blackView.alpha=0.50;
    
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
        userImage.imageURL=[NSURL URLWithString:imageURL];
        
    }
    //  userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"profilePic"]]];
    
    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(56, 4, self.view.frame.size.width, 20)];
    username.text=[dic objectForKey:@"userName"];
    username.textColor=[Helper colorFromHexString:@"1b73b1"];
    username.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:15];
    //username.backgroundColor = [UIColor whiteColor];
    [username sizeToFit];
    
    
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(75, 28, self.view.frame.size.width-90, 40)];
    address.text=[dic objectForKey:@"address"];
    address.numberOfLines=2;
    address.textAlignment=NSTextAlignmentCenter;
    address.textColor=[Helper colorFromHexString:@"8c95a1"];
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
    [mainView addSubview:addressView];
    [mainView addSubview:timeView];
    //[mainView addSubview:time];
    [mainView addSubview:lineView];
    
    mainView.userInteractionEnabled=YES;
    mainView.tag=section;
    UITapGestureRecognizer *gesture  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewProfile:)];
    [mainView addGestureRecognizer:gesture];
    
    return mainView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(void)like:(UITapGestureRecognizer *)gesture
{
    UIImageView *postImage=(UIImageView *)[gesture view];
    // Build the two index paths
    selectedIndex=postImage.tag;
    
    NSDictionary *dic=[postList objectAtIndex:postImage.tag];
    
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
//    else
//    {
//        long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
//        totalLikes=totalLikes-1;
//        NSMutableDictionary *details=[dic mutableCopy];
//        [details setObject:@"0" forKey:@"islike"];
//        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
//        [postList insertObject:details atIndex:postImage.tag];
//        [postList removeObjectAtIndex:postImage.tag+1];
//        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        NSDictionary *params = @{
//                                 @"method"       : @"unLikePost",
//                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
//                                 @"postid"         :[dic objectForKey:@"postid"]
//                                 };
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = nil;
//        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                                 options:kNilOptions
//                                                                   error:nil];
//            NSLog(@"JSON: %@", json);
//            [Helper hideIndicatorFromView:self.view];
//            
//            if ([[json objectForKey:@"success"]integerValue]==1)
//            {
//                
//            }
//            else
//            {
//                [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
//            }
//            
//            
//        } failure:^(NSURLSessionTask *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//            [Helper hideIndicatorFromView:self.view];
//            
//        }];
//        
//    }
    
    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:postImage.tag];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
    // Launch reload for the two index path
    [_tableV reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
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
            else
            {
                long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
                totalLikes=totalLikes-1;
                NSMutableDictionary *details=[dic mutableCopy];
                [details setObject:@"0" forKey:@"islike"];
                [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
                [postList insertObject:details atIndex:sender.tag];
                [postList removeObjectAtIndex:sender.tag+1];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *params = @{
                                         @"method"       : @"unLikePost",
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
            
            NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
            NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
            // Launch reload for the two index path
            [_tableV reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
           
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
    [Helper showIndicatorWithText:@"updating Posts..." inView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"sharePost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"       : [[postList objectAtIndex:sender.tag]valueForKey:@"postid"]
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

-(void)viewProfile:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag==110)
    {
        NSArray *visible       = [self.tableV indexPathsForVisibleRows];
        NSIndexPath *indexpath = (NSIndexPath*)[visible lastObject];
        if(indexpath.section == postList.count-2)
        {
            if(scrollOrNot==0)
            {
                scrollOrNot=1;
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *params = @{
                                         @"method"       : @"hasTagPost",
                                         @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                         @"page"         :[NSString stringWithFormat:@"%lu", ((unsigned long)self->postList.count/10)+1],
                                         @"hastag"       :[[NSUserDefaults standardUserDefaults]valueForKey:@"hashtag"]
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
                        if([[json objectForKey:@"message"]isEqualToString:@"Has tag post Details"])
                        {
                            
                        }
                        else
                        {
                            for(int i=0;i<[[json objectForKey:@"post"] count];i++)
                            {
                                [self->postList addObject:[[json objectForKey:@"post"]objectAtIndex:i]];
                                
                            }
                            [self.tableV reloadData];
                            //                [self.tableV beginUpdates];
                            //                self.tableV inser
                            ////                [self.tableV insertSections:[NSIndexSet indexSetWithIndex:self->postList.count-10]
                            ////                              withRowAnimation:UITableViewRowAnimationFade];
                            //                [self.tableV endUpdates];
                            
                            
                            //                NSUInteger sectionCount = self->postList.count;
                            //                NSIndexSet *indices = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)];
                            //                [self->_tableV insertSections:indices withRowAnimation:UITableViewRowAnimationFade];
                            //                [self->_tableV insertSections:self->postList.count withRowAnimation:UITableViewRowAnimationLeft];
                            //                [_tableV insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self->postList.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
                            
                            self->scrollOrNot=0;
                        }
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
    }
}
-(void)scrollToTop
{
    NSIndexPath* ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableV scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    
    NSLog(@"%@",[textView.text substringWithRange: characterRange]);
    
    NSString *testString = textView.text;
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detect matchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
    if (matches.count == 0){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[textView.text substringWithRange: characterRange] forKey:@"hashtag"];
        [userDefaults synchronize];
        hashtagScreenView *smvc = [[hashtagScreenView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
        return NO;
    }else{
        return true;
    }
    
    
}
-(void)totalSmilesView:(UITapGestureRecognizer*)gesture
{
        NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
        NSLog(@"%@",dic);
    
    NSString *st2;
    if([[dic objectForKey:@"sharePostid"]isEqualToString:@""])
    {
        st2=[dic objectForKey:@"postid"];
    }
    else
    {
        st2=[dic objectForKey:@"sharePostid"];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:st2 forKey:@"likedpostid"];
    [userDefaults synchronize];
    smileViewController *smvc = [[smileViewController alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
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
@end
