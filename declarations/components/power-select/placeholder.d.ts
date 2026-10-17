import Component from '@glimmer/component';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectInputSignature } from './input';
import type { Select } from '../../types.ts';
export interface PowerSelectPlaceholderSignatureArgs<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    select: Select<T, IsMultiple>;
    isMultipleWithSearch?: boolean;
    placeholder?: string;
    displayPlaceholder?: boolean;
    extra?: TExtra;
    inputComponent?: ComponentLike<PowerSelectInputSignature<T, TExtra, IsMultiple>>;
}
export interface PowerSelectPlaceholderSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLSpanElement;
    Args: PowerSelectPlaceholderSignatureArgs<T, TExtra, IsMultiple>;
}
export default class PowerSelectPlaceholder<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>> {
}
//# sourceMappingURL=placeholder.d.ts.map