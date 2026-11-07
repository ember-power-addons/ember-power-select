import Component from '@glimmer/component';
import { action } from '@ember/object';
import { eq, or } from 'ember-truth-helpers';
import element from 'ember-element-helper/helpers/element';
import { on } from '@ember/modifier';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { n } from 'decorator-transforms/runtime-esm';

class PowerSelectLabel extends Component {
  onLabelClick(e) {
    if (!this.args.select) {
      return;
    }
    this.args.select.actions.labelClick(e);
  }
  static {
    n(this.prototype, "onLabelClick", [action]);
  }
  static {
    setComponentTemplate(precompileTemplate("{{#let (or @labelTag \"div\") (element (or @labelTag \"div\")) as |tagName LabelTag|}}\n  <LabelTag id={{@labelId}} class=\"ember-power-select-label\" ...attributes for={{if (eq tagName \"label\") @triggerId}} {{on \"click\" this.onLabelClick}}>\n    {{@labelText}}\n  </LabelTag>\n{{/let}}", {
      strictMode: true,
      scope: () => ({
        or,
        element,
        eq,
        on
      })
    }), this);
  }
}

export { PowerSelectLabel as default };
//# sourceMappingURL=label.js.map
