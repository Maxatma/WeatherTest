#import "AppDelegate.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () < CLLocationManagerDelegate >
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    self.locationManager                    = [CLLocationManager new];
    self.locationManager.delegate           = self;
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?
    UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskAll;
}

#pragma mark - Location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation    = locations.firstObject;
    _coordinate             = [self.currentLocation coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                message:error.localizedRecoverySuggestion
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
