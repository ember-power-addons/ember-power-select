import Component from '@glimmer/component';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

class PowerSelectSearchMessage extends Component {
  static {
    setComponentTemplate(precompileTemplate("<ul class=\"ember-power-select-options\" role=\"listbox\" ...attributes>\n  <li class=\"ember-power-select-option ember-power-select-option--search-message\" role=\"option\" aria-selected={{false}}>\n    {{@searchMessage}}\n  </li>\n</ul>", {
      strictMode: true
    }), this);
  }
}

export { PowerSelectSearchMessage as default };
//# sourceMappingURL=search-message.js.map
