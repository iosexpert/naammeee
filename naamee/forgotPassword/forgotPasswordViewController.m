//
//  forgotPasswordViewController.m
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "forgotPasswordViewController.h"
#import "Helper.h"
#import "AFNetworking.h"

@interface forgotPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *userNamefeild;
}
@end

@implementation forgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.image=[UIImage imageNamed:@"bg-login"];;
    [self.view addSubview:backgroundImage];
    
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction:) forControlEvents:UIControlEventTouchUpInside];
    crossBtn.frame = CGRectMake(self.view.frame.size.width-55, 30, 35, 35);
    [self.view addSubview:crossBtn];
    
    UIImageView *logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 50, 200, 65)];
    logoimage.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:logoimage];
    
    
    
    
    UIView *feildBackView=[[UIView alloc]initWithFrame:CGRectMake(30, 180, self.view.frame.size.width-60, 50)];
    feildBackView.backgroundColor=[UIColor whiteColor];
    feildBackView.layer.cornerRadius=4.0;

    [self.view addSubview:feildBackView];
    
    UIImageView *nlogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    nlogo.image=[UIImage imageNamed:@"n-logo"];
    [feildBackView addSubview:nlogo];
    
    
    userNamefeild = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 200, 45)];
    userNamefeild.delegate=self;
    userNamefeild.placeholder=@"Email";
    [feildBackView addSubview:userNamefeild];
    
    
    UIButton *namelogin = [UIButton buttonWithType:UIButtonTypeCustom];
    namelogin.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    namelogin.layer.cornerRadius=3;
    [namelogin setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [namelogin addTarget:self action:@selector(forgotPass:) forControlEvents:UIControlEventTouchUpInside];
    namelogin.frame = CGRectMake(30, 250, self.view.frame.size.width-60, 50);
    [self.view addSubview:namelogin];
    
    
   
    // Do any additional setup after loading the view.
}
-(void)crossAction:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)forgotPass:(id)sender
{
    if (userNamefeild.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Email Address" message:@"Please enter your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if ([self validateEmailWithString:userNamefeild.text]==NO)
    {
        [[[UIAlertView alloc]initWithTitle:@"Invalid Email" message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if ([Helper isInternetConnected]==NO)
    {
        [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
    [Helper showIndicatorWithText:@"Getting Password..." inView:self.view];
    
//        "method":"recover",
//        "email":" test10011@technoarray.com ",
//        "deviceType":"2",
//        "deviceToken":"222"

        
        
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{@"method"      : @"recover",
                                 @"email"       : userNamefeild.text,
                                 @"deviceType"  : @"0",
                                 @"deviceToken" : @"123456789",
                                 };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"code"]integerValue]==1)
        {
            NSArray *msg=[json objectForKey:@"message"];
            if (msg.count>0)
            {
                [Helper showAlertViewWithTitle:@"Success" message:[msg objectAtIndex:0]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            NSArray *msg=[json objectForKey:@"message"];
            if (msg.count>0)
            {
                [Helper showAlertViewWithTitle:OOPS message:[msg objectAtIndex:0]];
            }
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)validateUsernameWithString:(NSString*)username
{
    NSCharacterSet * characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString: username];
    if([[NSCharacterSet alphanumericCharacterSet] isSupersetOfSet: characterSetFromTextField] == NO)
    {
        NSLog( @"there are bogus characters here, throw up a UIAlert at this point");
        return NO;
    }
    else
    {
        return YES;
    }
}
    -(BOOL)validateEmailWithString:(NSString*)emailmatch
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailmatch rangeOfString:@" "].location==NSNotFound && [emailTest evaluateWithObject:emailmatch])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
@end
