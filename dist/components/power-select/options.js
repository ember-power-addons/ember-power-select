import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import emberPowerSelectIsGroup from '../../helpers/ember-power-select-is-group.js';
import emberPowerSelectIsEqual from '../../helpers/ember-power-select-is-equal.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

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
      ElementProto.closest = function closest(selector) {
        // eslint-disable-next-line @typescript-eslint/no-this-alias
        let element = this;
        while (element !== null && element.nodeType === 1) {
          if (element.matches(selector)) {
            return element;
          }
          element = element.parentNode;
        }
        return null;
      };
    }
  })(window.Element.prototype);
}
class PowerSelectOptions extends Component {
  static {
    setComponentTemplate(precompileTemplate("{{!-- template-lint-disable require-context-role --}}\n<ul {{this.setupHandlers}} ...attributes>\n  {{#if @select.loading}}\n    {{#if @loadingMessage}}\n      <li class=\"ember-power-select-option ember-power-select-option--loading-message\" role=\"option\" aria-selected={{false}}>{{@loadingMessage}}</li>\n    {{/if}}\n  {{/if}}\n  {{#let @groupComponent @optionsComponent as |Group Options|}}\n    {{#each @options as |opt index|}}\n      {{#if (emberPowerSelectIsGroup opt)}}\n        {{#let (this.groupTyping opt) as |groupOpt|}}\n          <Group @group={{groupOpt}} @select={{@select}} @extra={{@extra}}>\n            <Options @options={{this.options groupOpt}} @select={{@select}} @groupIndex=\"{{@groupIndex}}{{index}}.\" @optionsComponent={{@optionsComponent}} @groupComponent={{@groupComponent}} @extra={{@extra}} role=\"presentation\" data-optgroup=\"true\" class=\"ember-power-select-options\" as |option|>\n              {{yield option @select}}\n            </Options>\n          </Group>\n        {{/let}}\n      {{else}}\n        <li class=\"ember-power-select-option\" id=\"{{@select.uniqueId}}-{{@groupIndex}}{{index}}\" aria-selected=\"{{emberPowerSelectIsEqual opt @select.selected}}\" aria-disabled={{if (this.isOptionDisabled opt) \"true\"}} aria-current=\"{{emberPowerSelectIsEqual opt @select.highlighted}}\" data-option-index=\"{{@groupIndex}}{{index}}\" role=\"option\">\n          {{yield (this.optionTyping opt) @select}}\n        </li>\n      {{/if}}\n    {{/each}}\n  {{/let}}\n</ul>", {
      strictMode: true,
      scope: () => ({
        emberPowerSelectIsGroup,
        emberPowerSelectIsEqual
      })
    }), this);
  }
  // extra._isTouchDevice is a workaround for test,!
  isTouchDevice = this.args.extra?._isTouchDevice || isTouchDevice;
  touchMoveEvent;
  mouseOverHandler = _ => {};
  mouseUpHandler = _ => {};
  touchEndHandler = _ => {};
  touchMoveHandler = _ => {};
  touchStartHandler = _ => {};
  _listElement = null;
  _didHandlerSetup = false;
  willDestroy() {
    super.willDestroy();
    if (this._listElement) {
      this._removeHandlers(this._listElement);
    }
  }
  setupHandlers = modifier(element => {
    if (this._didHandlerSetup) {
      return;
    }
    this._didHandlerSetup = true;
    this._listElement = element;
    this._addHandlers(element);
  });
  isOptionDisabled(option) {
    if (option && typeof option === 'object' && 'disabled' in option) {
      return option.disabled;
    }
    return false;
  }
  options(group) {
    if (group && typeof group === 'object' && 'options' in group) {
      return group.options;
    }
    return [];
  }
  groupTyping(opt) {
    return opt;
  }
  optionTyping(opt) {
    return opt;
  }
  _optionFromIndex(index) {
    const parts = index.split('.');
    let option = this.args.options[parseInt(parts[0] ?? '', 10)];
    for (let i = 1; i < parts.length; i++) {
      if (option && typeof option === 'object' && 'options' in option && option.options) {
        option = option.options[parseInt(parts[i] ?? '', 10)];
      }
    }
    return option;
  }
  _hasMoved(endEvent) {
    const moveEvent = this.touchMoveEvent;
    if (!moveEvent) {
      return false;
    }
    if (!moveEvent.changedTouches) {
      return false;
    }
    const changedTouch = moveEvent.changedTouches[0];
    if (!endEvent.changedTouches?.[0] ||
    // @ts-expect-error Property 'touchType' does not exist on type 'Touch'.
    changedTouch?.touchType !== 'stylus') {
      return true;
    }
    // Distinguish stylus scroll and tap: if touch "distance" < 5px, we consider it a tap
    const horizontalDistance = Math.abs((changedTouch?.pageX ?? 0) - endEvent.changedTouches[0].pageX);
    const verticalDistance = Math.abs((changedTouch?.pageY ?? 0) - endEvent.changedTouches[0].pageY);
    return horizontalDistance >= 5 || verticalDistance >= 5;
  }
  _addHandlers(element) {
    const isGroup = element.getAttribute('data-optgroup') === 'true';
    if (isGroup) {
      return;
    }
    const findOptionAndPerform = (action, e) => {
      if (e.target === null) return;
      const optionItem = e.target.closest('[data-option-index]');
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
    this.mouseUpHandler = e => findOptionAndPerform(this.args.select.actions.choose, e);
    element.addEventListener('mouseup', this.mouseUpHandler);
    if (this.args.highlightOnHover) {
      this.mouseOverHandler = e => findOptionAndPerform(this.args.select.actions.highlight, e);
      element.addEventListener('mouseover', this.mouseOverHandler);
    }
    if (this.isTouchDevice) {
      this.touchMoveHandler = e => {
        this.touchMoveEvent = e;
        if (element) {
          element.removeEventListener('touchmove', this.touchMoveHandler);
        }
      };
      // Add touch event handlers to detect taps
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      this.touchStartHandler = _ => {
        element.addEventListener('touchmove', this.touchMoveHandler);
      };
      this.touchEndHandler = e => {
        if (e.target === null) return;
        const optionItem = e.target.closest('[data-option-index]');
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
      };
      element.addEventListener('touchstart', this.touchStartHandler);
      element.addEventListener('touchend', this.touchEndHandler);
    }
    this.args.select.actions.scrollTo(this.args.select.highlighted);
  }
  _removeHandlers(element) {
    element.removeEventListener('mouseup', this.mouseUpHandler);
    element.removeEventListener('mouseover', this.mouseOverHandler);
    element.removeEventListener('touchstart', this.touchStartHandler);
    element.removeEventListener('touchmove', this.touchMoveHandler);
    element.removeEventListener('touchend', this.touchEndHandler);
  }
}

export { PowerSelectOptions as default };
//# sourceMappingURL=options.js.map
