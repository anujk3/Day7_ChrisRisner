//
//  ViewController.m
//  Day7
//
//  Created by Anuj Katiyal on 25/09/14.
//  Copyright (c) 2014 Katiyals. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableData *receivedData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFetchData1:(id)sender {
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://chrisrisner.com/Labs/day7test.php"]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (con){
        receivedData = [NSMutableData data];
    } else {
        //something bad happened
    }
}

- (IBAction)txtFetchData2:(id)sender {
    
    NSString *curStr = [NSString stringWithFormat:@"http://chrisrisner.com/Labs/day7test.php?name=%@",[self.txtName text] ];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:curStr]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (con) {
        receivedData = [NSMutableData data];
    }else{
        return;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if (receivedData == NULL) {
        receivedData = [[NSMutableData alloc]init];
    }
    [receivedData setLength:0];
    NSLog(@"didReceiveResponse: responseData length:(%lu)", (unsigned long)receivedData.length);

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[receivedData length]);
    
    NSString *responseText = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    NSLog(@"Response: %@", responseText);
    
    NSString *newLineStr = @"\n";
    responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
    
    [self.lblData setText:responseText];
}


@end
