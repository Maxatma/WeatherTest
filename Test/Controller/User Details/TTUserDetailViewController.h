
#import <UIKit/UIKit.h>
@class User;

@interface TTUserDetailViewController : UIViewController
@property (strong, nonatomic) User *currentUser;
@property (assign, nonatomic) BOOL editingMode;

@end
