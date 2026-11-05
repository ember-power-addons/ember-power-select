import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import emberPowerSelectIsGroup from '../../helpers/ember-power-select-is-group.ts';
import emberPowerSelectIsEqual from '../../helpers/ember-power-select-is-equal.ts';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPowerSelectGroupSignature } from './power-select-group.gts';
import type { GroupObject, Option, Select } from '../../types';

declare const FastBoot: unknown;

export interface PowerSelectOptionsSignature<
  T,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> {
  Element: HTMLUListElement;
  Args: PowerSelectOptionsArgs<T, TExtra, IsMultiple>;
  Blocks: {
    default: [opt: Option<T>, select: Select<T, IsMultiple>];
  };
}

interface PowerSelectOptionsArgs<
  T,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> {
  select: Select<T, IsMultiple>;
  highlightOnHover?: boolean;
  listboxId?: string;
  groupIndex: string;
  loadingMessage?: string;
  options: readonly T[];
  extra?: TExtra;
  groupComponent?: ComponentLike<
    PowerSelectPowerSelectGroupSignature<T, TExtra, IsMultiple>
  >;
  optionsComponent?: ComponentLike<
    PowerSelectOptionsSignature<T, TExtra, IsMultiple>
  >;
}

const isTouchDevice = !!window && 'ontouchstart' in window;
if (typeof FastBoot === 'undefined') {
  (function (ElementProto) {
    if (typeof ElementProto.matches !== 'function') {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      ElementProto.matches =
        // @ts-expect-error Property 'msMatchesSelector' does not exist on type 'Element'.
        ElementProto.msMatchesSelector ||
        // @ts-expect-error Property 'mozMatchesSelector' does not exist on type 'Element'.
        ElementProto.mozMatchesSelector ||
        // eslint-disable-next-line @typescript-eslint/unbound-method
        ElementProto.webkitMatchesSelector;
    }

    if (typeof ElementProto.closest !== 'function') {
      ElementProto.closest = function closest(selector: string) {
        // eslint-disable-next-line @typescript-eslint/no-this-alias
        let element: Element | null = this;
        while (element !== null && element.nodeType === 1) {
          if (element.matches(selector)) {
            return element;
          }
          element = element.parentNode as Element;
        }
        return null;
      };
    }
  })(window.Element.prototype);
}

export default class PowerSelectOptions<
  T = unknown,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> extends Component<PowerSelectOptionsSignature<T, TExtra, IsMultiple>> {
  <template>
    {{! template-lint-disable require-context-role }}
    <ul {{this.setupHandlers}} ...attributes>
      {{#if @select.loading}}
        {{#if @loadingMessage}}
          <li
            class="ember-power-select-option ember-power-select-option--loading-message"
            role="option"
            aria-selected={{false}}
          >{{@loadingMessage}}</li>
        {{/if}}
      {{/if}}
      {{#let @groupComponent @optionsComponent as |Group Options|}}
        {{#each @options as |opt index|}}
          {{#if (emberPowerSelectIsGroup opt)}}
            {{#let (this.groupTyping opt) as |groupOpt|}}
              <Group @group={{groupOpt}} @select={{@select}} @extra={{@extra}}>
                <Options
                  @options={{this.options groupOpt}}
                  @select={{@select}}
                  @groupIndex="{{@groupIndex}}{{index}}."
                  @optionsComponent={{@optionsComponent}}
                  @groupComponent={{@groupComponent}}
                  @extra={{@extra}}
                  role="presentation"
                  data-optgroup="true"
                  class="ember-power-select-options"
                  as |option|
                >
                  {{yield option @select}}
                </Options>
              </Group>
            {{/let}}
          {{else}}
            <li
              class="ember-power-select-option"
              id="{{@select.uniqueId}}-{{@groupIndex}}{{index}}"
              aria-selected="{{emberPowerSelectIsEqual opt @select.selected}}"
              aria-disabled={{if (this.isOptionDisabled opt) "true"}}
              aria-current="{{emberPowerSelectIsEqual opt @select.highlighted}}"
              data-option-index="{{@groupIndex}}{{index}}"
              role="option"
            >
              {{yield (this.optionTyping opt) @select}}
            </li>
          {{/if}}
        {{/each}}
      {{/let}}
    </ul>
  </template>
  // extra._isTouchDevice is a workaround for test,!
  private isTouchDevice =
    (this.args.extra as (TExtra & { _isTouchDevice?: boolean }) | undefined)
      ?._isTouchDevice || isTouchDevice;
  private touchMoveEvent?: TouchEvent;
  private mouseOverHandler: EventListener = ((
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _: MouseEvent,
  ): void => {}) as EventListener;
  private mouseUpHandler: EventListener = ((
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _: MouseEvent,
  ): void => {}) as EventListener;
  private touchEndHandler: EventListener = ((
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _: TouchEvent,
  ): void => {}) as EventListener;
  private touchMoveHandler: EventListener = ((
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _: TouchEvent,
  ): void => {}) as EventListener;
  private touchStartHandler: EventListener = ((
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    _: TouchEvent,
  ): void => {}) as EventListener;

  private _listElement: Element | null = null;
  private _didHandlerSetup: boolean = false;

  willDestroy(): void {
    super.willDestroy();
    if (this._listElement) {
      this._removeHandlers(this._listElement);
    }
  }

  setupHandlers = modifier((element: Element) => {
    if (this._didHandlerSetup) {
      return;
    }
    this._didHandlerSetup = true;
    this._listElement = element;
    this._addHandlers(element);
  });

  isOptionDisabled(option: T): boolean {
    if (option && typeof option === 'object' && 'disabled' in option) {
      return option.disabled as boolean;
    }

    return false;
  }

  options(group: GroupObject<T>): readonly T[] {
    if (group && typeof group === 'object' && 'options' in group) {
      return group.options as readonly T[];
    }

    return [];
  }

  groupTyping(opt: T) {
    return opt as GroupObject<T>;
  }

  optionTyping(opt: T) {
    return opt as Option<T>;
  }

  _optionFromIndex(index: string): Option<T> {
    const parts = index.split('.');
    let option = this.args.options[parseInt(parts[0] ?? '', 10)];
    for (let i = 1; i < parts.length; i++) {
      if (
        option &&
        typeof option === 'object' &&
        'options' in option &&
        option.options
      ) {
        option = (option.options as readonly T[])[parseInt(parts[i] ?? '', 10)];
      }
    }
    return option as Option<T>;
  }

  _hasMoved(endEvent: TouchEvent): boolean {
    const moveEvent = this.touchMoveEvent;
    if (!moveEvent) {
      return false;
    }

    if (!moveEvent.changedTouches) {
      return false;
    }

    const changedTouch = moveEvent.changedTouches[0];

    if (
      !endEvent.changedTouches?.[0] ||
      // @ts-expect-error Property 'touchType' does not exist on type 'Touch'.
      changedTouch?.touchType !== 'stylus'
    ) {
      return true;
    }

    // Distinguish stylus scroll and tap: if touch "distance" < 5px, we consider it a tap
    const horizontalDistance = Math.abs(
      (changedTouch?.pageX ?? 0) - endEvent.changedTouches[0].pageX,
    );
    const verticalDistance = Math.abs(
      (changedTouch?.pageY ?? 0) - endEvent.changedTouches[0].pageY,
    );
    return horizontalDistance >= 5 || verticalDistance >= 5;
  }

  private _addHandlers(element: Element) {
    const isGroup = element.getAttribute('data-optgroup') === 'true';
    if (isGroup) {
      return;
    }
    const findOptionAndPerform = (
      action: (selected: Option<T> | undefined, e?: Event) => void,
      e: MouseEvent,
    ): void => {
      if (e.target === null) return;
      const optionItem = (e.target as Element).closest('[data-option-index]');
      if (!optionItem) {
        return;
      }
      if (optionItem.closest('[aria-disabled=true]')) {
        return; // Abort if the item or an ancestor is disabled
      }
      const optionIndex = optionItem.getAttribute('data-option-index');
      if (optionIndex === null) return;
      action(this._optionFromIndex(optionIndex), e);
    };
    this.mouseUpHandler = ((e: MouseEvent): void =>
      findOptionAndPerform(
        this.args.select.actions.choose,
        e,
      )) as EventListener;
    element.addEventListener('mouseup', this.mouseUpHandler);
    if (this.args.highlightOnHover) {
      this.mouseOverHandler = ((e: MouseEvent): void =>
        findOptionAndPerform(
          this.args.select.actions.highlight,
          e,
        )) as EventListener;
      element.addEventListener('mouseover', this.mouseOverHandler);
    }
    if (this.isTouchDevice) {
      this.touchMoveHandler = ((e: TouchEvent): void => {
        this.touchMoveEvent = e;
        if (element) {
          element.removeEventListener('touchmove', this.touchMoveHandler);
        }
      }) as EventListener;
      // Add touch event handlers to detect taps
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      this.touchStartHandler = ((_: TouchEvent): void => {
        element.addEventListener('touchmove', this.touchMoveHandler);
      }) as EventListener;
      this.touchEndHandler = ((e: TouchEvent): void => {
        if (e.target === null) return;
        const optionItem = (e.target as Element).closest('[data-option-index]');
        if (optionItem === null) return;
        e.preventDefault();
        if (this._hasMoved(e)) {
          this.touchMoveEvent = undefined;
          return;
        }

        if (optionItem.closest('[aria-disabled=true]')) {
          return; // Abort if the item or an ancestor is disabled
        }

        const optionIndex = optionItem.getAttribute('data-option-index');
        if (optionIndex === null) return;
        this.args.select.actions.choose(this._optionFromIndex(optionIndex), e);
      }) as EventListener;
      element.addEventListener('touchstart', this.touchStartHandler);
      element.addEventListener('touchend', this.touchEndHandler);
    }

    this.args.select.actions.scrollTo(this.args.select.highlighted);
  }

  private _removeHandlers(element: Element) {
    element.removeEventListener('mouseup', this.mouseUpHandler);
    element.removeEventListener('mouseover', this.mouseOverHandler);
    element.removeEventListener('touchstart', this.touchStartHandler);
    element.removeEventListener('touchmove', this.touchMoveHandler);
    element.removeEventListener('touchend', this.touchEndHandler);
  }
}
