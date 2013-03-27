//
//  DetailViewController.h
//  ContactViewerIos
//
//  Created by ANDY SELVIG on 3/7/12.
//  Copyright (c) 2012 Tiny Mission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contact.h"
#import "EditViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Contact *detailItem;
@property (strong, nonatomic) ContactList *contacts;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailName;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@property (weak, nonatomic) IBOutlet UILabel *detailPhone;
@property (weak, nonatomic) IBOutlet UILabel *detailEmail;
@property (weak, nonatomic) IBOutlet UILabel *detailTwitterId;

@property (strong, nonatomic) EditViewController *editViewController;
@end
