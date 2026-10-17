import { buildTask } from 'ember-concurrency/async-arrow-runtime';
import Component from '@glimmer/component';
import { action } from '@ember/object';
import { modifier } from 'ember-modifier';
import { timeout } from 'ember-concurrency';
import { on } from '@ember/modifier';
import { eq, or, and } from 'ember-truth-helpers';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { n } from 'decorator-transforms/runtime-esm';

class PowerSelectBeforeOptions extends Component {
  didSetup = false;
  handleKeydown(e) {
    if (this.args.onKeydown(e) === false) {
      return false;
    }
    if (e.key === 'Enter') {
      this.args.select.actions.close(e);
    }
  }
  static {
    n(this.prototype, "handleKeydown", [action]);
  }
  handleInput(event) {
    const e = event;
    if (this.args.onInput(e) === false) {
      return false;
    }
  }
  static {
    n(this.prototype, "handleInput", [action]);
  }
  setupInput = modifier(el => {
    if (this.didSetup) {
      return;
    }
    this.didSetup = true;
    this._focusInput(el);
    return () => {
      this.args.select.actions?.search('');
    };
  },
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  {
    eager: false
  });
  _focusInput(el) {
    void this.focusLaterTask.perform(el);
  }
  focusLaterTask = buildTask(() => ({
    context: this,
    generator: function* (el) {
      yield timeout(0);
      if (this.args.autofocus !== false) {
        el.focus();
      }
    }
  }), null, "focusLaterTask", null);
  static {
    setComponentTemplate(precompileTemplate("{{#if (and @searchEnabled (or (eq @searchFieldPosition \"before-options\") (eq @searchFieldPosition undefined)))}}\n  <div class=\"ember-power-select-search\">\n    {{!-- template-lint-disable require-input-label --}}\n    <input type=\"search\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck={{false}} class=\"ember-power-select-search-input\" value={{@select.searchText}} role={{or @role \"combobox\"}} aria-activedescendant={{@ariaActiveDescendant}} aria-controls={{@listboxId}} aria-owns={{@listboxId}} aria-autocomplete=\"list\" aria-haspopup=\"listbox\" aria-expanded={{if @select.isOpen \"true\" \"false\"}} placeholder={{@searchPlaceholder}} aria-label={{@ariaLabel}} aria-labelledby={{@ariaLabelledBy}} aria-describedby={{@ariaDescribedBy}} {{on \"input\" this.handleInput}} {{on \"focus\" @onFocus}} {{on \"blur\" @onBlur}} {{on \"keydown\" this.handleKeydown}} {{this.setupInput}} />\n  </div>\n{{/if}}", {
      strictMode: true,
      scope: () => ({
        and,
        or,
        eq,
        on
      })
    }), this);
  }
}

export { PowerSelectBeforeOptions as default };
//# sourceMappingURL=before-options.js.map
