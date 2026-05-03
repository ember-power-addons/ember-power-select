import Component from '@glimmer/component';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { LinkTo } from '@ember/routing';
import PowerSelect from 'ember-power-select/components/power-select';
import MainHeaderSelectTrigger from 'docs/components/main-header-select-trigger';
import MemoryScroll from 'memory-scroll/components/memory-scroll';
import { or } from 'ember-truth-helpers';
import type RouterService from '@ember/routing/router-service';

const options = [
  ["I'm", 'just', 'a logo'],
  ['I', "don't", 'work'],
  ['Are', 'you', 'serious?'],
  ['La la', 'la la', "I can't hear you!"],
  ['No,', 'really.', 'STOP'],
  ['Enough.', "I'm done", 'with you'],
];

export default class extends Component {
  @service declare router: RouterService;

  mainSelected = 'foo';

  @tracked mainOptionsIndex = 0;

  get mainSelectOptions() {
    return this.mainOptionsIndex < options.length
      ? options[this.mainOptionsIndex]
      : [];
  }

  get disabled() {
    return (
      this.router.currentRouteName !== 'public-pages.index' ||
      this.mainOptionsIndex >= options.length
    );
  }

  @action
  changeOptions() {
    this.mainOptionsIndex++;
  }

  <template>
    <header class="main-header">
      <nav class="main-header-nav">
        <div class="main-header-nav-links">
          <LinkTo
            @route="public-pages.docs"
            class="main-header-nav-link"
          >Docs</LinkTo>
          <LinkTo
            @route="public-pages.cookbook"
            class="main-header-nav-link"
          >Cookbook</LinkTo>
          <a
            href="https://github.com/ember-power-addons/ember-power-select"
            class="main-header-nav-link"
          >Github</a>
        </div>
        <div class="main-header-logo">
          <LinkTo @route="public-pages.index" class="home-link" id="home-link">
            <img src="/ember_logo.png" alt="ember" />
          </LinkTo>
          <div class="main-header-select">
            <PowerSelect
              @options={{this.mainSelectOptions}}
              @selected={{this.mainSelected}}
              @disabled={{this.disabled}}
              @triggerComponent={{component
                MainHeaderSelectTrigger
                disabled=this.disabled
              }}
              @onChange={{this.changeOptions}}
              @ariaLabelledBy="home-link"
              @dropdownClass="main-header-select-dropdown"
              as |opt|
            >
              {{opt}}
            </PowerSelect>
          </div>
        </div>
      </nav>
    </header>
    <div class="main-content">
      {{outlet}}
    </div>
    <footer class="main-footer">
      <div class="main-footer-content">
        Deployed with love by
        <a href="https://github.com/cibernox">Miguel Camba</a>
      </div>
    </footer>

    <MemoryScroll @key={{or this.router.currentRouteName ""}} />
  </template>
}
