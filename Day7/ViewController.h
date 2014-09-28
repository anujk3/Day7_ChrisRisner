//
//  ViewController.h
//  Day7
//
//  Created by Anuj Katiyal on 25/09/14.
//  Copyright (c) 2014 Katiyals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
- (IBAction)btnFetchData1:(id)sender;
- (IBAction)txtFetchData2:(id)sender;

@end

