//
//  GroupDetailViewController.m
//  cruizeco
//
//  Created by Kishor Kundan on 8/14/15.
//  Copyright (c) 2015 Kishor Kundan. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "PostInfo.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

#import "PostTableViewCell.h"
#import "CommentTableViewCell.h"
#import "ReplyTableViewCell.h"
#import "PostActionTableViewCell.h"
#import "UIButton+Block.h"

#import "Popup.h"
#import <CMPopTipView.h>


enum activeTab{
    kPosts,
    kEvents
} ;


@interface GroupDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ivGroupImage;
@property (weak, nonatomic) IBOutlet UILabel *labelGroupTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelGroupDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelGroupMembers;
@property (weak, nonatomic) IBOutlet UIButton *btnGroupAction;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Paginator* paging;

/**
 Drop down menu from right bar button
 */
@property (strong, nonatomic) CMPopTipView* popTipView;

/**
 Number of Posts in the group
 */
@property NSInteger PostCount;

/**
 Number of Events in the group
 */
@property NSInteger EventCount;

/**
 All Posts in the group
 */
@property (strong, nonatomic) NSMutableArray* posts;

/**
 Currently showing tab Event or Posts
 */
@property NSInteger activeTab;

/**
 Network retries
 */
@property NSInteger networkRetries;

@property (strong, nonatomic) UIImageView* overlayView;
@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overlayView= [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.overlayView.image= [UIImage imageNamed:@"background.png"];
    [self.view addSubview:self.overlayView];
    
    
    
    if (self.removePreviousViewFromNavigationStack) {
        NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [navArray removeObjectAtIndex:[navArray count]-2];
        [self.navigationController setViewControllers:navArray animated:NO];
        [self.navigationController.navigationBar setHidden:YES];
        [self.navigationController.navigationBar setHidden:NO];
        [self getGroupDetail];
    } else {
        [self setupUI];
    }
    
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate= self;
    self.tableView.dataSource= self;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.paging= [[Paginator alloc] init];
    
    self.posts= [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.removePreviousViewFromNavigationStack) {
        [self getAdditionalDetails];
    }
}

-(void) viewDidLayoutSubviews {
    self.ivGroupImage.layer.cornerRadius= CGRectGetHeight(self.ivGroupImage.frame)/2;
    self.ivGroupImage.layer.masksToBounds = YES;
    self.ivGroupImage.clipsToBounds= YES;
}



-(void) setupUI {
    [self.overlayView removeFromSuperview];
    UIBarButtonItem *dropDown = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dropDown.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dropDown:)];
    dropDown.tintColor= [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem= dropDown;
    
    
    self.labelGroupTitle.text= self.groupInfo.name;
    self.labelGroupDescription.text= self.groupInfo.groupDescription;
    self.labelGroupMembers.text= [NSString stringWithFormat:@"%lu", (unsigned long)self.groupInfo.countMembers];
    //    self.labelgr.text= [NSString stringWithFormat:@"%lu", (unsigned long)self.groupInfo.countMembers];
    [self.ivGroupImage setImageWithURL:self.groupInfo.photoURL];
}

-(void) dropDown:(UIBarButtonItem*) sender {
    
    sender.image= [UIImage imageNamed:@"dropDown-inv.png"];
    
    float height= 25.0;
    float width= 155.0;
    
    UIButton* postInGroup= [UIButton buttonWithType:UIButtonTypeCustom];
    [postInGroup setTitle:@"Post in the group" forState:UIControlStateNormal];
    postInGroup.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    postInGroup.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [postInGroup setFrame:CGRectMake(0.0, 0.0, width, height)];
    [postInGroup.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [postInGroup setBackgroundColor:[UIColor clearColor]];
    
    [postInGroup setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        [self commentOnPost:self.groupInfo.groupId type:@"Post"];
        //
        //        AddTrackViewController* addTrackVC= [self.storyboard instantiateViewControllerWithIdentifier:@"AddTrackVC"];
        //        addTrackVC.title= @"Add Route";
        //        self.navigationItem.title= @"";
        //        self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
        //        [self.navigationController pushViewController:addTrackVC animated:YES];
    }];
    
    UIButton* newEventForTheGroup= [UIButton buttonWithType:UIButtonTypeCustom];
    [newEventForTheGroup setTitle:@"New Event for the group" forState:UIControlStateNormal];
    newEventForTheGroup.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    newEventForTheGroup.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [newEventForTheGroup setFrame:CGRectMake(0.0, height, width, height)];
    [newEventForTheGroup.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [newEventForTheGroup setBackgroundColor:[UIColor clearColor]];
    
    [newEventForTheGroup setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self.popTipView dismissAnimated:NO];
        //
        //        AddTrackViewController* addTrackVC= [self.storyboard instantiateViewControllerWithIdentifier:@"AddTrackVC"];
        //        addTrackVC.title= @"Add Route";
        //        self.navigationItem.title= @"";
        //        self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
        //        [self.navigationController pushViewController:addTrackVC animated:YES];
    }];
    
    UIView* contain= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height*2)];
    contain.backgroundColor= [UIColor clearColor];
    
    [contain addSubview:postInGroup];
    [contain addSubview:newEventForTheGroup];
    
    self.popTipView= [[CMPopTipView alloc] initWithCustomView:contain];
    self.popTipView.backgroundColor= [UIColor darkGrayColor];
    self.popTipView.has3DStyle= NO;
    self.popTipView.hasShadow= NO;
    self.popTipView.dismissTapAnywhere= YES;
    self.popTipView.hasGradientBackground= NO;
    self.popTipView.delegate= self;
    [self.popTipView presentPointingAtBarButtonItem:sender animated:YES];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // User can tap CMPopTipView to dismiss it
    self.navigationItem.rightBarButtonItem.image= [UIImage imageNamed:@"dropDown.png"];
    
}

#pragma mark API calls

#pragma mark API calls
-(void) getGroupDetail {
    if (!self.groupId) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{
                             @"token": kStaticToken,
                             @"group_id": self.groupId
                             };
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kGroupDetail] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (self.networkRetries < 3) {
                self.networkRetries++;
                [self getGroupDetail];
            }
            return;
        }
        self.groupInfo= [[GroupInfo alloc] initWithAttributes:[[responseObject objectForKey:@"output"] objectForKey:@"response"]];
        
        [self setupUI];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getAdditionalDetails];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle reachability here
        if (self.networkRetries < 3) {
            self.networkRetries++;
            [self getGroupDetail];
            return ;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}


-(void) getAdditionalDetails {
    self.paging.isPaginationInProgress= YES;
    if(self.paging.currentPage == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken, @"group_id": [NSString stringWithFormat:@"%lu", (unsigned long)self.groupInfo.groupId]};
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    
    NSString* addurl= (self.paging.currentPage==0)? kViewGroup : kGroupPostsPagination;
    [manager POST:[NSString stringWithFormat:@"%@%@page:%ld.json", kBaseUrl, addurl, (long)(self.paging.currentPage+1)] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        
        if (self.paging.currentPage == 0) {
            
            self.EventCount= [[[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"groupEventCount"] integerValue];
            for (NSDictionary* post in [[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"groupPost"]) {
                [self.posts addObject:[[PostInfo alloc] initWithAttributes:post]];
            }
            self.paging.pageCount= [[[[responseObject objectForKey:@"output"] objectForKey:@"response"] objectForKey:@"groupPostPageCount"] integerValue];
            
        } else {
            for (NSDictionary* post in [[responseObject objectForKey:@"output"] objectForKey:@"response"]) {
                [self.posts addObject:[[PostInfo alloc] initWithAttributes:post]];
            }
        }
        self.PostCount= [self.posts count];
        self.paging.currentPage+= 1;
        self.paging.isPaginationInProgress= NO;
        
        [self.tableView reloadData];
        
        if(self.paging.currentPage == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle reachability here
        self.paging.isPaginationInProgress= NO;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections= 0;
    
    switch (self.activeTab) {
        case kPosts:
            sections= self.PostCount;
            break;
        case kEvents:
            sections= self.EventCount;
            break;
        default:
            break;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows= 0;
    switch (self.activeTab) {
        case kPosts:{
            PostInfo* post= [self.posts objectAtIndex:section];
            rows= [post numberOfRepliesAndComments]+ 1 + 1;
        }
            break;
        case kEvents:
            break;
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* transparentView= [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 10.0)];
    transparentView.backgroundColor= [UIColor clearColor];
    return transparentView;
}
//0 Post
//1 Comment
//2     Reply
//3     Reply
//4 Comment
//5     Reply
//6

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostInfo* post= [self.posts objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return [self tableView:tableView postCellWithPostInfo:post atIndexPath:indexPath];
    }
    if (indexPath.row != ([self tableView:tableView numberOfRowsInSection:indexPath.section])) {
        for (PostCommentInfo* comment in post.comments) {
            if ( comment.endNode >= indexPath.row ) {
                if (comment.startNode == indexPath.row) {
                    return [self tableView:tableView commentCellWithCommentInfo:comment atIndexPath:indexPath];
                } else {
                    return [self tableView:tableView replyCellWithReplyInfo:[comment.replies objectAtIndex:(indexPath.row - comment.startNode) - 1] atIndexPath:indexPath];
                }
            }
        }
        
    }
    
    PostActionTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"PostActionTVC" forIndexPath:indexPath];
    [cell.labelMoreComments setHidden:YES];
    [cell.btnComment setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self commentOnPost:post.postId type:@"Comment"];
    }];
    [cell.viewBorder setAlpha:0.3];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(PostTableViewCell*) tableView:(UITableView*) tableView postCellWithPostInfo:(PostInfo*) post atIndexPath:(NSIndexPath*) indexPath {
    
    PostTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"PostTVC" forIndexPath:indexPath];
    //    if (![cell.authorName.text isEqualToString:@"Label"]) {
    //        return cell;
    //    }
    
    [cell.authorPhoto setImageWithURL:post.author.authorProfilePicture];
    cell.authorPhoto.layer.cornerRadius= CGRectGetHeight(cell.authorPhoto.frame)/2;
    cell.authorPhoto.layer.masksToBounds = YES;
    cell.authorPhoto.clipsToBounds= YES;
    
    [cell.authorName setText:post.author.name];
    [cell.postTitle setText:post.message];
    [cell.postTime setText:post.date];
    //    [cell.btnReply setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
    //        [self commentOnPost:post.postId];
    //    }];
    [cell.btnReply setHidden:YES];
    return cell;
}
-(CommentTableViewCell*) tableView:(UITableView*) tableView commentCellWithCommentInfo:(PostCommentInfo*) comment atIndexPath:(NSIndexPath*) indexPath {
    CommentTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"CommentTVC" forIndexPath:indexPath];
    
    //    if (![cell.authorName.text isEqualToString:@"Label"]) {
    //        return cell;
    //    }
    
    [cell.authorPhoto setImageWithURL:comment.author.authorProfilePicture];
    
    cell.authorPhoto.layer.cornerRadius= CGRectGetHeight(cell.authorPhoto.frame)/2;
    cell.authorPhoto.layer.masksToBounds = YES;
    cell.authorPhoto.clipsToBounds= YES;
    
    [cell.authorName setText:comment.author.name];
    [cell.comment setText:comment.message];
    [cell.commentDate setText:comment.date];
    [cell.btnReply setAction:kUIButtonBlockTouchUpInside withBlock:^(UIButton *sender) {
        [self commentOnPost:[comment.commentID integerValue] type:@"Reply"];
    }];
    return cell;
    
}

-(ReplyTableViewCell*) tableView:(UITableView*) tableView replyCellWithReplyInfo:(PostCommentReplyInfo*) reply atIndexPath:(NSIndexPath*) indexPath {
    ReplyTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"ReplyTVC" forIndexPath:indexPath];
    //    if (![cell.authorName.text isEqualToString:@"Label"]) {
    //        return cell;
    //    }
    
    [cell.authorPhoto setImageWithURL:reply.author.authorProfilePicture];
    
    cell.authorPhoto.layer.cornerRadius= CGRectGetHeight(cell.authorPhoto.frame)/2;
    cell.authorPhoto.layer.masksToBounds = YES;
    cell.authorPhoto.clipsToBounds= YES;
    
    [cell.replyMessage setText:reply.message];
    [cell.authorName setText:reply.author.name];
    [cell.replyDate setText:reply.date];
    [cell.btnReply setHidden:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ([self.posts count] - 1) && self.paging.currentPage < self.paging.pageCount && !self.paging.isPaginationInProgress) {
        
        [self getAdditionalDetails];
        
    }
}


-(void) commentOnPost:(NSInteger) postId type:(NSString*) type {
    self.navigationItem.rightBarButtonItem.image= [UIImage imageNamed:@"dropDown.png"];
    Popup *popup = [[Popup alloc] initWithTitle:type
                                       subTitle:nil
                          textFieldPlaceholders:@[[NSString stringWithFormat:@"Type your %@ here", type]]
                                    cancelTitle:@"Cancel"
                                   successTitle:@"Ok"
                                    cancelBlock:^{
                                    } successBlock:^{
                                    }];
    [popup setBackgroundColor:[UIColor whiteColor]];
    //    [popup setBorderColor:[UIColor blackColor]];
    //    [popup setTitleColor:[UIColor darkGrayColor]];
    //
    //    [popup setSubTitleColor:[UIColor lightTextColor]];
    [popup setSuccessBtnColor:[self defaultColor]];
    //    [popup setSuccessTitleColor:[UIColor whiteColor]];
    [popup setCancelBtnColor:[self secondDefaultColor]];
    //    [popup setCancelTitleColor:[UIColor whiteColor]];
    //
    [popup setIncomingTransition:PopupIncomingTransitionTypeBounceFromCenter];
    [popup setOutgoingTransition:PopupOutgoingTransitionTypeBounceFromCenter];
    [popup setBackgroundBlurType:PopupBackGroundBlurTypeDark];
    [popup setRoundedCorners:YES];
    [popup setTapBackgroundToDismiss:YES];
    [popup setDelegate:self];
    [popup showPopup];
    
}


- (void) dictionary:(NSMutableDictionary *)dictionary forpopup:(Popup *)popup stringsFromTextFields:(NSArray *)stringArray
{
    NSString *title = [stringArray objectAtIndex:0];            // post, comment or reply
    if (!title.length) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager* manager= [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"token": kStaticToken, @"group_id": [NSString stringWithFormat:@"%lu", (unsigned long)self.groupInfo.groupId], @"message":title};
    
    [manager.requestSerializer setValue:@"0d68ae6920f104c22b82f9b6d72b2100" forHTTPHeaderField:@"pbkey"];
    
    //    [manager.requestSerializer setValue:self.servicePointId forHTTPHeaderField:@"PB_SERVICE_POINT_COUNTER_ID"];
    //    [manager.requestSerializer setValue:self.restaurantId forHTTPHeaderField:@"PB_SERVICE_POINT_RESTAURANT_ID"];
    [manager POST:[NSString stringWithFormat:@"%@%@", kBaseUrl, kPostToGroup] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[[responseObject objectForKey:@"output"] objectForKey:@"status"] intValue] != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        //
        PostInfo* post= [[PostInfo alloc] init];
        //        self.name= [attributes objectForKey:@"PostAuthor"];
        //        self.authorProfilePicture= [NSURL URLWithString:[attributes objectForKey:@"AuthorPhoto"]];
        post.postId= [[[responseObject objectForKey:@"output"] objectForKey:@"response"] integerValue];
        post.commentCount= 0;
        post.date= @"now";
        post.message= title;
        post.author= [[PostAuthor alloc] initWithAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"iOS me not available",@"http://cdn2.hubspot.net/hub/150/file-13149256-jpg/images/sorry.jpg?t=1448387556650", nil] forKeys:[NSArray arrayWithObjects:@"PostAuthor", @"AuthorPhoto", nil]]];
        
        post.comments= [[NSMutableArray alloc] init];
        self.PostCount+= 1;
        [self.posts insertObject:post atIndex:0];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Handle reachability here
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

@end
