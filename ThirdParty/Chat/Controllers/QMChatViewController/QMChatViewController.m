//
//  QMChatViewController.m
//  QMChatViewController
//
//  Created by Andrey Ivanov on 06.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import "QMChatViewController.h"
#import "QMChatCollectionView.h"
#import "QMKeyboardController.h"
#import "QMToolbarContentView.h"
#import "QMChatCollectionViewFlowLayout.h"
#import "QMChatSection.h"
#import "QMChatSectionManager.h"
#import "QMDateUtils.h"
#import "QMGroupDetailsController.h"
#import "QMCollectionViewFlowLayoutInvalidationContext.h"
#import "NSString+QM.h"
#import "UIColor+QM.h"
#import "UIImage+QM.h"
#import "QMHeaderCollectionReusableView.h"
#import "TTTAttributedLabel.h"
#import "QMCreateNewChatController.h"
//#import "SyncViewController.h"
//#import "DEMORootViewController.h"
#import "QMApi.h"
#define StaticHeight    41


static NSString *const kQMSectionsInsertKey = @"kQMSectionsInsertKey";
static NSString *const kQMItemsInsertKey    = @"kQMItemsInsertKey";

static void * kChatKeyValueObservingContext = &kChatKeyValueObservingContext;

@interface QMChatViewController () <QMInputToolbarDelegate, QMKeyboardControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate, QMChatSectionManagerDelegate>

@property (weak, nonatomic) IBOutlet QMChatCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet QMInputToolbar *inputToolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomLayoutGuide;


//top view

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblName1;
@property (weak, nonatomic) IBOutlet UILabel *lblName2;
@property (weak, nonatomic) IBOutlet UILabel *lblMile;


//@property (weak, nonatomic) IBOutlet UILabel *lblTOList;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnHomeClick:(id)sender;

//

@property (nonatomic, readonly) UIImagePickerController* pickerController;
@property (weak, nonatomic) UIView *snapshotView;
@property (strong, nonatomic) QMKeyboardController *keyboardController;
@property (strong, nonatomic) NSIndexPath *selectedIndexPathForMenu;
@property (assign, nonatomic) BOOL isObserving;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation QMChatViewController
{
    //SyncViewController *syncObj;
    CGRect rectFrame;
    NSString *copystring;
    QBChatMessage* messageDelte;
     NSInteger sameSection,nextRow;
    
}

@synthesize pickerController = _pickerController,dicCustomerData;

+ (UINib *)nib {
    
    return [UINib nibWithNibName:NSStringFromClass([QMChatViewController class]) bundle:[NSBundle bundleForClass:[QMChatViewController class]]];
}

+ (instancetype)messagesViewController {
    
    return [[[self class] alloc] initWithNibName:NSStringFromClass([QMChatViewController class]) bundle:[NSBundle bundleForClass:[QMChatViewController class]]];
}

- (void)dealloc {
    
    [self registerForNotifications:NO];
    [self removeObservers];
    
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    self.collectionView = nil;
    
    self.inputToolbar.contentView.textView.delegate = nil;
    self.inputToolbar.delegate = nil;
    self.inputToolbar = nil;
    
    self.toolbarHeightConstraint = nil;
    self.toolbarBottomLayoutGuide = nil;
    
    self.senderDisplayName = nil;
    
    [self.keyboardController endListeningForKeyboard];
    self.keyboardController = nil;
}

- (void)ConfigureTopUserView {
    
    self.navigationController.navigationBar.hidden=YES;
    _viewheader.backgroundColor=AppColor;
    
  //  _lblheader.text = [NSString stringWithFormat:@"%@(%@)" ,self.dialog.name ,[[self.dialog valueForKey:@"data"] valueForKey:@"category"]];
    
    
}
#pragma mark - Initialization

- (void)configureMessagesViewController {
    
    self.isObserving = NO;
     //syncObj=[[SyncViewController alloc]init];
    self.toolbarHeightConstraint.constant = self.inputToolbar.preferredDefaultHeight;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    


    
    
    
    self.chatSectionManager = [[QMChatSectionManager alloc] init];
    self.chatSectionManager.delegate = self;
    
    self.inputToolbar.delegate = self;
    self.inputToolbar.contentView.textView.delegate = self;
    self.automaticallyScrollsToMostRecentMessage = YES;
    self.topContentAdditionalInset = 0.0f;
    [self updateCollectionViewInsets];
    
    self.keyboardController =
    [[QMKeyboardController alloc] initWithTextView:self.inputToolbar.contentView.textView
                                       contextView:self.view
                              panGestureRecognizer:self.collectionView.panGestureRecognizer
                                          delegate:self];
    
    [self registerCells];
}

- (void)registerCells {
    /**
     *  Register header view
     */
    UINib *headerNib = [QMHeaderCollectionReusableView nib];
    NSString *headerView = [QMHeaderCollectionReusableView cellReuseIdentifier];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerView];
    /**
     *  Register contact request cell
     */
    UINib *requestNib = [QMChatContactRequestCell nib];
    NSString *requestIdentifier = [QMChatContactRequestCell cellReuseIdentifier];
    [self.collectionView registerNib:requestNib forCellWithReuseIdentifier:requestIdentifier];
    /**
     *  Register Notification  cell
     */
    UINib *notificationNib = [QMChatNotificationCell nib];
    NSString *notificationIdentifier = [QMChatNotificationCell cellReuseIdentifier];
    [self.collectionView  registerNib:notificationNib forCellWithReuseIdentifier:notificationIdentifier];
    /**
     *  Register outgoing cell
     */
    UINib *outgoingNib = [QMChatOutgoingCell nib];
    NSString *ougoingIdentifier = [QMChatOutgoingCell cellReuseIdentifier];
    [self.collectionView  registerNib:outgoingNib forCellWithReuseIdentifier:ougoingIdentifier];
    /**
     *  Register incoming cell
     */
    UINib *incomingNib = [QMChatIncomingCell nib];
    NSString *incomingIdentifier = [QMChatIncomingCell cellReuseIdentifier];
    [self.collectionView  registerNib:incomingNib forCellWithReuseIdentifier:incomingIdentifier];
    /**
     *  Register attachment incoming cell
     */
    UINib *attachmentIncomingNib  = [QMChatAttachmentIncomingCell nib];
    NSString *attachmentIncomingIdentifier = [QMChatAttachmentIncomingCell cellReuseIdentifier];
    [self.collectionView registerNib:attachmentIncomingNib forCellWithReuseIdentifier:attachmentIncomingIdentifier];
    /**
     *  Register outgoing incoming cell
     */
    UINib *attachmentOutgoingNib  = [QMChatAttachmentOutgoingCell nib];
    NSString *attachmentOutgoingIdentifier = [QMChatAttachmentOutgoingCell cellReuseIdentifier];
    [self.collectionView registerNib:attachmentOutgoingNib forCellWithReuseIdentifier:attachmentOutgoingIdentifier];
}

#pragma mark - Getters

- (IBAction)btnBackClick:(id)sender {
    
    
   // NSLog(@"%@",[[self.navigationController viewControllers] objectAtIndex:2]);
    /*
    if ([[self.navigationController.viewControllers objectAtIndex:0]isKindOfClass:[ViewController class]]) {
        
     
        if ([[self.navigationController viewControllers] count]==3) {
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
        }
        else{
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
        }
        
    }
    else{
        
         UIStoryboard *objStoryboard ;
        if (IS_IPAD) {
            objStoryboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        }
        else {
            objStoryboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        }
        
        
        DEMORootViewController *ivc = [objStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
        
        
        
        
        [self.navigationController pushViewController:ivc animated:YES];
    }
    */
//    
//    DELE.navigationController=[[UINavigationController alloc] initWithRootViewController:ivc];
//    DELE.window.rootViewController = DELE.navigationController;
    
  //  [self.navigationController pushViewController:ivc animated:YES];
  
    self.navigationController.navigationBar.hidden=NO;
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHomeClick:(id)sender
{
    /*
    if ([[self.navigationController.viewControllers objectAtIndex:0]isKindOfClass:[ViewController class]]) {
        id obj=[self.navigationController.viewControllers objectAtIndex:0];
        
        
        [self.navigationController popToViewController:obj animated:YES];
    }
    else{
        UIStoryboard *objStoryboard ;
        
        
        if (IS_IPAD) {
            objStoryboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        }
        else {
            objStoryboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        }
        
      
        
        
        DEMORootViewController *ivc = [objStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
        
        
        
        
        [self.navigationController pushViewController:ivc animated:YES];
    }
    
*/
    
   
}

- (IBAction)btnAddClick:(id)sender {
    
    
    
    UIStoryboard *objStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    
    QMCreateNewChatController *objnewchat= [objStoryboard instantiateViewControllerWithIdentifier:@"QMCreateNewChatController"];
    [self.navigationController presentViewController:objnewchat animated:YES completion:nil];
    
    
    
    
}

- (UIImagePickerController *)pickerController
{
    if (_pickerController == nil) {
        _pickerController = [UIImagePickerController new];
        _pickerController.delegate = self;
    }
    return _pickerController;
}

#pragma mark - Setters

- (void)setTopContentAdditionalInset:(CGFloat)topContentAdditionalInset {
    
    _topContentAdditionalInset = topContentAdditionalInset;
    [self updateCollectionViewInsets];
}

#pragma mark - QMChatSectionManagerDelegate

- (void)chatSectionManager:(QMChatSectionManager *)chatSectionManager didInsertSections:(NSIndexSet *)sectionsIndexSet andItems:(NSArray *)itemsIndexPaths animated:(BOOL)animated {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_block_t performUpdate = ^{
        
        __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionView performBatchUpdates:^{
            
            if ([sectionsIndexSet count] > 0) [strongSelf.collectionView insertSections:sectionsIndexSet];
            [strongSelf.collectionView insertItemsAtIndexPaths:itemsIndexPaths];
            
        } completion:nil];
    };
    
    if (animated) {
        
        performUpdate();
    }
    else {
        
        [UIView performWithoutAnimation:^{
            
            performUpdate();
        }];
    }
}

- (void)chatSectionManager:(QMChatSectionManager *)chatSectionManager didUpdateMessagesWithIDs:(NSArray *)messagesIDs atIndexPaths:(NSArray *)itemsIndexPaths {
    
    for (NSString *messageID in messagesIDs) {
        
        [self.collectionView.collectionViewLayout removeSizeFromCacheForItemID:messageID];
    }
    
    [self.collectionView reloadItemsAtIndexPaths:itemsIndexPaths];
}

- (void)chatSectionManager:(QMChatSectionManager *)chatSectionManager didDeleteMessagesWithIDs:(NSArray *)messagesIDs atIndexPaths:(NSArray *)itemsIndexPaths withSectionsIndexSet:(NSIndexSet *)sectionsIndexSet animated:(BOOL)animated {
    
    for (NSString *messageID in messagesIDs) {
        
        [self.collectionView.collectionViewLayout removeSizeFromCacheForItemID:messageID];
    }
    
    __weak __typeof(self)weakSelf = self;
    dispatch_block_t performUpdate = ^{
        
        __typeof(weakSelf)strongSelf = weakSelf;
        if (sectionsIndexSet.count > 0) {
            
            [strongSelf.collectionView deleteSections:sectionsIndexSet];
        }
        if (itemsIndexPaths.count > 0) {
            
            [strongSelf.collectionView deleteItemsAtIndexPaths:itemsIndexPaths];
        }
    };
    
    if (animated) {
        
        performUpdate();
    }
    else {
        
        [UIView performWithoutAnimation:^{
            
            performUpdate();
        }];
    }
}

- (void)insertMessagesToTheTopAnimated:(NSArray *)messages {
    NSParameterAssert(messages);
    
    [self.chatSectionManager addMessages:messages];
}

- (NSDictionary *)updateDataSourceWithMessages:(NSArray *)messages {
    
    [self.chatSectionManager addMessages:messages];
    return @{};
}

- (void)insertMessageToTheBottomAnimated:(QBChatMessage *)message {
    NSParameterAssert(message);
    
    [self.chatSectionManager addMessages:@[message]];
}

- (void)insertMessagesToTheBottomAnimated:(NSArray *)messages {
    NSAssert([messages count] > 0, @"Array must contain messages!");
    
    [self.chatSectionManager addMessages:messages];
}

- (void)updateMessage:(QBChatMessage *)message {
    
    [self.chatSectionManager updateMessages:@[message]];
}

- (void)updateMessages:(NSArray *)messages {
    
    [self.chatSectionManager updateMessages:messages];
}

- (void)deleteMessage:(QBChatMessage *)message {
    
    [self.chatSectionManager deleteMessages:@[message]];
}

- (void)deleteMessages:(NSArray *)messages {
    
    [self.chatSectionManager deleteMessages:messages];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[[self class] nib] instantiateWithOwner:self options:nil];
    
    //setting top view labels
    [self ConfigureTopUserView];
    
    [self configureMessagesViewController];
    [self registerForNotifications:YES];
    
    //Customize your toolbar buttons
   // self.inputToolbar.contentView.leftBarButtonItem = [self accessoryButtonItem];
    self.inputToolbar.contentView.rightBarButtonItem = [self sendButtonItem];
    /*if ([[syncObj getSendbuttonDisable:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]]isEqualToString:@"N"]) {
        self.inputToolbar.userInteractionEnabled=NO;
        
        
        
        
    }*/
    self.collectionView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    
    

   }

- (void)viewWillAppear:(BOOL)animated {
    
    NSParameterAssert(self.senderID != 0);
    NSParameterAssert(self.senderDisplayName != nil);
    
    [super viewWillAppear:animated];
    
    [self updateKeyboardTriggerPoint];
    UIGraphicsBeginImageContext(self.collectionView.frame.size);
    [[UIImage imageNamed:@"chatBG.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:image];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addObservers];
    [self addActionToInteractivePopGestureRecognizer:YES];
    [self.keyboardController beginListeningForKeyboard];
    
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        [self.snapshotView removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self addActionToInteractivePopGestureRecognizer:NO];
    
	[self removeObservers];
	[self.keyboardController endListeningForKeyboard];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING: %s", __PRETTY_FUNCTION__);
}

#pragma mark - Tool bar

- (UIButton *)accessoryButtonItem {
    
    UIImage *accessoryImage = [UIImage imageNamed:@"Chat_camera"];
    UIImage *normalImage = [accessoryImage imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [accessoryImage imageMaskedWithColor:[UIColor darkGrayColor]];
    
    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, accessoryImage.size.width, 32.0f)];
    [accessoryButton setImage:normalImage forState:UIControlStateNormal];
    [accessoryButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    accessoryButton.backgroundColor = [UIColor clearColor];
    accessoryButton.tintColor = [UIColor lightGrayColor];
    
    return accessoryButton;
}

- (UIButton *)sendButtonItem {
    
    NSString *sendTitle = NSLocalizedString(@"Send", nil);
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:sendTitle forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendButton setTitleColor:[ [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0] colorByDarkeningColorWithValue:0.1f] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    sendButton.titleLabel.minimumScaleFactor = 0.85f;
    sendButton.contentMode = UIViewContentModeCenter;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.tintColor = [UIColor blueColor];
    
    CGFloat maxHeight = 32.0f;
    
    CGRect sendTitleRect = [sendTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{ NSFontAttributeName : sendButton.titleLabel.font }
                                                   context:nil];
    
    sendButton.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(CGRectIntegral(sendTitleRect)), maxHeight);
    
    return sendButton;
}


#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[QMCollectionViewFlowLayoutInvalidationContext context]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - Messages view controller

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSUInteger)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date {
    
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil otherButtonTitles:@"Camera", nil];
    [actionSheet showInView:self.view];
}

- (void)didPickAttachmentImage:(UIImage *)image {
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

- (void)finishSendingMessage {
    
    [self finishSendingMessageAnimated:YES];
}

- (void)finishSendingMessageAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    textView.text = nil;
    [textView.undoManager removeAllActions];
    
    [self.inputToolbar toggleSendButtonEnabled];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:animated];
    }
}

- (void)finishReceivingMessage {
    
    [self finishReceivingMessageAnimated:YES];
}

- (void)finishReceivingMessageAnimated:(BOOL)animated {
    
    if (self.automaticallyScrollsToMostRecentMessage && ![self isMenuVisible]) {
        [self scrollToBottomAnimated:animated];
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (self.chatSectionManager.totalMessagesCount > 0) {
        NSIndexPath* topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:topIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // disabling scrolll to bottom when tapping status bar
    return NO;
}

#pragma mark - Collection view data source

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.0f, self.heightForSectionHeader);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.chatSectionManager messagesCountForSectionAtIndex:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.chatSectionManager.chatSectionsCount;
}

- (UICollectionReusableView *)collectionView:(QMChatCollectionView *)collectionView
                    sectionHeaderAtIndexPath:(NSIndexPath *)indexPath {
    QMHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:[QMHeaderCollectionReusableView cellReuseIdentifier] forIndexPath:indexPath];
    
    QMChatSection *chatSection = [self.chatSectionManager chatSectionAtIndex:indexPath.section];
    headerView.headerLabel.text = [self nameForSectionWithDate:[chatSection lastMessageDate]];
    headerView.transform = self.collectionView.transform;
    
    return headerView;
}

- (UICollectionReusableView *)collectionView:(QMChatCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        // due to collection view being reversed, section header is actually footer
        return [self collectionView:collectionView sectionHeaderAtIndexPath:indexPath];
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(QMChatCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    QBChatMessage *messageItem = [self.chatSectionManager messageForIndexPath:indexPath];
    
    Class class = [self viewClassForItem:messageItem];
    NSString *itemIdentifier = [class cellReuseIdentifier];
    
    QMChatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.transform = self.collectionView.transform;
    cell.backgroundColor=[UIColor clearColor];
    
    
  
    
    [self collectionView:collectionView configureCell:cell forIndexPath:indexPath];
    
    UILongPressGestureRecognizer *lngPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
    
    lngPress.accessibilityHint = cell.textView.text;
    lngPress.accessibilityLanguage = [NSString stringWithFormat:@"%ld~%d",(long)indexPath.section,indexPath.row];
    
    
    
    [cell.textView addGestureRecognizer:lngPress];
    
    
    return cell;
}
- (void)labelClick:(UITapGestureRecognizer*)gesture
{
    
    
    CGPoint p = [gesture locationInView:self.collectionView];
    
    NSIndexPath *  indexpathTemp = [self.collectionView indexPathForItemAtPoint:p];
    
    
         messageDelte = [self.chatSectionManager messageForIndexPath:indexpathTemp];
    
//    if ([[gesture.accessibilityLanguage componentsSeparatedByString:@"~"]count]==2) {
//          NSIndexPath *indexpathTemp =   [NSIndexPath indexPathForRow:[[[gesture.accessibilityLanguage componentsSeparatedByString:@"~"]objectAtIndex:1] integerValue] inSection:[[[gesture.accessibilityLanguage componentsSeparatedByString:@"~"]objectAtIndex:0] integerValue]];
//        
//        
//
//        
//    }
  
    
   
    
    sameSection = indexpathTemp.section;
    
    nextRow = indexpathTemp.row-1;
    
    
    
    
    copystring = gesture.accessibilityHint;
    
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
    CGPoint point1 = [tap locationInView:self.view];
    
 
    rectFrame = CGRectMake(point1.x-100, point1.y, 200, 100);

    [self becomeFirstResponder];
    
  
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
          [menu setTargetRect:rectFrame inView:self.view];
  
    
    
    [menu setMenuVisible:YES animated:YES];
}
- (void)collectionView:(QMChatCollectionView *)collectionView configureCell:(UICollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[QMChatContactRequestCell class]]) {
        
        QMChatContactRequestCell *conatactRequestCell = (id)cell;
        conatactRequestCell.actionsHandler = self.actionsHandler;
    }
    
    if ([cell isKindOfClass:[QMChatCell class]]) {
        
        QMChatCell *chatCell = (QMChatCell *)cell;

        QBChatMessage *messageItem = [self.chatSectionManager messageForIndexPath:indexPath];
  
        chatCell.textView.text = [self attributedStringForItem:messageItem];
        chatCell.topLabel.text = [self topLabelAttributedStringForItem:messageItem];
        chatCell.bottomLabel.text = [self bottomLabelAttributedStringForItem:messageItem];
        
        
        //comment on 10/6/16
       
        
    //chatCell.topLabel.text =[syncObj GetUSernameFromBlobId:chatCell.topLabel.text ] ;
         }
        
    
}

- (NSAttributedString *)topLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    NSAssert(NO, @"Have to be overridden in subclasses!");
    return nil;
}

- (NSAttributedString *)attributedStringForItem:(QBChatMessage *)messageItem {
    NSAssert(NO, @"Have to be overridden in subclasses!");
    return nil;
}

- (NSAttributedString *)bottomLabelAttributedStringForItem:(QBChatMessage *)messageItem {
    NSAssert(NO, @"Have to be overridden in subclasses!");
    return nil;
}

#pragma mark - Collection view delegate

//- (BOOL)collectionView:(QMChatCollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//
// return NO;
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure want to delete?" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        self.chatSectionManager.delegate = self;
//        
//         QBChatMessage* message = [self.chatSectionManager messageForIndexPath:indexPath];
//        
//
//        
//        NSString *msgId = [message valueForKey:@"ID"];
//      
//        
//        NSSet *mesagesIDs = [NSSet setWithObjects:msgId, nil];
//        
//        [QBRequest deleteMessagesWithIDs:mesagesIDs forAllUsers:YES successBlock:^(QBResponse *response) {
//            
//            
//            [self.chatSectionManager deleteMessage:message];
//            
//          //  [[[QMApi instance]chatService]deleteMessageLocally:message ];
//            [[[QMApi instance]chatService] readMessages:@[message]  forDialogID:message.dialogID];
//            
//            [[[QMApi instance]chatService] deleteMessagesLocally:@[message] forDialogID:message.dialogID];
//            
//          
//            
//           // [[QMApi instance].chatService.messagesMemoryStorage deleteMessage:message];
//            
//
//        } errorBlock:^(QBResponse *response) {
//            
//        }];
//        
// 
//    }]];
//    
//
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        
//        
//       
//    }]];
//    
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        [self presentViewController:alertController animated:YES completion:nil];
//    });
//    
//
//    
//    
//    return  NO;
//    
//    
//    
////    self.selectedIndexPathForMenu = indexPath;
////    
////    return YES;
//}



- (void)collectionView:(QMChatCollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
      NSLog(@"performAction");
    
    NSAssert(NO, @"Have to be overridden in subclasses.");
}

- (Class)viewClassForItem:(QBChatMessage *)item {
    NSAssert(NO, @"Have to be overridden in subclasses.");
    return nil;
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(QMChatCollectionView *)collectionView
                  layout:(QMChatCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (NSString *)collectionView:(QMChatCollectionView *)collectionView itemIdAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *message = [self.chatSectionManager messageForIndexPath:indexPath];
    
    return message.ID;
}

- (QMChatCellLayoutModel)collectionView:(QMChatCollectionView *)collectionView layoutModelAtIndexPath:(NSIndexPath *)indexPath {
    
    QBChatMessage *item = [self.chatSectionManager messageForIndexPath:indexPath];
    Class class = [self viewClassForItem:item];
    
    return [class layoutModel];
}

#pragma mark - Input toolbar delegate

- (void)messagesInputToolbar:(QMInputToolbar *)toolbar didPressLeftBarButton:(UIButton *)sender {
    
    if (toolbar.sendButtonOnRight) {
        
        [self didPressAccessoryButton:sender];
    }
    else {
        
        [self didPressSendButton:sender
                 withMessageText:[self currentlyComposedMessageText]
                        senderId:self.senderID
               senderDisplayName:self.senderDisplayName
                            date:[NSDate date]];
    }
}

- (void)messagesInputToolbar:(QMInputToolbar *)toolbar didPressRightBarButton:(UIButton *)sender {
    
    if (toolbar.sendButtonOnRight) {
        
        [self didPressSendButton:sender withMessageText:[self currentlyComposedMessageText] senderId:self.senderID
               senderDisplayName:self.senderDisplayName
                            date:[NSDate date]];
    }
    else {
        
        [self didPressAccessoryButton:sender];
    }
}

- (NSString *)currentlyComposedMessageText {
    //  auto-accept any auto-correct suggestions
    [self.inputToolbar.contentView.textView.inputDelegate selectionWillChange:self.inputToolbar.contentView.textView];
    [self.inputToolbar.contentView.textView.inputDelegate selectionDidChange:self.inputToolbar.contentView.textView];
    
    return [self.inputToolbar.contentView.textView.text stringByTrimingWhitespace];
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView != self.inputToolbar.contentView.textView) {
        return;
    }
    
    [textView becomeFirstResponder];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView != self.inputToolbar.contentView.textView ) {
        return;
    }
    

     
    
    [self.inputToolbar toggleSendButtonEnabled];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView != self.inputToolbar.contentView.textView) {
        return;
    }
    
    [textView resignFirstResponder];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.pickerController animated:YES completion:nil];
    }
//    } else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:self.pickerController animated:YES completion:nil];
//    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    [self didPickAttachmentImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Notifications

- (void)handleDidChangeStatusBarFrameNotification:(NSNotification *)notification {
    
    if (self.keyboardController.keyboardIsVisible) {
        [self setToolbarBottomLayoutGuideConstant:CGRectGetHeight(self.keyboardController.currentKeyboardFrame)];
    }
}


#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == kChatKeyValueObservingContext) {
        
        if (object == self.inputToolbar.contentView.textView
            && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [change[NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
            
            CGFloat dy = newContentSize.height - oldContentSize.height;
            
            [self adjustInputToolbarForComposerTextViewContentSizeChange:dy];
            [self updateCollectionViewInsets];
            
            if (self.automaticallyScrollsToMostRecentMessage) {
                
                [self scrollToBottomAnimated:NO];
            }
        }
    }
}

#pragma mark - Keyboard controller delegate

- (void)keyboardController:(QMKeyboardController *)keyboardController keyboardDidChangeFrame:(CGRect)keyboardFrame {
    
    if (![self.inputToolbar.contentView.textView isFirstResponder] && self.toolbarBottomLayoutGuide.constant == 0.0f) {
        return;
    }
    
    CGFloat heightFromBottom = CGRectGetMaxY(self.collectionView.frame) + StaticHeight - CGRectGetMinY(keyboardFrame);
    
    heightFromBottom = MAX(0.0f, heightFromBottom);
    
    [self setToolbarBottomLayoutGuideConstant:heightFromBottom];
}

- (void)setToolbarBottomLayoutGuideConstant:(CGFloat)constant {
	
	if (fabs(self.toolbarBottomLayoutGuide.constant - constant) < 0.01) {
		return;
	}
	
    self.toolbarBottomLayoutGuide.constant = constant;
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    
    [self updateCollectionViewInsets];
}

- (void)updateKeyboardTriggerPoint {
    
    self.keyboardController.keyboardTriggerPoint = CGPointMake(0.0f, CGRectGetHeight(self.inputToolbar.bounds));
}

#pragma mark - Gesture recognizers

- (void)handleInteractivePopGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    BOOL ios8 = [[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending;
    
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            if (ios8) {
                
                [self.snapshotView removeFromSuperview];
            }
            
            [self.keyboardController endListeningForKeyboard];
            
            if (ios8) {
                
                [self.inputToolbar.contentView.textView resignFirstResponder];
                [UIView animateWithDuration:0.0
                                 animations:^
                 {
                     [self setToolbarBottomLayoutGuideConstant:0.0f];
                 }];
                
                UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:YES];
                [self.view addSubview:snapshot];
                self.snapshotView = snapshot;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            [self.keyboardController beginListeningForKeyboard];
            
            if (ios8) {
                [self.snapshotView removeFromSuperview];
            }
            
            break;
        default:
            break;
    }
}

#pragma mark - Input toolbar utilities

- (BOOL)inputToolbarHasReachedMaximumHeight {
    
    return CGRectGetMinY(self.inputToolbar.frame) == (self.topLayoutGuide.length + self.topContentAdditionalInset);
}

- (void)adjustInputToolbarForComposerTextViewContentSizeChange:(CGFloat)dy {
    
    BOOL contentSizeIsIncreasing = (dy > 0);
    
    if ([self inputToolbarHasReachedMaximumHeight]) {
        
        BOOL contentOffsetIsPositive = (self.inputToolbar.contentView.textView.contentOffset.y > 0);
        
        if (contentSizeIsIncreasing || contentOffsetIsPositive) {
            [self scrollComposerTextViewToBottomAnimated:YES];
            
            return;
        }
    }
    
    CGFloat toolbarOriginY = CGRectGetMinY(self.inputToolbar.frame);
    CGFloat newToolbarOriginY = toolbarOriginY - dy;
    
    //  attempted to increase origin.Y above topLayoutGuide
    if (newToolbarOriginY <= self.topLayoutGuide.length + self.topContentAdditionalInset) {
        
        dy = toolbarOriginY - (self.topLayoutGuide.length + self.topContentAdditionalInset);
        [self scrollComposerTextViewToBottomAnimated:YES];
    }
    
    [self adjustInputToolbarHeightConstraintByDelta:dy];
    
    [self updateKeyboardTriggerPoint];
    
    if (dy < 0) {
        
        [self scrollComposerTextViewToBottomAnimated:NO];
    }
}

- (void)adjustInputToolbarHeightConstraintByDelta:(CGFloat)dy {
    
    self.toolbarHeightConstraint.constant += dy;
    
    if (self.toolbarHeightConstraint.constant < self.inputToolbar.preferredDefaultHeight) {
        self.toolbarHeightConstraint.constant = self.inputToolbar.preferredDefaultHeight;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

- (void)scrollComposerTextViewToBottomAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputToolbar.contentView.textView;
    CGPoint contentOffsetToShowLastLine = CGPointMake(0.0f, textView.contentSize.height - CGRectGetHeight(textView.bounds));
    
    if (!animated) {
        textView.contentOffset = contentOffsetToShowLastLine;
        return;
    }
    
    [UIView animateWithDuration:0.01 delay:0.01 options:UIViewAnimationOptionCurveLinear animations:^{
        
        textView.contentOffset = contentOffsetToShowLastLine;
    }
                     completion:nil];
}

#pragma mark - Collection view utilities

- (void)updateCollectionViewInsets {

    [self setCollectionViewInsetsTopValue:CGRectGetMaxY(self.collectionView.frame) + StaticHeight - CGRectGetMinY(self.inputToolbar.frame)
                              bottomValue:self.topLayoutGuide.length + self.topContentAdditionalInset];
}

- (void)setCollectionViewInsetsTopValue:(CGFloat)top bottomValue:(CGFloat)bottom {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

- (BOOL)isMenuVisible {
    
    
    return YES;
    //  check if cell copy menu is showing
    //  it is only our menu if `selectedIndexPathForMenu` is not `nil`
    return self.selectedIndexPathForMenu != nil && [[UIMenuController sharedMenuController] isMenuVisible];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/**
 *  label能执行哪些操作
 *  return YES; 支持这种操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(action));
    if (action == @selector(delete:))  return YES;
    if (action == @selector(cut:)  || action == @selector(paste:)) return NO;
    if (action == @selector(copy:))  return YES;
    if (action == @selector(select:))  return NO;
    if (action == @selector(delete:))  return YES;
    if (action == @selector(selectAll:))  return NO;
    return NO;
}
#pragma mark - Utilities

- (NSTimeInterval)timeIntervalBetweenSections {
    
    return self.chatSectionManager.timeIntervalBetweenSections;
}
- (void)copy:(UIMenuController *)menu
{
    
    

    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = copystring;
}
- (void)delete:(UIMenuController *)menu
{
    /////////
    if ([[messageDelte.customParameters valueForKey:@"isHidden"]isEqualToString:@"N"]&&  nextRow>=0) {
        
        
        
        
        NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:nextRow inSection:sameSection];
        if (indexpath2 && indexpath2 !=nil) {
            QBChatMessage   *message2 = [self.chatSectionManager messageForIndexPath:indexpath2];
            if (message2 && message2 != nil) {
                
                [message2.customParameters setValue:@"N" forKey:@"isHidden"];
                [self.collectionView reloadItemsAtIndexPaths:@[indexpath2]];
                
                
            }
            
            
            
        }
        
        
    }
    
    
    
    ////////
    
    
    
    
            self.chatSectionManager.delegate = self;
    

    
    
    
            NSString *msgId = [messageDelte valueForKey:@"ID"];
    
    
            NSSet *mesagesIDs = [NSSet setWithObjects:msgId, nil];
    
            [QBRequest deleteMessagesWithIDs:mesagesIDs forAllUsers:YES successBlock:^(QBResponse *response) {
    
    
                [self.chatSectionManager deleteMessage:messageDelte];
    
              //  [[[QMApi instance]chatService]deleteMessageLocally:message ];
                [[[QMApi instance]chatService] readMessages:@[messageDelte]  forDialogID:messageDelte.dialogID];
    
                [[[QMApi instance]chatService] deleteMessagesLocally:@[messageDelte] forDialogID:messageDelte.dialogID];
    
    
                
                // [[QMApi instance].chatService.messagesMemoryStorage deleteMessage:message];
                

    
    
    
            } errorBlock:^(QBResponse *response) {
                
            }];
            
     
        }
- (void)setTimeIntervalBetweenSections:(NSTimeInterval)timeIntervalBetweenSections {
    
    [self.chatSectionManager setTimeIntervalBetweenSections:timeIntervalBetweenSections];
}

- (NSIndexSet *)indexSetForSectionsToInsert:(NSArray *)sectionsToInsert {
    
    NSMutableIndexSet *sectionsIndexSet = [NSMutableIndexSet indexSet];
    if ([sectionsToInsert count] > 0) {
        for (NSNumber *sectionIndex in sectionsToInsert) {
            [sectionsIndexSet addIndex:[sectionIndex integerValue]];
        }
    }
    
    return [sectionsIndexSet copy];
}

- (NSUInteger)totalMessagesCount {
    
    return self.chatSectionManager.totalMessagesCount;
}

- (NSString *)nameForSectionWithDate:(NSDate *)date {
    
    return [QMDateUtils formattedStringFromDate:date];
}

- (QBChatMessage *)messageForIndexPath:(NSIndexPath *)indexPath {

    return [self.chatSectionManager messageForIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForMessage:(QBChatMessage *)message {
    
    return [self.chatSectionManager indexPathForMessage:message];
}




- (void)registerForNotifications:(BOOL)registerForNotifications {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    if (registerForNotifications) {
        
        [defaultCenter addObserver:self
                          selector:@selector(handleDidChangeStatusBarFrameNotification:)
                              name:UIApplicationDidChangeStatusBarFrameNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(didReceiveMenuWillShowNotification:)
                              name:UIMenuControllerWillShowMenuNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(didReceiveMenuWillHideNotification:)
                              name:UIMenuControllerWillHideMenuNotification
                            object:nil];
    }
    else {
        
        [defaultCenter removeObserver:self
                                 name:UIApplicationDidChangeStatusBarFrameNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UIMenuControllerWillShowMenuNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UIMenuControllerWillHideMenuNotification
                               object:nil];
    }
}

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification {
    
    if (!self.selectedIndexPathForMenu) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    UIMenuController *menu = [notification object];
    [menu setMenuVisible:NO animated:NO];
    
    QMChatCell *selectedCell = (QMChatCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPathForMenu];
    CGRect selectedCellMessageBubbleFrame = [selectedCell convertRect:selectedCell.containerView.frame toView:self.view];
    
    [menu setTargetRect:selectedCellMessageBubbleFrame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
}


- (void)didReceiveMenuWillHideNotification:(NSNotification *)notification {
    
    if (!self.selectedIndexPathForMenu) {
        return;
    }
    
    //  per comment above in 'shouldShowMenuForItemAtIndexPath:'
    //  re-enable 'selectable', thus re-enabling data detectors if present
    //    QMChatCollectionViewCell *selectedCell = (id)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPathForMenu];
    //    selectedCell.textView.selectable = YES;
    self.selectedIndexPathForMenu = nil;
}

- (void)removeObservers {
    
    if (!self.isObserving) {
        return;
    }
    
    @try {
        [_inputToolbar.contentView.textView removeObserver:self
                                                forKeyPath:NSStringFromSelector(@selector(contentSize))
                                                   context:kChatKeyValueObservingContext];
    }
    @catch (NSException * __unused exception) {
        
    }
    
    self.isObserving = NO;
}


- (void)addObservers {
    
    if (self.isObserving) {
        return;
    }
    
    [self.inputToolbar.contentView.textView addObserver:self
                                             forKeyPath:NSStringFromSelector(@selector(contentSize))
                                                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                context:kChatKeyValueObservingContext];
    
    self.isObserving = YES;
}

- (void)addActionToInteractivePopGestureRecognizer:(BOOL)addAction {
    
    if (self.navigationController.interactivePopGestureRecognizer) {
        
        [self.navigationController.interactivePopGestureRecognizer removeTarget:nil
                                                                         action:@selector(handleInteractivePopGestureRecognizer:)];
        
        if (addAction) {
            
            [self.navigationController.interactivePopGestureRecognizer addTarget:self
                                                                          action:@selector(handleInteractivePopGestureRecognizer:)];
        }
    }
}
@end
