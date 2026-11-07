import Component from '@glimmer/component';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPlaceholderSignature } from './placeholder';
import type { PowerSelectSelectedItemSignature, Select, TSearchFieldPosition } from '../../types';
export interface PowerSelectBeforeOptionsSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLDivElement;
    Args: {
        select: Select<T, IsMultiple>;
        searchEnabled?: boolean;
        ariaLabel?: string;
        ariaLabelledBy?: string;
        ariaDescribedBy?: string;
        role?: string;
        searchPlaceholder?: string;
        searchFieldPosition?: TSearchFieldPosition;
        ariaActiveDescendant?: string;
        listboxId?: string;
        placeholder?: string;
        autofocus?: boolean;
        extra?: TExtra;
        triggerRole?: string;
        onKeydown: (e: KeyboardEvent) => boolean | void;
        onBlur: (e: FocusEvent) => void;
        onFocus: (e: FocusEvent) => void;
        onInput: (e: InputEvent) => boolean | void;
        placeholderComponent?: ComponentLike<PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>>;
        selectedItemComponent?: ComponentLike<PowerSelectSelectedItemSignature<T, TExtra, IsMultiple>>;
    };
}
export default class PowerSelectBeforeOptions<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectBeforeOptionsSignature<T, TExtra, IsMultiple>> {
    didSetup: boolean;
    handleKeydown(e: KeyboardEvent): false | void;
    handleInput(event: Event): false | void;
    setupInput: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLElement;
    }>;
    private _focusInput;
    private focusLaterTask;
}
//# sourceMappingURL=before-options.d.ts.map