import { module, test } from 'qunit';
import { setupRenderingTest } from '../../../helpers';
import { render, type TestContext } from '@ember/test-helpers';
import { clickTrigger } from '#src/test-support/helpers.ts';
import { numbers } from '../../../../demo-app/utils/constants';
import { click, triggerEvent } from '@ember/test-helpers';
import type { Select, Selected } from '#src/types.ts';
import PowerSelect from '#src/components/power-select.gts';
import { fn } from '@ember/helper';
import HostWrapper from '../../../../demo-app/components/host-wrapper.gts';

interface NumbersContext<
  IsMultiple extends boolean = false,
> extends TestContext {
  element: HTMLElement;
  numbers: typeof numbers;
  selected: Selected<string, IsMultiple>;
  foo: (
    selection: Selected<string, IsMultiple>,
    select: Select<string, IsMultiple>,
    event?: Event,
  ) => void;
  onChange: (
    selection: Selected<string, IsMultiple>,
    select: Select<string, IsMultiple>,
    event?: Event,
  ) => void;
}

function getRootNode(element: Element): HTMLElement {
  const shadowRoot = element.querySelector('[data-host-wrapper]')?.shadowRoot;
  if (shadowRoot) {
    return shadowRoot as unknown as HTMLElement;
  }

  return element.getRootNode() as HTMLElement;
}

module(
  'Integration | Component | Ember Power Select (Mouse control)',
  function (hooks) {
    setupRenderingTest(hooks);

    test<NumbersContext>('Mouseovering a list item highlights it', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasAttribute(
          'aria-current',
          'true',
          'The first element is highlighted',
        );
      await triggerEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(4)',
        ) as HTMLElement,
        'mouseover',
      );
      assert
        .dom(
          '.ember-power-select-option:nth-child(4)',
          getRootNode(this.element),
        )
        .hasAttribute('aria-current', 'true', 'The 4th element is highlighted');
      assert
        .dom(
          '.ember-power-select-option:nth-child(4)',
          getRootNode(this.element),
        )
        .hasText('four');
    });

    test<NumbersContext>('Mouseovering a list item does not highlight it when highlightOnHover is false', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @highlightOnHover={{false}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasAttribute(
          'aria-current',
          'true',
          'The first element is highlighted',
        );
      await triggerEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(4)',
        ) as HTMLElement,
        'mouseover',
      );

      assert
        .dom(
          '.ember-power-select-option:nth-child(4)',
          getRootNode(this.element),
        )
        .hasAttribute(
          'aria-current',
          'false',
          'The 4th element is not highlighted',
        );
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasAttribute(
          'aria-current',
          'true',
          'The 1st element is still highlighted',
        );
    });

    test<NumbersContext>('Clicking an item selects it, closes the dropdown and focuses the trigger', async function (assert) {
      const self = this;

      assert.expect(5);

      this.numbers = numbers;
      this.foo = (val, dropdown, event) => {
        assert.strictEqual(
          val,
          'four',
          'The action is invoked with the selected value as first parameter',
        );
        assert.ok(
          dropdown.actions.close,
          'The action is invoked with the the dropdown object as second parameter',
        );
        assert.ok(
          event instanceof window.Event,
          'The third argument is an event',
        );
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(4)',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select was closed');
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger',
          ),
      );
    });

    test<NumbersContext>('Clicking the trigger while the select is opened closes it and and focuses the trigger', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>f
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The select is opened');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is closed');
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger',
          ),
      );
    });

    test<NumbersContext>('Doing mousedown the clear button removes the selection but does not open the select', async function (assert) {
      const self = this;

      assert.expect(6);

      this.numbers = numbers;
      this.onChange = (selected, dropdown) => {
        assert.strictEqual(
          selected,
          undefined,
          'The onchange action was called with the new selection (undefined)',
        );
        assert.ok(
          dropdown.actions.close,
          'The onchange action was called with the dropdown object as second argument',
        );
        this.set('selected', selected);
      };
      this.selected = 'three';
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @allowClear={{true}}
              @onChange={{self.onChange}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is closed');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .includesText('three', 'A element is selected');
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-clear-btn',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is still closed');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .doesNotIncludeText('three', 'That element is not selected now');
    });

    test<NumbersContext>("Clicking anywhere outside the select while opened closes the component and doesn't focuses the trigger", async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <input type="text" id="other-thing" />
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The select is opened');
      await click(
        getRootNode(this.element).querySelector('#other-thing') as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is closed');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .isNotFocused();
    });

    test<NumbersContext>("Doing mouseup over an option less than 2px in the Y axis of where the mousedown that opened the component was triggered doesn't select the option", async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
        { clientY: 123 },
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The select is opened');

      await triggerEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
        'mousedown',
        { clientY: 124 },
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The select is still opened');
      await triggerEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
        'mouseup',
        {
          clientY: 125,
        },
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is closed now');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('two', 'The element has been selected');
    });

    test<NumbersContext>('Releasing the mouse over an option without moving after the mousedown that opened the select does not choose it (#1408, #1263)', async function (assert) {
      const self = this;

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      const root = getRootNode(this.element);
      await triggerEvent(
        root.querySelector('.ember-power-select-trigger') as HTMLElement,
        'mousedown',
        { clientX: 50, clientY: 40 },
      );
      // The dropdown rendered under the cursor, so the release lands on an option
      await triggerEvent(
        root.querySelector(
          '.ember-power-select-option:nth-child(1)',
        ) as HTMLElement,
        'mouseup',
        { clientX: 51, clientY: 41 },
      );
      assert
        .dom('.ember-power-select-dropdown', root)
        .exists('The select is still open');
      assert.strictEqual(self.selected, undefined, 'Nothing was selected');

      await click(
        root.querySelector(
          '.ember-power-select-option:nth-child(1)',
        ) as HTMLElement,
        { clientX: 50, clientY: 40 },
      );
      assert
        .dom('.ember-power-select-trigger', root)
        .hasText('one', 'A later click on the same spot selects the option');
    });

    test<
      NumbersContext<true>
    >('Releasing the mouse over an option without moving after the mousedown that opened a multiple select does not choose it (#1408)', async function (assert) {
      const self = this;

      this.numbers = numbers;
      await render<NumbersContext<true>>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      const root = getRootNode(this.element);
      await triggerEvent(
        root.querySelector('.ember-power-select-trigger') as HTMLElement,
        'mousedown',
        { clientX: 50, clientY: 40 },
      );
      await triggerEvent(
        root.querySelector(
          '.ember-power-select-option:nth-child(1)',
        ) as HTMLElement,
        'mouseup',
        { clientX: 50, clientY: 40 },
      );
      assert
        .dom('.ember-power-select-dropdown', root)
        .exists('The select is still open');
      assert.strictEqual(self.selected, undefined, 'Nothing was selected');
    });

    test<NumbersContext>('Pressing on the trigger, dragging to an option and releasing chooses it', async function (assert) {
      const self = this;

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      const root = getRootNode(this.element);
      await triggerEvent(
        root.querySelector('.ember-power-select-trigger') as HTMLElement,
        'mousedown',
        { clientX: 50, clientY: 40 },
      );
      await triggerEvent(
        root.querySelector(
          '.ember-power-select-option:nth-child(3)',
        ) as HTMLElement,
        'mouseup',
        { clientX: 50, clientY: 90 },
      );
      assert
        .dom('.ember-power-select-dropdown', root)
        .doesNotExist('The select is closed');
      assert
        .dom('.ember-power-select-trigger', root)
        .hasText('three', 'The option was chosen');
    });

    test<NumbersContext>('Clicking on a wrapped option should select it', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;

      this.foo = (val) => {
        assert.strictEqual(val, 'four', 'The expected value was selected');
      };

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              <span class="special-class">{{option}}</span>
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      const element = getRootNode(this.element).querySelectorAll(
        '.special-class',
      )[3];
      if (element) {
        await click(element);
      }
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select was closed');
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger',
          ),
      );
    });

    test<NumbersContext>('Mouse-overing on a wrapped option should select it', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              <span class="special-class">{{option}}</span>
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one', 'The first element is highlighted');

      const element = getRootNode(this.element).querySelectorAll(
        '.special-class',
      )[3];
      if (element) {
        await triggerEvent(element, 'mouseover');
      }
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('four', 'The fourth element is highlighted');
    });

    test<NumbersContext>("Mouse-overing the list itself doesn't crashes the app", async function (assert) {
      const self = this;

      assert.expect(0); // NOTE: The fact that this tests runs without errors is the prove that it works

      this.numbers = numbers;

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              <span class="special-class">{{option}}</span>
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await triggerEvent(
        getRootNode(this.element).querySelector('ul') as HTMLElement,
        'mouseover',
      );
    });
  },
);
