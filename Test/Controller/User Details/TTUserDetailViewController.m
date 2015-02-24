#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "TTUserDetailViewController.h"
#import "RMPickerViewController.h"
#import "User.h"

@interface TTUserDetailViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, RMPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView    *imageView;
@property (weak, nonatomic) IBOutlet UIButton       *ageButton;
@property (weak, nonatomic) IBOutlet UILabel        *enabledLabel;
@property (weak, nonatomic) IBOutlet UISwitch       *enabledSwitch;
@property (weak, nonatomic) IBOutlet UITextField    *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField    *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextView     *userDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel        *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton       *saveButton;
@property (weak, nonatomic) IBOutlet UIButton       *backButton;

@property (strong, nonatomic)RMPickerViewController     *agePickerVC;
@property (strong, nonatomic)UIImagePickerController    *imagePickerController;

- (IBAction)saveButtonPressed:  (id)sender;
- (IBAction)ageButtonPressed:   (id)sender;
- (void)saveUser;

@end

@implementation TTUserDetailViewController

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePresssed)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapBackground:)];
    backgroundTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:backgroundTap];
    
    if (self.editingMode)
        self.currentUser = [User MR_createEntity];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    self.firstNameTextField.text        = _currentUser.firstName;
    self.lastNameTextField.text         = _currentUser.lastName;
    self.userDescriptionTextView.text   = _currentUser.userDescription;
    [self.enabledSwitch setOn: _currentUser.userEnabled.boolValue animated:NO];
    [self.ageButton setTitle: _currentUser.age.stringValue forState:UIControlStateNormal];
    
    self.userDescriptionTextView.editable           = _editingMode;
    self.firstNameTextField.userInteractionEnabled  = _editingMode;
    self.lastNameTextField.userInteractionEnabled   = _editingMode;
    self.ageButton.userInteractionEnabled           = _editingMode;
    self.saveButton.hidden                          = !_editingMode;
    self.enabledSwitch.userInteractionEnabled       = _editingMode;
    self.imageView.userInteractionEnabled           = _editingMode;
    if (!_editingMode)
    {
        UIImage *image          = [UIImage imageWithContentsOfFile:_currentUser.photo];
        self.imageView.image    = image;
    }
    
    self.userNameLabel.text = _editingMode ? @"Add User" : _currentUser.firstName;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
    if (!self.firstNameTextField.text || !(self.firstNameTextField.text.length > 0))
        [self.currentUser MR_deleteEntity];
}

#pragma mark Actions
- (IBAction)saveButtonPressed:(id)sender
{
    if (self.firstNameTextField.text && self.firstNameTextField.text.length > 0)
    {
        [self saveUser];
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Enter firstname at least"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)ageButtonPressed:(id)sender
{
    self.agePickerVC            = [RMPickerViewController pickerController];
    self.agePickerVC.delegate   = self;
    [self.agePickerVC show];
}

- (void)imagePresssed
{
    [self saveUser];
    self.imagePickerController          = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark -
- (void)saveUser
{
    self.currentUser.firstName          = _firstNameTextField.text;
    self.currentUser.lastName           = _lastNameTextField.text;
    self.currentUser.userDescription    = _userDescriptionTextView.text;
    self.currentUser.userEnabled        = @(_enabledSwitch.isOn);
    self.currentUser.age                = @(_ageButton.titleLabel.text.intValue);
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - UIPickerView
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 60-17;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d",18+row];
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray  *)selectedRows
{
    [self.ageButton setTitle: [NSString stringWithFormat:@"%d",[selectedRows.firstObject integerValue] + 18]
                    forState:UIControlStateNormal];
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image            = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData               = UIImagePNGRepresentation(self.imageView.image);
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    NSString *localFilePath         = [documentsDirectory stringByAppendingPathComponent:
                                       [NSString stringWithFormat:@"%@_%@.png",
                                        [NSDate date], _currentUser.firstName]];
    [imageData writeToFile:localFilePath atomically:YES];
    self.currentUser.photo  = localFilePath;
    UIImage *image          = [UIImage imageWithContentsOfFile:_currentUser.photo];
    self.imageView.image    = image;
}

#pragma mark - Keyboard
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary* info      = [notification userInfo];
    CGSize keyboardSize     = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin    = self.userDescriptionTextView.frame.origin;
    CGFloat buttonHeight    = self.userDescriptionTextView.frame.size.height;
    CGRect visibleRect      = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)didTapBackground: (UITapGestureRecognizer*) recognizer
{
    [self.view endEditing:NO];
}

@end
