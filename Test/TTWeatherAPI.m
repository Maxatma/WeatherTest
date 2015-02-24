
#import "TTWeatherAPI.h"
#import "AFJSONRequestOperation.h"

@interface TTWeatherAPI ()
{
    NSString            *_baseURL;
    NSString            *_apiKey;
    NSString            *_apiVersion;
    NSOperationQueue    *_weatherQueue;
    NSString            *_lang;
}

@end

@implementation TTWeatherAPI

- (instancetype) initWithAPIKey:(NSString *) apiKey
{
    self = [super init];
    if (self)
    {
        _baseURL            = @"http://api.openweathermap.org/data/";
        _apiKey             = apiKey;
        _apiVersion         = @"2.5";
        _weatherQueue       = [[NSOperationQueue alloc] init];
        _weatherQueue.name  = @"OMWWeatherQueue";
    }
    return self;
}

- (void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                       withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
{
    NSString *method = [NSString stringWithFormat:@"/weather?lat=%f&lon=%f",
                        coordinate.latitude, coordinate.longitude ];
    [self callMethod:method withCallback:callback];
    
}

- (void) callMethod:(NSString *) method withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback
{
    
    NSOperationQueue *callerQueue = [NSOperationQueue currentQueue];
    
    // build the lang parameter
    NSString *langString = (_lang && _lang.length > 0) ? [NSString stringWithFormat:@"&lang=%@", _lang] : @"";
    
    NSString *urlString     = [NSString stringWithFormat:@"%@%@%@&APPID=%@%@", _baseURL, _apiVersion, method, _apiKey, langString];
    NSURL *url              = [NSURL URLWithString:urlString];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *res = JSON;
        [callerQueue addOperationWithBlock:^{
            callback(nil, res);
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        // callback on the caller queue
        [callerQueue addOperationWithBlock:^{
            callback(error, nil);
        }];
        
    }];
    
    [_weatherQueue addOperation:operation];
}

@end