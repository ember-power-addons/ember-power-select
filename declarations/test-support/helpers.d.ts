import { click, triggerKeyEvent, triggerEvent, type Target } from '@ember/test-helpers';
/**
 * @private
 * @param {String} selector CSS3 selector of the elements to check the content
 * @param {String} text Substring that the selected element must contain
 * @returns HTMLElement The first element that maches the given selector and contains the
 *                      given text
 */
export declare function findContains(selector: string, text: string, rootElement?: HTMLElement | Element): Element | undefined;
export declare function nativeMouseDown(selectorOrDomElement: Parameters<typeof triggerEvent>[0], options?: Parameters<typeof triggerEvent>[2]): Promise<void>;
export declare function nativeMouseUp(selectorOrDomElement: Parameters<typeof triggerEvent>[0], options?: Parameters<typeof triggerEvent>[2]): Promise<void>;
export declare function triggerKeydown(domElement: Parameters<typeof triggerKeyEvent>[0], k: Parameters<typeof triggerKeyEvent>[2]): Promise<void>;
export declare function typeInSearch(scopeOrText: string, text?: string, rootElement?: HTMLElement | Element): Promise<void> | undefined;
export declare function clickTrigger(scope?: Target | string, options?: Parameters<typeof click>[1]): Promise<void>;
export declare function nativeTouch(selectorOrDomElement: Parameters<typeof triggerEvent>[1]): Promise<void>;
export declare function touchTrigger(): Promise<void>;
//# sourceMappingURL=helpers.d.ts.map