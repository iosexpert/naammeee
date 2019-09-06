//
//  registerViewController.m
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "registerViewController.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "tabbarViewController.h"
@interface registerViewController ()<UITextFieldDelegate>
{
     UITextField *name;
     UITextField *username;
     UITextField *email;
     UITextField *password;
     UITextField *confirm;
    UIScrollView *scrv;
}
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.image=[UIImage imageNamed:@"bg-login"];;
    [self.view addSubview:backgroundImage];
    
   

    
    scrv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    scrv.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scrv];
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction:) forControlEvents:UIControlEventTouchUpInside];
    crossBtn.frame = CGRectMake(self.view.frame.size.width-55, 30, 35, 35);
    [scrv addSubview:crossBtn];
    
    
    UIImageView *logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 50, 200, 65)];
    logoimage.image=[UIImage imageNamed:@"logo"];
    [scrv addSubview:logoimage];
    
    
    
    UIView *feildBackView=[[UIView alloc]initWithFrame:CGRectMake(30, 130, self.view.frame.size.width-60, 250)];
    feildBackView.backgroundColor=[UIColor whiteColor];
    feildBackView.layer.cornerRadius=4.0;
    [scrv addSubview:feildBackView];
    
    int y=0;
    for(int i=0;i<5;i++)
    {
    UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(0, y+50, feildBackView.frame.size.width, 1)];
    sepView.backgroundColor=[UIColor lightGrayColor];
    [feildBackView addSubview:sepView];
        if(i<3)
        {
        UIImageView *nlogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, y+12.5, 25, 25)];
        nlogo.image=[UIImage imageNamed:@"n-logo"];
        [feildBackView addSubview:nlogo];
        }
        else
        {
            UIImageView *locklogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, y+12.5, 25, 25)];
            locklogo.image=[UIImage imageNamed:@"lock"];
            [feildBackView addSubview:locklogo];
        }
        y=y+50;

        
    }
    UIButton *namelogin = [UIButton buttonWithType:UIButtonTypeCustom];
    namelogin.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    namelogin.layer.cornerRadius=3;
    [namelogin setTitle:@"Sign Up" forState:UIControlStateNormal];
    [namelogin addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    namelogin.frame = CGRectMake(30, 400, self.view.frame.size.width-60, 50);
    [scrv addSubview:namelogin];
    
    
    
    name = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 200, 45)];
    name.delegate=self;
    name.tag=1;
    name.placeholder=@"Name";
    [feildBackView addSubview:name];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(50, 55, 200, 45)];
    username.delegate=self;
    username.tag=2;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.placeholder=@"User Name";
    [feildBackView addSubview:username];
    
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(50, 105, 200, 45)];
    email.delegate=self;
    email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email.keyboardType=UIKeyboardTypeEmailAddress;
    email.tag=3;
    email.placeholder=@"Email";
    [feildBackView addSubview:email];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(50, 155, 200, 45)];
    password.delegate=self;
    password.tag=4;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.placeholder=@"Password";
    password.secureTextEntry=true;
    [feildBackView addSubview:password];
    
    confirm = [[UITextField alloc] initWithFrame:CGRectMake(50, 205, 200, 45)];
    confirm.delegate=self;
    confirm.tag=5;
    confirm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirm.placeholder=@"Confirm Password";
    confirm.secureTextEntry=true;
    [feildBackView addSubview:confirm];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)signUpAction:(UIButton*)btn
{
    if(name.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Name" message:@"Please enter your name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if (username.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Username" message:@"Please enter username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if ([self validateUsernameWithString:username.text]==NO)
    {
        [[[UIAlertView alloc]initWithTitle:@"Invalid Username" message:@"Please enter valid username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if (email.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Email Address" message:@"Please enter your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if ([self validateEmailWithString:email.text]==NO)
    {
        [[[UIAlertView alloc]initWithTitle:@"Invalid Email" message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if (password.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Password" message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if (confirm.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Confirm Password" message:@"Please confirm your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if (![password.text isEqualToString:confirm.text])
    {
        [[[UIAlertView alloc]initWithTitle:@"Mismatch" message:@"Password did not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else if ([Helper isInternetConnected]==NO)
    {
        [[[UIAlertView alloc]initWithTitle:OOPS message:INTERNET_ERROR delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
        [self hidekeyboard];
        
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

    [self.view endEditing:YES];
}
-(void)hidekeyboard
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

    [name resignFirstResponder];
    [username resignFirstResponder];
    [email resignFirstResponder];
    [password resignFirstResponder];
    [confirm resignFirstResponder];
    
    
//    "method":"userRegister",
//    "username":"Pratibha",
//    "fullname":"Pratibha",
//    "email":"test1@technoarray.com",
//    "password":"123456789",
//    "deviceType" : "1",
//    "deviceToken":"1234"

    NSDictionary *paramss=@{
                            @"method"     :@"userRegister",
                            @"username"   :username.text,
                            @"fullname"   :name.text,
                            @"email"      :email.text,
                            @"password"   :password.text,
                            @"deviceType" :@"0",
                            @"deviceToken":@"123456789",
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
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[json objectForKey:@"user_id"] forKey:@"userid"];
            [userDefaults synchronize];
            
            tabbarViewController *fpvc=[[tabbarViewController alloc]init];
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

-(void)crossAction:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==1)
    {
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

    }
    else  if(textField.tag==2)
    {
        [scrv setContentOffset:CGPointMake(0, 70) animated:YES];

    }
    else  if(textField.tag==3)
    {
        [scrv setContentOffset:CGPointMake(0, 90) animated:YES];

    }
    else  if(textField.tag==4)
    {
        [scrv setContentOffset:CGPointMake(0, 110) animated:YES];
    }
    else
    {
        [scrv setContentOffset:CGPointMake(0, 140) animated:YES];

    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==2)
    {
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string lowercaseString]];
        return NO;
    }
    }
    return YES;
}

@end
