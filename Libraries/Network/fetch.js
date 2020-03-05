/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 * @flow
 */

/* globals Headers, Request, Response */

'use strict';

type PromiseOnFulfillHandler = (value: any) => any;
type PromiseOnRejectHandler = () => any;
type PromiseHandler = (
  onFulfill: ?PromiseOnFulfillHandler,
  onReject: ?PromiseOnRejectHandler,
) => Promise<any>;
type FetchResponse = any;

type ExtendedFetchOptions = {
  autoCloseBlob?: boolean,
};

// side-effectful require() to put fetch,
// Headers, Request, Response in global scope
require('whatwg-fetch');

const __fetch = fetch;
function patchedFetch(...params: any): Promise<FetchResponse> {
  const originalFetch = __fetch;

  const options: ?ExtendedFetchOptions = arguments[1];
  if (
    options != null &&
    typeof options === 'object' &&
    options.autoCloseBlob === false
  ) {
    return originalFetch.apply(this, arguments);
  }

  //
  // Implementation Details:
  // If fetch(uri, { autoCloseBlob: true }),
  // we will try to reorder users promise chain and try to do blob close at the end.
  //
  // If original promise chain is like:
  // fetch()
  //   .then(handler1)
  //   .then(handler2)
  //   .then(handler3)
  //
  // The patched promise chain will be:
  // fetch()
  //   .then(setupOriginalResp)
  //   .then(runNextHandler)
  //   .then(handler1)
  //   .then(runNextHandler)
  //   .then(handler2)
  //   .then(runNextHandler)
  //   .then(handler3)
  //   .then(runNextHandler)
  //   .then(finalizeBlob)
  //

  // store user promise chain handlers into this queue
  // We will reorder promise chaing and try to add |finalizeBlob()| to the tail of queue.
  const handlerQueue: Array<PromiseHandler> = [];

  // the promise after fetch(...)
  const promise: Promise<FetchResponse> = originalFetch.apply(this, arguments);

  // original then function before patch
  const originalThen = Promise.prototype.then;

  // original fetch response. At |finalizeBlob()| we need lookup this and do blob close if necessary
  let originalResp: ?FetchResponse = null;
  function setupOriginalResp(resp: FetchResponse) {
    originalResp = resp;
    return resp;
  }
  promise.then(setupOriginalResp);

  // to close blob in fetch response if necessary
  function finalizeBlob() {
    if (
      originalResp != null &&
      typeof originalResp._bodyBlob === 'object' &&
      typeof originalResp._bodyBlob.close === 'function'
    ) {
      originalResp._bodyBlob.close();
      originalResp._bodyBlob = null;
    }
  }

  // to patch Promise.then which add the handler into |handlerQueue|
  function patchedThen(handler: PromiseHandler): Promise<any> {
    handlerQueue.push(handler);
    const newPromise = Promise.resolve(originalResp);
    (newPromise: any).then = patchedThen;
    return newPromise;
  }
  (promise: any).then = patchedThen;

  // a promise handler to execute next handler in |handlerQueue|
  function runNextHandler(currPromise: Promise<any>) {
    const handler = handlerQueue.shift();
    if (handler) {
      const nextPromise: Promise<any> = originalThen.call(currPromise, handler);
      originalThen.call(nextPromise, () => runNextHandler(nextPromise));
    } else {
      finalizeBlob();
      originalThen.call(currPromise, () => originalResp);
    }
  }

  originalThen.call(promise, () => runNextHandler(promise));
  return promise;
}

global.fetch = patchedFetch;
module.exports = {fetch: patchedFetch, Headers, Request, Response};
