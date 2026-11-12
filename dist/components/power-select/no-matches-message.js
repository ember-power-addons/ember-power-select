import Component from '@glimmer/component';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

class PowerSelectNoMatchesMessage extends Component {
  static {
    setComponentTemplate(precompileTemplate("{{#if @noMatchesMessage}}\n  <ul class=\"ember-power-select-options\" role=\"listbox\" ...attributes>\n    <li class=\"ember-power-select-option ember-power-select-option--no-matches-message\" role=\"option\" aria-selected={{false}}>\n      {{@noMatchesMessage}}\n    </li>\n  </ul>\n{{/if}}", {
      strictMode: true
    }), this);
  }
}

export { PowerSelectNoMatchesMessage as default };
//# sourceMappingURL=no-matches-message.js.map
