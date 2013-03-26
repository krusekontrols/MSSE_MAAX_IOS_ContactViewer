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

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailName;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;

@property (weak, nonatomic) IBOutlet UILabel *detailPhone;
@property (weak, nonatomic) IBOutlet UILabel *detailEmail;
@property (weak, nonatomic) IBOutlet UILabel *detailTwitterId;

@end
