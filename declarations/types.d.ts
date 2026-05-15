import type { Dropdown, DropdownActions } from 'ember-basic-dropdown/types';
export type TLabelClickAction = 'focus' | 'open';
export type TSearchFieldPosition = 'before-options' | 'trigger';
export interface Select<T = unknown, IsMultiple extends boolean = false> extends Dropdown {
    readonly selected: Selected<T, IsMultiple>;
    readonly multiple: IsMultiple;
    readonly highlighted: Option<T>;
    readonly options: readonly T[];
    readonly results: readonly T[];
    readonly resultsCount: number;
    readonly loading: boolean;
    readonly isActive: boolean;
    readonly searchText: string;
    readonly lastSearchedText: string;
    readonly actions: SelectActions<T, IsMultiple>;
}
interface SelectActions<T, IsMultiple extends boolean = false> extends DropdownActions {
    readonly search: (term: string) => void;
    readonly highlight: (option: Option<T> | undefined) => void;
    readonly select: (selected: Selected<T, IsMultiple>, e?: Event) => void;
    readonly choose: (selected: Option<T> | undefined, e?: Event) => void;
    readonly scrollTo: (option: Option<T> | undefined) => void;
    readonly labelClick: (e: MouseEvent) => void;
}
export type Selected<T, IsMultiple extends boolean = false> = IsMultiple extends true ? Option<T>[] : Option<T> | undefined;
export type MultipleSelect<T> = Select<T, true>;
export type MultipleSelected<T> = Selected<T, true>;
export type Option<T> = T extends readonly (infer U)[] ? Option<U> : T extends {
    groupName: string;
    options: infer O;
} ? Option<O> : T;
type GroupWithOptionsPrev = [never, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
type GroupWithOptions<T, Depth extends number = 5> = Depth extends 0 ? never : T extends {
    groupName: string;
    options: infer O;
} ? T | GroupWithOptions<O extends readonly unknown[] ? O[number] : never, GroupWithOptionsPrev[Depth]> : T extends readonly (infer U)[] ? GroupWithOptions<U, GroupWithOptionsPrev[Depth]> : never;
export type GroupObject<T> = Extract<GroupWithOptions<T, 5>, {
    groupName: string;
    options: unknown[];
    disabled?: boolean;
}>;
export interface GroupBase<T = unknown> {
    groupName: string;
    options: readonly T[];
    disabled?: boolean;
    [key: string]: unknown;
}
export type MatcherFn<T> = (option: T | undefined, text: string) => number;
export interface DefaultHighlightedParams<T> {
    results: readonly T[];
    highlighted: Option<T> | undefined;
    selected: Selected<T> | Selected<T, true>;
}
export interface PowerSelectSelectedItemSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLElement;
    Args: {
        extra?: TExtra;
        selected: Option<T>;
        select: Select<T, IsMultiple>;
    };
    Blocks: {
        default: [];
    };
}
export interface PowerSelectAfterOptionsSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLElement;
    Args: {
        extra?: TExtra;
        select: Select<T, IsMultiple>;
    };
    Blocks: {
        default: [];
    };
}
export {};
//# sourceMappingURL=types.d.ts.map