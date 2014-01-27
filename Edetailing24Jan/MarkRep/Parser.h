//
//  Parser.h
//  MyDay
//
//  Created by Karbens on 10/18/13.
//  Copyright (c) 2013 Karbens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"
#import "Parent.h"
#import "Child.h"
#import "Brand.h"
#import "Reference.h"
#import "DataList.h"
#import "Summary.h"

@protocol ParserDelegate <NSObject>

-(void)getContents;
- (void)loadGridView;
-(void)didFail;
@end

@interface Parser : NSObject <NSXMLParserDelegate,NSURLConnectionDelegate>{
   
    NSXMLParser *XmlParser;
    BOOL errorParsing;
    NSString *currentElement;
    NSMutableString *ElementValue;
    NSMutableArray *ParentsArray, *childArray,*ContentArray,*BrandArray,*ReferenceArr,*DataListArr,*SummaryArray;
    NSMutableDictionary *ContentDict,*ParentDict,*ChildDict,*BrandDict,*ReferenceDict,*DataListDict;
    Content *aContent;
    BOOL _isContent,_isParent,_isChild,_isBrand,_isReference,_isDataList,_isSummary;
    int i;
    NSMutableData *requestedData;
      id aDelegate;
    
}
@property(nonatomic,assign) id <ParserDelegate> aDelegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property(nonatomic,retain)NSMutableDictionary *item,*ContentDict,*ParentDict,*ChildDict,*ReferenceDict,*DataListDict,*SummaryDict;
@property(nonatomic,retain)Content *aContent;
@property(nonatomic,retain)Parent *aParent;
@property(nonatomic,retain)Child *aChild;
@property(nonatomic,retain)Brand *aBrand;
@property(nonatomic,retain)Reference *aReference;
@property(nonatomic,retain)DataList *aDatalist;
@property(nonatomic,retain)Summary *aSummary;

- (NSData *)dataAtIndex:(NSInteger)idx;
- (id)initWithUrl:(NSString *)aUrl;
- (void)requestWithUrls:(NSString *)aUrl;
//@property (nonatomic, assign) id < ParserDelegate > aDelegate;

@end
