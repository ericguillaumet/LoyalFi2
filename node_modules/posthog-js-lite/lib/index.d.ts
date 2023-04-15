declare type PosthogCoreOptions = {
    host?: string;
    flushAt?: number;
    flushInterval?: number;
    enable?: boolean;
    sendFeatureFlagEvent?: boolean;
    preloadFeatureFlags?: boolean;
    bootstrap?: {
        distinctId?: string;
        isIdentifiedId?: boolean;
        featureFlags?: Record<string, boolean | string>;
    };
    fetchRetryCount?: number;
    fetchRetryDelay?: number;
    requestTimeout?: number;
    sessionExpirationTimeSeconds?: number;
    captureMode?: 'json' | 'form';
};
declare enum PostHogPersistedProperty {
    AnonymousId = "anonymous_id",
    DistinctId = "distinct_id",
    Props = "props",
    FeatureFlags = "feature_flags",
    OverrideFeatureFlags = "override_feature_flags",
    Queue = "queue",
    OptedOut = "opted_out",
    SessionId = "session_id",
    SessionLastTimestamp = "session_timestamp",
    PersonProperties = "person_properties",
    GroupProperties = "group_properties"
}
declare type PostHogFetchOptions = {
    method: 'GET' | 'POST' | 'PUT' | 'PATCH';
    mode?: 'no-cors';
    credentials?: 'omit';
    headers: {
        [key: string]: string;
    };
    body?: string;
    signal?: AbortSignal;
};
declare type PostHogFetchResponse = {
    status: number;
    text: () => Promise<string>;
    json: () => Promise<any>;
};
declare type PostHogEventProperties = {
    [key: string]: any;
};
declare type PostHogAutocaptureElement = {
    $el_text?: string;
    tag_name: string;
    href?: string;
    nth_child?: number;
    nth_of_type?: number;
    order?: number;
} & {
    [key: string]: any;
};
declare type PostHogDecideResponse = {
    config: {
        enable_collect_everything: boolean;
    };
    editorParams: {
        toolbarVersion: string;
        jsURL: string;
    };
    isAuthenticated: true;
    supportedCompression: string[];
    featureFlags: {
        [key: string]: string | boolean;
    };
    sessionRecording: boolean;
};

interface RetriableOptions {
    retryCount?: number;
    retryDelay?: number;
    retryCheck?: (err: any) => true;
}

declare class SimpleEventEmitter {
    events: {
        [key: string]: ((...args: any[]) => void)[];
    };
    constructor();
    on(event: string, listener: (...args: any[]) => void): () => void;
    emit(event: string, payload: any): void;
}

declare abstract class PostHogCore {
    private apiKey;
    host: string;
    private flushAt;
    private flushInterval;
    private requestTimeout;
    private captureMode;
    private sendFeatureFlagEvent;
    private flagCallReported;
    private removeDebugCallback?;
    protected _events: SimpleEventEmitter;
    protected _flushTimer?: any;
    protected _decideResponsePromise?: Promise<PostHogDecideResponse>;
    protected _retryOptions: RetriableOptions;
    protected _sessionExpirationTimeSeconds: number;
    abstract fetch(url: string, options: PostHogFetchOptions): Promise<PostHogFetchResponse>;
    abstract getLibraryId(): string;
    abstract getLibraryVersion(): string;
    abstract getCustomUserAgent(): string | void;
    abstract getPersistedProperty<T>(key: PostHogPersistedProperty): T | undefined;
    abstract setPersistedProperty<T>(key: PostHogPersistedProperty, value: T | null): void;
    private _optoutOverride;
    constructor(apiKey: string, options?: PosthogCoreOptions);
    protected getCommonEventProperties(): any;
    protected setupBootstrap(options?: Partial<PosthogCoreOptions>): void;
    private get props();
    private set props(value);
    private clearProps;
    private _props;
    get optedOut(): boolean;
    optIn(): void;
    optOut(): void;
    on(event: string, cb: (...args: any[]) => void): () => void;
    reset(propertiesToKeep?: PostHogPersistedProperty[]): void;
    debug(enabled?: boolean): void;
    private buildPayload;
    getSessionId(): string | undefined;
    resetSessionId(): void;
    getAnonymousId(): string;
    getDistinctId(): string;
    register(properties: {
        [key: string]: any;
    }): void;
    unregister(property: string): void;
    /***
     *** TRACKING
     ***/
    identify(distinctId?: string, properties?: PostHogEventProperties): this;
    capture(event: string, properties?: {
        [key: string]: any;
    }, forceSendFeatureFlags?: boolean): this;
    alias(alias: string): this;
    autocapture(eventType: string, elements: PostHogAutocaptureElement[], properties?: PostHogEventProperties): this;
    /***
     *** GROUPS
     ***/
    groups(groups: {
        [type: string]: string | number;
    }): this;
    group(groupType: string, groupKey: string | number, groupProperties?: PostHogEventProperties): this;
    groupIdentify(groupType: string, groupKey: string | number, groupProperties?: PostHogEventProperties): this;
    /***
     * PROPERTIES
     ***/
    personProperties(properties: {
        [type: string]: string;
    }): this;
    groupProperties(properties: {
        [type: string]: Record<string, string>;
    }): this;
    /***
     *** FEATURE FLAGS
     ***/
    private decideAsync;
    private _decideAsync;
    private setKnownFeatureFlags;
    getFeatureFlag(key: string): boolean | string | undefined;
    getFeatureFlags(): PostHogDecideResponse['featureFlags'] | undefined;
    isFeatureEnabled(key: string): boolean | undefined;
    reloadFeatureFlagsAsync(sendAnonDistinctId?: boolean): Promise<PostHogDecideResponse['featureFlags']>;
    onFeatureFlags(cb: (flags: PostHogDecideResponse['featureFlags']) => void): () => void;
    onFeatureFlag(key: string, cb: (value: string | boolean) => void): () => void;
    overrideFeatureFlag(flags: PostHogDecideResponse['featureFlags'] | null): void;
    _sendFeatureFlags(event: string, properties?: {
        [key: string]: any;
    }): void;
    /***
     *** QUEUEING AND FLUSHING
     ***/
    private enqueue;
    flushAsync(): Promise<any>;
    flush(callback?: (err?: any, data?: any) => void): void;
    private fetchWithRetry;
    shutdownAsync(): Promise<void>;
    shutdown(): void;
}

declare type PostHogOptions = {
    autocapture?: boolean;
    persistence?: 'localStorage' | 'sessionStorage' | 'cookie' | 'memory';
    persistence_name?: string;
} & PosthogCoreOptions;

declare class PostHog extends PostHogCore {
    private _storage;
    private _storageCache;
    private _storageKey;
    constructor(apiKey: string, options?: PostHogOptions);
    getPersistedProperty<T>(key: PostHogPersistedProperty): T | undefined;
    setPersistedProperty<T>(key: PostHogPersistedProperty, value: T | null): void;
    fetch(url: string, options: PostHogFetchOptions): Promise<PostHogFetchResponse>;
    getLibraryId(): string;
    getLibraryVersion(): string;
    getCustomUserAgent(): void;
    getCommonEventProperties(): any;
}

export { PostHog, PostHog as default };
