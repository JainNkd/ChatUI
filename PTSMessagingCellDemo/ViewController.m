//
//  ViewController.m
//  PTSMessagingCellDemo
//
//  Created by Ralph Gasser on 15.09.12.
//  Copyright (c) 2012 pontius software GmbH. All rights reserved.
//

#import "ViewController.h"

#define kTopViewHeight 175
#define kStatusBarSize 20
@interface ViewController ()

@end

@implementation ViewController
@synthesize viewForm,chatBox,chatButton,messages,tableView;
-(void)awakeFromNib {
    
    NSArray *messagesArr = [[NSArray alloc] initWithObjects:
              @"Hello, how are you.",
              @"I'm great, how are you?",
              @"I'm fine, thanks. Up for dinner tonight?",
              @"Glad to hear. No sorry, I have to work.",
              @"Oh that sucks. A pitty, well then - have a nice day.."
              @"Thanks! You too. Cuu soon.",
              nil];
    
    messages = [[NSMutableArray alloc]initWithArray:messagesArr];
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    isTopView = YES;
    CGFloat viewOriginY = 20;
    if(isTopView)
    {
    self.topView =[[UIView alloc]initWithFrame:CGRectMake(0,viewOriginY,320,155)];
    self.topView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: self.topView];
        
        viewOriginY += self.topView.frame.size.height+10;
    }
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,viewOriginY,320,339)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    viewOriginY += self.tableView.frame.size.height;
    
    self.viewForm = [[UIView alloc]initWithFrame:CGRectMake(0,viewOriginY,320,44)];
    self.viewForm.backgroundColor = [self colorFromHexString:@"#F1F1F1"];
    [self.view addSubview:self.viewForm];
    
    self.chatBox = [[UITextView alloc]initWithFrame:CGRectMake(10,7,230,30)];
    self.chatBox.delegate =self;
    self.chatBox.backgroundColor = [self colorFromHexString:@"#FCFCFC"];
    self.chatBox.autocapitalizationType = FALSE;
    self.chatBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.chatBox.keyboardType = UIKeyboardTypeDefault;
    
    self.chatBox.layer.cornerRadius = 7;
    self.chatBox.layer.masksToBounds = YES;
    [self.viewForm addSubview:self.chatBox];
    
    self.chatButton = [[UIButton alloc]initWithFrame: CGRectMake(255, 7, 50, 30)];
    self.chatButton.backgroundColor = [UIColor clearColor];
    [self.chatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chatButton addTarget:self action:@selector(chatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.viewForm addSubview:self.chatButton];
    
    
    //set notification for when keyboard shows/hides
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //set notification for when a key is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(keyPressed:)
                                                 name: UITextViewTextDidChangeNotification
                                               object: nil];
    
    //turn off scrolling and set the font details.
    chatBox.scrollEnabled = NO;
    chatBox.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    self.viewForm.translatesAutoresizingMaskIntoConstraints = YES;
    self.tableView.translatesAutoresizingMaskIntoConstraints = YES;
    self.chatButton.translatesAutoresizingMaskIntoConstraints = YES;
    self.chatBox.translatesAutoresizingMaskIntoConstraints = YES;
    
    [super viewDidLoad];
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loction
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
    
    // get the height since this is the main value that we need.
    
    // get a rect for the table/main frame
    CGRect topviewFrame = self.topView.frame;
    topviewFrame.origin.y -= kTopViewHeight;

    NSInteger kbSizeH = keyboardBounds.size.height;
    
    // get a rect for the table/main frame
    CGRect tableFrame = tableView.frame;
    tableFrame.origin.y -=kTopViewHeight;
    tableFrame.origin.y +=kStatusBarSize;
    tableFrame.size.height -= kbSizeH;
    tableFrame.size.height += kTopViewHeight;
    tableFrame.size.height -= kStatusBarSize;
    
    
    // get a rect for the form frame
    CGRect formFrame = viewForm.frame;
    formFrame.origin.y -= kbSizeH;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // set views with new info
    tableView.frame = tableFrame;
    viewForm.frame = formFrame;
    
    [tableView setContentOffset:CGPointMake(0,tableView.contentSize.height - tableView.frame.size.height)]
    ;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyPressed: (NSNotification*) notification{
    // get the size of the text block so we can work our magic
    CGSize newSize = [chatBox.text
                      sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                      constrainedToSize:CGSizeMake(222,9999)
                      lineBreakMode:UILineBreakModeWordWrap];
    NSInteger newSizeH = newSize.height;
    NSInteger newSizeW = newSize.width;
    
    // I output the new dimensions to the console
    // so we can see what is happening
    NSLog(@"NEW SIZE : %ld X %ld", (long)newSizeW, (long)newSizeH);
    if (chatBox.hasText)
    {
        // if the height of our new chatbox is
        // below 90 we can set the height
        if (newSizeH <= 90)
        {
            [chatBox scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
            
            // chatbox
            CGRect chatBoxFrame = chatBox.frame;
            NSInteger chatBoxH = chatBoxFrame.size.height;
            NSInteger chatBoxW = chatBoxFrame.size.width;
            NSLog(@"CHAT BOX SIZE : %ld X %ld", (long)chatBoxW, (long)chatBoxH);
            chatBoxFrame.size.height = newSizeH + 12;
            chatBox.frame = chatBoxFrame;
            
            // form view
            CGRect formFrame = viewForm.frame;
            NSInteger viewFormH = formFrame.size.height;
            NSLog(@"FORM VIEW HEIGHT : %ld", (long)viewFormH);
            formFrame.size.height = 30 + newSizeH;
            formFrame.origin.y = 272 - (newSizeH - 18);
            viewForm.frame = formFrame;
            
            // table view
            CGRect tableFrame = tableView.frame;
            NSInteger viewTableH = tableFrame.size.height;
            NSLog(@"TABLE VIEW HEIGHT : %ld", (long)viewTableH);
            tableFrame.size.height = 252 - (newSizeH - 18);
            tableView.frame = tableFrame;
            
            [tableView setContentOffset:CGPointMake(0,tableView.contentSize.height - tableView.frame.size.height)]
            ;

        }
        
        // if our new height is greater than 90
        // sets not set the height or move things
        // around and enable scrolling
        if (newSizeH > 90)
        {
            chatBox.scrollEnabled = YES;
            [tableView setContentOffset:CGPointMake(0,tableView.contentSize.height - tableView.frame.size.height)]
            ;

        }
    }
}

- (void)chatButtonClick{
    // hide the keyboard, we are done with it.
    [chatBox resignFirstResponder];
    [messages addObject:chatBox.text];
    chatBox.text = nil;
    
    // chatbox
    CGRect chatBoxFrame = chatBox.frame;
    chatBoxFrame.size.height = 30;
    chatBox.frame = chatBoxFrame;
    
    // form view
    CGRect formFrame = viewForm.frame;
    formFrame.size.height = 44;
    formFrame.origin.y = 524;
    viewForm.frame = formFrame;
    
    // get a rect for the table/main frame
    CGRect topviewFrame = self.topView.frame;
    topviewFrame.origin.y  = 0;

    // table view
    CGRect tableFrame = tableView.frame;
    tableFrame.origin.y = kTopViewHeight+10;
    tableFrame.size.height = 339;
    tableView.frame = tableFrame;

    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // set views with new info
    tableView.frame = tableFrame;
    viewForm.frame = formFrame;
    [self.tableView reloadData];
    [tableView setContentOffset:CGPointMake(0,tableView.contentSize.height - tableView.frame.size.height)]
    ;

    
    // commit animations
    [UIView commitAnimations];

}

-(void) keyboardWillHide:(NSNotification *)note{
    // get keyboard size and loction
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
    
    
    // get a rect for the table/main frame
    CGRect topviewFrame = self.topView.frame;
    topviewFrame.origin.y += kTopViewHeight;
    
    // get the height since this is the main value that we need.
    NSInteger kbSizeH = keyboardBounds.size.height;
    
    // get a rect for the table/main frame
    CGRect tableFrame = tableView.frame;
    tableFrame.origin.y += kTopViewHeight;
    tableFrame.origin.y -=kStatusBarSize;
    tableFrame.size.height += kbSizeH;
    tableFrame.size.height -= kTopViewHeight;
    tableFrame.size.height += kStatusBarSize;

    
    // get a rect for the form frame
    CGRect formFrame = viewForm.frame;
    formFrame.origin.y += kbSizeH;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // set views with new info
    tableView.frame = tableFrame;
    viewForm.frame = formFrame;
    [tableView setContentOffset:CGPointMake(0,tableView.contentSize.height - tableView.frame.size.height)]
    ;

    
    // commit animations
    [UIView commitAnimations];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize messagesize = [PTSMessagingCell messageSize:[messages objectAtIndex:indexPath.row]];
//    return messagesize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
        return messagesize.height + 2*[PTSMessagingCell textMarginVertical]+15;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    
    if (indexPath.row % 2 == 0) {
        ccell.sent = YES;
        ccell.avatarImageView.image = [UIImage imageNamed:@""];
    } else {
        ccell.sent = NO;
        ccell.avatarImageView.image = [UIImage imageNamed:@""];
    }
    
    ccell.messageLabel.text = [messages objectAtIndex:indexPath.row];
    ccell.timeLabel.text = @"";
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}



@end
