// RDVCalendarDayCell.m
// RDVCalendarView
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVCalendarDayCell.h"

@interface RDVCalendarDayCell() {
    BOOL _selected;
    BOOL _highlighted;
}

@end

@implementation RDVCalendarDayCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = [reuseIdentifier copy];
        _selectionStyle = RDVCalendarDayCellSelectionStyleDefault;
        
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_backgroundView];
        //セルの角を丸くする
        _backgroundView.layer.cornerRadius =10;
        
        _selectedBackgroundView = [[UIView alloc] init];
        [_selectedBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
        [_selectedBackgroundView setAlpha:0];
        //セルの角を丸くする
        _selectedBackgroundView.layer.cornerRadius =10;
        [self addSubview:_selectedBackgroundView];
        
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
        
        //日付の色
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTextColor:[UIColor blackColor]];
//        [_textLabel setHighlightedTextColor:[UIColor whiteColor]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
//        [_textLabel setFont:[UIFont systemFontOfSize:20]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [_textLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:20]];
        }else{
            [_textLabel setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:40]];
        }
        [_contentView addSubview:_textLabel];
        
        
        //読み終わった日付はグレー色にする
        _textLabel2 =[[UILabel alloc] init];
        [_textLabel2 setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        [_textLabel2 setBackgroundColor:[UIColor clearColor]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [_textLabel2 setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:20]];
        }else{
            [_textLabel2 setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:40]];
        }
        [_contentView addSubview:_textLabel2];
        
        
        
    }
    return self;
}

- (id)init {
    return [self initWithReuseIdentifier:@""];
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGSize titleSize = [[self textLabel] sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    CGSize titleSize2 = [[self textLabel2] sizeThatFits:CGSizeMake(frameSize.width, frameSize.height)];
    
    [[self backgroundView] setFrame:self.bounds];
    [[self selectedBackgroundView] setFrame:self.bounds];
    [[self contentView] setFrame:self.bounds];
    
    [[self textLabel] setFrame:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2),
                                           roundf(frameSize.height / 2 - titleSize.height / 2),
                                           titleSize.width, titleSize.height)];
    [[self textLabel2] setFrame:CGRectMake(roundf(frameSize.width / 2 - titleSize2.width / 2),
                                          roundf(frameSize.height / 2 - titleSize2.height / 2),
                                          titleSize2.width, titleSize2.height)];
}

#pragma mark - Selection

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected == _selected) {
        return;
    }
    
    _selected = selected;
    _highlighted = NO;
    
    if ([self selectionStyle] != RDVCalendarDayCellSelectionStyleNone) {
        __weak RDVCalendarDayCell *weakSelf = self;
        
        void (^block)() = ^{
            if (selected) {
                [[weakSelf backgroundView] setAlpha:0.0f];
                [[weakSelf selectedBackgroundView] setAlpha:1.0f];
            } else {
                [[weakSelf backgroundView] setAlpha:1.0f];
                [[weakSelf selectedBackgroundView] setAlpha:0.0f];
            }
            for (id subview in [[weakSelf contentView] subviews]) {
                if ([subview respondsToSelector:@selector(setHighlighted:)]) {
                    [subview setHighlighted:selected];
                }
            }
        };
        
        if (animated) {
            [UIView animateWithDuration:0.25f animations:block];
        } else {
            block();
        }
    }
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (BOOL)isHighlighted {
    return _highlighted;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted == _highlighted) {
        return;
    }
    
    _highlighted = highlighted;
    _selected = NO;
    
    if ([self selectionStyle] != RDVCalendarDayCellSelectionStyleNone) {
        __weak RDVCalendarDayCell *weakSelf = self;
        
        void (^block)() = ^{
            if (highlighted) {
                [[weakSelf backgroundView] setAlpha:0.0f];
                [[weakSelf selectedBackgroundView] setAlpha:1.0f];
            } else {
                [[weakSelf backgroundView] setAlpha:1.0f];
                [[weakSelf selectedBackgroundView] setAlpha:0.0f];
            }
            for (id subview in [[weakSelf contentView] subviews]) {
                if ([subview respondsToSelector:@selector(setHighlighted:)]) {
                    [subview setHighlighted:highlighted];
                }
            }
        };
        
        if (animated) {
            [UIView animateWithDuration:0.25f animations:block];
        } else {
            block();
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [self setHighlighted:highlighted animated:NO];
}

#pragma mark - Cell reuse

- (void)prepareForReuse {
    [self setSelected:NO];
    [self setHighlighted:NO];
    
    [[self textLabel] setText:@""];
    [[self textLabel2] setText:@""];
}

@end
