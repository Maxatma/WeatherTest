#import "TTWeatherViewController.h"
#import "TTWeatherAPI.h"
#import "AppDelegate.h"
#import "Weather.h"
#import <CoreLocation/CoreLocation.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>


@interface TTWeatherViewController ()< CLLocationManagerDelegate >
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)getButtonPressed:(id)sender;

@end

@implementation TTWeatherViewController

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
- (IBAction)getButtonPressed:(id)sender
{
    CLLocationCoordinate2D coordinate = [(AppDelegate *)[[UIApplication sharedApplication] delegate] coordinate];
    TTWeatherAPI * api = [[TTWeatherAPI alloc]initWithAPIKey:@""];
    [api currentWeatherByCoordinate:coordinate withCallback:^(NSError *error, NSDictionary *result) {
        Weather * weather = [Weather MR_createEntity];
        weather.lon                 = result[@"coord"][@"lon"];
        weather.lat                 = result[@"coord"][@"lon"];
        weather.weatherDescription  = [result[@"weather"] firstObject] [@"description"];
        weather.main                = [result[@"weather"] firstObject] [@"main"];
        weather.tempMin             = result[@"main"][@"temp_min"];
        weather.tempMax             = result[@"main"][@"temp_max"];
        weather.pressure            = result[@"main"][@"pressure"];
        weather.windSpeed           = result[@"wind"][@"speed"];

        NSRange range       = [weather.description rangeOfString:@"{"];
        NSString *substring = [[weather.description substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        range               = [substring rangeOfString:@"}"];
        substring           = [substring substringToIndex:NSMaxRange(range)-1];
        
        self.textView.text = substring;
    }];
}

@end
