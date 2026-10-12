import { module, test } from 'qunit';
import { setupRenderingTest } from '../../../helpers';
import { optionAtIndex } from '#src/utils/group-utils.ts';
import { clickTrigger } from '#src/test-support/helpers.ts';
import { namesStartingWithA } from '../../../../demo-app/utils/constants';
import { render, focus, triggerKeyEvent } from '@ember/test-helpers';
import type { Selected } from '#src/types.ts';
import type { TestContext } from '@ember/test-helpers';
import PowerSelect from '#src/components/power-select.gts';
import { fn } from '@ember/helper';
import HostWrapper from '../../../../demo-app/components/host-wrapper.gts';

interface Helpers {
  beforeInteraction: (trigger: Element, assert: Assert) => Promise<void>;
  checkSelectedValue: (
    value: string | undefined,
    trigger: Element,
    assert: Assert,
  ) => void;
  valueAt: (
    coll: string[],
    _idx: number,
    isGrouped?: boolean,
  ) => string | undefined;
}

const WITH_EPS_CLOSED: Helpers = {
  async beforeInteraction(trigger: Element, assert: Assert) {
    await focus(trigger);
    assert.dom(trigger).hasText('', 'no value selected');
    assert
      .dom('.ember-power-select-dropdown', getRootNode(trigger))
      .doesNotExist('The dropdown is closed');
  },

  checkSelectedValue(
    value: string | undefined,
    trigger: Element,
    assert: Assert,
  ) {
    // -1 adjust the position for the implicit placeholder
    assert.dom(trigger).hasText(value ?? '');
    assert
      .dom('.ember-power-select-dropdown', getRootNode(trigger))
      .doesNotExist('The dropdown is still closed');
  },

  valueAt(
    coll: string[],
    _idx: number,
    isGrouped: boolean = false,
  ): string | undefined {
    const idx = isGrouped ? _idx - 1 : (_idx - 1) % coll.length;
    return optionAtIndex(coll, idx).option;
  },
};

const WITH_EPS_OPEN: Helpers = {
  async beforeInteraction(trigger: Element, assert: Assert) {
    await clickTrigger(
      getRootNode(trigger).querySelector(
        '.ember-power-select-trigger',
      ) as HTMLElement,
    );
    assert
      .dom('.ember-power-select-dropdown', getRootNode(trigger))
      .exists('The dropdown is open');
  },

  checkSelectedValue(
    value: string | undefined,
    trigger: Element,
    assert: Assert,
  ) {
    assert.dom(trigger).hasText('', 'nothing is selected');
    assert
      .dom(
        '.ember-power-select-option[aria-current=true]',
        getRootNode(trigger),
      )
      .hasText(value ?? '');
    assert
      .dom('.ember-power-select-dropdown', getRootNode(trigger))
      .exists('The dropdown is still open');
  },

  valueAt(
    coll: string[],
    _idx: number,
    isGrouped: boolean = false,
  ): string | undefined {
    const idx = isGrouped ? _idx : _idx % coll.length;
    return optionAtIndex(coll, idx).option;
  },
};

async function typeString(trigger: Element, str: string, times: number = 1) {
  for (let j = 0; j < times; j++) {
    for (let i = 0; i < str.length; i++) {
      await triggerKeyEvent(trigger, 'keydown', str.charAt(i));
    }
  }
}

interface NamesContext extends TestContext {
  element: HTMLElement;
  names: string[];
  selected: Selected<string>;
}

type Group =
  | {
      groupName: string;
      disabled?: boolean;
      options: (
        string | { groupName: string; disabled?: boolean; options: string[] }
      )[];
    }
  | string;

interface GroupContext extends TestContext {
  element: HTMLElement;
  names: Group[];
  selected: Selected<Group>;
}

function getRootNode(element: Element): HTMLElement {
  const shadowRoot = element.querySelector('[data-host-wrapper]')?.shadowRoot;
  if (shadowRoot) {
    return shadowRoot as unknown as HTMLElement;
  }

  return element.getRootNode() as HTMLElement;
}

module(
  'Integration | Component | Ember Power Select (Type Ahead Native Behaviour)',
  function (hooks) {
    setupRenderingTest(hooks);

    const items: [string, Helpers][] = [
      ['Closed', WITH_EPS_CLOSED],
      ['Open', WITH_EPS_OPEN],
    ];

    items.forEach(([state, helpers]) => {
      test<NamesContext>(`(${state}) Repeating the first character cycles through the results`, async function (assert) {
        const self = this;

        this.names = namesStartingWithA;
        await render<NamesContext>(
          <template>
            <HostWrapper>
              <PowerSelect
                @options={{self.names}}
                @onChange={{fn (mut self.selected)}}
                @selected={{self.selected}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            </HostWrapper>
          </template>,
        );

        const trigger = getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        );
        if (trigger) {
          await helpers.beforeInteraction(trigger, assert);
          await typeString(trigger, 'AAA');
          helpers.checkSelectedValue(
            helpers.valueAt(this.names, 'aaa'.length),
            trigger,
            assert,
          );
        } else {
          assert.notOk('Trigger Element is undefined!');
        }
      });

      test<NamesContext>(`(${state}) When going over all the possible results, it goes back to the first`, async function (assert) {
        const self = this;

        this.names = namesStartingWithA;
        await render<NamesContext>(
          <template>
            <HostWrapper>
              <PowerSelect
                @options={{self.names}}
                @onChange={{fn (mut self.selected)}}
                @selected={{self.selected}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            </HostWrapper>
          </template>,
        );

        const trigger = getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        );
        if (trigger) {
          await helpers.beforeInteraction(trigger, assert);
          const { length } = namesStartingWithA;
          for (let i = 0; i < length; i++) {
            void triggerKeyEvent(trigger, 'keydown', 'A');
          }
          await triggerKeyEvent(trigger, 'keydown', 'A');
          helpers.checkSelectedValue(
            helpers.valueAt(this.names, length + 1),
            trigger,
            assert,
          );
        } else {
          assert.notOk('Trigger Element is undefined!');
        }
      });

      test<NamesContext>(`(${state}) Though repeating the first char, the whole search term is remembered`, async function (assert) {
        const self = this;

        this.names = namesStartingWithA;
        await render<NamesContext>(
          <template>
            <HostWrapper>
              <PowerSelect
                @options={{self.names}}
                @onChange={{fn (mut self.selected)}}
                @selected={{self.selected}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            </HostWrapper>
          </template>,
        );

        const trigger = getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        );
        if (trigger) {
          await helpers.beforeInteraction(trigger, assert);
          void triggerKeyEvent(trigger, 'keydown', 'A');
          void triggerKeyEvent(trigger, 'keydown', 'A');
          await triggerKeyEvent(trigger, 'keydown', 'R');
          helpers.checkSelectedValue('Aaran', trigger, assert);
          assert.notEqual(
            helpers.valueAt(this.names, 'aar'.length),
            'Aaran',
            'Aaran would not be selected unless aa was remembered',
          );
        } else {
          assert.notOk('Trigger Element is undefined!');
        }
      });

      test<NamesContext>(`(${state}) Typing the first character after typing a different one does not set again the cycling behaviour`, async function (assert) {
        const self = this;

        this.names = namesStartingWithA;
        await render<NamesContext>(
          <template>
            <HostWrapper>
              <PowerSelect
                @options={{self.names}}
                @onChange={{fn (mut self.selected)}}
                @selected={{self.selected}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            </HostWrapper>
          </template>,
        );

        const trigger = getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        );
        if (trigger) {
          await helpers.beforeInteraction(trigger, assert);
          void triggerKeyEvent(trigger, 'keydown', 'A');
          void triggerKeyEvent(trigger, 'keydown', 'A');
          void triggerKeyEvent(trigger, 'keydown', 'R');
          await triggerKeyEvent(trigger, 'keydown', 'A');
          helpers.checkSelectedValue('Aaran', trigger, assert);
        } else {
          assert.notOk('Trigger Element is undefined!');
        }
      });

      test<GroupContext>(`(${state}) Cycling characters works with grouped items`, async function (assert) {
        const self = this;

        this.names = [
          { groupName: 'First', options: ['Faa', 'Fab', 'Fac'] },
          {
            groupName: 'Second',
            options: ['Fba', { groupName: '2.1', options: ['FFba'] }, 'Fbb'],
          },
        ];
        await render<GroupContext>(
          <template>
            <HostWrapper>
              <PowerSelect
                @options={{self.names}}
                @onChange={{fn (mut self.selected)}}
                @selected={{self.selected}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            </HostWrapper>
          </template>,
        );
        const trigger = getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        );
        if (trigger) {
          await helpers.beforeInteraction(trigger, assert);
          await typeString(trigger, 'F', state === 'Open' ? 1 : 2); // Normalize open closed behaviour
          helpers.checkSelectedValue('Fab', trigger, assert);
          await typeString(trigger, 'F', 2);
          helpers.checkSelectedValue('Fba', trigger, assert);
          await typeString(trigger, 'F');
          helpers.checkSelectedValue('FFba', trigger, assert);
          await typeString(trigger, 'F');
          helpers.checkSelectedValue('Fbb', trigger, assert);
        } else {
          assert.notOk('Trigger Element is undefined!');
        }
      });
    });
  },
);
