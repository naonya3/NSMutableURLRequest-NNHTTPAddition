over iOS4.3

##LICENSE
MIT

##How to create HTTPRequest

###GET,POST,PUT,DELET
```
NSURL *url = [NSURL URLWithString:@"http://example.com/"];
    // Parametors
    NSDictionary *params = @{@"key":@"value"};
    
    // HTTP Headers
    NSDictionary *headers = @{@"User-Agent":@"NSMutableURLRequest+NNHTTPAddition Demo App"};
    
    // Create HTTPRequest
    NSMutableURLRequest *request = [NSMutableURLRequest httpRequestWithURL:url
                                                                parameters:params
                                                                   headers:headers                 
                                                                httpMethod:NNHTTPMethodGET // NNHTTPMethodGET,NNHTTPMethodPOST,NNHTTPMethodPUT,NNHTTPMethodDELETE,
                                                               contentType:NNPostContentTypeNone];// POST, NNPostContentTypeForm
```

###POST(Multipart)
```
NSURL *url = [NSURL URLWithString:@"http://example.com/"];
    
    NNMultiPartFileData *filedata = [[NNMultiPartFileData alloc] init];
    filedata.fileName = @"apple.png";
    filedata.mimeType = @"image/png";
    filedata.data = UIImagePNGRepresentation([UIImage imageNamed:@"apple.jpg"]);
    
    NSDictionary *params = @{
                             @"key":@"value",
                             @"image":filedata
                             };
    
    NSDictionary *headers = @{@"User-Agent":@"NSMutableURLRequest+NNHTTPAddition Demo App"};
    
    // Create HTTPRequest
    NSMutableURLRequest *request = [NSMutableURLRequest httpRequestWithURL:url
                                                                parameters:params
                                                                   headers:headers                 
                                                                httpMethod:NNHTTPMethodGET // NNHTTPMethodGET,NNHTTPMethodPOST,NNHTTPMethodPUT,NNHTTPMethodDELETE,
                                                               contentType:NNPostContentTypeMultiPart];// use NNPostContentTypeMultiPart
```

##Send Request(Sample)
###Over iOS5
Using NSURLConnect is easy.

####sample
```
[NSURLConnection sendAsynchronousRequest:createdRequest queue:queue completionHandler:completionBlock];
```

###Under iOS4.3
Using [ISHTTPOperation][1] is easy.

- [ISHTTPOperation][1]

####sample
```
[ISHTTPOperation sendRequest:createdRequest handler:completionBlock];
```




  [1]: https://github.com/ishkawa/ISHTTPOperation