import Component from '@glimmer/component';
import type { GroupBase, GroupObject, Select } from '../../types.ts';
export interface PowerSelectPowerSelectGroupSignature<T, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLLIElement;
    Args: {
        group: GroupObject<T>;
        select: Select<T, IsMultiple>;
        extra?: TExtra;
    };
    Blocks: {
        default: [];
    };
}
export default class PowerSelectPowerSelectGroup<T extends GroupBase, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectPowerSelectGroupSignature<T, TExtra, IsMultiple>> {
    uniqueId: string;
}
//# sourceMappingURL=power-select-group.d.ts.map