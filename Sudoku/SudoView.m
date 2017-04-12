//
//  SudoView.m
//  Sudoku
//
//  Created by CSX on 2017/4/11.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "SudoView.h"
#import "SudoModel.h"

typedef enum :NSInteger{
    BTNTags = 10,
}Tags;

@interface SudoView ()
{
    int cellWidth;
    NSString *titleStr;
    UIView *bgView;
}
@property (nonatomic , strong)NSMutableArray *dataArr;
@end

@implementation SudoView
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (int i = 0; i<81; i++) {
            [_dataArr addObject:@""];
        }
    }
    return _dataArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        cellWidth = (frame.size.width-20)/9;
        [self createViewWithFrame:frame];
        
        [self createButtonViewWithFrame:frame];
    }
    return self;
}
- (void)createViewWithFrame:(CGRect)frame{
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width, frame.size.width)];
    bgView.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
    bgView.layer.cornerRadius = 5;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    for (int i = 0; i < 81; i++) {
        UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        if (i%9>=3 && i%9 <6) {
            myCreateButton = [self createWithBegain:10 andIndex:i];
        }else if (i%9 >= 6){
            myCreateButton = [self createWithBegain:15 andIndex:i];
        }else{
            myCreateButton = [self createWithBegain:5 andIndex:i];
        }
        [myCreateButton setBackgroundColor:[UIColor lightGrayColor]];
        myCreateButton.titleLabel.layer.cornerRadius = 5;
        int a = arc4random()%5;
        NSString *title;
        if (a==1) {
            title = [self titleWithIndex:i];
        }else{
           title = @"";
        }
        [self.dataArr replaceObjectAtIndex:i withObject:title];
        [myCreateButton setTitle:title forState:UIControlStateNormal];
        myCreateButton.tag = BTNTags+i;
        myCreateButton.titleLabel.clipsToBounds = YES;
        [myCreateButton addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:myCreateButton];
    }
    
}
//递归生成
- (NSString *)titleWithIndex:(int)i{
    static NSString *title;
    title = [NSString stringWithFormat:@"%d",arc4random()%9+1];
    if ([SudoModel isSatisfyWithDataArr:self.dataArr WithIndex:i AndTitle:title]) {
        return title;
    }else{
       return [self titleWithIndex:i];
    }
}
- (UIButton *)createWithBegain:(int)index andIndex:(int)i{
    UIButton *myCreateButton = [[UIButton alloc]init];
    if (i/9 >= 3 && i/9 <6) {
        myCreateButton.frame = CGRectMake(index+cellWidth*(i%9), 10+cellWidth*(i/9), cellWidth-5, cellWidth-5);
    }else if (i/9 >= 6) {
        myCreateButton.frame = CGRectMake(index+cellWidth*(i%9), 15+cellWidth*(i/9), cellWidth-5, cellWidth-5);
    }else{
        myCreateButton.frame = CGRectMake(index+cellWidth*(i%9), 5+cellWidth*(i/9), cellWidth-5, cellWidth-5);
    }
    return myCreateButton;
}

- (void)buttonChoose:(UIButton *)sender{
    [sender setTitle:titleStr forState:UIControlStateNormal];
    [SudoModel isSatisfyWithDataArr:self.dataArr WithIndex:(int)(sender.tag-BTNTags) AndTitle:titleStr WithBlock:^(BOOL isSatisfy, NSArray *errIndexArr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isSatisfy) {
                for (int i = 0; i<errIndexArr.count; i++) {
                    int ind = [errIndexArr[i] intValue];
                    UIButton *btn = [bgView viewWithTag:ind+BTNTags];
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                titleStr = @"";
            }
        });
    }];
}
- (void)createButtonViewWithFrame:(CGRect)frame{
    int celWidth = (frame.size.width-20)/6;
    for (int i = 0; i<11; i++) {
        UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myCreateButton.frame = CGRectMake(10+i%6*celWidth, frame.size.width+25+(i/6)*75,celWidth-5, 50);
        [myCreateButton setBackgroundColor:[UIColor grayColor]];
        if (i == 9) {
            [myCreateButton setTitle:@"A" forState:UIControlStateNormal];
        }else if (i == 10){
            [myCreateButton setTitle:@"C" forState:UIControlStateNormal];
        }else{
          [myCreateButton setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        }
        [myCreateButton addTarget:self action:@selector(titleChoose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:myCreateButton];
    }
}
- (void)titleChoose:(UIButton *)sender{
    titleStr = sender.titleLabel.text;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end