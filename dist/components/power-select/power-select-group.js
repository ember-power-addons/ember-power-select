import Component from '@glimmer/component';
import { guidFor } from '@ember/object/internals';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

class PowerSelectPowerSelectGroup extends Component {
  uniqueId = guidFor(this);
  static {
    setComponentTemplate(precompileTemplate("<li class=\"ember-power-select-group\" aria-disabled={{if @group.disabled \"true\"}} role=\"group\" aria-labelledby={{this.uniqueId}}>\n  <span class=\"ember-power-select-group-name\" id={{this.uniqueId}}>{{@group.groupName}}</span>\n  {{yield}}\n</li>", {
      strictMode: true
    }), this);
  }
}

export { PowerSelectPowerSelectGroup as default };
//# sourceMappingURL=power-select-group.js.map
