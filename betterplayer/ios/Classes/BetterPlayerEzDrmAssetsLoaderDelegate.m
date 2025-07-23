// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "BetterPlayerEzDrmAssetsLoaderDelegate.h"


@implementation BetterPlayerEzDrmAssetsLoaderDelegate

NSString *_assetId;

NSString *DEFAULT_LICENSE_SERVER_URL = @"https://fps.ezdrm.com/api/licenses/";

- (instancetype)init:(NSURL *)certificateURL withLicenseURL:(NSURL *)licenseURL {
    self = [super init];
    _certificateURL = certificateURL;
    _licenseURL = licenseURL;
    return self;
}

/*------------------------------------------
 **
 ** getContentKeyAndLeaseExpiryFromKeyServerModuleWithRequest
 **
 ** Takes the bundled SPC and sends it to the license server defined at licenseUrl or KEY_SERVER_URL (if licenseUrl is null).
 ** It returns CKC.
 ** ---------------------------------------*/
- (NSData *)getContentKeyAndLeaseExpiryFromKeyServerModuleWithRequest:(NSData *)requestBytes and:(NSString *)assetId and:(NSString *)customParams and:(NSError *)errorOut {
    NSData *decodedData;
    NSURLResponse *response;

    NSURL *finalLicenseURL;
    if (_licenseURL != [NSNull null]) {
        finalLicenseURL = _licenseURL;
    } else {
        finalLicenseURL = [[NSURL alloc] initWithString:DEFAULT_LICENSE_SERVER_URL];
    }
    NSURL *ksmURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", finalLicenseURL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:ksmURL];


    [request setHTTPMethod:@"POST"];

    // Encode requestBytes to Base64
    NSString *base64RequestBytes = [requestBytes base64EncodedStringWithOptions:0];
    NSString *spcRequest = [NSString stringWithFormat:@"spc=%@", base64RequestBytes];

    [request setHTTPBody:[spcRequest dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request addValue:@"de236319-cabd-4102-b240-98d92ec0db3a" forHTTPHeaderField:@"SWANKPORTAL"];


    NSData *ckcData;
    @try {
        decodedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

        NSString *ckcStr = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        // our ckc starts with <ckc> and ends with </ckc> we need to strip that off
        NSString *newckcStr = [ckcStr stringByReplacingOccurrencesOfString:@"<ckc>" withString:@""];
        newckcStr = [newckcStr stringByReplacingOccurrencesOfString:@"</ckc>" withString:@""];

        ckcData = [[NSData alloc] initWithBase64EncodedString:newckcStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

    }
    @catch (NSException *excp) {
        NSLog(@"SDK Error, SDK responded with Error: (error)");
    }


    return ckcData;
}

/*------------------------------------------
 **
 ** getAppCertificate
 **
 ** returns the apps certificate for authenticating against your server
 ** the example here uses a local certificate
 ** but you may need to edit this function to point to your certificate
 ** ---------------------------------------*/
- (NSData *)getAppCertificate:(NSString *)String {
    NSData *certificate = nil;
    certificate = [NSData dataWithContentsOfURL:_certificateURL];
    return certificate;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSURL *assetURI = loadingRequest.request.URL;
    NSString *str = assetURI.absoluteString;

    _assetId = [str stringByReplacingOccurrencesOfString:@"skd://" withString:@""];

    NSString *scheme = assetURI.scheme;
    NSData *requestBytes;
    NSData *certificate;
    if (!([scheme isEqualToString:@"skd"])) {
        return NO;
    }
    @try {
        certificate = [self getAppCertificate:_assetId];
    }

    @catch (NSException *excp) {
        [loadingRequest finishLoadingWithError:[[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorClientCertificateRejected userInfo:nil]];
    }
    @try {
        requestBytes = [loadingRequest streamingContentKeyRequestDataForApp:certificate contentIdentifier:[_assetId dataUsingEncoding:NSUTF8StringEncoding] options:nil error:nil];
    }
    @catch (NSException *excp) {
        [loadingRequest finishLoadingWithError:nil];
        return YES;
    }

    NSString *passthruParams = [NSString stringWithFormat:@"?customdata=%@", _assetId];
    NSData *responseData;
    NSError *error;

    responseData = [self getContentKeyAndLeaseExpiryFromKeyServerModuleWithRequest:requestBytes and:_assetId and:passthruParams and:error];

    if (responseData != nil && responseData != NULL &&
        ![responseData.class isKindOfClass:NSNull.class]) {
        AVAssetResourceLoadingDataRequest *dataRequest = loadingRequest.dataRequest;
        [dataRequest respondWithData:responseData];
        [loadingRequest finishLoading];
    } else {
        [loadingRequest finishLoadingWithError:error];
    }

    return YES;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForRenewalOfRequestedResource:(AVAssetResourceRenewalRequest *)renewalRequest {
    return [self resourceLoader:resourceLoader shouldWaitForLoadingOfRequestedResource:renewalRequest];
}

@end
