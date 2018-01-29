//
//  ViewController.m
//  PDFExcelDemo
//
//  Created by pang on 2018/1/29.
//  Copyright © 2018年 zk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *header = @[@"Quantity", @"Description", @"Unit price", @"Total"];
    NSArray *invoiceInfo1 = @[@"1", @"Development", @"$1000", @"1000"];
    NSArray *invoiceInfo2 = @[@"1", @"Development", @"$1000", @"1000"];
    NSArray *invoiceInfo3 = @[@"1", @"Development", @"$1000", @"1000"];
    NSArray *invoiceInfo4 = @[@"1", @"Development", @"$1000", @"1000"];
    NSArray *allInfo = @[header, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4];
    
    self.data = allInfo;
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"test.PDF"];
    [self drawPDF:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [self.webView loadRequest:request];
    
}

- (void)drawPDF:(NSString *)filePath {
    
    //开始绘制
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    //创建第一页  页面大小
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), nil);

    [self drawTableAt:CGPointMake(20, 20) withRowHeight:40 andColumnWidth:100];
    
    [self drawTableDataAt:CGPointMake(20, 20) withRowHeight:40 andColumnWidth:100];
    //結束
    UIGraphicsEndPDFContext();
}



/**
 画表格

 @param origin 起点
 @param rowHeight 行高
 @param columnWidth 列宽
 */
- (void)drawTableAt:(CGPoint)origin withRowHeight:(int)rowHeight andColumnWidth:(int)columnWidth {
    if (self.data.count == 0) {
        return;
    }
    //設置線條
    //獲取上下文
    CGContextRef conxtext = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(conxtext, kCGLineCapRound);   //端
    CGContextSetLineWidth(conxtext, 1); //線寬
    [[UIColor grayColor] setStroke]; //設置填充色
    CGContextBeginPath(conxtext);
    
    NSArray *titleData = [self.data firstObject];
    NSUInteger numberOfRows = self.data.count;
    NSUInteger numberOfColumns = titleData.count;
    
    //绘制水平线
    for (int i = 0; i <= self.data.count ; i++) {
        int newOrigin = origin.y + (rowHeight * i);
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns * columnWidth), newOrigin);
        
        CGContextMoveToPoint(conxtext, from.x, from.y);
        CGContextAddLineToPoint(conxtext, to.x, to.y);
        
    }
    
    //绘制垂直线
    for (int i = 0; i <= numberOfColumns; i++) {
        int newOrigin = origin.x + (columnWidth * i);
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y + (numberOfRows * rowHeight));
        
        CGContextMoveToPoint(conxtext, from.x, from.y);
        CGContextAddLineToPoint(conxtext, to.x, to.y);
    }
    
    CGContextStrokePath(conxtext);
}

- (void)drawTableDataAt:(CGPoint)origin
          withRowHeight:(int)rowHeight
         andColumnWidth:(int)columnWidth
{
    if (self.data.count == 0) {
        return;
    }
    //獲取上下文
    CGContextRef conxtext = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(conxtext, kCGLineCapRound);   //端
    CGContextSetLineWidth(conxtext, 1); //線寬
    [[UIColor grayColor] setStroke]; //設置填充色
    
    CGFloat padding = 10;
    for (int i = 0; i < self.data.count; i++) {
        NSArray *rowData = self.data[i];
        for (int j = 0; j< rowData.count; j++) {
            int newOriginX = origin.x + (columnWidth * j);
            int newOriginY = origin.y + (rowHeight * i);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            NSString *text = rowData[j];
            [text drawInRect:frame withAttributes:nil];
        }
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
