//
//  ViewController.h
//  PTSMessagingCellDemo
//
//  Created by Ralph Gasser on 15.09.12.
//  Copyright (c) 2012 pontius software GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSMessagingCell.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    UITableView * tableView;
    
    NSArray * messages;
}

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic, strong) UIView *viewForm;

@property (nonatomic, strong) UITextView *chatBox;

@property (nonatomic, strong) UIButton *chatButton;

@property (nonatomic) NSArray * messages;

@end
