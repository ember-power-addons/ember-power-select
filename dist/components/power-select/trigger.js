import Component from '@glimmer/component';
import { action, get } from '@ember/object';
import { modifier } from 'ember-modifier';
import PowerSelectInput from './input.js';
import { notEq, isEmpty, eq, or, not, and } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import emberPowerSelectIsSelectedPresent from '../../helpers/ember-power-select-is-selected-present.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { n } from 'decorator-transforms/runtime-esm';

class PowerSelectTrigger extends Component {
  _lastIsOpen = this.args.select.isOpen;
  get inputComponent() {
    return PowerSelectInput;
  }
  get selected() {
    return this.args.select.selected;
  }
  get selectedMultiple() {
    return this.args.select.selected;
  }
  clear(e) {
    e.stopPropagation();
    const value = this.args.select.multiple ? [] : undefined;
    this.args.select.actions.select(value);
  }
  static {
    n(this.prototype, "clear", [action]);
  }
  isOptionDisabled(option) {
    if (option && typeof option === 'object' && 'disabled' in option) {
      return option.disabled;
    }
    return false;
  }
  chooseOption(e) {
    if (!this.args.select.multiple) {
      return;
    }
    if (e.target === null) return;
    const selectedIndex = e.target.getAttribute('data-selected-index');
    if (selectedIndex) {
      const numericIndex = parseInt(selectedIndex, 10);
      e.stopPropagation();
      e.preventDefault();
      const object = this.selectedObject(this.selectedMultiple, numericIndex);
      this.args.select.actions.choose(object);
    }
  }
  static {
    n(this.prototype, "chooseOption", [action]);
  }
  stopPropagation(e) {
    e.stopPropagation();
  }
  openChange = modifier((element, [isOpen]) => {
    this._openChanged(element, [isOpen]);
  });
  _openChanged(_el, [isOpen]) {
    if (isOpen === false && this._lastIsOpen === true) {
      void Promise.resolve().then(() => {
        this.args.select.actions?.search('');
      });
    }
    this._lastIsOpen = isOpen;
  }
  selectedObject(list, index) {
    if (list && 'objectAt' in list && typeof list.objectAt === 'function') {
      return list.objectAt(index);
    } else if (list) {
      return get(list, index);
    }
  }
  static {
    setComponentTemplate(precompileTemplate("{{#if @select.multiple}}\n  {{!-- template-lint-disable no-invalid-interactive --}}\n  {{!-- template-lint-disable no-unsupported-role-attributes --}}\n  {{!-- template-lint-disable require-aria-activedescendant-tabindex --}}\n  <ul id=\"ember-power-select-multiple-options-{{@select.uniqueId}}\" aria-activedescendant={{if (and @select.isOpen (not @searchEnabled)) @ariaActiveDescendant}} class=\"ember-power-select-multiple-options\" {{this.openChange @select.isOpen}} {{on \"click\" this.chooseOption}} ...attributes>\n    {{#if (selectIsSelectedPresent this.selectedMultiple)}}\n      {{#each this.selectedMultiple as |opt idx|}}\n        <li class=\"ember-power-select-multiple-option\n            {{if (this.isOptionDisabled opt) \"ember-power-select-multiple-option--disabled\"}}\">\n          {{#unless @select.disabled}}\n            {{!-- template-lint-disable no-pointer-down-event-binding --}}\n            <span role=\"button\" aria-label=\"remove element\" class=\"ember-power-select-multiple-remove-btn\" data-selected-index={{idx}} {{on \"touchend\" this.stopPropagation}} {{on \"mousedown\" this.stopPropagation}}>\n              &times;\n            </span>\n          {{/unless}}\n          {{#if @selectedItemComponent}}\n            {{#let @selectedItemComponent as |SelectedItemComponent|}}\n              <SelectedItemComponent @extra={{@extra}} @selected={{opt}} @select={{@select}} />\n            {{/let}}\n          {{else}}\n            {{yield opt @select}}\n          {{/if}}\n        </li>\n      {{/each}}\n    {{else}}\n      {{#if (and @placeholder (or (not @searchEnabled) (eq @searchFieldPosition \"before-options\")))}}\n        <li>\n          {{#let @placeholderComponent as |PlaceholderComponent|}}\n            <PlaceholderComponent @placeholder={{@placeholder}} @select={{@select}} />\n          {{/let}}\n        </li>\n      {{/if}}\n    {{/if}}\n    {{#if (and @searchEnabled (eq @searchFieldPosition \"trigger\"))}}\n      <li class=\"ember-power-select-trigger-multiple-input-container\">\n        {{#let (component this.inputComponent select=@select extra=@extra ariaActiveDescendant=@ariaActiveDescendant ariaLabelledBy=@ariaLabelledBy ariaDescribedBy=@ariaDescribedBy role=@role ariaLabel=@ariaLabel listboxId=@listboxId tabindex=@tabindex buildSelection=@buildSelection searchPlaceholder=(or @placeholder @searchPlaceholder) placeholderComponent=@placeholderComponent searchField=@searchField searchFieldPosition=@searchFieldPosition onFocus=@onFocus onBlur=@onBlur onKeydown=@onKeydown onInput=@onInput) as |InputComponent|}}\n          {{#let @placeholderComponent as |PlaceholderComponent|}}\n            <PlaceholderComponent @select={{@select}} @extra={{@extra}} @placeholder={{@placeholder}} @isMultipleWithSearch={{true}} @inputComponent={{InputComponent}} @displayPlaceholder={{and (not @select.searchText) (isEmpty @select.selected)}} />\n          {{/let}}\n        {{/let}}\n      </li>\n    {{/if}}\n  </ul>\n{{else}}\n  {{#if (selectIsSelectedPresent this.selected)}}\n    {{#if (or (notEq @searchFieldPosition \"trigger\") (not @select.searchText))}}\n      {{#if @selectedItemComponent}}\n        {{#let @selectedItemComponent as |SelectedItemComponent|}}\n          <SelectedItemComponent @extra={{@extra}} @selected={{this.selected}} @select={{@select}} />\n        {{/let}}\n      {{else}}\n        <span class=\"ember-power-select-selected-item\">\n          {{yield this.selected @select}}\n        </span>\n      {{/if}}\n    {{/if}}\n    {{#if (and @searchEnabled (eq @searchFieldPosition \"trigger\"))}}\n      <PowerSelectInput @select={{@select}} @extra={{@extra}} @ariaActiveDescendant={{@ariaActiveDescendant}} @ariaLabelledBy={{@ariaLabelledBy}} @ariaDescribedBy={{@ariaDescribedBy}} @role={{@role}} @ariaLabel={{@ariaLabel}} @listboxId={{@listboxId}} @tabindex={{@tabindex}} @buildSelection={{@buildSelection}} @searchPlaceholder={{or @placeholder @searchPlaceholder}} @placeholderComponent={{@placeholderComponent}} @searchField={{@searchField}} @onFocus={{@onFocus}} @onBlur={{@onBlur}} @onKeydown={{@onKeydown}} @onInput={{@onInput}} @searchFieldPosition={{@searchFieldPosition}} @autofocus={{false}} />\n    {{/if}}\n    {{#if (and @allowClear (not @select.disabled))}}\n      {{!-- template-lint-disable no-pointer-down-event-binding --}}\n      <span class=\"ember-power-select-clear-btn\" role=\"button\" {{on \"touchend\" this.stopPropagation}} {{on \"mousedown\" this.stopPropagation}} {{on \"click\" this.clear}}>&times;</span>\n    {{/if}}\n  {{else}}\n    {{#if (and @searchEnabled (eq @searchFieldPosition \"trigger\"))}}\n      {{#let (component this.inputComponent select=@select extra=@extra ariaActiveDescendant=@ariaActiveDescendant ariaLabelledBy=@ariaLabelledBy ariaDescribedBy=@ariaDescribedBy role=@role ariaLabel=@ariaLabel listboxId=@listboxId searchPlaceholder=(or @placeholder @searchPlaceholder) onFocus=@onFocus onBlur=@onBlur onKeydown=@onKeydown onInput=@onInput searchFieldPosition=@searchFieldPosition autofocus=false) as |InputComponent|}}\n        {{#let @placeholderComponent as |PlaceholderComponent|}}\n          <PlaceholderComponent @select={{@select}} @placeholder={{@placeholder}} @isMultipleWithSearch={{true}} @inputComponent={{InputComponent}} @extra={{@extra}} @displayPlaceholder={{and (not @select.searchText) (isEmpty this.selected)}} />\n        {{/let}}\n      {{/let}}\n    {{else}}\n      {{#let @placeholderComponent as |PlaceholderComponent|}}\n        <PlaceholderComponent @placeholder={{@placeholder}} @select={{@select}} @extra={{@extra}} />\n      {{/let}}\n    {{/if}}\n  {{/if}}\n{{/if}}\n<span class=\"ember-power-select-status-icon\"></span>", {
      strictMode: true,
      scope: () => ({
        and,
        not,
        on,
        selectIsSelectedPresent: emberPowerSelectIsSelectedPresent,
        or,
        eq,
        isEmpty,
        notEq,
        PowerSelectInput
      })
    }), this);
  }
}

export { PowerSelectTrigger as default };
//# sourceMappingURL=trigger.js.map
