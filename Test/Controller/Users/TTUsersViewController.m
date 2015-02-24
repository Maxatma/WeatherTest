#import "TTUsersViewController.h"
#import "TTUserDetailViewController.h"
#import "UserTableViewCell.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#include "User.h"

@interface TTUsersViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (strong, nonatomic) NSArray *usersArray;
@property (strong, nonatomic) TTUserDetailViewController *userDetailVC;

@end

@implementation TTUsersViewController

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _usersTableView.delegate   = self;
    _usersTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.usersArray = [NSArray arrayWithArray:[User MR_findAll]];
    [self.usersTableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _usersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) cell            = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    User * currentUser        = _usersArray[indexPath.row];
    cell.firstNameLabel.text  = currentUser.firstName;
    cell.lastNameLabel.text   = currentUser.lastName;
    cell.lockimageView.hidden = currentUser.userEnabled.boolValue;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.userDetailVC.currentUser     = (User*)_usersArray[indexPath.row] ;
}

#pragma mark - Segue
- (IBAction)unwindToUsersVC:(UIStoryboardSegue *)unwindSegue
{
}

-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.userDetailVC  = [segue destinationViewController];
    
    if ([segue.identifier  isEqualToString:@"newUserSegue"])
        self.userDetailVC.editingMode = YES;
    
    if ([segue.identifier isEqualToString:@"selectedUserSegue"])
        self.userDetailVC.editingMode = NO;
}

@end
