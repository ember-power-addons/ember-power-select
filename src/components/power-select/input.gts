import Component from '@glimmer/component';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';
import { assert } from '@ember/debug';
import { get } from '@ember/object';
import { task, timeout } from 'ember-concurrency';
import { on } from '@ember/modifier';
import { or } from 'ember-truth-helpers';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPlaceholderSignature } from './placeholder.gts';
import type { Select, Selected, TSearchFieldPosition } from '../../types';
import type { PowerSelectArgs } from '../power-select.gts';

export interface PowerSelectInputSignature<
  T = unknown,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> {
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
    placeholderComponent?: ComponentLike<
      PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>
    >;
    onKeydown?: (e: KeyboardEvent) => boolean | void;
    onBlur?: (e: FocusEvent) => void;
    onFocus?: (e: FocusEvent) => void;
    onInput?: (e: InputEvent) => void | boolean;
    buildSelection?: PowerSelectArgs<T, IsMultiple, TExtra>['buildSelection'];
  };
}

export default class PowerSelectInput<
  T = unknown,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> extends Component<PowerSelectInputSignature<T, TExtra, IsMultiple>> {
  didSetup: boolean = false;

  private _lastIsOpen: boolean = this.args.select.isOpen;

  get placeholder() {
    if (!this.args.isDefaultPlaceholder) {
      return undefined;
    }

    if (this.args.select.multiple) {
      return !this.args.select.selected ||
        (Array.isArray(this.args.select.selected) &&
          this.args.select.selected.length === 0)
        ? this.args.searchPlaceholder || ''
        : '';
    }

    return this.args.searchPlaceholder;
  }

  @action
  handleKeydown(e: KeyboardEvent): false | void {
    if (e.target === null) return;
    if (this.args.onKeydown && this.args.onKeydown(e) === false) {
      e.stopPropagation();
      return false;
    }
    if (this.args.select.multiple) {
      if (e.key === 'Backspace') {
        e.stopPropagation();
        if (
          !(e.target as HTMLInputElement).value.trim() &&
          this.args.buildSelection &&
          Array.isArray(this.args.select.selected)
        ) {
          const selected = this.args.select.selected as Selected<T, true>;
          const lastSelection = selected[selected.length - 1];

          if (lastSelection) {
            this.args.select.actions.select(
              this.args.buildSelection(lastSelection, this.args.select),
              e,
            );
            if (typeof lastSelection === 'string') {
              this.args.select.actions.search(lastSelection);
            } else {
              assert(
                '`<PowerSelect>` requires a `@searchField` when the options are not strings to remove options using backspace',
                this.args.searchField,
              );
              this.args.select.actions.search(
                (get(lastSelection, this.args.searchField) || '') as string,
              );
            }
            this.args.select.actions.open(e);
          }
        }
      } else if (e.key?.length === 1 && /[a-z0-9 ]/i.test(e.key)) {
        // Keys 0-9, a-z or SPACE
        e.stopPropagation();
      }
    } else if (e.key === 'Enter') {
      this.args.select.actions.close(e);
    }
  }

  @action
  handleInput(event: Event): false | void {
    const e = event as InputEvent;
    if (this.args.onInput && this.args.onInput(e) === false) {
      return false;
    }

    this.args.select.actions.open(e);
  }

  @action
  handleBlur(event: Event) {
    if (!this._lastIsOpen && this.args.searchFieldPosition === 'trigger') {
      this.args.select.actions?.search('');
    }

    if (this.args.onBlur) {
      this.args.onBlur(event as FocusEvent);
    }
  }

  @action
  handleFocus(event: Event) {
    if (this.args.onFocus) {
      this.args.onFocus(event as FocusEvent);
    }
  }

  setupInput = modifier(
    (el: HTMLElement) => {
      if (this.didSetup) {
        return;
      }

      this.didSetup = true;

      if (
        this.args.searchFieldPosition === undefined ||
        this.args.searchFieldPosition === 'before-options'
      ) {
        this._focusInput(el);
      }

      return () => {
        // We don't need to reset search value, when searchFieldPosition is trigger, because complete power select will be destroyed
        if (this.args.searchFieldPosition === 'trigger') {
          return;
        }

        this.args.select.actions?.search('');
      };
    },
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    { eager: false },
  );

  openChange = modifier((element: HTMLElement, [isOpen]: [boolean]) => {
    this._openChanged(element, [isOpen]);
  });

  private _openChanged(element: HTMLElement, [isOpen]: [boolean]) {
    if (
      isOpen === false &&
      this._lastIsOpen === true &&
      document.activeElement !== element
    ) {
      void Promise.resolve().then(() => {
        this.args.select.actions?.search('');
      });
    }
    this._lastIsOpen = isOpen;
  }

  private _focusInput(el: HTMLElement) {
    void this.focusLaterTask.perform(el);
  }

  private focusLaterTask = task(async (el: HTMLElement) => {
    await timeout(0);
    if (this.args.autofocus !== false) {
      el.focus();
    }
  });

  <template>
    <div class="ember-power-select-input">
      {{! template-lint-disable require-input-label }}
      {{! template-lint-disable no-positive-tabindex }}
      {{! template-lint-disable require-aria-activedescendant-tabindex }}
      <input
        type="search"
        autocomplete="off"
        autocorrect="off"
        autocapitalize="off"
        spellcheck={{false}}
        class={{if
          @select.multiple
          "ember-power-select-trigger-multiple-input"
          "ember-power-select-search-input-field"
        }}
        value={{@select.searchText}}
        role={{or @role "combobox"}}
        aria-activedescendant={{if @select.isOpen @ariaActiveDescendant}}
        aria-controls={{if @select.isOpen @listboxId}}
        aria-owns={{if @select.isOpen @listboxId}}
        aria-autocomplete="list"
        aria-haspopup="listbox"
        aria-expanded={{if @select.isOpen "true" "false"}}
        placeholder={{this.placeholder}}
        aria-label={{@ariaLabel}}
        aria-labelledby={{@ariaLabelledBy}}
        aria-describedby={{@ariaDescribedBy}}
        disabled={{@select.disabled}}
        tabindex={{@tabindex}}
        form="power-select-fake-form"
        id="ember-power-select-trigger-input-{{@select.uniqueId}}"
        {{on "input" this.handleInput}}
        {{on "focus" this.handleFocus}}
        {{on "blur" this.handleBlur}}
        {{on "keydown" this.handleKeydown}}
        {{this.setupInput}}
        {{this.openChange @select.isOpen}}
        ...attributes
      />
    </div>
  </template>
}
