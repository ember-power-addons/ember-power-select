import Component from '@glimmer/component';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPowerSelectGroupSignature } from './power-select-group';
import type { GroupObject, Option, Select } from '../../types';
export interface PowerSelectOptionsSignature<T, TExtra = unknown, IsMultiple extends boolean = false> {
    Element: HTMLUListElement;
    Args: PowerSelectOptionsArgs<T, TExtra, IsMultiple>;
    Blocks: {
        default: [opt: Option<T>, select: Select<T, IsMultiple>];
    };
}
interface PowerSelectOptionsArgs<T, TExtra = unknown, IsMultiple extends boolean = false> {
    select: Select<T, IsMultiple>;
    highlightOnHover?: boolean;
    listboxId?: string;
    groupIndex: string;
    loadingMessage?: string;
    options: readonly T[];
    extra?: TExtra;
    groupComponent?: ComponentLike<PowerSelectPowerSelectGroupSignature<T, TExtra, IsMultiple>>;
    optionsComponent?: ComponentLike<PowerSelectOptionsSignature<T, TExtra, IsMultiple>>;
}
export default class PowerSelectOptions<T = unknown, TExtra = unknown, IsMultiple extends boolean = false> extends Component<PowerSelectOptionsSignature<T, TExtra, IsMultiple>> {
    private isTouchDevice;
    private touchMoveEvent?;
    private mouseOverHandler;
    private mouseUpHandler;
    private touchEndHandler;
    private touchMoveHandler;
    private touchStartHandler;
    private _listElement;
    private _didHandlerSetup;
    willDestroy(): void;
    setupHandlers: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: Element;
    }>;
    isOptionDisabled(option: T): boolean;
    options(group: GroupObject<T>): readonly T[];
    groupTyping(opt: T): GroupObject<T>;
    optionTyping(opt: T): Option<T>;
    _optionFromIndex(index: string): Option<T>;
    _hasMoved(endEvent: TouchEvent): boolean;
    private _addHandlers;
    private _removeHandlers;
}
export {};
//# sourceMappingURL=options.d.ts.map