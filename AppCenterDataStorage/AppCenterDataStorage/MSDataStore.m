#import "MSDataStore.h"
#import "MSAppCenterInternal.h"
#import "MSAppDelegateForwarder.h"
#import "MSAuthTokenContext.h"
#import "MSChannelUnitConfiguration.h"
#import "MSChannelUnitProtocol.h"
#import "MSDataStoreError.h"
#import "MSDataStoreInternal.h"
#import "MSDataStorePrivate.h"
#import "MSDocumentWrapper.h"
#import "MSHttpIngestion.h"
#import "MSPaginatedDocuments.h"
#import "MSReadOptions.h"
#import "MSStorageIngestion.h"
#import "MSTokenExchange.h"
#import "MSWriteOptions.h"

/**
 * Service storage key name.
 */
static NSString *const kMSServiceName = @"DataStorage";

/**
 * The group ID for storage.
 */
static NSString *const kMSGroupId = @"DataStorage";

/**
 * Singleton.
 */
static MSDataStore *sharedInstance = nil;
static dispatch_once_t onceToken;

@implementation MSDataStore

@synthesize channelUnitConfiguration = _channelUnitConfiguration;

#pragma mark - Service initialization

- (instancetype)init {
  if ((self = [super init])) {
    _tokenExchangeUrl = kMSDefaultApiUrl;
  }
  return self;
}
#pragma mark - Service methods

+ (void)readWithPartition:(NSString *)partition
               documentId:(NSString *)documentId
             documentType:(Class)documentType
        completionHandler:(MSDocumentWrapperCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)documentType;
  (void)completionHandler;
}

+ (void)readWithPartition:(NSString *)partition
               documentId:(NSString *)documentId
             documentType:(Class)documentType
              readOptions:(MSReadOptions *)readOptions
        completionHandler:(MSDocumentWrapperCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)documentType;
  (void)readOptions;
  (void)completionHandler;
}

+ (void)listWithPartition:(NSString *)partition
             documentType:(Class)documentType
        completionHandler:(MSPaginatedDocumentsCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentType;
  (void)completionHandler;
}

+ (void)listWithPartition:(NSString *)partition
             documentType:(Class)documentType
              readOptions:(MSReadOptions *)readOptions
        completionHandler:(MSPaginatedDocumentsCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentType;
  (void)readOptions;
  (void)completionHandler;
}

+ (void)createWithPartition:(NSString *)partition
                 documentId:(NSString *)documentId
                   document:(id<MSSerializableDocument>)document
          completionHandler:(MSDocumentWrapperCompletionHandler)completionHandler {
  // @todo

  (void)partition;
  (void)documentId;
  (void)document;
  (void)completionHandler;
}

+ (void)createWithPartition:(NSString *)partition
                 documentId:(NSString *)documentId
                   document:(id<MSSerializableDocument>)document
               writeOptions:(MSWriteOptions *)writeOptions
          completionHandler:(MSDocumentWrapperCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)writeOptions;
  (void)document;
  (void)completionHandler;
}

+ (void)replaceWithPartition:(NSString *)partition
                  documentId:(NSString *)documentId
                    document:(id<MSSerializableDocument>)document
           completionHandler:(MSDocumentWrapperCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)document;
  (void)completionHandler;
}

+ (void)replaceWithPartition:(NSString *)partition
                  documentId:(NSString *)documentId
                    document:(id<MSSerializableDocument>)document
                writeOptions:(MSWriteOptions *)writeOptions
           completionHandler:(MSDocumentWrapperCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)document;
  (void)writeOptions;
  (void)completionHandler;
}

+ (void)deleteDocumentWithPartition:(NSString *)partition
                         documentId:(NSString *)documentId
                  completionHandler:(MSDataStoreErrorCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)completionHandler;
}

+ (void)deleteDocumentWithPartition:(NSString *)partition
                         documentId:(NSString *)documentId
                       writeOptions:(MSWriteOptions *)writeOptions
                  completionHandler:(MSDataStoreErrorCompletionHandler)completionHandler {
  // @todo
  (void)partition;
  (void)documentId;
  (void)writeOptions;
  (void)completionHandler;
}

#if TARGET_OS_OSX
- (void)dealloc {
}

#endif

#pragma mark - MSServiceInternal

+ (instancetype)sharedInstance {
  dispatch_once(&onceToken, ^{
    if (sharedInstance == nil) {
      sharedInstance = [self new];
    }
  });
  return sharedInstance;
}

- (void)startWithChannelGroup:(id<MSChannelGroupProtocol>)channelGroup
                    appSecret:(nullable NSString *)appSecret
      transmissionTargetToken:(nullable NSString *)token
              fromApplication:(BOOL)fromApplication {
  [super startWithChannelGroup:channelGroup appSecret:appSecret transmissionTargetToken:token fromApplication:fromApplication];

  // Make sure that ingestion hasn't already been initialized.
  if (appSecret && !self.ingestion) {
    self.ingestion = [[MSStorageIngestion alloc] initWithBaseUrl:self.tokenExchangeUrl appSecret:(NSString *)appSecret];
  }
  MSLogVerbose([MSDataStore logTag], @"Started Data Storage service.");
}

+ (NSString *)serviceName {
  return kMSServiceName;
}

+ (NSString *)logTag {
  return @"AppCenterDataStorage";
}

- (NSString *)groupId {
  return kMSGroupId;
}

#pragma mark - MSServiceAbstract

- (void)applyEnabledState:(BOOL)isEnabled {
  [super applyEnabledState:isEnabled];
  if (isEnabled) {
    [[MSAuthTokenContext sharedInstance] addDelegate:self];
  } else {
    [[MSAuthTokenContext sharedInstance] removeDelegate:self];
  }
}

#pragma mark - MSAuthTokenContextDelegate

- (void)authTokenContext:(MSAuthTokenContext *)__unused authTokenContext
     didReceiveAuthToken:(/* nullable (changed in #1328) */ NSString *)authToken {
  if (authToken == nil) {
    [MSTokenExchange removeAllCachedTokens];
  }
}

#pragma mark - Public

+ (void)setTokenExchangeUrl:(NSString *)tokenExchangeUrl {
  [[MSDataStore sharedInstance] setTokenExchangeUrl:tokenExchangeUrl];
}

@end
