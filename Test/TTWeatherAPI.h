
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TTWeatherAPI : NSObject
- (instancetype) initWithAPIKey:(NSString *) apiKey;
- (void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                       withCallback:( void (^)( NSError* error, NSDictionary *result ) )callback;
@end
