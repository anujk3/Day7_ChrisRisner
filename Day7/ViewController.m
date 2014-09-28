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
    NSString *queryString = [NSString stringWithFormat:@"http://chrisrisner.com/Labs/day7test.php"];
                             
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:queryString]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Value1", @"Key1",
                                    @"Value2", @"Key2",
                                    nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-type"];

    // should check for and handle errors here but we aren't
    [theRequest setHTTPBody:jsonData];

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
//    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
//    if (con) {
//        receivedData = [NSMutableData data];
//    }else{
//        return;
//    }
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            //do something with error
        } else {
            NSString *responseText = [[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding];
            NSLog(@"Response: %@", responseText);
            
            NSString *newLineStr = @"\n";
            responseText = [responseText stringByReplacingOccurrencesOfString:@"<br />" withString:newLineStr];
            [self.lblData setText:responseText];
        }
    }];
    
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
