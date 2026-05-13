import Component from '@glimmer/component';
import { action } from '@ember/object';
import { get } from '@ember/object';
import { modifier } from 'ember-modifier';
import PowerSelectInput, { type PowerSelectInputSignature } from './input.gts';
import { and, eq, isEmpty, not, notEq, or } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import selectIsSelectedPresent from '../../helpers/ember-power-select-is-selected-present.ts';
import type { PowerSelectArgs } from '../power-select.gts';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPlaceholderSignature } from './placeholder.gts';
import type {
  Option,
  PowerSelectSelectedItemSignature,
  Select,
  Selected,
  TSearchFieldPosition,
} from '../../types.ts';

export interface PowerSelectTriggerSignature<
  T = unknown,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> {
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
    placeholderComponent?: ComponentLike<
      PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>
    >;
    selectedItemComponent?: ComponentLike<
      PowerSelectSelectedItemSignature<T, TExtra, IsMultiple>
    >;
    onInput?: (e: InputEvent) => void | boolean;
    onKeydown?: (e: KeyboardEvent) => void | boolean;
    onFocus?: (e: FocusEvent) => void;
    onBlur?: (e: FocusEvent) => void;
  };
  Blocks: {
    default: [selected: Option<T>, select: Select<T, IsMultiple>];
  };
}

export default class PowerSelectTrigger<
  T = unknown,
  TExtra = unknown,
  IsMultiple extends boolean = false,
> extends Component<PowerSelectTriggerSignature<T, TExtra, IsMultiple>> {
  private _lastIsOpen: boolean = this.args.select.isOpen;

  get inputComponent(): ComponentLike<
    PowerSelectInputSignature<T, TExtra, IsMultiple>
  > {
    return PowerSelectInput;
  }

  get selected() {
    return this.args.select.selected as Selected<T, false>;
  }

  get selectedMultiple() {
    return this.args.select.selected as Selected<T, true>;
  }

  @action
  clear(e: Event): void {
    e.stopPropagation();
    const value = this.args.select.multiple ? [] : undefined;
    this.args.select.actions.select(value as Selected<T, IsMultiple>);
  }

  isOptionDisabled(option: Option<T>): boolean {
    if (option && typeof option === 'object' && 'disabled' in option) {
      return option.disabled as boolean;
    }

    return false;
  }

  @action
  chooseOption(e: Event) {
    if (!this.args.select.multiple) {
      return;
    }

    if (e.target === null) return;
    const selectedIndex = (e.target as Element).getAttribute(
      'data-selected-index',
    );
    if (selectedIndex) {
      const numericIndex = parseInt(selectedIndex, 10);
      e.stopPropagation();
      e.preventDefault();
      const object = this.selectedObject(this.selectedMultiple, numericIndex);
      this.args.select.actions.choose(object);
    }
  }

  stopPropagation(e: Event): void {
    e.stopPropagation();
  }

  openChange = modifier((element: Element, [isOpen]: [boolean]) => {
    this._openChanged(element, [isOpen]);
  });

  private _openChanged(_el: Element, [isOpen]: [boolean]) {
    if (isOpen === false && this._lastIsOpen === true) {
      void Promise.resolve().then(() => {
        this.args.select.actions?.search('');
      });
    }
    this._lastIsOpen = isOpen;
  }

  selectedObject<T>(
    list: readonly Option<T>[] | undefined,
    index: number,
  ): Option<T> | undefined {
    if (list && 'objectAt' in list && typeof list.objectAt === 'function') {
      return (
        list as readonly Option<T>[] & {
          objectAt(index: number): T | undefined;
        }
      ).objectAt(index) as Option<T> | undefined;
    } else if (list) {
      return get(list, index);
    }
  }

  <template>
    {{#if @select.multiple}}
      {{! template-lint-disable no-invalid-interactive }}
      {{! template-lint-disable no-unsupported-role-attributes }}
      {{! template-lint-disable require-aria-activedescendant-tabindex }}
      <ul
        id="ember-power-select-multiple-options-{{@select.uniqueId}}"
        aria-activedescendant={{if
          (and @select.isOpen (not @searchEnabled))
          @ariaActiveDescendant
        }}
        class="ember-power-select-multiple-options"
        {{this.openChange @select.isOpen}}
        {{on "click" this.chooseOption}}
        ...attributes
      >
        {{#if (selectIsSelectedPresent this.selectedMultiple)}}
          {{#each this.selectedMultiple as |opt idx|}}
            <li
              class="ember-power-select-multiple-option
                {{if
                  (this.isOptionDisabled opt)
                  'ember-power-select-multiple-option--disabled'
                }}"
            >
              {{#unless @select.disabled}}
                {{! template-lint-disable no-pointer-down-event-binding }}
                <span
                  role="button"
                  aria-label="remove element"
                  class="ember-power-select-multiple-remove-btn"
                  data-selected-index={{idx}}
                  {{on "touchend" this.stopPropagation}}
                  {{on "mousedown" this.stopPropagation}}
                >
                  &times;
                </span>
              {{/unless}}
              {{#if @selectedItemComponent}}
                {{#let @selectedItemComponent as |SelectedItemComponent|}}
                  <SelectedItemComponent
                    @extra={{@extra}}
                    @selected={{opt}}
                    @select={{@select}}
                  />
                {{/let}}
              {{else}}
                {{yield opt @select}}
              {{/if}}
            </li>
          {{/each}}
        {{else}}
          {{#if
            (and
              @placeholder
              (or
                (not @searchEnabled) (eq @searchFieldPosition "before-options")
              )
            )
          }}
            <li>
              {{#let @placeholderComponent as |PlaceholderComponent|}}
                <PlaceholderComponent
                  @placeholder={{@placeholder}}
                  @select={{@select}}
                />
              {{/let}}
            </li>
          {{/if}}
        {{/if}}
        {{#if (and @searchEnabled (eq @searchFieldPosition "trigger"))}}
          <li class="ember-power-select-trigger-multiple-input-container">
            {{#let
              (component
                this.inputComponent
                select=@select
                extra=@extra
                ariaActiveDescendant=@ariaActiveDescendant
                ariaLabelledBy=@ariaLabelledBy
                ariaDescribedBy=@ariaDescribedBy
                role=@role
                ariaLabel=@ariaLabel
                listboxId=@listboxId
                tabindex=@tabindex
                buildSelection=@buildSelection
                searchPlaceholder=(or @placeholder @searchPlaceholder)
                placeholderComponent=@placeholderComponent
                searchField=@searchField
                searchFieldPosition=@searchFieldPosition
                onFocus=@onFocus
                onBlur=@onBlur
                onKeydown=@onKeydown
                onInput=@onInput
              )
              as |InputComponent|
            }}
              {{#let @placeholderComponent as |PlaceholderComponent|}}
                <PlaceholderComponent
                  @select={{@select}}
                  @extra={{@extra}}
                  @placeholder={{@placeholder}}
                  @isMultipleWithSearch={{true}}
                  @inputComponent={{InputComponent}}
                  @displayPlaceholder={{and
                    (not @select.searchText)
                    (isEmpty @select.selected)
                  }}
                />
              {{/let}}
            {{/let}}
          </li>
        {{/if}}
      </ul>
    {{else}}
      {{#if (selectIsSelectedPresent this.selected)}}
        {{#if
          (or (notEq @searchFieldPosition "trigger") (not @select.searchText))
        }}
          {{#if @selectedItemComponent}}
            {{#let @selectedItemComponent as |SelectedItemComponent|}}
              <SelectedItemComponent
                @extra={{@extra}}
                @selected={{this.selected}}
                @select={{@select}}
              />
            {{/let}}
          {{else}}
            <span class="ember-power-select-selected-item">
              {{yield this.selected @select}}
            </span>
          {{/if}}
        {{/if}}
        {{#if (and @searchEnabled (eq @searchFieldPosition "trigger"))}}
          <PowerSelectInput
            @select={{@select}}
            @extra={{@extra}}
            @ariaActiveDescendant={{@ariaActiveDescendant}}
            @ariaLabelledBy={{@ariaLabelledBy}}
            @ariaDescribedBy={{@ariaDescribedBy}}
            @role={{@role}}
            @ariaLabel={{@ariaLabel}}
            @listboxId={{@listboxId}}
            @tabindex={{@tabindex}}
            @buildSelection={{@buildSelection}}
            @searchPlaceholder={{or @placeholder @searchPlaceholder}}
            @placeholderComponent={{@placeholderComponent}}
            @searchField={{@searchField}}
            @onFocus={{@onFocus}}
            @onBlur={{@onBlur}}
            @onKeydown={{@onKeydown}}
            @onInput={{@onInput}}
            @searchFieldPosition={{@searchFieldPosition}}
            @autofocus={{false}}
          />
        {{/if}}
        {{#if (and @allowClear (not @select.disabled))}}
          {{! template-lint-disable no-pointer-down-event-binding }}
          <span
            class="ember-power-select-clear-btn"
            role="button"
            {{on "touchend" this.stopPropagation}}
            {{on "mousedown" this.stopPropagation}}
            {{on "click" this.clear}}
          >&times;</span>
        {{/if}}
      {{else}}
        {{#if (and @searchEnabled (eq @searchFieldPosition "trigger"))}}
          {{#let
            (component
              this.inputComponent
              select=@select
              extra=@extra
              ariaActiveDescendant=@ariaActiveDescendant
              ariaLabelledBy=@ariaLabelledBy
              ariaDescribedBy=@ariaDescribedBy
              role=@role
              ariaLabel=@ariaLabel
              listboxId=@listboxId
              searchPlaceholder=(or @placeholder @searchPlaceholder)
              onFocus=@onFocus
              onBlur=@onBlur
              onKeydown=@onKeydown
              onInput=@onInput
              searchFieldPosition=@searchFieldPosition
              autofocus=false
            )
            as |InputComponent|
          }}
            {{#let @placeholderComponent as |PlaceholderComponent|}}
              <PlaceholderComponent
                @select={{@select}}
                @placeholder={{@placeholder}}
                @isMultipleWithSearch={{true}}
                @inputComponent={{InputComponent}}
                @extra={{@extra}}
                @displayPlaceholder={{and
                  (not @select.searchText)
                  (isEmpty this.selected)
                }}
              />
            {{/let}}
          {{/let}}
        {{else}}
          {{#let @placeholderComponent as |PlaceholderComponent|}}
            <PlaceholderComponent
              @placeholder={{@placeholder}}
              @select={{@select}}
              @extra={{@extra}}
            />
          {{/let}}
        {{/if}}
      {{/if}}
    {{/if}}
    <span class="ember-power-select-status-icon"></span>
  </template>
}
