/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 * @emails oncall+react_native
 * @flow
 */

'use strict';

let nativeBlobModuleRelease = jest.fn();
let nativeFileReaderReadAsText = jest.fn();

jest.unmock('event-target-shim').setMock('../../BatchedBridge/NativeModules', {
  BlobModule: {
    ...require('../../Blob/__mocks__/BlobModule'),
    release: nativeBlobModuleRelease,
  },
  FileReaderModule: {
    ...require('../../Blob/__mocks__/FileReaderModule'),
    readAsText: nativeFileReaderReadAsText,
  },
});

const Blob = require('../../Blob/Blob');
const FileReader = require('../../Blob/FileReader');

const {fetch} = require('../fetch');

type MockXHR = {
  open: (...params: any) => void,
  send: (data?: any) => void,
  sendRequestHeader: Function,
  getAllResponseHeaders: Function,
  readyState: number,
  response: any,
  onload: Function,
};

describe('fetch', function() {
  let xhr: MockXHR;

  beforeAll(() => {
    global.Blob = Blob;
    global.FileReader = FileReader;
    global.self = global;
  });

  beforeEach(() => {
    nativeBlobModuleRelease.mockReset();
    nativeFileReaderReadAsText.mockReturnValue(Promise.resolve(''));

    global.XMLHttpRequest = jest.fn().mockImplementation(() => {
      xhr = {
        open: jest.fn(),
        send: jest.fn(),
        sendRequestHeader: jest.fn(),
        getAllResponseHeaders: jest.fn(),
        readyState: 4,
        response: '',
        onload: jest.fn(),
      };
      return xhr;
    });
  });

  it('should resolve text promise', async () => {
    const respText = 'ok';
    nativeFileReaderReadAsText.mockReturnValue(Promise.resolve(respText));
    const promise = fetch('foo');
    xhr.response = new Blob([respText], {type: 'text/plain', lastModified: 0});
    xhr.onload();
    const resp = await promise;
    const text = await resp.text();
    const textWithSuffix = await Promise.resolve(text + '_suffix');
    expect(text).toBe(respText);
    expect(textWithSuffix).toBe(respText + '_suffix');
    expect(nativeBlobModuleRelease.mock.calls.length).toBe(1);
  });

  it('should resolve json promise', async () => {
    const respJson = {foo: 'bar'};
    nativeFileReaderReadAsText.mockReturnValue(
      Promise.resolve(JSON.stringify(respJson)),
    );
    const promise = fetch('foo');
    xhr.response = new Blob([JSON.stringify(respJson)], {
      type: 'application/json',
      lastModified: 0,
    });
    xhr.onload();
    const resp = await promise;
    const json = await resp.json();
    expect(json).toEqual(respJson);
  });

  it('should release internal blob', async () => {
    const promise = fetch('foo');
    xhr.response = new Blob();
    xhr.onload();
    const resp = await promise;
    await resp.text();
    expect(nativeBlobModuleRelease.mock.calls.length).toBe(1);
  });

  it('should release internal blob for rejection in promise chain', async () => {
    const promise = fetch('foo');
    xhr.response = new Blob();
    xhr.onload();
    const resp = await promise;
    await resp.text();
    try {
      throw new Error('bar');
    } catch (e) {}
    expect(nativeBlobModuleRelease.mock.calls.length).toBe(1);
  });

  it('[Limitation] will be dangling reference if using fetch promise in setTimeout', async () => {
    let blob: ?Blob = null;
    setTimeout(async () => {
      const promise = fetch('foo');
      xhr.response = new Blob();
      xhr.onload();
      const resp = await promise;
      blob = await resp.blob();
      expect(nativeBlobModuleRelease.mock.calls.length).toBe(1);
    }, 10);
    jest.runAllTimers();
    expect(() => {
      (blob: any).close();
    }).toThrow('Blob has been closed and is no longer available');
  });

  it('should not release internal blob if autoCloseBlob=false', async () => {
    const respText = 'ok';
    nativeFileReaderReadAsText.mockReturnValue(Promise.resolve(respText));
    const promise = fetch('foo', {autoCloseBlob: false});
    xhr.response = new Blob([respText], {type: 'text/plain', lastModified: 0});
    xhr.onload();
    const resp = await promise;
    const text = await resp.text();
    expect(nativeBlobModuleRelease.mock.calls.length).toBe(0);
    expect(text).toBe(respText);
  });
});
