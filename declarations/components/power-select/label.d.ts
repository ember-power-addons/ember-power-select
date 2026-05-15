import Component from '@glimmer/component';
import type { Select } from '../../types.js';
export interface PowerSelectLabelArgs<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    select: Select<T, IsMultiple>;
    labelText?: string;
    labelId: string;
    triggerId: string;
    labelTag?: keyof HTMLElementTagNameMap;
    extra?: TExtra;
}
export interface PowerSelectLabelSignature<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLElement;
    Args: PowerSelectLabelArgs<T, TExtra, IsMultiple>;
}
export default class PowerSelectLabel<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectLabelSignature<T, TExtra, IsMultiple>> {
    onLabelClick(e: MouseEvent): void;
}
//# sourceMappingURL=label.d.ts.map