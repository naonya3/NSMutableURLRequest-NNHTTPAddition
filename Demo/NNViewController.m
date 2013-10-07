//
//  NNViewController.m
//  NNHTTPAddition
//
//  Created by Naoto Horiguchi on 2013/10/07.
//  Copyright (c) 2013年 Naoto Horiguchi. All rights reserved.
//

#import "NNViewController.h"

#import "NSMutableURLRequest+NNHTTPAddition.h"
#import <ISHTTPOperation/ISHTTPOperation.h>

@interface NNViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation NNViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)_getTouched:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://hrc.ideeile.com/"];
    NSDictionary *params = @{@"hoge":@"piyo"};
    NSDictionary *headers = @{@"User-Agent":@"NSMutableURLRequest+NNHTTPAddition Demo App"};
    
    // NNHTTPAddition create HTTP Request
    NSMutableURLRequest *request = [NSMutableURLRequest httpRequestWithURL:url parameters:params headers:headers httpMethod:NNHTTPMethodGET contentType:NNPostContentTypeNone];
    
    [ISHTTPOperation sendRequest:request handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
        [_webView loadHTMLString:[[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding] baseURL:url];
    }];
}

- (IBAction)_multiTouched:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://hrc.ideeile.com/"];
    
    NNMultiPartFileData *filedata = [[NNMultiPartFileData alloc] init];
    filedata.fileName = @"apple.png";
    filedata.mimeType = @"image/png";
    filedata.data = UIImagePNGRepresentation([UIImage imageNamed:@"apple.jpg"]);
    
    NSDictionary *params = @{
                             @"hoge":@"piyo",
                             @"image":filedata
                             };
    
    NSDictionary *headers = @{@"User-Agent":@"NSMutableURLRequest+NNHTTPAddition Demo App"};
    
    // NNHTTPAddition create HTTP Request
    NSMutableURLRequest *request = [NSMutableURLRequest httpRequestWithURL:url parameters:params headers:headers httpMethod:NNHTTPMethodPOST contentType:NNPostContentTypeMultiPart];
    
    [ISHTTPOperation sendRequest:request handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
        [_webView loadHTMLString:[[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding] baseURL:url];
    }];
}

- (IBAction)_postTouched:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://hrc.ideeile.com/"];
    NSDictionary *params = @{@"hoge":@"piyo"};
    NSDictionary *headers = @{@"User-Agent":@"NSMutableURLRequest+NNHTTPAddition Demo App"};
    
    // NNHTTPAddition create HTTP Request
    NSMutableURLRequest *request = [NSMutableURLRequest httpRequestWithURL:url parameters:params headers:headers httpMethod:NNHTTPMethodPOST contentType:NNPostContentTypeForm];
    
    [ISHTTPOperation sendRequest:request handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
        [_webView loadHTMLString:[[NSString alloc] initWithData:object encoding:NSUTF8StringEncoding] baseURL:url];
    }];
}

@end
