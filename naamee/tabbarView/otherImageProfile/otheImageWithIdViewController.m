//
//  otheImageWithIdViewController.m
//  naamee
//
//  Created by mac on 08/03/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "otheImageWithIdViewController.h"
#import "Constants.h"
#import "Helper.h"
#import "AsyncImageView.h"
#import "AFNetworking.h"
#import "otherUserProfileView.h"
#import "commentViewController.h"
#import "hashtagScreenView.h"
#import "smileViewController.h"
#import "GoogleMapViewController.h"

@interface otheImageWithIdViewController ()
{
    NSMutableDictionary *exploreArr;
    UIScrollView *scrv;
    UIImageView *smileyImage ,*smileImageicon;
    UILabel *numberOfLikes;
    UIView *likeBtnView;
}
@end

@implementation otheImageWithIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    exploreArr=[[[NSUserDefaults standardUserDefaults]valueForKey:@"explore"]mutableCopy];
    
//    [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
//    
//    
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *params = @{
//                             @"method"       : @"getUserList",
//                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
//                             @"page"  :@"0"
//                             };
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = nil;
//    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                             options:kNilOptions
//                                                               error:nil];
//        [Helper hideIndicatorFromView:self.view];
//        
//        if ([[json objectForKey:@"success"]integerValue]==1)
//        {
//            self->fList=[[json valueForKey:@"UsersList"]mutableCopy];
//            [self->fTable reloadData];
//            
//        }
//        else
//        {
//            [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
//        }
//        
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [Helper hideIndicatorFromView:self.view];
//        
//    }];
    
}
-(void)updateViewWithData
{
    
 
    
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.navigationController.navigationBarHidden=true;
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 20, 200, 44);
    nameBtn.backgroundColor=[UIColor clearColor];
    [nameBtn setTitle:@"POSTS" forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:nameBtn];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    
    scrv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    scrv.backgroundColor=[UIColor whiteColor];
    
    
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 69.5)];
    mainView.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.7];
    
    AsyncImageView *userCover=[[AsyncImageView alloc]initWithFrame:mainView.bounds];
    NSString *coverURL;
    if ([[exploreArr objectForKey:@"coverPic"] isKindOfClass:[NSNull class]] || [[exploreArr objectForKey:@"coverPic"] isEqualToString:@"<null>"])
    {
        
    }
    else
    {
        coverURL=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [exploreArr objectForKey:@"coverPic"]];
    }
    
    if (coverURL)
    {
        userCover.imageURL=[NSURL URLWithString:coverURL];
        
    }
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha=0.50;
    
    //userCover.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"coverPic"]]];
    
    
    AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, 10, 40, 40)];
    NSString *imageURL;
    if ([[exploreArr objectForKey:@"userImage"] isKindOfClass:[NSNull class]] || [[exploreArr objectForKey:@"userImage"] isEqualToString:@"<null>"])
    {
        
    }
    else
    {
        imageURL=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [exploreArr objectForKey:@"userImage"]];
    }
    
    if (imageURL)
    {
        userImage.imageURL=[NSURL URLWithString:imageURL];
        
    }
    
    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(56, 8, self.view.frame.size.width, 20)];
    username.text=[exploreArr objectForKey:@"userName"];
    username.textColor=[Helper colorFromHexString:@"1b73b1"];
    username.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:15];
    [username sizeToFit];
    
    
    
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(75, 28, self.view.frame.size.width-120, 40)];
    address.text=[exploreArr objectForKey:@"address"];
    address.numberOfLines=2;
    address.textAlignment=NSTextAlignmentCenter;
    address.textColor=[Helper colorFromHexString:@"d0d0d0"];
    address.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
    address.lineBreakMode = NSLineBreakByWordWrapping;
    //address.backgroundColor = [UIColor whiteColor];
    [address sizeToFit];
    
    UIView *addressView;
    if (![[exploreArr objectForKey:@"address"] isKindOfClass:[NSNull class]] && [[exploreArr objectForKey:@"address"] length]>0)
    {
        addressView = [[UIView alloc]initWithFrame:CGRectMake(56, 28, 15+4+address.frame.size.width+2, 40)];
        //addressView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *addressIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
        addressIcon.image=[UIImage imageNamed:@"marker.png"];
        
        address.frame=CGRectMake(19, 0, address.frame.size.width, 20);
        
        [addressView addSubview:addressIcon];
        [addressView addSubview:address];
    }
    addressView.tag=0;
    addressView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gestureloc=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressLocation:)];
    [addressView addGestureRecognizer:gestureloc];
    //    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 20)];
    //    time.text=[NSDate mysqlDatetimeFormattedAsTimeAgo:[exploreArr objectForKey:@"created"]];
    //    time.textColor=[Helper colorFromHexString:@"8c95a1"];
    //    time.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    //    //time.backgroundColor = [UIColor whiteColor];
    //    [time sizeToFit];
    //
    //    UIView *timeView;
    //
    //    timeView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, userImage.frame.origin.y+1, 15+5+time.frame.size.width+2, 20)];
    //    //timeView.backgroundColor = [UIColor whiteColor];
    //
    //    UIImageView *timeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2.5, 15, 15)];
    //    timeIcon.image=[UIImage imageNamed:@"time"];
    //
    //    time.frame=CGRectMake(20, 0, time.frame.size.width, 20);
    //
    //    [timeView addSubview:timeIcon];
    //    [timeView addSubview:time];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 69.5, self.view.frame.size.width, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    lineView.alpha=0.5;
    
    [mainView addSubview:userCover];
    [mainView addSubview:blackView];
    [mainView addSubview:userImage];
    [mainView addSubview:username];
    //[mainView addSubview:addressIcon];
    //[mainView addSubview:address];
    [mainView addSubview:addressView];
    //[mainView addSubview:timeView];
    //[mainView addSubview:time];
    [mainView addSubview:lineView];
    
    mainView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gesture  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewProfile:)];
    [mainView addGestureRecognizer:gesture];
    [scrv addSubview:mainView];
    
    
    NSDictionary *dic =[exploreArr mutableCopy];
    
    
//    AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width)];
    AsyncImageView *postImage;
    if([[dic valueForKey:@"postImage_width"]intValue]<self.view.frame.size.width)
    {
        postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y,self.view.frame.size.width, [[dic valueForKey:@"postImage_height"]intValue])];
        postImage.contentMode=UIViewContentModeScaleAspectFill;
        
    }
    else
    {
        postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, mainView.frame.size.height+mainView.frame.origin.y,[[dic valueForKey:@"postImage_width"]intValue], [[dic valueForKey:@"postImage_height"]intValue])];
        postImage.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    
    postImage.clipsToBounds=YES;
    postImage.userInteractionEnabled=YES;
     postImage.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *gesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like:)];
    gesture1.numberOfTapsRequired=2;
    [postImage addGestureRecognizer:gesture1];
    
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 2.0;
    // [postImage addGestureRecognizer:longPress];
    
    
    NSString *url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"postImage"]];
    postImage.imageURL=[NSURL URLWithString:url];
    //postImage.contentMode=UIViewContentModeScaleAspectFit;
    
    
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
    NSString *likeStr=@"smile";
    if ([[dic objectForKey:@"totalLikes"] intValue]>1)
    {
        likeStr=@"smiles";
    }
    numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"totalLikes"], likeStr];
    numberOfLikes.textColor=[Helper colorFromHexString:@"8c95a1"];
    numberOfLikes.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
    numberOfLikes.userInteractionEnabled=true;
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
        
        [scrv addSubview:moodimage];
        [scrv addSubview:moodhashtag];
        
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
        
        [scrv addSubview:wearingimage];
        [scrv addSubview:wearinghashtag];
        
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
        
        [scrv addSubview:listeningimage];
        [scrv addSubview:listenhashtag];
        
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
        
        [scrv addSubview:watchimage];
        [scrv addSubview:watchhashtag];
        
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
        
        [scrv addSubview:locationimage];
        [scrv addSubview:locationhashtag];
        
        yCoordinate=yCoordinate+20;
    }
    
    UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160/2-10, yCoordinate+10, 170, 40)];
    buttonView.backgroundColor=[UIColor whiteColor];
    
    likeBtnView = [[UIView alloc]initWithFrame:CGRectMake(32.5, 7.5, 25, 25)];
    
    smileImageicon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImageicon.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([[dic objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImageicon setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImageicon setTintColor:[UIColor whiteColor]];
    }
    
    smileImageicon.contentMode=UIViewContentModeScaleAspectFill;
    smileImageicon.clipsToBounds=YES;
    [likeBtnView addSubview:smileImageicon];
    
    UIButton *likeBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
    [likeBtn setBackgroundColor:[UIColor clearColor]];
    [likeBtn addTarget:self action:@selector(likePost:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *commentBtn =[[UIButton alloc]initWithFrame:CGRectMake(70, 0, 40, buttonView.frame.size.height)];
    [commentBtn setImage:[UIImage imageNamed:@"comment_btn.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentPost:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *repeatBtn=[[UIButton alloc]initWithFrame:CGRectMake(120, 0, 40, buttonView.frame.size.height)];
    [repeatBtn setImage:[UIImage imageNamed:@"repeat_btn.png"] forState:UIControlStateNormal];
    [repeatBtn addTarget:self action:@selector(repeatPost:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    [scrv addSubview:postImage];
    [scrv addSubview:numberOfRepeats];
    [scrv addSubview:repeaticon];
    [scrv addSubview:numberOfLikes];
    [scrv addSubview:hearticon];
    [scrv addSubview:caption];
    [scrv addSubview:buttonView];
    
    smileyImage = [[UIImageView alloc]initWithFrame:CGRectMake(postImage.frame.size.width/2-40, postImage.frame.size.height/2-40, 80, 80)];
    [smileyImage setImage:[UIImage imageNamed:@"smiley.png"]];
    [scrv addSubview:smileyImage];
    smileyImage.hidden=true;
    
    NSLog(@"%f",buttonView.frame.size.height+buttonView.frame.origin.y);
    scrv.contentSize=CGSizeMake(0,buttonView.frame.size.height+buttonView.frame.origin.y+64);
    //        selectedIndex=-1;
    //        smileyImage.hidden=NO;
    //        smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    //        [UIView animateWithDuration:1.0
    //                         animations:^{
    //                             smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    //                         } completion:^(BOOL finished) {
    //                             smileyImage.hidden=YES;
    //                         }];
    
    
    
    [self.view addSubview:scrv];
    
}
#pragma mark -- Action Button

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewProfile:(UITapGestureRecognizer *)gesture
{
    if([[exploreArr valueForKey:@"user_id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        self.tabBarController.selectedIndex=4;
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[exploreArr valueForKey:@"user_id"] forKey:@"otherUserId"];
        [userDefaults synchronize];
        
        otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
    }
}
-(void)repeatPost:(UIButton *)sender
{
    [Helper showIndicatorWithText:@"updating Posts..." inView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"sharePost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"       : [exploreArr valueForKey:@"postid"]
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

-(void)likePost:(UIButton *)sender
{
    @try {
        if ([Helper isInternetConnected]==YES)
        {
            [self likeAPost:exploreArr];
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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:exploreArr forKey:@"postDetails"];
        [userDefaults synchronize];
        
        
        
        commentViewController *smvc = [[commentViewController alloc]init];
        smvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:smvc animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}
-(void)likeAPost:(NSDictionary *)dict
{
    
    
    if ([[dict objectForKey:@"islike"] integerValue]==0)
    {
        smileyImage.hidden=NO;
        smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        [UIView animateWithDuration:1.0
                         animations:^{
                             self->smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         } completion:^(BOOL finished) {
                             self->smileyImage.hidden=YES;
                         }];
        //like
        long totalLikes=[[dict objectForKey:@"totalLikes"] integerValue];
        totalLikes=totalLikes+1;
        NSMutableDictionary *details=[dict mutableCopy];
        [details setObject:@"1" forKey:@"islike"];
        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
        exploreArr=[details mutableCopy];
        
        NSString *likeStr=@"smile";
        
        if ([[exploreArr objectForKey:@"totalLikes"] intValue]>1)
        {
            likeStr=@"smiles";
        }
        numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [exploreArr objectForKey:@"totalLikes"], likeStr];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"likePost",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"         :[dict objectForKey:@"postid"]
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
        long totalLikes=[[dict objectForKey:@"totalLikes"] integerValue];
        totalLikes=totalLikes-1;
        NSMutableDictionary *details=[dict mutableCopy];
        [details setObject:@"0" forKey:@"islike"];
        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
        exploreArr=[details mutableCopy];
        
        NSString *likeStr=@"smile";
        
        if ([[exploreArr objectForKey:@"totalLikes"] intValue]>1)
        {
            likeStr=@"smiles";
        }
        numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [exploreArr objectForKey:@"totalLikes"], likeStr];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"unLikePost",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"         :[dict objectForKey:@"postid"]
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
    
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImageicon.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if ([[dict objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImageicon setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImageicon setTintColor:[UIColor whiteColor]];
    }
    
}
-(void)like:(UITapGestureRecognizer *)gesture
{
    smileyImage.hidden=NO;
    smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:1.0
                     animations:^{
                         self->smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         self->smileyImage.hidden=YES;
                     }];
    
    
    
    // Build the two index paths
    
    NSDictionary *dic=[exploreArr mutableCopy];
    
    
    if ([[dic objectForKey:@"islike"] integerValue]==0)
    {
        //like
        long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
        totalLikes=totalLikes+1;
        NSMutableDictionary *details=[dic mutableCopy];
        [details setObject:@"1" forKey:@"islike"];
        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
        exploreArr=[details mutableCopy];
        
        NSString *likeStr=@"smile";
        
        if ([[exploreArr objectForKey:@"totalLikes"] intValue]>1)
        {
            likeStr=@"smiles";
        }
        numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [exploreArr objectForKey:@"totalLikes"], likeStr];
        
        
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
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImageicon.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if ([[dic objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImageicon setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImageicon setTintColor:[UIColor whiteColor]];
    }
    //    else
    //    {
    //        long totalLikes=[[dic objectForKey:@"totalLikes"] integerValue];
    //        totalLikes=totalLikes-1;
    //        NSMutableDictionary *details=[dic mutableCopy];
    //        [details setObject:@"0" forKey:@"islike"];
    //        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
    //        exploreArr=[details mutableCopy];
    //
    //        NSString *likeStr=@"smile";
    //
    //        if ([[exploreArr objectForKey:@"totalLikes"] intValue]>1)
    //        {
    //            likeStr=@"smiles";
    //        }
    //        numberOfLikes.text=[NSString stringWithFormat:@"%@ %@", [exploreArr objectForKey:@"totalLikes"], likeStr];
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
    
    
}
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
    
    
    
}
-(void)totalSmilesView:(UITapGestureRecognizer*)gesture
{
    
    //    NSDictionary *dic=[postList objectAtIndex:gesture.view.tag];
    //    NSLog(@"%@",dic);
    NSString *st2;
    if([[exploreArr objectForKey:@"sharePostid"]isEqualToString:@""])
    {
        st2=[exploreArr objectForKey:@"postid"];
    }
    else
    {
        st2=[exploreArr objectForKey:@"sharePostid"];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:st2 forKey:@"likedpostid"];
    [userDefaults synchronize];
    smileViewController *smvc = [[smileViewController alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)addressLocation:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic=[exploreArr mutableCopy];
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
