import Component from '@glimmer/component';
import { type PowerSelectInputSignature } from './input';
import type { PowerSelectArgs } from '../power-select';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPlaceholderSignature } from './placeholder';
import type { Option, PowerSelectSelectedItemSignature, Select, Selected, TSearchFieldPosition } from '../../types.ts';
export interface PowerSelectTriggerSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLUListElement;
    Args: {
        select: Select<T, IsMultiple>;
        allowClear?: boolean;
        searchEnabled?: boolean;
        placeholder?: string;
        searchPlaceholder?: string;
        searchField?: string;
        searchFieldPosition?: TSearchFieldPosition;
        listboxId?: string;
        tabindex?: number | string;
        ariaLabel?: string;
        ariaLabelledBy?: string;
        ariaDescribedBy?: string;
        loadingMessage?: string;
        role?: string;
        ariaActiveDescendant: string;
        extra?: TExtra;
        buildSelection?: PowerSelectArgs<T, IsMultiple, TExtra>['buildSelection'];
        placeholderComponent?: ComponentLike<PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>>;
        selectedItemComponent?: ComponentLike<PowerSelectSelectedItemSignature<T, TExtra, IsMultiple>>;
        onInput?: (e: InputEvent) => void | boolean;
        onKeydown?: (e: KeyboardEvent) => void | boolean;
        onFocus?: (e: FocusEvent) => void;
        onBlur?: (e: FocusEvent) => void;
    };
    Blocks: {
        default: [selected: Option<T>, select: Select<T, IsMultiple>];
    };
}
export default class PowerSelectTrigger<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectTriggerSignature<T, TExtra, IsMultiple>> {
    private _lastIsOpen;
    get inputComponent(): ComponentLike<PowerSelectInputSignature<T, TExtra, IsMultiple>>;
    get selected(): Selected<T, false>;
    get selectedMultiple(): Selected<T, true>;
    clear(e: Event): void;
    isOptionDisabled(option: Option<T>): boolean;
    chooseOption(e: Event): void;
    stopPropagation(e: Event): void;
    openChange: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: [boolean];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: Element;
    }>;
    private _openChanged;
    selectedObject<T>(list: readonly Option<T>[] | undefined, index: number): Option<T> | undefined;
}
//# sourceMappingURL=trigger.d.ts.map