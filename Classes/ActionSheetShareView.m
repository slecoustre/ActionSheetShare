//
//  ActionSheetShareView.m
//  Tools
//
//  Created by Stephane on 12/12/2014.
//  Copyright (c) 2014 Stephane. All rights reserved.
//

#import "ActionSheetShareView.h"
#import <pop/POP.h>

#define MARGIN 10.0
#define CORNER_RADIUS 5.0
#define HEIGHT_BUTTON_DEFAULT 50
#define HEIGHT_LIST_DEFAULT 150
#define WIDTH_ITEM 85
#define FONT_SIZE_BUTTON_DEFAULT 22

@interface ActionSheetShareButtonTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString* buttonText;
@property (assign, nonatomic) BOOL isLast;
@property (strong,nonatomic) UILabel* label;
@end

@implementation ActionSheetShareButtonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.label = [UILabel new];
        self.label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:FONT_SIZE_BUTTON_DEFAULT];
        
        //todo voir pour récuperer la valeur par défaut
        self.label.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1 alpha:1.0];
        
        [self addSubview:self.label];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger remove = 1;
    if(self.isLast){
        remove = 0;
    }
    self.label.frame = CGRectMake(0.0, 0.0,self.frame.size.width,self.frame.size.height-remove);
}

-(void)setButtonText:(NSString*)buttonText{
    _buttonText = buttonText;
    self.label.text = buttonText;
}

@end

@interface ActionSheetShareListTableViewCell : UITableViewCell

@property (strong, nonatomic) UICollectionView* collectionView;
@property (assign, nonatomic) BOOL isLast;

@end

@implementation ActionSheetShareListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(WIDTH_ITEM, HEIGHT_LIST_DEFAULT);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];

        [self addSubview:self.collectionView];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger remove = 1;
    if(self.isLast){
        remove = 0;
    }
    self.collectionView.frame = CGRectMake(0.0, 0.0,self.frame.size.width,self.frame.size.height-remove);
}

@end

@interface ActionSheetShareButtonCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) UIImage* image;
@property (strong,nonatomic) UIImageView* imageView;
@property (strong,nonatomic) NSString* buttonText;
@property (strong,nonatomic) UILabel* label;
@end

@implementation ActionSheetShareButtonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        NSInteger width = self.frame.size.width - (2 * MARGIN);
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN, 3 * MARGIN, width, width)];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(2, 4 * MARGIN + width, self.frame.size.width - 4, 40)];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines =2;
        [self addSubview:self.label];
    }
    
    return self;
}

-(void)setButtonText:(NSString *)buttonText{
    _buttonText = buttonText;
    self.label.text = buttonText;
    [self.label sizeToFit];
    CGRect frame = self.label.frame;
    self.label.frame = CGRectMake(frame.origin.x, frame.origin.y, self.frame.size.width - 4, frame.size.height);
}

-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

@end

@interface ActionSheetShareView ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView* contentView;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIButton* cancelButton;
@property (assign, nonatomic) NSInteger currentNbRow;
@property (assign, nonatomic) CGRect frameShow;
@property (assign, nonatomic) CGRect frameHide;
@property (strong, nonatomic) NSArray* colors;

@end

@implementation ActionSheetShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        
    }
    
    return self;
}

- (void)show{
    CGFloat height = 0.0;
    NSInteger nbRows = [self tableView:nil numberOfRowsInSection:0];
    for (NSInteger i = 0; i<nbRows; i++) {
        height += [self tableView:nil heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    CGRect currentFrame = self.frame;
    self.tableView.frame = CGRectMake(MARGIN, currentFrame.size.height - (2*MARGIN) - HEIGHT_BUTTON_DEFAULT - height, currentFrame.size.width - (MARGIN*2), height);

    [self.tableView reloadData];
    //animation pour le overlay
    POPBasicAnimation *animAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animAlpha.fromValue = @(0.0);
    animAlpha.toValue = @(1.0);
    self.frame = self.frameShow;
    [self pop_removeAllAnimations];
    [self pop_addAnimation:animAlpha forKey:@"fade"];
    
    POPBasicAnimation *animPosY = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animPosY.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self.contentView pop_removeAllAnimations];
    [self.contentView pop_addAnimation:animPosY forKey:@"slide"];
}


- (void)hide{
    //animation pour le overlay
    POPBasicAnimation *animAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha ];
    animAlpha.fromValue = @(1.0);
    animAlpha.toValue = @(0.0);
    [self pop_removeAllAnimations];
    [self pop_addAnimation:animAlpha forKey:@"fade"];
    
    POPBasicAnimation *animPosY = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animPosY.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height*3/2)];
    [self.contentView pop_removeAllAnimations];
    [self.contentView pop_addAnimation:animPosY forKey:@"slide"];
}

- (void)initialize{
    self.colors = @[
                    [UIColor colorWithRed:1 green:0 blue:0 alpha:1],
                    [UIColor colorWithRed:0 green:1 blue:0 alpha:1],
                    [UIColor colorWithRed:0 green:0 blue:1 alpha:1]];
    
    self.frameHide = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frameShow = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.frame = self.frameHide;
    self.clipsToBounds = YES;
    [self initializeOverlay];
    [self initializeContent];
}

- (void)initializeOverlay{
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
}

- (void)handleTapFrom:(UITapGestureRecognizer*)recognizer{
    [self hide];
}

- (void)initializeContent{
    self.contentView = [[UIView alloc]initWithFrame:self.frameHide];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    UIView* tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UITapGestureRecognizer* tapGestureRecognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [tapView addGestureRecognizer:tapGestureRecognizer];
    [self.contentView addSubview:tapView];
    [self initializeCancel];
    [self initializeTableView];
    

}

- (void)initializeCancel {
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.text = @"Cancel";
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE_BUTTON_DEFAULT];
    self.cancelButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.cancelButton.layer.cornerRadius = CORNER_RADIUS;
    CGRect currentFrame = self.frame;
    self.cancelButton.frame = CGRectMake(MARGIN, currentFrame.size.height - MARGIN - HEIGHT_BUTTON_DEFAULT, currentFrame.size.width - (MARGIN*2), HEIGHT_BUTTON_DEFAULT);
    
    [self.contentView addSubview:self.cancelButton];

    [self.cancelButton addTarget:self action:@selector(handelPushFrom:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handelPushFrom:(id)sender{
    [self hide];
}

- (void)initializeTableView{
    self.tableView = [UITableView new];
    self.tableView.layer.cornerRadius = CORNER_RADIUS;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = HEIGHT_BUTTON_DEFAULT;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = NO;
    
    [self.tableView registerClass:[ActionSheetShareButtonTableViewCell class] forCellReuseIdentifier:@"Button"];
    [self.tableView registerClass:[ActionSheetShareListTableViewCell class] forCellReuseIdentifier:@"List"];
    [self.contentView addSubview:self.tableView];
}

-(void)setButtonText:(NSString *)buttonText{
    _buttonText = buttonText;
    [self.cancelButton setTitle:buttonText forState:UIControlStateNormal];
    self.cancelButton.titleLabel.text = buttonText;
}

#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger nbRows = 1;
    if([self.dataSource respondsToSelector:@selector(numberOfRowsInActionShareView:)])
        nbRows = [self.dataSource numberOfRowsInActionShareView:self];
    
    self.currentNbRow = nbRows;
    return nbRows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger nbCells = 1;
    if ([self.dataSource respondsToSelector:@selector(actionShareView:numberOfCellsInRow:)]) {
        nbCells = [self.dataSource actionShareView:self numberOfCellsInRow:indexPath.row];
    }
    
    if(nbCells == 1){
        ActionSheetShareButtonTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Button" forIndexPath:indexPath];
        cell.buttonText = [self.dataSource actionShareView:self buttonTextForItemAtIndexPath:indexPath];
        cell.isLast = indexPath.row == self.currentNbRow -1;
        return cell;
    }
    else{
        ActionSheetShareListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"List" forIndexPath:indexPath];
        cell.isLast = indexPath.row == self.currentNbRow -1;
        [cell.collectionView registerClass:[ActionSheetShareButtonCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        cell.collectionView.tag = indexPath.row;
        return cell;
    }
    
}

#pragma mark <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger nbCells = 1;
    if ([self.dataSource respondsToSelector:@selector(actionShareView:numberOfCellsInRow:)]) {
        nbCells = [self.dataSource actionShareView:self numberOfCellsInRow:indexPath.row];
    }

    if(nbCells > 1){
        return HEIGHT_LIST_DEFAULT;
    }
    else{
        return HEIGHT_BUTTON_DEFAULT;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(actionShareView:didSelectItemAtIndexPath:)]){
        [self.delegate actionShareView:self didSelectItemAtIndexPath:indexPath];
    }
    [self hide];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource actionShareView:self numberOfCellsInRow:collectionView.tag];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ActionSheetShareButtonCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.buttonText = [self.dataSource actionShareView:self buttonTextForItemAtIndexPath:[NSIndexPath indexPathForRow:collectionView.tag inSection:indexPath.row]];
    if([self.dataSource respondsToSelector:@selector(actionShareView:imageForItemAtIndexPath:)]){
        cell.image = [self.dataSource actionShareView:self imageForItemAtIndexPath:[NSIndexPath indexPathForRow:collectionView.tag inSection:indexPath.row]];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(actionShareView:didSelectItemAtIndexPath:)]){
        [self.delegate actionShareView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:collectionView.tag inSection:indexPath.row]];
    }
    [self hide];
}

@end
