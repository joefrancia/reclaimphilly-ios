//
//  RPDetailViewController.h
//  reclaimPhilly
//
//  Created by Joe Francia on 2013-07-29.
//  Copyright (c) 2013 Reclaim Philly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"
#import "SSTextField.h"
#import "FlatUIKit.h"
#import "RPProperty.h"

@interface RPDetailViewController : UIViewController <UIGestureRecognizerDelegate,
                                        UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet SSTextField *addressField;
@property (weak, nonatomic) IBOutlet SSTextView *descriptionField;
@property (weak, nonatomic) IBOutlet FUIButton *sendButton;
@property (weak, nonatomic) IBOutlet FUIButton *photoButton;
@property (weak, nonatomic) IBOutlet FUIButton *cancelButton;
@property (strong, nonatomic) RPProperty *property;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *imageTap;
@property (weak, nonatomic) IBOutlet UIButton *residentialBtn;
@property (weak, nonatomic) IBOutlet UIButton *nonResidentialBtn;
@property (weak, nonatomic) IBOutlet UIButton *lotBtn;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail1;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail2;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail3;

- (IBAction)cancelReport:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)sendReport:(id)sender;
- (IBAction)toggleResidential:(UIButton *)sender;
- (IBAction)toggleNonResidential:(UIButton *)sender;
- (IBAction)toggleLot:(UIButton *)sender;

@end
