//
//  EditViewController.h
//  ContactViewerIos
//
//  Created by Mark Kruse on 3/26/13.
//  Copyright (c) 2013 Tiny Mission. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "contact.h"

@interface EditViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Contact *detailItem;

@property (strong, nonatomic) IBOutlet UITextField *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailName;
@property (weak, nonatomic) IBOutlet UITextField *detailTitle;
@property (weak, nonatomic) IBOutlet UITextField *detailPhone;
@property (weak, nonatomic) IBOutlet UITextField *detailEmail;
@property (weak, nonatomic) IBOutlet UITextField *detailTwitterId;

@end
