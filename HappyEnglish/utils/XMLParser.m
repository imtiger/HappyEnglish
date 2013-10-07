//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "XMLParser.h"
#import "Word.h"
#import "GDataXMLNode.h"


@implementation XMLParser {

}
+ (Word *)parseWord:(NSData *)data {
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    if (doc == nil) {return nil;}
    Word *word = [[Word alloc] init];
    GDataXMLElement *rootElement = doc.rootElement;
    NSLog(@"%@", rootElement);

    NSArray *keys = [rootElement elementsForName:@"key"];
    if (keys && keys.count > 0) {
        GDataXMLElement *key = (GDataXMLElement *) [keys objectAtIndex:0];
        word.source = key.stringValue;
    }

    NSArray *phoneticSymbols = [rootElement elementsForName:@"ps"];
    if (phoneticSymbols && phoneticSymbols.count > 0) {
        GDataXMLElement *phoneticSymbol = (GDataXMLElement *) [phoneticSymbols objectAtIndex:0];
        word.phoneticSymbol = phoneticSymbol.stringValue;
    }
    NSArray *pronounce = [rootElement elementsForName:@"pron"];
    if (pronounce && pronounce.count > 0) {
        GDataXMLElement *pronunciationUrl = (GDataXMLElement *) [pronounce objectAtIndex:0];
        word.pronunciationUrl = pronunciationUrl.stringValue;
    }
    NSArray *poses = [rootElement elementsForName:@"pos"];
    NSArray *acceptations = [rootElement elementsForName:@"acceptation"];
    for (int i = 0; i < poses.count && i < acceptations.count; i++) {
        GDataXMLElement *pos = [poses objectAtIndex:i];
        GDataXMLElement *acceptation = [acceptations objectAtIndex:i];
        NSMutableDictionary *meaning = [[NSMutableDictionary alloc] init];
        [meaning setObject:pos.stringValue forKey:@"pos"];
        [meaning setObject:acceptation.stringValue forKey:@"acceptaion"];
        [word addMeaning:meaning];
    }
    return word;
}

@end