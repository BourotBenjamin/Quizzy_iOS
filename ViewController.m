//
//  ViewController.m
//  QuestionForADumb
//
//  Created by Philoupe on 14/01/2015.
//  Copyright (c) 2015 Philoupe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableString *jsonQuestions;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jsonQuestions = [[NSMutableString alloc] initWithUTF8String:""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.parse.com/1/functions/Quizzy"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"UVTVIdLgjILqOhCY2yiq0p2eKj8W7ZyNJcKulXTq" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:@"a0egq79FWFd2orj7lcj4gkTfQvxcpoLUhY6kNREY" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request setValue:@" application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    self.jsonQuestions = [[NSMutableString alloc] initWithUTF8String:""];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Succeeded! Received %lu bytes of data to append",(unsigned long)[data length]);
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(newStr);
    [self.jsonQuestions appendString:newStr];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.jsonQuestions length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSLog(@"BeforeJSON");
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:[self.jsonQuestions dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&myError];

    NSLog(@"AfterJSON");
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
