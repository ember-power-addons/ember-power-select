import type { DefaultHighlightedParams, GroupBase, MatcherFn, Option, Selected } from '../types';
export declare function isGroup<T>(entry: unknown): entry is GroupBase<T>;
export declare function countOptions<T = unknown>(collection: readonly T[]): number;
export declare function indexOfOption<T, Option>(collection: readonly T[], option: Option): number;
export declare function pathForOption<T = unknown>(collection: readonly T[], option: unknown): string;
export declare function optionAtIndex<T>(originalCollection: readonly T[], index: number): {
    disabled: boolean;
    option: Option<T> | undefined;
};
export declare function findOptionWithOffset<T>(options: readonly T[], text: string, matcher: MatcherFn<T>, offset: number, skipDisabled?: boolean): Option<T> | undefined;
export declare function filterOptions<T = unknown, MT = unknown, IsMultiple extends boolean = false>(options: readonly T[], text: string, matcher: MatcherFn<MT>, skipDisabled?: boolean): T[];
export declare function defaultHighlighted<T>({ results, highlighted, selected, }: DefaultHighlightedParams<T>): Option<T> | undefined;
export declare function advanceSelectableOption<T, IsMultiple extends boolean = false>(options: readonly T[], currentOption: Selected<T, IsMultiple>, step: 1 | -1): Option<T> | undefined;
export declare function stripDiacritics(text: string | number): string;
export declare function defaultMatcher(value: string, text: string): number;
export declare function defaultTypeAheadMatcher(value: string, text: string): number;
//# sourceMappingURL=group-utils.d.ts.map