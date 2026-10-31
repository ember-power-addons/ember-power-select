import Component from '@glimmer/component';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPlaceholderSignature } from './placeholder';
import type { Select, TSearchFieldPosition } from '../../types';
import type { PowerSelectArgs } from '../power-select';
export interface PowerSelectInputSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLInputElement;
    Args: {
        select: Select<T, IsMultiple>;
        ariaLabel?: string;
        ariaLabelledBy?: string;
        ariaDescribedBy?: string;
        role?: string;
        searchField?: string;
        searchPlaceholder?: string;
        searchFieldPosition?: TSearchFieldPosition;
        ariaActiveDescendant?: string;
        isDefaultPlaceholder?: boolean;
        listboxId?: string;
        autofocus?: boolean;
        tabindex?: number | string;
        extra?: TExtra;
        placeholderComponent?: ComponentLike<PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>>;
        onKeydown?: (e: KeyboardEvent) => boolean | void;
        onBlur?: (e: FocusEvent) => void;
        onFocus?: (e: FocusEvent) => void;
        onInput?: (e: InputEvent) => void | boolean;
        buildSelection?: PowerSelectArgs<T, IsMultiple, TExtra>['buildSelection'];
    };
}
export default class PowerSelectInput<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectInputSignature<T, TExtra, IsMultiple>> {
    didSetup: boolean;
    private _lastIsOpen;
    get placeholder(): string | undefined;
    handleKeydown(e: KeyboardEvent): false | void;
    handleInput(event: Event): false | void;
    handleBlur(event: Event): void;
    handleFocus(event: Event): void;
    setupInput: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLElement;
    }>;
    openChange: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: [boolean];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLElement;
    }>;
    private _openChanged;
    private _focusInput;
    private focusLaterTask;
}
//# sourceMappingURL=input.d.ts.map