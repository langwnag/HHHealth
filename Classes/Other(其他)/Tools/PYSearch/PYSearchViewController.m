//
//  代码地址: https://github.com/iphone5solo/PYSearch
//  代码地址: http://www.code4app.com/thread-11175-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYSearchViewController.h"
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"

#define PYRectangleTagMaxCol 3 // 矩阵标签时，最多列数
#define PYTextColor PYColor(113, 113, 113)  // 文本字体颜色
#define PYColorPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)] // 随机选取颜色池中的颜色

@interface PYSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, PYSearchSuggestionViewDataSource,UIGestureRecognizerDelegate>

/** 头部内容view */
@property (nonatomic, weak) UIView *headerContentView;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistories;

/** 键盘正在移动 */
@property (nonatomic, assign) BOOL keyboardshowing;
/** 记录键盘高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;

/** 搜索建议（推荐）控制器 */
@property (nonatomic, weak) PYSearchSuggestionViewController *searchSuggestionVC;

/** 热门标签容器 */
@property (nonatomic, weak) UIView *hotSearchTagsContentView;

/** 排名标签(第几名) */
@property (nonatomic, copy) NSArray<UILabel *> *rankTags;
/** 排名内容 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTextLabels;
/** 排名整体标签（包含第几名和内容） */
@property (nonatomic, copy) NSArray<UIView *> *rankViews;

/** 搜索历史标签容器，只有在PYSearchHistoryStyle值为PYSearchHistoryStyleTag才有值 */
@property (nonatomic, weak) UIView *searchHistoryTagsContentView;
/** 搜索历史标签的清空按钮 */
@property (nonatomic, weak) UIButton *emptyButton;

/** 基本搜索TableView(显示历史搜索和搜索记录) */
@property (nonatomic, strong) UITableView *baseSearchTableView;
/** 记录是否点击搜索建议 */
@property (nonatomic, assign) BOOL didClickSuggestionCell;
/** 中间线 */
@property (nonatomic,weak) UIView* centecrView;

@end

@implementation PYSearchViewController

- (instancetype)init
{
    if (self = [super init]) {

        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

+ (PYSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder
{
    PYSearchViewController *searchVC = [[PYSearchViewController alloc] init];
    searchVC.hotSearches = hotSearches;
    searchVC.searchBar.placeholder = placeholder;
    return searchVC;
}

+ (PYSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(PYDidSearchBlock)block
{
    PYSearchViewController *searchVC = [self searchViewControllerWithHotSearches:hotSearches searchBarPlaceholder:placeholder];
    searchVC.didSearchBlock = [block copy];
    return searchVC;
}

#pragma mark - 懒加载
- (UITableView *)baseSearchTableView
{
    if (!_baseSearchTableView) {
        UITableView *baseSearchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, SZRScreenWidth, SZRScreenHeight) style:UITableViewStyleGrouped];
//        baseSearchTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        baseSearchTableView.backgroundColor = [UIColor whiteColor];
        baseSearchTableView.delegate = self;
        baseSearchTableView.dataSource = self;
        [self.view addSubview:baseSearchTableView];
        _baseSearchTableView = baseSearchTableView;
    }
    return _baseSearchTableView;
}

- (UITableViewController *)searchResultController
{
    if (!_searchResultController) {
        _searchResultController = [[UITableViewController alloc] init];
        self.searchResultTableView = _searchResultController.tableView;
    }
    return _searchResultController;
}

- (PYSearchSuggestionViewController *)searchSuggestionVC
{
    if (!_searchSuggestionVC) {
        PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] initWithStyle:UITableViewStyleGrouped];
        __weak typeof(self) _weakSelf = self;
        searchSuggestionVC.didSelectCellBlock = ^(UITableViewCell *didSelectCell) {
            // 设置搜索信息
            _weakSelf.searchBar.text = didSelectCell.textLabel.text;
            // 如果实现搜索建议代理方法则searchBarSearchButtonClicked失效
            if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndex:searchText:)]) {
                // 获取下标
                NSIndexPath *indexPath = [_weakSelf.searchSuggestionVC.tableView indexPathForCell:didSelectCell];
                [self.delegate searchViewController:_weakSelf didSelectSearchSuggestionAtIndex:indexPath.row searchText:_weakSelf.searchBar.text];
            } else {
                // 点击搜索
                [_weakSelf searchBarSearchButtonClicked:_weakSelf.searchBar];
            }
        };
        searchSuggestionVC.view.frame = CGRectMake(0, 0, self.view.py_width, self.view.py_height);
        searchSuggestionVC.tableView.contentInset = UIEdgeInsetsMake(-30, 0, self.keyboardHeight, 0);
        searchSuggestionVC.view.backgroundColor = self.baseSearchTableView.backgroundColor;
        searchSuggestionVC.view.hidden = YES;
        // 设置数据源
        searchSuggestionVC.dataSource = self;
        [self.view addSubview:searchSuggestionVC.view];
        [self addChildViewController:searchSuggestionVC];
        _searchSuggestionVC = searchSuggestionVC;
    }
    return _searchSuggestionVC;
}

- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        // 添加清空按钮
        UIButton *emptyButton = [[UIButton alloc] init];
        emptyButton.titleLabel.font = self.searchHistoryHeader.font;
        [emptyButton setTitleColor:PYTextColor forState:UIControlStateNormal];
        [emptyButton setTitle:@"清空" forState:UIControlStateNormal];
        [emptyButton setImage:[UIImage imageNamed:@"PYSearch.bundle/empty"] forState:UIControlStateNormal];
        [emptyButton addTarget:self action:@selector(emptySearchHistoryDidClick) forControlEvents:UIControlEventTouchUpInside];
        [emptyButton sizeToFit];
        emptyButton.py_width += PYMargin;
        emptyButton.py_height += PYMargin;
        emptyButton.py_centerY = self.searchHistoryHeader.py_centerY;
        emptyButton.py_x = self.headerContentView.py_width - emptyButton.py_width;
        [self.headerContentView addSubview:emptyButton];
        _emptyButton = emptyButton;
    }
    return _emptyButton;
}

#pragma mark - 搜索历史（标签容器视图）
- (UIView *)searchHistoryTagsContentView
{
    if (!_searchHistoryTagsContentView) {
        UIView *searchHistoryTagsContentView = [[UIView alloc] init];
//        searchHistoryTagsContentView.backgroundColor = [UIColor yellowColor];
        searchHistoryTagsContentView.py_width = PYScreenW - PYMargin * 2;
        searchHistoryTagsContentView.py_y = CGRectGetMaxY(self.hotSearchTagsContentView.frame) + PYMargin;
        [self.headerContentView addSubview:searchHistoryTagsContentView];
        _searchHistoryTagsContentView = searchHistoryTagsContentView;
    }
    return _searchHistoryTagsContentView;
}

- (UILabel *)searchHistoryHeader
{
    if (!_searchHistoryHeader) {
        UILabel *titleLabel = [self setupTitleLabel:PYSearchHistoryText];
        [self.headerContentView addSubview:titleLabel];
        _searchHistoryHeader = titleLabel;
    }
    return _searchHistoryHeader;
}

- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath];
        if (!_searchHistories) {
            _searchHistories = [NSMutableArray array];
        }
    }
    return _searchHistories;
}

#pragma mark  包装cancelButton
- (UIBarButtonItem *)cancelButton
{
    return self.navigationItem.rightBarButtonItem;
}

/** 视图完全显示 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 弹出键盘
    [self.searchBar becomeFirstResponder];
}

/** 视图即将消失 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 回收键盘
    [self.searchBar resignFirstResponder];
}

/** 控制器销毁 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 初始化 */
- (void)setup
{
    // 设置背景颜色为白色
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.baseSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClicked)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSerchBarWhenTapBackground:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

    /**
     * 设置一些默认设置
     */
    // 热门搜索风格设置
    self.hotSearchStyle = PYHotSearchStyleDefault;
    // 设置搜索历史风格
    self.searchHistoryStyle = PYHotSearchStyleDefault;
    // 设置搜索结果显示模式
    self.searchResultShowMode = PYSearchResultShowModeDefault;
    // 显示搜索建议
    self.searchSuggestionHidden = NO;
    // 搜索历史缓存路径
    self.searchHistoriesCachePath = PYSearchHistoriesPath;
    
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.py_x = PYMargin * 0.5;
    titleView.py_y = 7;
    titleView.py_width = self.view.py_width - 64 - titleView.py_x * 2;
    titleView.py_height = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.py_width -= PYMargin * 1.5;
//    searchBar.placeholder = PYSearchPlaceholderText;
    searchBar.tintColor = [UIColor orangeColor];
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
    
    // 设置头部（热门搜索）
    UIView *headerView = [[UIView alloc] init];
#pragma mark - 自己添加查看效果
//    headerView.backgroundColor = [UIColor purpleColor];
    UIView *contentView = [[UIView alloc] init];
    contentView.py_y = PYMargin * 2;
    contentView.py_x = PYMargin * 1.5;
    contentView.py_width = PYScreenW - contentView.py_x * 2;
    [headerView addSubview:contentView];
  
    // 中间线
    UIView* centecrView = [[UIView alloc] init];
    centecrView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    centecrView.py_x = 0;
    centecrView.py_width = self.view.py_width;
    centecrView.py_height = 8.0f;
    [headerView addSubview:centecrView];
    self.centecrView = centecrView;

    
    UILabel *titleLabel = [self setupTitleLabel:PYHotSearchText];
#pragma mark - 热门搜索 （标题）文字颜色
    titleLabel.textColor = [UIColor grayColor];
    self.hotSearchHeader = titleLabel;
    [contentView addSubview:titleLabel];
    
    // 创建热门搜索标签容器
    UIView *hotSearchTagsContentView = [[UIView alloc] init];
#pragma mark - 热门搜索容器背景颜色
//    hotSearchTagsContentView.backgroundColor = [UIColor greenColor];
    hotSearchTagsContentView.py_width = contentView.py_width;
    hotSearchTagsContentView.py_y = CGRectGetMaxY(titleLabel.frame) + PYMargin;
    [contentView addSubview:hotSearchTagsContentView];
    self.hotSearchTagsContentView = hotSearchTagsContentView;
    self.headerContentView = contentView;
    self.baseSearchTableView.tableHeaderView = headerView;
     // 默认没有热门搜索
    self.hotSearches = nil;
}

/** 创建并设置标题 */
- (UILabel *)setupTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.tag = 1;
#pragma mark - 设置（搜索历史） 标题颜色
    titleLabel.textColor = PYTextColor;
    [titleLabel sizeToFit];
    titleLabel.py_x = 0;
    titleLabel.py_y = -10;
    return titleLabel;
}

#pragma mark - 自己添加取消按钮的代理方法
- (void)cancelButtonClicked{
    if ([self.cateDelegate respondsToSelector:@selector(onSearchCancelClick)]) {
        [self.cateDelegate onSearchCancelClick];
    }
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)hideSerchBarWhenTapBackground:(id)sender {
    [self.searchBar resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


/**
 * 设置热门搜索标签(不带排名)
 * PYHotSearchStyleNormalTag || PYHotSearchStyleColorfulTag ||
 * PYHotSearchStyleBorderTag || PYHotSearchStyleARCBorderTag
 */
- (void)setupHotSearchNormalTags
{
    // 添加和布局标签
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchTagsContentView tagTexts:self.hotSearches];
    // 根据hotSearchStyle设置标签样式
    [self setHotSearchStyle:self.hotSearchStyle];
}


/**
 * 设置搜索历史标签
 * PYSearchHistoryStyleTag
 */
- (void)setupSearchHistoryTags
{
    // 隐藏尾部清除按钮
    self.baseSearchTableView.tableFooterView = nil;
    
    // 添加搜索历史头部
    self.searchHistoryHeader.py_y = self.hotSearches.count > 0 ? CGRectGetMaxY(self.centecrView.frame) - PYMargin * 0.5: 0;
    
//    self.emptyButton.py_y = self.searchHistoryHeader.py_y - PYMargin * 0.5;
    self.emptyButton.py_y = self.centecrView.py_y - PYMargin * 0.5;

    self.searchHistoryTagsContentView.py_y = self.searchHistoryHeader.py_y + PYMargin* 2.5;
    // 添加和布局标签
    self.searchHistoryTags = [self addAndLayoutTagsWithTagsContentView:self.searchHistoryTagsContentView tagTexts:[self.searchHistories copy]];
}

#pragma mark - 热门搜索
/**  添加和布局标签 */
- (NSArray *)addAndLayoutTagsWithTagsContentView:(UIView *)contentView tagTexts:(NSArray<NSString *> *)tagTexts;
{
    // 清空标签容器的子控件
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加热门搜索标签
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        label.textColor = [UIColor orangeColor];
        label.layer.borderColor = [UIColor orangeColor].CGColor;
        label.layer.borderWidth = 0.5f;
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    
    // 计算位置
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    // 调整布局
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // 当搜索字数过多，宽度为contentView的宽度
        if (subView.py_width > contentView.py_width) subView.py_width = contentView.py_width;
        if (currentX + subView.py_width + PYMargin * countRow > contentView.py_width) { // 得换行
            subView.py_x = 0;
            subView.py_y = (currentY += subView.py_height) + PYMargin * ++countCol;
            currentX = subView.py_width;
            countRow = 1;
        } else { // 不换行
            subView.py_x = (currentX += subView.py_width) - subView.py_width + PYMargin * countRow;
            subView.py_y = currentY + PYMargin * countCol;
            countRow ++;
        }
    }
    // 设置contentView高度
    contentView.py_height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    // 设置头部高度
    self.baseSearchTableView.tableHeaderView.py_height = self.headerContentView.py_height = CGRectGetMaxY(contentView.frame) + PYMargin * 4;
    // 中间线高度
    self.centecrView.py_y = CGRectGetMaxY(self.hotSearchTagsContentView.frame)+PYMargin*4;
    
    // 取消隐藏
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    // 重新赋值, 注意：当操作系统为iOS 9.x系列的tableHeaderView高度设置失效，需要重新设置tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
    return [tagsM copy];
}

#pragma mark - setter
- (void)setCancelButton:(UIBarButtonItem *)cancelButton
{
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    _searchHistoriesCachePath = [searchHistoriesCachePath copy];
    // 刷新
    self.searchHistories = nil;
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) { // 搜索历史为cell类型
        [self.baseSearchTableView reloadData];
    } else { // 搜索历史为标签类型
        [self setSearchHistoryStyle:self.searchHistoryStyle];
    }
}

- (void)setHotSearchTags:(NSArray<UILabel *> *)hotSearchTags
{
    // 设置热门搜索时(标签tag为1，搜索历史为0)
    for (UILabel *tagLabel in hotSearchTags) {
        tagLabel.tag = 1;
    }
    _hotSearchTags = hotSearchTags;
}

- (void)setSearchBarBackgroundColor:(UIColor *)searchBarBackgroundColor
{
    _searchBarBackgroundColor = searchBarBackgroundColor;
    
    // 取出搜索栏的textField设置其背景色
    for (UIView *subView in [[self.searchBar.subviews lastObject] subviews]) {
        if ([[subView class] isSubclassOfClass:[UITextField class]]) { // 是UItextField
            // 设置UItextField的背景色
            UITextField *textField = (UITextField *)subView;
            textField.backgroundColor = searchBarBackgroundColor;
            // 退出循环
            break;
        }
    }
}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    if (self.searchSuggestionHidden) return; // 如果隐藏，直接返回，避免刷新操作
    
    _searchSuggestions = [searchSuggestions copy];
    // 赋值给搜索建议控制器
    self.searchSuggestionVC.searchSuggestions = [searchSuggestions copy];
}

- (void)setRankTagBackgroundColorHexStrings:(NSArray<NSString *> *)rankTagBackgroundColorHexStrings
{
    if (rankTagBackgroundColorHexStrings.count < 4) { // 不符合要求，使用基本设置
        NSArray *colorStrings = @[@"#f14230", @"#ff8000", @"#ffcc01", @"#ebebeb"];
        _rankTagBackgroundColorHexStrings = colorStrings;
    } else { // 取前四个
        _rankTagBackgroundColorHexStrings = @[rankTagBackgroundColorHexStrings[0], rankTagBackgroundColorHexStrings[1], rankTagBackgroundColorHexStrings[2], rankTagBackgroundColorHexStrings[3]];
    }
    
    // 刷新
    self.hotSearches = self.hotSearches;
}

- (void)setHotSearches:(NSArray *)hotSearches
{
    _hotSearches = hotSearches;
    // 没有热门搜索,隐藏相关控件，直接返回
    if (hotSearches.count == 0) {
        self.baseSearchTableView.tableHeaderView.hidden = YES;
        self.hotSearchHeader.hidden = YES;
        return;
    };
    // 有热门搜索，取消相关隐藏
    self.baseSearchTableView.tableHeaderView.hidden = NO;
    self.hotSearchHeader.hidden = NO;
    // 根据hotSearchStyle设置标签
    if (self.hotSearchStyle == PYHotSearchStyleDefault
        || self.hotSearchStyle == PYHotSearchStyleColorfulTag
        || self.hotSearchStyle == PYHotSearchStyleBorderTag
        || self.hotSearchStyle == PYHotSearchStyleARCBorderTag) { // 不带排名的标签
        [self setupHotSearchNormalTags];
    } else if (self.hotSearchStyle == PYHotSearchStyleRankTag) { // 带有排名的标签
    
    } else if (self.hotSearchStyle == PYHotSearchStyleRectangleTag) { // 矩阵标签
//        [self setupHotSearchRectangleTags];
    }
    // 刷新搜索历史布局
    [self setSearchHistoryStyle:self.searchHistoryStyle];
}

#pragma mark - 搜索历史标签
- (void)setSearchHistoryStyle:(PYSearchHistoryStyle)searchHistoryStyle
{
    _searchHistoryStyle = searchHistoryStyle;
    
    // 默认cell，直接返回
    if (searchHistoryStyle == UISearchBarStyleDefault) return;
    // 创建、初始化默认标签
    [self setupSearchHistoryTags];
    // 根据标签风格设置标签
    switch (searchHistoryStyle) {

        case PYSearchHistoryStyleBorderTag: // 边框标签
            for (UILabel *tag in self.searchHistoryTags) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
//                tag.layer.borderColor = PYColor(223, 223, 223).CGColor;
#pragma mark - 自己添加
                tag.layer.borderColor = [UIColor grayColor].CGColor;
                tag.textColor = [UIColor grayColor];
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
            }
            break;
        default:
            break;
    }
}


/** 键盘显示完成（弹出） */
- (void)keyboardDidShow:(NSNotification *)noti
{
    // 取出键盘高度
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardshowing = YES;
}

/** 点击清空历史按钮 */
- (void)emptySearchHistoryDidClick
{
    // 移除所有历史搜索
    [self.searchHistories removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) {
        // 刷新cell
        [self.baseSearchTableView reloadData];
    } else {
        // 更新
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    PYSearchLog(@"清空历史记录");
}

/** 选中标签 */
- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    self.searchBar.text = label.text;
    
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) { // 搜索历史为标签时，刷新标签
        // 刷新tableView
        [self.baseSearchTableView reloadData];
    } else {
        // 更新
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    
    if (label.tag == 1) { // 热门搜索标签
        // 取出下标
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectHotSearchAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectHotSearchAtIndex:[self.hotSearchTags indexOfObject:label] searchText:label.text];
        } else {
            [self searchBarSearchButtonClicked:self.searchBar];
        }
    } else { // 搜索历史标签
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:[self.searchHistoryTags indexOfObject:label] searchText:label.text];
        } else {
            [self searchBarSearchButtonClicked:self.searchBar];
        }
    }
    PYSearchLog(@"搜索 %@", label.text);
}

// 热门是橘黄色  历史：灰色

/** 添加标签 */
- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
//    label.textColor = [UIColor orangeColor];
//    label.backgroundColor = [UIColor py_colorWithHexString:@"#fafafa"];
#pragma mark - 自己添加
//    label.layer.borderWidth = 0.5f;
//    label.layer.borderColor = [UIColor orangeColor].CGColor;
    
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.py_width += 20;
    label.py_height += 14;
    return label;
}

#pragma mark - PYSearchSuggestionViewDataSource
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchSuggestionView:)]) {
        return [self.dataSource numberOfSectionsInSearchSuggestionView:searchSuggestionView];
    }
    return 1;
}

- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:numberOfRowsInSection:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView numberOfRowsInSection:section];
    }
    return self.searchSuggestions.count;
}

- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:heightForRowAtIndexPath:)]) {
        return [self.dataSource searchSuggestionView:searchSuggestionView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 回收键盘
    [searchBar resignFirstResponder];
    // 先移除再刷新
    [self.searchHistories removeObject:searchBar.text];
    [self.searchHistories insertObject:searchBar.text atIndex:0];
    // 刷新数据
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) { // 普通风格Cell
        [self.baseSearchTableView reloadData];
    } else { // 搜索历史为标签
        // 更新
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoriesCachePath];
    // 处理搜索结果
    switch (self.searchResultShowMode) {
        case PYSearchResultShowModePush: // Push
            [self.navigationController pushViewController:self.searchResultController animated:YES];
            break;
        case PYSearchResultShowModeEmbed: // 内嵌
            // 添加搜索结果的视图
            [self.view addSubview:self.searchResultController.tableView];
            [self addChildViewController:self.searchResultController];
            break;
        case PYSearchResultShowModeCustom: // 自定义
            
            break;
        default:
            break;
    }
    // 如果代理实现了代理方法则调用代理方法
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithsearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSearchWithsearchBar:searchBar searchText:searchBar.text];
        return;
    }
    // 如果有block则调用
    if (self.didSearchBlock) self.didSearchBlock(self, searchBar, searchBar.text);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 如果有搜索文本且显示搜索建议，则隐藏
    self.baseSearchTableView.hidden = searchText.length && !self.searchSuggestionHidden;
    // 根据输入文本显示建议搜索条件
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchText.length;
    // 放在最上层
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    // 如果代理实现了代理方法则调用代理方法
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchText];
    }
}

- (void)closeDidClick:(UIButton *)sender
{
    // 获取当前cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    // 移除搜索信息
    [self.searchHistories removeObject:cell.textLabel.text];
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:PYSearchHistoriesPath];
    // 刷新
    [self.baseSearchTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 没有搜索记录就隐藏
    self.baseSearchTableView.tableFooterView.hidden = self.searchHistories.count == 0;
    return  self.searchHistoryStyle == PYSearchHistoryStyleCell ? self.searchHistories.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PYSearchHistoryCellID";
    // 创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = PYTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor redColor];
        
        // 添加关闭按钮
        UIButton *closetButton = [[UIButton alloc] init];
        // 设置图片容器大小、图片原图居中
        closetButton.py_size = CGSizeMake(cell.py_height, cell.py_height);
        [closetButton setImage:[UIImage imageNamed:@"PYSearch.bundle/close"] forState:UIControlStateNormal];
        UIImageView *closeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/close"]];
        [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
        closeView.contentMode = UIViewContentModeCenter;
        cell.accessoryView = closetButton;
        // 添加分割线
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/cell-content-line"]];
        line.py_height = 0.5;
        line.alpha = 0.7;
        line.py_x = PYMargin;
        line.py_y = 43;
        line.py_width = PYScreenW;
        [cell.contentView addSubview:line];
    }
    
    // 设置数据
    cell.imageView.image = PYSearchHistoryImage;
    cell.textLabel.text = self.searchHistories[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.searchHistories.count && self.searchHistoryStyle == PYSearchHistoryStyleCell ? PYSearchHistoryText : nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出选中的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = cell.textLabel.text;
    
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchHistoryAtIndex:searchText:)]) { // 实现代理方法则调用，则搜索历史时searchViewController:didSearchWithsearchBar:searchText:失效
        [self.delegate searchViewController:self didSelectSearchHistoryAtIndex:indexPath.row searchText:cell.textLabel.text];
    } else {
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动时，回收键盘
    if (self.keyboardshowing) [self.searchBar resignFirstResponder];
}

@end
