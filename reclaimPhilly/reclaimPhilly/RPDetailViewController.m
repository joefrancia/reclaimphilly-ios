//
//  RPDetailViewController.m
//  reclaimPhilly
//
//  Created by Joe Francia on 2013-07-29.
//  Copyright (c) 2013 Reclaim Philly. All rights reserved.
//

#import "RPDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RPProperty.h"
#import "MF_Base64Additions.h"
//#import "UIImage+Resize.h"  
#import "BlocksKit.h"
#import "FlatUIKit.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "UIImage+ReclaimPhilly.h"

@interface RPDetailViewController ()

@end

@implementation RPDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


-(void)setupButtons {
    self.cancelButton.buttonColor = [UIColor lightBrown];
    self.cancelButton.shadowColor = [UIColor darkBrown];
    [self.cancelButton setOnTouchDownBlock:^(NSSet* set, UIEvent* event) {
        self.cancelButton.buttonColor = [UIColor darkBrown];
    }];
    [self.cancelButton setOnTouchUpBlock:^(NSSet* set, UIEvent* event) {
        self.cancelButton.buttonColor = [UIColor lightBrown];
    }];
    self.cancelButton.shadowHeight = 0.5f;
    self.cancelButton.cornerRadius = 3.0f;
    self.cancelButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor darkBrown] forState:UIControlStateHighlighted];

    self.sendButton.buttonColor = [UIColor lightBrown];
    self.sendButton.shadowColor = [UIColor darkBrown];
    self.sendButton.shadowHeight = 0.5f;
    self.sendButton.cornerRadius = 3.0f;
    self.sendButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor darkBrown] forState:UIControlStateHighlighted];

    self.photoButton.buttonColor = [UIColor lightBrown];
    self.photoButton.shadowColor = [UIColor darkBrown];
    self.photoButton.shadowHeight = 0.5f;
    self.photoButton.cornerRadius = 3.0f;
    self.photoButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.photoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.photoButton setTitleColor:[UIColor darkBrown] forState:UIControlStateHighlighted];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupButtons];

    self.property.lotType = nil;
    self.property.description = nil;
    self.property.picture1 = nil;
    self.property.picture2 = nil;
    self.property.picture3 = nil;

    self.descriptionField.placeholder = @"Enter any additional notes about this property";
    self.descriptionField.placeholderTextColor = [UIColor lightBrown];
    self.addressField.placeholderTextColor = [UIColor lightBrown];
    self.addressField.delegate = self;

    self.descriptionField.layer.borderWidth = 1.0f;
    self.descriptionField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionField.delegate = self;

    self.imageTap.numberOfTapsRequired = 1;
    self.imageTap.numberOfTouchesRequired = 1;

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    toolbar.barStyle = UIBarStyleBlack;
    [barButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], UITextAttributeFont,nil] forState:UIControlStateNormal];
        toolbar.items = @[barButton];

    self.descriptionField.inputAccessoryView = toolbar;
    self.addressField.inputAccessoryView = toolbar;
}

- (void)viewDidUnload {
    [self setAddressField:nil];
    [self setDescriptionField:nil];
    [self setSendButton:nil];
    [self setPhotoButton:nil];
    [self setCancelButton:nil];
    [self setImageTap:nil];
    [self setResidentialBtn:nil];
    [self setNonResidentialBtn:nil];
    [self setLotBtn:nil];
    [self setThumbnail1:nil];
    [self setThumbnail2:nil];
    [self setThumbnail3:nil];
    [super viewDidUnload];
}

- (void)dismissKeyboard {
    [self.descriptionField resignFirstResponder];
    [self.addressField resignFirstResponder];
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.property.address1 = textField.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.property.description = textView.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelReport:(id)sender {
    self.property.lotType = nil;
    self.property.description = nil;
    self.property.picture1 = nil;
    self.property.picture2 = nil;
    self.property.picture3 = nil;
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (IBAction)sendReport:(id)sender {
    if (self.property.lotType) {
        [self.property report];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [UIAlertView alertViewWithTitle:@"Missing Vacancy Type"
                                                         message:@"Please choose a vacancy type"];
            [alert addButtonWithTitle:@"OK"];
//            [alert setDidDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.residentialBtn.selected = YES;
//                });
//
//                double delayInSeconds = 0.5;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    self.residentialBtn.selected = NO;
//                    self.nonResidentialBtn.selected = YES;
//                });
//
//                delayInSeconds = 1.0;
//                popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    self.nonResidentialBtn.selected = NO;
//                    self.lotBtn.selected = YES;
//                });
//
//                delayInSeconds = 1.5;
//                popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    self.lotBtn.selected = NO;
//                });
//            }];
            [alert show];
        });
    }

}

- (IBAction)toggleResidential:(UIButton *)sender {
    self.nonResidentialBtn.selected = NO;
    self.lotBtn.selected = NO;
    sender.selected = YES;
    self.property.lotType = RES;
}

- (IBAction)toggleNonResidential:(UIButton *)sender {
    self.residentialBtn.selected = NO;
    self.lotBtn.selected = NO;
    sender.selected = YES;
    self.property.lotType = NRS;
}

- (IBAction)toggleLot:(UIButton *)sender {
    self.nonResidentialBtn.selected = NO;
    self.residentialBtn.selected = NO;
    sender.selected = YES;
    self.property.lotType = LOT;
}


#pragma mark -
#pragma mark Photo stuff

- (IBAction)addPhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
        [self presentModalViewController:imgPicker animated:YES];
    }
}

-(void)showPhoto:(NSUInteger)index {

//    [self presentViewController:photoNav animated:NO completion:^{
//        [photoNav pushViewController:photoBrowser animated:YES];
//        if (firstTime) {
//            firstTime = NO;
//            [photoBrowser setControlsHidden:YES animated:NO permanent:NO];
//            [TSMessage showNotificationInViewController:photoBrowser
//                                              withTitle:@"Photo Browser"
//                                            withMessage:@"Tap once to show the controls.  Use the arrows or swipe left and right to navigate through the photos.  Click Done to return to the call screen."
//                                               withType:TSMessageNotificationTypeSuccess
//                                           withDuration:10.0
//                                           withCallback:^{
//                                               [photoBrowser setControlsHidden:NO animated:YES permanent:YES];
//                                           }];
//        } else {
//            [photoBrowser setControlsHidden:NO animated:YES permanent:YES];
//        }
//    }];
}


-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *picture;

    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];

        if (editedImage) {
            picture = editedImage;
        } else {
            picture = originalImage;
        }

        NSNumber *thumbPosition = [self.property addPicture:[UIImage imageWithImage:picture scaledToSize:CGSizeMake(900, 900)]];
        CGSize thumbnailSize;
        switch (picture.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                thumbnailSize = CGSizeMake(self.thumbnail1.bounds.size.height,
                                           self.thumbnail1.bounds.size.width);
                break;
            default:
                thumbnailSize = CGSizeMake(self.thumbnail1.bounds.size.width,
                                           self.thumbnail1.bounds.size.height);
                break;
        }

        UIImage *thumbnail = [UIImage imageWithImage:picture scaledToSize:thumbnailSize];
        switch ([thumbPosition intValue]) {
            case 1:
                self.thumbnail1.image = thumbnail;
                break;
            case 2:
                self.thumbnail2.image = thumbnail;
                break;
            case 3:
                self.thumbnail3.image = thumbnail;
                break;
            default:
                break;
        }

        [self dismissModalViewControllerAnimated:YES];
    }
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end
