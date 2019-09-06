//
//  commentViewController.m
//  naamee
//
//  Created by mac on 13/12/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "commentViewController.h"
#import "AsyncImageView.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "Helper.h"
#import "editPostFilterView.h"
#import "otherUserProfileView.h"
#import "NSDate+NVTimeAgo.h"
#import "hashtagScreenView.h"

@interface commentViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *commentList;
    UILabel *postReaction;
    UIImageView *smileImage;
    UIView *likeBtnView;
    UIImage *postImage;
    UIButton *menuBtn;
    AsyncImageView *userImage;
    AsyncImageView *mainimageView;
    UIImageView *smileyImage;
    NSMutableArray *mentionusersList,*allUserList1,*allUserList,*searchlist,*rangeArr;
    int selectedRow;
}
@property (strong, nonatomic)  UITableView *table,*mentionTable;
@property (strong, nonatomic) NSMutableDictionary *postDetails;
@property (strong, nonatomic)  UITextField *commentField;
@property (strong, nonatomic)  UIButton *sendBtn;
@property (strong, nonatomic)  UIView *bottomView;
@property (strong, nonatomic) NSString *titleText;
- (IBAction)postComment:(id)sender;
@end

@implementation commentViewController
@synthesize table, postDetails, bottomView, commentField, sendBtn, titleText;
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"home"];
    postDetails = [[[NSUserDefaults standardUserDefaults]valueForKey:@"postDetails"]mutableCopy];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.navigationController.navigationBarHidden=true;
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    mentionusersList=[NSMutableArray new];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tag=0;
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    table.tableHeaderView=[self tableHeaderView];
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [table addGestureRecognizer:lpgr];
    
    
    
   
    
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    _mentionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, bottomView.frame.origin.y-200, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    _mentionTable.delegate = self;
    _mentionTable.dataSource = self;
    _mentionTable.tag=1;
    _mentionTable.backgroundColor = [UIColor whiteColor];
    _mentionTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_mentionTable];
    _mentionTable.hidden=true;
    
    
    
    
    commentField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width-90, 34)];
    commentField.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    [bottomView addSubview:commentField];
    
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton addTarget:self action:@selector(postComment:) forControlEvents:UIControlEventTouchUpInside];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentButton setBackgroundColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0]];
    commentButton.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
    [commentButton setTitle:@"SEND" forState:UIControlStateNormal];
    commentButton.frame = CGRectMake(self.view.frame.size.width-80,5 , 70, 40);
    [bottomView addSubview:commentButton];
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 20, 200, 44);
    nameBtn.backgroundColor=[UIColor clearColor];
    [nameBtn setTitle:[postDetails objectForKey:@"username"] forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:nameBtn];
    
    NSString *useriddd=[postDetails valueForKey:@"user_id"];
    if(![[postDetails valueForKey:@"shareduserfullname"]isEqualToString:@""])
    {
        useriddd=[postDetails valueForKey:@"ownerid"];
    }
    
    if ([useriddd integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] integerValue])
    {
    menuBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    menuBtn.frame = CGRectMake(self.view.frame.size.width-60, 20, 40, 44);
    menuBtn.backgroundColor=[UIColor clearColor];
    [menuBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setImage:[UIImage imageNamed:@"more_menu"] forState:UIControlStateNormal];
    [menuBtn setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:menuBtn];
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(20, 24, 30, 30);
    backButton.backgroundColor=[UIColor clearColor];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:backButton];
    
    
    
    
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, commentField.frame.size.height)];
    commentField.leftView=leftView;
    commentField.leftViewMode=UITextFieldViewModeAlways;
    commentField.layer.cornerRadius=5;
    commentField.delegate=self;
    commentField.placeholder=@"Add a comment";
    commentList=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePost:) name:@"DeletePost" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; //
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"likePostSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likePostSuccess:) name:@"likePostSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlikePostSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlikePostSuccess:) name:@"unlikePostSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addCommentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCommentSuccess:) name:@"addCommentSuccess" object:nil];
}
-(void)back
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:postDetails forKey:@"postDetailschnage"];    
    [userDefaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([Helper isInternetConnected]==YES)
    {
        
        
        NSString *st;
        if ([postDetails objectForKey:@"sharePostid"])
        {
           if( [[postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
            st=[postDetails objectForKey:@"postid"];
            else
                st=[postDetails objectForKey:@"sharePostid"];
        }
        else
        {
            st=[postDetails objectForKey:@"postid"];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"getComments",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"postid"       :st,
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
                self->commentList=[[json valueForKey:@"comments"] mutableCopy];
                [self->table reloadData];
                if(self->commentList.count>1)
                {
                    int lastRowNumber = [self->table numberOfRowsInSection:0] - 1;
                NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
                    [self->table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            }
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *params = @{
                                     @"method"       : @"mentionUser",
                                     @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                     };
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = nil;
            [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                NSLog(@"JSON: %@", json);
                if ([[json objectForKey:@"success"]integerValue]==1)
                {
                    self->allUserList=[[json objectForKey:@"userDetail"]mutableCopy];
                    self->allUserList1 =[[json objectForKey:@"userDetail"]mutableCopy];
                }
                else
                {
                }
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [Helper hideIndicatorFromView:self.view];
            }];
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
        
       // [WebAPI getCommentsListForPost:[postDetails objectForKey:@"postid"]];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}



#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    if(tableView.tag==1)
    {
        NSArray *components=[[NSString stringWithFormat:@"%@",[commentField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]] componentsSeparatedByString:@" "];
        NSMutableArray *componets1=[NSMutableArray arrayWithArray:components];
        if(components.count>0)
        {
            //NSString *stt=[NSString stringWithFormat:@"%@",[components lastObject]];

            

            [componets1 replaceObjectAtIndex:[componets1 indexOfObject:[componets1 lastObject]] withObject:[NSString stringWithFormat:@"@%@ ",[searchlist[indexPath.row]valueForKey:@"username"]]];
            NSString *finalS=@"";
            for(int i=0;i<componets1.count;i++)
            {
                if([finalS isEqualToString:@""])
                    finalS=[NSString stringWithFormat:@"%@",componets1[i]];
                else
                finalS=[NSString stringWithFormat:@"%@ %@",finalS,componets1[i]];
            }
//               NSString *str = [commentField.text stringByReplacingOccurrencesOfString:stt
//                                                                            withString:[NSString stringWithFormat:@"@%@ ",[searchlist[indexPath.row]valueForKey:@"username"]]];
            [mentionusersList addObject:[searchlist[indexPath.row]valueForKey:@"id"]];
            
            
            if(allUserList1.count>1)
            [allUserList1 removeObject:searchlist[indexPath.row]];
            else
                [allUserList1 removeAllObjects];
                commentField.text=[NSString stringWithFormat:@"%@", finalS];;
                _mentionTable.hidden = true;
    }
}
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1)
        return searchlist.count;
    else
    return commentList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1)
    {
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        for (UIView *v in cell.contentView.subviews)
        {
            [v removeFromSuperview];
        }
        UILabel *comment=[[UILabel alloc]initWithFrame:CGRectMake(10, 5,300, 20)];
        comment.textColor=[UIColor blackColor];
        comment.font=[UIFont fontWithName:Helvetica_REGULAR size:13];
        comment.text=[[searchlist objectAtIndex:indexPath.row]valueForKey:@"username"];
        [cell addSubview:comment];
        
        return cell;
    }
    else
    {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    NSDictionary *dic=[commentList objectAtIndex:indexPath.row];
    
    AsyncImageView *userImagee=[[AsyncImageView alloc]initWithFrame:CGRectMake(8, 8, 45, 45)];
    NSString *imageURL;
    
    imageURL=  [NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [dic objectForKey:@"pic"]];
    userImagee.imageURL=[NSURL URLWithString:imageURL];

    UILabel *username=[[UILabel alloc]initWithFrame:CGRectMake(userImagee.frame.origin.x+userImagee.frame.size.width+10, 8, self.view.frame.size.width-(userImagee.frame.origin.x+userImagee.frame.size.width+10+8), 20)];
        
    username.text=[dic objectForKey:@"userName"];
        username.tag=indexPath.row;
        username.userInteractionEnabled=YES;
        UITapGestureRecognizer *gesturee=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userNameView:)];
        gesturee.numberOfTapsRequired=1;
        [username addGestureRecognizer:gesturee];
        
    username.textColor=[Helper colorFromHexString:@"1b73b1"];
    username.font=[UIFont fontWithName:@"Helvetica Neue Medium" size:15];
    
    UITextView *comment=[[UITextView alloc]initWithFrame:CGRectMake(username.frame.origin.x, username.frame.origin.y+username.frame.size.height, username.frame.size.width, 20)];
    comment.textColor=[UIColor darkGrayColor];
    comment.font=[UIFont fontWithName:Helvetica_REGULAR size:13];
        comment.delegate=self;
        comment.editable=false;
        comment.scrollEnabled=false;
        comment.userInteractionEnabled=false;
        
        NSData *data = [NSData dataWithBytes: [[dic objectForKey:@"comment"] UTF8String] length:strlen([[dic objectForKey:@"comment"] UTF8String])];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        NSArray *components=[[NSString stringWithFormat:@"%@",msg] componentsSeparatedByString:@" "];
        rangeArr=[NSMutableArray new];
        for(int i=0;i<components.count;i++)
        {
            if([components[i] length]>1)
            {
            if([[components[i] substringToIndex:1] isEqualToString:@"@"])
            {
                NSString *sttt=msg;
                NSRange rangee= [sttt rangeOfString: components[i]];
                [rangeArr addObject:[NSValue valueWithRange:rangee]];
            }
            }

        }
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:msg];

        for(int i=0;i<rangeArr.count;i++)
        {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[rangeArr[i] rangeValue]];
            [string addAttribute:NSLinkAttributeName value:@"click" range:[rangeArr[i] rangeValue]];
        }


//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,5)];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5,6)];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11,5)];
//
        NSString *text=msg;
    
    comment.attributedText=string;
    [comment sizeToFit];
    
    CGRect rect=[Helper calculateHeightForText:text fontName:Helvetica_REGULAR fontSize:13 maximumWidth:username.frame.size.width];
    
    CGRect frame=comment.frame;
    frame.origin.x=username.frame.origin.x;
    frame.origin.y=comment.frame.origin.y;
    frame.size.width=username.frame.size.width;
    frame.size.height=rect.size.height+8;
    comment.frame=frame;
    
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(username.frame.origin.x, comment.frame.origin.y+comment.frame.size.height, username.frame.size.width, 20)];
    time.textColor=[UIColor lightGrayColor];
        time.text=[NSDate mysqlDatetimeFormattedAsTimeAgo:[dic objectForKey:@"createdon"]];
    time.font=[UIFont fontWithName:Helvetica_REGULAR size:13];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, time.frame.origin.y+time.frame.size.height, self.view.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    
    [cell.contentView addSubview:userImagee];
    [cell.contentView addSubview:username];
    [cell.contentView addSubview:comment];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:lineView];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    userImagee.frame=CGRectMake(userImagee.frame.origin.x, (lineView.frame.origin.y+lineView.frame.size.height)/2 - userImagee.frame.size.height/2, userImagee.frame.size.width, userImagee.frame.size.height);
        return cell;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1)
        return 30;
    else
    {
    NSDictionary *dic=[commentList objectAtIndex:indexPath.row];
    NSString *text=[dic objectForKey:@"comment"];
    CGRect rect=[Helper calculateHeightForText:text fontName:Helvetica_REGULAR fontSize:13 maximumWidth:self.view.frame.size.width-(8+45+10+8)];
    return rect.size.height+8+20+20+1+8;
    }
}

-(UIView *)tableHeaderView
{
    UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    if([[postDetails valueForKey:@"postImage_width"]intValue]<self.view.frame.size.width)
    {
        mainimageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, [[postDetails valueForKey:@"postImage_height"]intValue])];
        mainimageView.contentMode = UIViewContentModeScaleAspectFill;

    }
    else
    {
        mainimageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0,[[postDetails valueForKey:@"postImage_width"]intValue], [[postDetails valueForKey:@"postImage_height"]intValue])];
        mainimageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    mainimageView.clipsToBounds=YES;
//    mainimageView=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];

    CGFloat yCoordinate = mainimageView.frame.origin.y+mainimageView.frame.size.height+8;
    
    UITextView *caption=[[UITextView alloc]initWithFrame:CGRectMake(10, yCoordinate, self.view.frame.size.width-20, 20)];
    caption.delegate=self;
    caption.editable=false;
    caption.scrollEnabled=false;
    caption.dataDetectorTypes = UIDataDetectorTypeLink;
    caption.textColor=[Helper colorFromHexString:@"343536"];
    caption.font=[UIFont fontWithName:@"Helvetica Neue" size:13];
    
   /* NSString *text=@"";
    if (![[postDetails objectForKey:@"caption"] isKindOfClass:[NSNull class]])
    {
        text=[postDetails objectForKey:@"caption"];
    }
    
    caption.text=text;*/
    NSString *text=@"";
    if (![[postDetails objectForKey:@"caption"] isKindOfClass:[NSNull class]])
    {
        
        text=[postDetails objectForKey:@"caption"];
        NSLog(@"text %@", text);
    }
    
    
    NSData *data = [NSData dataWithBytes: [[postDetails objectForKey:@"caption"] UTF8String] length:strlen([[postDetails objectForKey:@"caption"] UTF8String])];
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
    CGRect rect=[Helper calculateHeightForText:text fontName:@"Helvetica Neue" fontSize:15 maximumWidth:self.view.frame.size.width-20];
    
    CGRect frame=caption.frame;
    frame.origin.x=10;
    frame.origin.y=caption.frame.origin.y;
    frame.size.width=self.view.frame.size.width-20;
    frame.size.height=rect.size.height+8;
    caption.frame=frame;
    
    yCoordinate = yCoordinate + caption.frame.size.height+8;
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, yCoordinate, self.view.frame.size.width, 0)];
    
    CGFloat viewHeight = 0;
    
    UIImageView *moodimage;
    UITextView *moodhashtag;
    
    if ([[postDetails objectForKey:@"mood"] length]>0)
    {
        moodimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        moodimage.image=[UIImage imageNamed:@"mood_share.png"];
        
        moodhashtag=[[UITextView alloc]initWithFrame:CGRectMake(moodimage.frame.origin.x+moodimage.frame.size.width+8, moodimage.frame.origin.y-7, self.view.frame.size.width-moodimage.frame.origin.x+moodimage.frame.size.width+8+8, 30)];
        
        NSData *data = [NSData dataWithBytes: [[postDetails objectForKey:@"mood"] UTF8String] length:strlen([[postDetails objectForKey:@"mood"] UTF8String])];
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
        
        
        
       /* moodhashtag.text=[postDetails objectForKey:@"mood"];
        moodhashtag.font=[UIFont systemFontOfSize:13];*/
        
        [detailView addSubview:moodimage];
        [detailView addSubview:moodhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *wearingimage;
    UITextView *wearinghashtag;
    if ([[postDetails objectForKey:@"wearing"] length]>0)
    {
        wearingimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        wearingimage.image=[UIImage imageNamed:@"wearing_share.png"];
        
        wearinghashtag=[[UITextView alloc]initWithFrame:CGRectMake(wearingimage.frame.origin.x+wearingimage.frame.size.width+8, wearingimage.frame.origin.y-7, self.view.frame.size.width-wearingimage.frame.origin.x+wearingimage.frame.size.width+8+8, 30)];
        
        wearinghashtag.backgroundColor=[UIColor clearColor];
        
        NSData *data = [NSData dataWithBytes: [[postDetails objectForKey:@"wearing"] UTF8String] length:strlen([[postDetails objectForKey:@"wearing"] UTF8String])];
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
        wearinghashtag.delegate=self;
        wearinghashtag.editable=false;
        wearinghashtag.scrollEnabled=false;
        wearinghashtag.font=[UIFont systemFontOfSize:13];
        /*wearinghashtag.text=[postDetails objectForKey:@"wearing"];
        wearinghashtag.font=[UIFont systemFontOfSize:13];*/
        
        [detailView addSubview:wearingimage];
        [detailView addSubview:wearinghashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *listeningimage;
    UITextView *listenhashtag;
    
    if ([[postDetails objectForKey:@"listening"] length]>0)
    {
        listeningimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        listeningimage.image=[UIImage imageNamed:@"listning_share.png"];
        
        listenhashtag=[[UITextView alloc]initWithFrame:CGRectMake(listeningimage.frame.origin.x+listeningimage.frame.size.width+8, listeningimage.frame.origin.y-7, self.view.frame.size.width-listeningimage.frame.origin.x+listeningimage.frame.size.width+8+8, 30)];
        
        NSData *data = [NSData dataWithBytes: [[postDetails objectForKey:@"listening"] UTF8String] length:strlen([[postDetails objectForKey:@"listening"] UTF8String])];
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
        listenhashtag.backgroundColor=[UIColor clearColor];
        listenhashtag.attributedText=string;
        listenhashtag.font=[UIFont systemFontOfSize:13];
        listenhashtag.delegate=self;
        listenhashtag.editable=false;
        listenhashtag.scrollEnabled=false;
        /*listenhashtag.text=[postDetails objectForKey:@"listening"];
        listenhashtag.font=[UIFont systemFontOfSize:13];*/
        
        [detailView addSubview:listeningimage];
        [detailView addSubview:listenhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *watchimage;
    UITextView *watchhashtag;
    if ([[postDetails objectForKey:@"watching"] length]>0)
    {
        watchimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        watchimage.image=[UIImage imageNamed:@"watching_share.png"];
        
        watchhashtag=[[UITextView alloc]initWithFrame:CGRectMake(watchimage.frame.origin.x+watchimage.frame.size.width+8, watchimage.frame.origin.y-7, self.view.frame.size.width-watchimage.frame.origin.x+watchimage.frame.size.width+8+8, 30)];
        if ([[postDetails objectForKey:@"watching"] hasPrefix:@" "])
        {
            watchhashtag.text=[[postDetails objectForKey:@"watching"] substringFromIndex:1];
        }
        else
        {
            watchhashtag.text=[postDetails objectForKey:@"watching"];
        }
        NSData *data = [NSData dataWithBytes: [[postDetails objectForKey:@"watching"] UTF8String] length:strlen([[postDetails objectForKey:@"watching"] UTF8String])];
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
        watchhashtag.backgroundColor=[UIColor clearColor];

        watchhashtag.attributedText=string;
        watchhashtag.font=[UIFont systemFontOfSize:13];
        watchhashtag.delegate=self;
        watchhashtag.editable=false;
        watchhashtag.scrollEnabled=false;
        [detailView addSubview:watchimage];
        [detailView addSubview:watchhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    UIImageView *locationimage;
    UITextView *locationhashtag;
    
    if ([[postDetails objectForKey:@"location"] length]>0)
    {
        locationimage=[[UIImageView alloc]initWithFrame:CGRectMake(20, viewHeight, 20, 20)];
        locationimage.image=[UIImage imageNamed:@"where_share.png"];
        
        locationhashtag=[[UITextView alloc]initWithFrame:CGRectMake(locationimage.frame.origin.x+locationimage.frame.size.width+8, locationimage.frame.origin.y-7, self.view.frame.size.width-locationimage.frame.origin.x+locationimage.frame.size.width+8+8, 30)];
        NSData *data = [NSData dataWithBytes: [[postDetails objectForKey:@"location"] UTF8String] length:strlen([[postDetails objectForKey:@"location"] UTF8String])];
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
        locationhashtag.backgroundColor=[UIColor clearColor];
        locationhashtag.attributedText=string;
        locationhashtag.delegate=self;
        locationhashtag.editable=false;
        locationhashtag.scrollEnabled=false;
        locationhashtag.font=[UIFont systemFontOfSize:13];
       /* locationhashtag.text=[postDetails objectForKey:@"location"];
        locationhashtag.font=[UIFont systemFontOfSize:13];*/
        
        [detailView addSubview:locationimage];
        [detailView addSubview:locationhashtag];
        
        viewHeight=viewHeight+20;
    }
    
    viewHeight = viewHeight + 8;
    
    detailView.frame=CGRectMake(0, yCoordinate, self.view.frame.size.width, viewHeight);
    
    yCoordinate = yCoordinate + detailView.frame.size.height + 8;
    
    postReaction=[[UILabel alloc]initWithFrame:CGRectMake(10, yCoordinate, self.view.frame.size.width-20, 20)];
    
    NSString *smile = @"smile";
    if ([[postDetails objectForKey:@"totalLikes"] integerValue]>1)
    {
        smile = @"smiles";
    }
    
    NSString *comment = @"comment";
    if ([[postDetails objectForKey:@"totalComments"] integerValue]>1)
    {
        comment = @"comments";
    }
    
    NSString *repeat = @"repeat";
    if ([[postDetails objectForKey:@"totalShares"] integerValue]>1)
    {
        repeat = @"repeats";
    }
    postReaction.text=[NSString stringWithFormat:@"%@ %@    %@ %@    %@ %@", [postDetails objectForKey:@"totalLikes"], smile,  [postDetails objectForKey:@"totalComments"], comment, [postDetails objectForKey:@"totalShares"], repeat];
    postReaction.textColor=[UIColor lightGrayColor];
    postReaction.font=[UIFont fontWithName:Helvetica_REGULAR size:12];
    
    UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-160/2, postReaction.frame.origin.y+postReaction.frame.size.height+15, 160, 35)];
    buttonView.backgroundColor=[UIColor whiteColor];
    
    likeBtnView = [[UIView alloc]initWithFrame:CGRectMake(32.5, 7.5, 25, 25)];
    smileImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
    
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([[postDetails objectForKey:@"islike"] intValue]==0)
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
    
    [buttonView addSubview:likeBtnView];
    [buttonView addSubview:likeBtn];
    
    UIButton *commentBtn =[[UIButton alloc]initWithFrame:CGRectMake(70, 0, 35, buttonView.frame.size.height)];
    [commentBtn setImage:[UIImage imageNamed:@"comment_btn.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentPost:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[postDetails valueForKey:@"shareduserfullname"]isEqualToString:@""])
    {
        UIButton *repeatBtn=[[UIButton alloc]initWithFrame:CGRectMake(115, 0, 35, buttonView.frame.size.height)];
        [repeatBtn setImage:[UIImage imageNamed:@"repeat_btn.png"] forState:UIControlStateNormal];
        [repeatBtn addTarget:self action:@selector(repeatPost:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:repeatBtn];
    }
    else
    {
     
    }
    [buttonView addSubview:likeBtn];
    [buttonView addSubview:commentBtn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, buttonView.frame.origin.y+buttonView.frame.size.height+8, self.view.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    
    [mainView addSubview:mainimageView];
    [mainView addSubview:caption];
    [mainView addSubview:detailView];
    [mainView addSubview:postReaction];
    [mainView addSubview:buttonView];
    [mainView addSubview:lineView];
    
    mainView.frame=CGRectMake(0, 0, self.view.frame.size.width, lineView.frame.origin.y+lineView.frame.size.height);
    
    mainimageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like:)];
    gesture.numberOfTapsRequired=2;
    [mainimageView addGestureRecognizer:gesture];

    
    mainimageView.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [postDetails objectForKey:@"postImage"]]];
    
    mainimageView.backgroundColor = UIColor.whiteColor;
    smileyImage = [[UIImageView alloc]initWithFrame:CGRectMake(mainimageView.frame.size.width/2-40, mainimageView.frame.size.height/2-40, 80, 80)];
    [smileyImage setImage:[UIImage imageNamed:@"smiley.png"]];
    [mainimageView addSubview:smileyImage];
        smileyImage.hidden=YES;
    
    
    return mainView;
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
    
    if ([[postDetails objectForKey:@"islike"] integerValue]==0)
    {
        
        /*long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
         NSLog(@"postDetails before: %@",postDetails);
        totalLikes=totalLikes+1;
        NSMutableDictionary *details=[postDetails mutableCopy];
        [details setObject:@"1" forKey:@"islike"];
        [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
        NSLog(@"details : %@",details);
        postDetails=[details mutableCopy];
        NSLog(@"postDetails : %@",postDetails);*/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"likePostSuccess" object:postDetails];
//        [commentList insertObject:details atIndex:0];
//        [commentList removeObjectAtIndex:1];
//         commentList=[details mutableCopy];
        
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor whiteColor]];
        
        [table reloadData];
        
        NSString *st;
        if([[postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
        {
            st=[postDetails objectForKey:@"postid"];
        }
        else
        {
            st=[postDetails objectForKey:@"sharePostid"];
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
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject                                                                     options:kNilOptions error:nil];
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

    [table reloadData];

   
}
#pragma mark -- Button Action

-(void)likePost:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"home"];

    if ([Helper isInternetConnected]==YES)
    {
        if ([[postDetails objectForKey:@"islike"] integerValue]==0)
        {
            
          /*  long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
            totalLikes=totalLikes+1;
            NSMutableDictionary *details=[postDetails mutableCopy];
            [details setObject:@"1" forKey:@"islike"];
            [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
            postDetails=[details mutableCopy];*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"likePostSuccess" object:nil];
//            [commentList insertObject:details atIndex:0];
//            [commentList removeObjectAtIndex:1];
//            commentList=[details mutableCopy];
            [table reloadData];

            smileyImage.hidden=NO;
            smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            [UIView animateWithDuration:1.0
                             animations:^{
                                 self->smileyImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                             } completion:^(BOOL finished) {
                                 self->smileyImage.hidden=YES;
                             }];
            
            NSString *st;
            if([[postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
            {
                st=[postDetails objectForKey:@"postid"];
            }
            else
            {
                st=[postDetails objectForKey:@"sharePostid"];
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
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject                                                                     options:kNilOptions error:nil];
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
            //dislike
            
            
           /* long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
            totalLikes=totalLikes-1;
            NSMutableDictionary *details=[postDetails mutableCopy];
            [details setObject:@"0" forKey:@"islike"];
            [details setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
            postDetails=[details mutableCopy];*/
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlikePostSuccess" object:nil];
//            [commentList insertObject:details atIndex:0];
//            [commentList removeObjectAtIndex:1];
//             commentList=[details mutableCopy];
            [table reloadData];

            [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
            [smileImage setTintColor:[UIColor blackColor]];
            
            NSString *st;
            if([[postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
            {
                st=[postDetails objectForKey:@"postid"];
            }
            else
            {
                st=[postDetails objectForKey:@"sharePostid"];
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
    [table reloadData];
}

-(void)commentPost:(UIButton *)sender
{
    
    [commentField becomeFirstResponder];
}

-(void)repeatPost:(UIButton *)sender
{
    [Helper showIndicatorWithText:@"updating Posts..." inView:self.view];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"sharePost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"       : [postDetails objectForKey:@"postid"]
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
            [Helper showAlertViewWithTitle:@"Repost Done" message:@""];
            //[self viewWillAppear:0];
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
-(void)addCommentWithDetails:(NSDictionary *)details
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"home"];

    [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
    NSString *st=@"";
    for(int i=0;i<mentionusersList.count;i++)
    {
        if(st.length==0)
            st=[NSString stringWithFormat:@"%@",mentionusersList[i]];
        else
            st=[NSString stringWithFormat:@"%@,%@",st,mentionusersList[i]];
    }
    
    [mentionusersList removeAllObjects];
    [searchlist removeAllObjects];
    allUserList1 =[allUserList mutableCopy];

   // NSString *st1=@"";
//    if([[details objectForKey:@"sharePostid"]isEqualToString:@""])
//    {
       // st1=[details objectForKey:@"postid"];
//    }
//    else
//    {
//        st1=[details objectForKey:@"sharePostid"];
//    }
    NSString *st1=@"";
    if([[postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
    {
        st1=[postDetails objectForKey:@"postid"];
    }
    else
    {
        st1=[postDetails objectForKey:@"sharePostid"];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"addComments",
                             @"comment"      : [details valueForKey:@"comment"],
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"       :st1,
                             @"mention"      :st
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            long totalcomments=[[self->postDetails objectForKey:@"totalComments"] integerValue];
            totalcomments=totalcomments+1;
            [self->postDetails setObject:[NSString stringWithFormat:@"%lu", totalcomments] forKey:@"totalComments"];
            [self updateValues];
            
            
            
            NSString *st2;
            if([[self->postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
            {
                st2=[self->postDetails objectForKey:@"postid"];
            }
            else
            {
                st2=[self->postDetails objectForKey:@"sharePostid"];
            }
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *params = @{
                                     @"method"       : @"getComments",
                                     @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                     @"postid"       :st2,
                                     };
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = nil;
            [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                NSLog(@"JSON: %@", json);
               // [Helper hideIndicatorFromView:self.view];
                
                if ([[json objectForKey:@"success"]integerValue]==1)
                {
                    self->commentList=[[json valueForKey:@"comments"] mutableCopy];
                    [self->table reloadData];
                    if(self->commentList.count>1)
                    {
                        int lastRowNumber = [self->table numberOfRowsInSection:0] - 1;
                        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
                        [self->table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];

                    }
                    [Helper hideIndicatorFromView:self.view];

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
            
            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    

    
    

}
- (IBAction)postComment:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"home"];

    if (commentField.text.length>0)
    {
        if ([Helper isInternetConnected]==YES)
        {
            
            
            NSString *uniText = [NSString stringWithUTF8String:[commentField.text UTF8String]];
            NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
            NSString *goodMsg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
            
            
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:@"addComments" forKey:@"method"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"userid"];
            [dic setObject:[postDetails objectForKey:@"postid"] forKey:@"postid"];
            [dic setObject:goodMsg forKey:@"comment"];
            [self addCommentWithDetails:dic];
            
//            NSMutableDictionary *commentDic=[NSMutableDictionary dictionary];
//            [commentDic setObject:commentField.text forKey:@"comment"];
//
//            NSString *dateStr=[Helper getDateStringFromDate:[NSDate date]];
//
//            [commentDic setObject:dateStr forKey:@"createdon"];
//            [commentDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] forKey:@"name"];
//            [commentDic setObject:@"bg1.jpg" forKey:@"pic"];
//            [commentList addObject:commentDic];
//
//            [table reloadData];
//            int lastRowNumber = [table numberOfRowsInSection:0] - 1;
//            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//            [table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
            commentField.text=@"";
            [commentField resignFirstResponder];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
}

-(void)menu
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", @"Share", @"Delete", nil];
    sheet.tag=1;
    [sheet showInView:self.view];
}

#pragma mark -- ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if (buttonIndex==0)
        {
            //edit
            if(UIImagePNGRepresentation(mainimageView.image))
            {
            editPostFilterView *smvc = [[editPostFilterView alloc]init];
            [[NSUserDefaults standardUserDefaults]setValue:postDetails forKey:@"postDdetails"];
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(mainimageView.image) forKey:@"currentImage"];
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isCommenting"];
            [self.navigationController pushViewController:smvc animated:YES];
            }
        }
        else if (buttonIndex==1)
        {
            //share
            NSArray *objectsToShare = @[postImage];
            
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
                activityVC.popoverPresentationController.sourceView = menuBtn;
            }
        }
        else if (buttonIndex==2)
        {
            //delete
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you really want to delete this post?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag=1;
            [alert show];
        }
    }
    else if(actionSheet.tag==2)
    {
        if (buttonIndex==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you really want to delete this Comment?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag=2;
            [alert show];
        }
        else if(buttonIndex==1)
        {
            
        }
    }
}

#pragma mark -- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [Helper showIndicatorWithText:@"Loading..." inView:self.view];
            [self deletePostByPostID:[postDetails objectForKey:@"postid"]];
        }
    }
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            [self deleteComment];
            
            //[self deletePostByPostID:[postDetails objectForKey:@"postid"]];
        }
    }
}
-(void)deleteComment
{
    NSDictionary *dic=[commentList objectAtIndex:selectedRow];
    [Helper showIndicatorWithText:@"Deleting Comment..." inView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"deleteComment",
                             @"commentid"    : [dic valueForKey:@"commentid"],
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            long totalcomments=[[self->postDetails objectForKey:@"totalComments"] integerValue];
            totalcomments=totalcomments-1;
            [self->postDetails setObject:[NSString stringWithFormat:@"%lu", totalcomments] forKey:@"totalComments"];
            [self updateValues];

            
                NSString *st;
                if([[self->postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
                {
                    st=[self->postDetails objectForKey:@"postid"];
                }
                else
                {
                    st=[self->postDetails objectForKey:@"sharePostid"];
                }
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSDictionary *params = @{
                                         
                                         @"method"       : @"getComments",
                                         @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                         @"postid"       :st,
                                         
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
                        self->commentList=[[json valueForKey:@"comments"] mutableCopy];
                        [self->table reloadData];
                        if(self->commentList.count>1)
                        {
                            int lastRowNumber = [self->table numberOfRowsInSection:0] - 1;
                            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
                            [self->table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
        else
        {
            
            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:self->postDetails];
            [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark -- Helper Methods

-(void)updateValues
{

    NSString *smile = @"smile";
    if ([[postDetails objectForKey:@"totalLikes"] integerValue]>1)
    {
        smile = @"smiles";
    }
    
    NSString *comment = @"comment";
    if ([[postDetails objectForKey:@"totalComments"] integerValue]>1)
    {
        comment = @"comments";
    }
    
    NSString *repeat = @"repeat";
    if ([[postDetails objectForKey:@"totalLikes"] integerValue]>1)
    {
        repeat = @"repeats";
    }
    postReaction.text=[NSString stringWithFormat:@"%@ %@    %@ %@    %@ %@", [postDetails objectForKey:@"totalLikes"], smile,  [postDetails objectForKey:@"totalComments"], comment, [postDetails objectForKey:@"totalShares"], repeat];
    
    UIImage *image = [UIImage imageNamed:@"smile.png"];
    smileImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if ([[postDetails objectForKey:@"islike"] intValue]==0)
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:213/255.0 blue:218/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor blackColor]];
    }
    else
    {
        [likeBtnView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:34/255.0 blue:63/255.0 alpha:1]];
        [smileImage setTintColor:[UIColor whiteColor]];
    }
}

#pragma mark -- Notification Methods

-(void)commentListSuccess:(NSNotification *)notification
{
    commentList=[notification.object mutableCopy];
    [table reloadData];
}

-(void)likePostSuccess:(NSNotification *)notification
{
    long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
    totalLikes=totalLikes+1;
    [postDetails setObject:@"1" forKey:@"islike"];
    [postDetails setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
    [self updateValues];
}

-(void)unlikePostSuccess:(NSNotification *)notification
{
    long totalLikes=[[postDetails objectForKey:@"totalLikes"] integerValue];
    totalLikes=totalLikes-1;
    if (1>totalLikes)
    {
        totalLikes=0;
    }
    [postDetails setObject:@"0" forKey:@"islike"];
    [postDetails setObject:[NSString stringWithFormat:@"%lu", totalLikes] forKey:@"totalLikes"];
    [self updateValues];
}

-(void)addCommentSuccess:(NSNotification *)notification
{
    long totalcomments=[[postDetails objectForKey:@"totalComments"] integerValue];
    totalcomments=totalcomments+1;
    NSMutableDictionary *st=[postDetails mutableCopy];
    [st setObject:[NSString stringWithFormat:@"%lu", totalcomments] forKey:@"totalComments"];
    postDetails=[st mutableCopy];
    [self updateValues];
}

-(void)sharePostSuccess:(NSNotification *)notification
{
//    [[[[iToast makeText:@"Post shared successfully."]
//       setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
}

-(void)deletePost:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:postDetails];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark keyboard notifications methods

-(void) keyboardWillShow:(NSNotification *)note
{
    NSLog(@"keyboard Will Shown");
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    [self moveControls:note up:YES];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSLog(@"keyboard Will Hide");
    
    [self moveControls:note up:NO];
}

- (void)moveControls:(NSNotification*)notification up:(BOOL)up
{
    NSDictionary* userInfo = [notification userInfo];
    CGRect newFrame = [self getNewControlsFrame:userInfo up:up];
    
    [self animateControls:userInfo withFrame:newFrame];
}

- (CGRect)getNewControlsFrame:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect kbFrame = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    CGRect newFrame = self.view.frame;
    
    if (up == YES)
    {
        newFrame.origin.y = -kbFrame.size.height+64-60;
    }
    else
    {
        newFrame.origin.y = 0;
    }
    
    return newFrame;
}

- (void)animateControls:(NSDictionary*)userInfo withFrame:(CGRect)newFrame
{
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    self.view.frame = newFrame;
    [UIView commitAnimations];
}

#pragma mark -- TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    searchlist =[NSMutableArray new];
    NSArray *components=[[NSString stringWithFormat:@"%@%@",commentField.text,string] componentsSeparatedByString:@" "];
    NSString *stt=[NSString stringWithFormat:@"%@",[components lastObject]];
    
    if(components.count>0 && [stt length]>1)
       {
          if([[stt substringToIndex:1] isEqualToString:@"@"])
            {
                if([stt length]>1)
                [self mentionUser:[stt substringFromIndex:1]];
            }

       }
    return YES;
}
-(void)mentionUser:(NSString*)st
{
    NSLog(@"%@",st);
    for(int i=0;i<allUserList1.count;i++)
    {
    if ([[[allUserList1 objectAtIndex:i]valueForKey:@"username"] rangeOfString:st options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        NSLog(@"sub string doesnt exist");
    }
    else
    {
        [searchlist addObject:[allUserList1 objectAtIndex:i]];
    }

        if(searchlist.count>0)
    _mentionTable.hidden=false;
        else
            _mentionTable.hidden=true;

    [_mentionTable reloadData];
}
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    
    NSLog(@"%@",[textView.text substringWithRange: characterRange]);
    NSString *testString = textView.text;
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detect matchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
    
    
    
    if (matches.count == 0){
        
        
            NSString *firstLetter = [[textView.text substringWithRange: characterRange] substringToIndex:1];
             if([firstLetter isEqualToString:@"@"])
               {
        
        
        for(int i=0;i<allUserList.count;i++)
        {
            if([[[allUserList objectAtIndex:i]valueForKey:@"username"]isEqualToString:[[textView.text substringWithRange: characterRange]substringFromIndex:1]])
            {
                if([[[allUserList objectAtIndex:i]valueForKey:@"id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
                {
                    self.tabBarController.selectedIndex=4;
                }
                else
                {
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[[allUserList objectAtIndex:i]valueForKey:@"id"] forKey:@"otherUserId"];
                    [userDefaults synchronize];
                    
                    otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
                    [self.navigationController pushViewController:smvc animated:YES];
                }
            }
        }
               }
                   else
                   {
                       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                               [userDefaults setObject:[[textView.text substringWithRange: characterRange] substringFromIndex:1] forKey:@"hashtag"];
                               [userDefaults synchronize];
                               hashtagScreenView *smvc = [[hashtagScreenView alloc]init];
                               [self.navigationController pushViewController:smvc animated:YES];
                               return NO;
                   }
        
        return NO;
    }else{
        return true;
    }
    

}





//- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
//{
//
//    NSLog(@"%@",[textView.text substringWithRange: characterRange]);
//
//    NSString *testString = textView.text;
//    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
//    NSArray *matches = [detect matchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
//
//    if (matches.count == 0){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:[[textView.text substringWithRange: characterRange] substringFromIndex:1] forKey:@"hashtag"];
//        [userDefaults synchronize];
//        hashtagScreenView *smvc = [[hashtagScreenView alloc]init];
//        [self.navigationController pushViewController:smvc animated:YES];
//        return NO;
//
//    }else{
//        return true;
//    }
//
//
//
//
//}
-(NSString*)HourCalculation:(NSString*)PostDate

{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormat dateFromString:PostDate];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
    NSDate *ExpDate = date;//[dateFormat dateFromString:PostDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit|NSWeekCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:ExpDate toDate:[NSDate date] options:0];
    NSString *time;
    if(components.year!=0)
    {
        if(components.year==1)
        {
            time=[NSString stringWithFormat:@"%ld year",(long)components.year];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld years",(long)components.year];
        }
    }
    else if(components.month!=0)
    {
        if(components.month==1)
        {
            time=[NSString stringWithFormat:@"%ld month",(long)components.month];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld months",(long)components.month];
        }
    }
    else if(components.week!=0)
    {
        if(components.week==1)
        {
            time=[NSString stringWithFormat:@"%ld week",(long)components.week];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld weeks",(long)components.week];
        }
    }
    else if(components.day!=0)
    {
        if(components.day==1)
        {
            time=[NSString stringWithFormat:@"%ld day",(long)components.day];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld days",(long)components.day];
        }
    }
    else if(components.hour!=0)
    {
        if(components.hour==1)
        {
            time=[NSString stringWithFormat:@"%ld hour",(long)components.hour];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld hours",(long)components.hour];
        }
    }
    else if(components.minute!=0)
    {
        if(components.minute==1)
        {
            time=[NSString stringWithFormat:@"%ld minute",(long)components.minute];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld minutes",(long)components.minute];
        }
    }
    else if(components.second>=0)
    {
        if(components.second==0)
        {
            time=[NSString stringWithFormat:@"1 second"];
        }
        else
        {
            time=[NSString stringWithFormat:@"%ld seconds",(long)components.second];
        }
    }
    return [NSString stringWithFormat:@"%@",time];
}

-(void)userNameView:(UITapGestureRecognizer*)gesture
{
 
    NSDictionary *dic=[commentList objectAtIndex:gesture.view.tag];
    if([[dic valueForKey:@"userid"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        self.tabBarController.selectedIndex=4;
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"%@",[dic valueForKey:@"userid"]);
        [userDefaults setObject:[dic valueForKey:@"userid"] forKey:@"otherUserId"];
        [userDefaults synchronize];
        
        otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
    }
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.table];
    
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        NSLog(@"%ld", (long)indexPath.row);
        selectedRow=(int)indexPath.row;
        NSDictionary *dic=[commentList objectAtIndex:selectedRow];
        
        NSString *st;
        if([[postDetails objectForKey:@"sharePostid"]isEqualToString:@""])
        {
            st=[postDetails objectForKey:@"postid"];
        }
        else
        {
            st=[postDetails objectForKey:@"sharePostid"];
        }
        
        
    if([[dic valueForKey:@"userid"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]] || [st isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];
        sheet.tag=2;
        [sheet showInView:self.view];

       
    }
    }
}

@end
