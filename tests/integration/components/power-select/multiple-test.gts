import { module, test } from 'qunit';
import { setupRenderingTest } from '../../../helpers';
import { typeInSearch, clickTrigger } from '#src/test-support/helpers.ts';
import {
  numbers,
  names,
  countries,
  countriesWithDisabled,
  type Country,
} from '../../../../demo-app/utils/constants';
import {
  click,
  tap,
  triggerKeyEvent,
  focus,
  render,
  type TestContext,
  settled,
} from '@ember/test-helpers';
import { tracked } from '@glimmer/tracking';
import type {
  DefaultHighlightedParams,
  MatcherFn,
  MultipleSelect,
  MultipleSelected,
} from '#src/types.ts';
import { fn, array } from '@ember/helper';
import PowerSelect from '#src/components/power-select.gts';
import HostWrapper from '../../../../demo-app/components/host-wrapper.gts';
import { timeout } from 'ember-concurrency';

interface NumbersContext extends TestContext {
  element: HTMLElement;
  numbers: string[] | Promise<string[]>;
  selected: MultipleSelected<string>;
  searchFn: (term: string) => string[] | Promise<string[]>;
  endsWithMatcher: MatcherFn<string>;
  defaultHighlighted?:
    string | ((params: DefaultHighlightedParams<string>) => string);
  foo: () => void;
  onChange: (
    selection: MultipleSelected<string>,
    select: MultipleSelect<string>,
  ) => void;
}

interface Person {
  name: string;
  surname: string;
}

interface PeopleContext extends TestContext {
  element: HTMLElement;
  people: Person[] | Promise<Person[]>;
  selected: MultipleSelected<Person>;
  foo: () => void;
  onChange: (selected: MultipleSelected<Person>) => void;
}

interface UserContext extends TestContext {
  element: HTMLElement;
  selected: MultipleSelected<User>;
  search: (term: string) => User[];
  onChange: (user: MultipleSelected<User>) => void;
}

interface StateContext extends TestContext {
  element: HTMLElement;
  state: State;
  sort: (arr: string[]) => string[];
  selected: MultipleSelected<string>;
}

interface CountryContext extends TestContext {
  element: HTMLElement;
  countries: Country[];
  selected: MultipleSelected<typeof countries>;
  foo: () => void;
  onChange: (
    selection: MultipleSelected<Country>,
    select: MultipleSelect<Country>,
  ) => void;
}

class User {
  @tracked name: string;

  constructor(name: string) {
    this.name = name;
  }

  isEqual(other: User | undefined) {
    return this.name === other?.name;
  }
}

class State {
  @tracked selected: string[] | undefined = ['a'];
}

function getRootNode(element: Element): HTMLElement {
  const shadowRoot = element.querySelector('[data-host-wrapper]')?.shadowRoot;
  if (shadowRoot) {
    return shadowRoot as unknown as HTMLElement;
  }

  return element.getRootNode() as HTMLElement;
}

module(
  'Integration | Component | Ember Power Select (Multiple)',
  function (hooks) {
    setupRenderingTest(hooks);

    test<NumbersContext>("Multiple selects don't have a search box by default", async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      await render<NumbersContext>(
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

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-search', getRootNode(this.element))
        .doesNotExist('There is no search box');
    });

    test<NumbersContext>('Multiple selects have a search box in the trigger when the search is enabled', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
        .dom('.ember-power-select-trigger input', getRootNode(this.element))
        .exists();
      assert
        .dom('.ember-power-select-dropdown input', getRootNode(this.element))
        .doesNotExist();
    });

    test<NumbersContext>('Multiple selects have a search box in the dropdown when the search is enabled and search position is `after-options`', async function (assert) {
      const self = this;

      assert.expect(2);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              @searchFieldPosition="before-options"
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
        .dom('.ember-power-select-trigger input', getRootNode(this.element))
        .doesNotExist();
      assert
        .dom('.ember-power-select-dropdown input', getRootNode(this.element))
        .exists();
    });

    test<NumbersContext>('The searchbox of multiple selects has type="search" and a form attribute to prevent submitting the wrapper form when pressing enter', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
        .dom('.ember-power-select-trigger input', getRootNode(this.element))
        .hasAttribute('type', 'search');
      assert
        .dom('.ember-power-select-trigger input', getRootNode(this.element))
        .hasAttribute('form');
    });

    test<NumbersContext>('When the select opens, the search input (if any) in the trigger gets the focus', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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

      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger-multiple-input',
          ),
      );
    });

    test<NumbersContext>('When the select opens and search position is `after-options`, the search input (if any) in the dropdown gets the focus', async function (assert) {
      const self = this;

      assert.expect(1);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              @searchFieldPosition="before-options"
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
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-search-input',
          ),
      );
    });

    test<NumbersContext>("Click on an element selects it and closes the dropdown and focuses the trigger's input", async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger-multiple-input',
          ),
      );

      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      // eslint-disable-next-line ember/no-settled-after-test-helper
      await settled();
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The dropdown is closed');
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is 1 option selected');
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .includesText('two', 'The clicked element has been selected');
    });

    test<NumbersContext>('Selecting an element triggers the onchange action with the list of selected options', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.onChange = (values) => {
        assert.deepEqual(
          values,
          ['two'],
          'The onchange action is fired with the list of values',
        );
      };

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.onChange}}
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
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
    });

    test<NumbersContext>('Click an option when there is already another selects both, and triggers the onchange action with them', async function (assert) {
      const self = this;

      assert.expect(5);

      this.numbers = numbers;
      this.selected = ['four'];
      this.onChange = (values) => {
        assert.deepEqual(
          values,
          ['four', 'two'],
          'The onchange action is fired with the list of values',
        );
        this.set('selected', values);
      };

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is 1 option selected');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 2 }, 'There is 2 options selected');
      assert
        .dom(
          '.ember-power-select-multiple-option:nth-child(1)',
          getRootNode(this.element),
        )
        .includesText('four', 'The first option is the provided one');
      assert
        .dom(
          '.ember-power-select-multiple-option:nth-child(2)',
          getRootNode(this.element),
        )
        .includesText('two', 'The second option is the one just selected');
    });

    test<NumbersContext>('If there is many selections, all those options are styled as `selected`', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.selected = ['four', 'two'];

      await render<NumbersContext>(
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

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-option:nth-child(2)',
          getRootNode(this.element),
        )
        .hasAttribute(
          'aria-selected',
          'true',
          'The second option is styled as selected',
        );
      assert
        .dom(
          '.ember-power-select-option:nth-child(4)',
          getRootNode(this.element),
        )
        .hasAttribute(
          'aria-selected',
          'true',
          'The 4th option is styled as selected',
        );
    });

    test<NumbersContext>('When the popup opens, the first items is highlighed, even if there is only one selection', async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      this.selected = ['four'];

      await render<NumbersContext>(
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
        .exists({ count: 1 }, 'There is one element highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .exists({ count: 1 }, 'There is one element selected');
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"][aria-selected="true"]',
          getRootNode(this.element),
        )
        .doesNotExist('They are not the same');
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one', 'The highlighted element is the first one');
    });

    test<NumbersContext>('Clicking on an option that is already selected unselects it, closes the select and triggers the `onchange` action', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.selected = ['four'];
      this.onChange = (selected) => {
        assert.ok(selected.length === 0, 'No elements are selected');
        this.set('selected', selected);
      };

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is 1 option selected');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option[aria-selected="true"]',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'There is no options selected');
    });

    test<NumbersContext>('The default filtering works in multiple mode', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'four', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'Only two items matched the criteria');
    });

    test<PeopleContext>('The filtering specifying a searchkey works in multiple model', async function (assert) {
      const self = this;

      assert.expect(8);

      this.people = [
        { name: 'María', surname: 'Murray' },
        { name: 'Søren', surname: 'Williams' },
        { name: 'João', surname: 'Jin' },
        { name: 'Miguel', surname: 'Camba' },
        { name: 'Marta', surname: 'Stinson' },
        { name: 'Lisa', surname: 'Simpson' },
      ];
      this.foo = () => {};

      await render<PeopleContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.people}}
              @searchField="name"
              @onChange={{self.foo}}
              @searchEnabled={{true}}
              as |person|
            >
              {{person.name}}
              {{person.surname}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'mar', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'Only 2 results match the search');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('María Murray');
      assert
        .dom(
          '.ember-power-select-option:nth-child(2)',
          getRootNode(this.element),
        )
        .hasText('Marta Stinson');
      await typeInSearch('', 'mari', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 }, 'Only 1 results match the search');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('María Murray');
      await typeInSearch('', 'o', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'Only 2 results match the search');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('Søren Williams');
      assert
        .dom(
          '.ember-power-select-option:nth-child(2)',
          getRootNode(this.element),
        )
        .hasText('João Jin');
    });

    test<NumbersContext>('The filtering specifying a custom matcher works in multiple model', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.endsWithMatcher = function (value, text) {
        return value?.slice(text.length * -1) === text ? 0 : -1;
      };
      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @matcher={{self.endsWithMatcher}}
              @onChange={{self.foo}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'on', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found', 'No number ends in "on"');
      await typeInSearch('', 'teen', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 7 }, 'There is 7 number that end in "teen"');
    });

    test<NumbersContext>('The search using a custom action works int multiple mode', async function (assert) {
      const self = this;

      const done = assert.async();
      assert.expect(1);

      this.searchFn = async (term: string) => {
        await timeout(100);
        return numbers.filter((str) => str.includes(term));
      };
      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @search={{self.searchFn}}
              @onChange={{self.foo}}
              @searchEnabled={{true}}
              as |number|
            >
              {{number}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'teen', getRootNode(this.element));

      setTimeout(function () {
        assert
          .dom('.ember-power-select-option', getRootNode(self.element))
          .exists({ count: 7 });
        done();
      }, 150);
    });

    test<NumbersContext>('Pressing ENTER when the select is closed opens and nothing is written on the box opens it', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        27,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger-multiple-input',
          ),
      );
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
    });

    test<NumbersContext>('Pressing ENTER on a multiple select with `searchEnabled=false` when it is closed opens it', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await focus(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
    });

    test<NumbersContext>('Pressing ENTER over a highlighted element selects it', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.onChange = (selected) => {
        assert.deepEqual(selected, ['two']);
        this.set('selected', selected);
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              @searchEnabled={{true}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .includesText('two', 'The element was selected');
    });

    test<NumbersContext>('Pressing ENTER over a highlighted element on a multiple select without a searchbox selects it', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
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

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
        'keydown',
        40,
      );
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .includesText('two', 'The element was selected');
    });

    test<NumbersContext>('Pressing ENTER over a highlighted element on a select without a searchbox selects it', async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      this.onChange = (selected) => {
        assert.deepEqual(selected, ['two']);
        this.set('selected', selected);
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
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
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'There is no elements selected');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
        'keydown',
        40,
      );
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is one element selected');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .includesText('two', 'The element was selected');
    });

    test<NumbersContext>('Pressing ENTER over a highlighted element what is already selected closes the select without doing anything and focuses the trigger', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.selected = ['two'];
      this.onChange = (val) => {
        assert.ok(false, 'This should never be invoked');
        this.set('selected', val);
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              @searchEnabled={{true}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .includesText('two', 'The element is still selected');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger-multiple-input',
          ),
      );
    });

    test<NumbersContext>('Pressing BACKSPACE on the search input when there is text on it does nothing special', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.selected = ['two'];
      this.onChange = (val) => {
        assert.ok(false, 'This should not be called');
        this.set('selected', val);
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'four', getRootNode(this.element));
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        8,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The dropown is still opened');
    });

    test<NumbersContext>("Pressing BACKSPACE on the search input when it's empty removes the last selection and performs a search for that text immediately, opening the select if closed", async function (assert) {
      const self = this;

      assert.expect(9);

      this.numbers = numbers;
      this.selected = ['two'];
      this.onChange = (val, dropdown) => {
        assert.deepEqual(val, [], 'The selected item was unselected');
        this.set('selected', val);
        assert.ok(
          dropdown.actions.close,
          'The dropdown API is received as second argument',
        );
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.onChange}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is one element selected');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        8,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'There is no elements selected');
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasValue('two', 'The text of the seach input is two now');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The dropown has been opened');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 }, 'The list has been filtered');
      const input = getRootNode(this.element)?.querySelector(
        '.ember-power-select-trigger-multiple-input',
      ) as HTMLInputElement | undefined;
      assert.strictEqual(input?.selectionStart ?? 0, 3);
      assert.strictEqual(input?.selectionEnd ?? 0, 3);
    });

    test<CountryContext>("Pressing BACKSPACE on the search input when it's empty removes the last selection and performs a search for that text immediatly (when options are not strings)", async function (assert) {
      const self = this;

      assert.expect(7);

      this.countries = countries;
      if (countries[2] && countries[4]) {
        this.selected = [countries[2], countries[4]];
      }
      this.onChange = (val, dropdown) => {
        assert.deepEqual(
          val,
          [countries[2]],
          'The selected item was unselected',
        );
        this.set('selected', val);
        assert.ok(
          dropdown.actions.close,
          'The dropdown API is received as second argument',
        );
      };
      await render<CountryContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.countries}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              @searchField="name"
              @searchEnabled={{true}}
              as |c|
            >
              {{c.name}}
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
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 2 }, 'There is two elements selected');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        8,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is one element selected');
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasValue('Latvia', 'The text of the seach input is two "Latvia"');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The dropown is still opened');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 }, 'The list has been filtered');
    });

    test<NumbersContext>("Pressing BACKSPACE on the search input when it's empty removes the last selection ALSO when that option didn't come from the outside", async function (assert) {
      const self = this;

      assert.expect(5);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
          '.ember-power-select-option:nth-child(3)',
        ) as HTMLElement,
      );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'There is one element selected');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        8,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'There is no elements selected');
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasValue('three', 'The text of the seach input is three now');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The dropown is still opened');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 }, 'The list has been filtered');
    });

    test<NumbersContext>("Pressing BACKSPACE on the search input when it's empty doesnt trigger error", async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        8,
      );

      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'There is no elements selected');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The dropdown is still opened');
    });

    test<NumbersContext>('If the multiple component is focused, pressing KEYDOWN opens it', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @searchEnabled={{true}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        27,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is closed');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The select is opened');
    });

    test<NumbersContext>('If the multiple component is focused, pressing KEYUP opens it', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @searchEnabled={{true}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        27,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The select is closed');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        38,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('The select is opened');
    });

    test<NumbersContext>('The placeholder is only visible when no options are selected', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @placeholder="Select stuff here"
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute(
          'placeholder',
          'Select stuff here',
          'There is a placeholder',
        );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute('placeholder', '', 'The placeholder is gone');
    });

    test<NumbersContext>('The placeholder is visible when no options are selected and search is disabled', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @placeholder="Select stuff here"
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-placeholder', getRootNode(this.element))
        .hasText('Select stuff here', 'There is a placeholder');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-placeholder', getRootNode(this.element))
        .doesNotExist('The placeholder is gone');
    });

    test<NumbersContext>('If the placeholder is null the placeholders shouldn\'t be "null" (issue #94)', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute('placeholder', '', 'Input does not have a placeholder');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute(
          'placeholder',
          '',
          'Input still does not have a placeholder',
        );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-multiple-remove-btn',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute(
          'placeholder',
          '',
          'Input still does not have a placeholder',
        );
    });

    test<NumbersContext>('Selecting and removing should result in desired behavior', async function (assert) {
      const self = this;

      assert.expect(3);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'Should add selected option');
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-multiple-remove-btn',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute(
          'placeholder',
          '',
          'Input still does not have a placeholder',
        );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'Should remove selected option');
    });

    test<NumbersContext>('Selecting and removing can also be done with touch events', async function (assert) {
      const self = this;

      assert.expect(3);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
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
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'Should add selected option');
      await tap(
        getRootNode(this.element).querySelector(
          '.ember-power-select-multiple-remove-btn',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute(
          'placeholder',
          '',
          'Input still does not have a placeholder',
        );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 }, 'Should remove selected option');
    });

    test<NumbersContext>('Typing in the input opens the component and filters the options', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await typeInSearch('', 'fo', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'The dropdown is opened and results filtered');
    });

    test<NumbersContext>('Typing in the input opens the component and filters the options also with async searches', async function (assert) {
      const self = this;

      assert.expect(1);

      this.searchFn = async (term) => {
        await timeout(100);
        return numbers.filter((str) => str.includes(term));
      };

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @search={{self.searchFn}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await typeInSearch('', 'fo', getRootNode(this.element));
      const done = assert.async();

      setTimeout(function () {
        assert
          .dom('.ember-power-select-option', getRootNode(self.element))
          .exists({ count: 2 }, 'The dropdown is opened and results filtered');
        done();
      }, 150);
    });

    test<NumbersContext>('The publicAPI is yielded as second argument in multiple selects', async function (assert) {
      const self = this;

      assert.expect(2);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              as |option select|
            >
              {{select.lastSearchedText}}:{{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'tw', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('tw:two');
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option',
        ) as HTMLElement,
      );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'thr', getRootNode(this.element));
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .includesText('thr:two', 'The trigger also receives the public API');
    });

    test<NumbersContext>('The search input is cleared when the component is closed', async function (assert) {
      const self = this;

      assert.expect(3);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
            <div id="other-thing">Other div</div>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'asjdnah', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found');
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasValue('asjdnah');
      await click(
        getRootNode(this.element).querySelector('#other-thing') as HTMLElement,
      );
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasValue('');
    });

    test<NumbersContext>('When hitting ENTER after a search with no results, the component is closed but the onchange function is not invoked', async function (assert) {
      const self = this;

      assert.expect(3);
      this.numbers = numbers;
      this.onChange = () => {
        assert.ok(false, 'The handle change should not be called');
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'asjdnah', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('The dropdown is closed');
      assert.ok(
        (getRootNode(this.element) as unknown as ShadowRoot).activeElement ===
          getRootNode(this.element).querySelector(
            '.ember-power-select-trigger-multiple-input',
          ),
      );
    });

    test<NumbersContext>('The trigger of multiple selects have a special class to distinguish them from regular ones, even if you pass them another one', async function (assert) {
      const self = this;

      assert.expect(2);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @triggerClass="foobar-trigger"
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasClass(
          'ember-power-select-multiple-trigger',
          'The trigger has the default class',
        );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasClass('foobar-trigger', 'The trigger has the given class');
    });

    test<NumbersContext>('The component works when the array of selected elements is mutated in place instead of replaced', async function (assert) {
      assert.expect(1);

      class NumberClass {
        @tracked selected: string[] = [];

        numbers = numbers;

        onChange = (values: MultipleSelected<string>) => {
          numberClass.selected = values;
        };
      }

      const numberClass = new NumberClass();

      await render(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{numberClass.numbers}}
              @selected={{numberClass.selected}}
              @onChange={{numberClass.onChange}}
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
      if (numbers[3]) {
        numberClass.selected = [...numberClass.selected, numbers[3]];
      }
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 2 }, 'Two elements are selected');
    });

    test<NumbersContext>('When the input inside the multiple select gets focused, the trigger and the dropdown gain special `--active` classes', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .doesNotHaveClass(
          'ember-power-select-trigger--active',
          'The trigger does not have the class',
        );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasClass(
          'ember-power-select-trigger--active',
          'The trigger has the class',
        );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .hasClass(
          'ember-power-select-dropdown--active',
          'The dropdown has the class',
        );
    });

    test<NumbersContext>('When the power select multiple uses the default component and the search is enabled, the trigger has `tabindex=-1`', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasAttribute('tabindex', '-1', 'The trigger has tabindex=-1');
    });

    test<NumbersContext>('When the power select multiple uses the default component and the search is disabled, the trigger has `tabindex=0`', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      await render<NumbersContext>(
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

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasAttribute('tabindex', '0', 'The trigger has tabindex=0');
    });

    test<NumbersContext>('When the power select multiple uses the default component and the search is enabled, and the component receives an specific tabindex, the trigger has tabindex=-1, and the tabindex is applied to the searchbox inside', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @tabindex="3"
              @searchEnabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasAttribute('tabindex', '-1', 'The trigger has tabindex=1');
      assert
        .dom(
          '.ember-power-select-trigger-multiple-input',
          getRootNode(this.element),
        )
        .hasAttribute('tabindex', '3', 'The searchbox has tabindex=3');
    });

    test<NumbersContext>('Multiple selects honor the `defaultHighlighted` option', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.defaultHighlighted = numbers[3];
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @defaultHighlighted={{self.defaultHighlighted}}
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
        .dom(
          '.ember-power-select-option[aria-current=true]',
          getRootNode(this.element),
        )
        .hasText(
          'four',
          'the given defaultHighlighted element is highlighted instead of the first, as usual',
        );
    });

    test<UserContext>('If the options of a multiple select implement `isEqual`, that option is used to determine whether or not two items are the same', async function (assert) {
      const self = this;

      this.search = (term: string) => {
        return names
          .filter((n) => n.indexOf(term) > -1)
          .map((name) => new User(name));
      };

      await render<UserContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @searchEnabled={{true}}
              @search={{self.search}}
              as |user|
            >
              {{user.name}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await typeInSearch('', 'M', getRootNode(this.element));
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      await typeInSearch('', 'Mi', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasAttribute(
          'aria-selected',
          'true',
          'The item in the list is marked as selected',
        );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option',
        ) as HTMLElement,
      ); // select the same user again should remove it
      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 0 });
    });

    test<CountryContext>('When there is an option which is disabled the css class "ember-power-select-multiple-option--disabled" should be added', async function (assert) {
      const self = this;

      assert.expect(2);

      this.countries = countriesWithDisabled;
      const countriesWithDisabledLength = this.countries.length;
      let disabledNumCountries = 0;
      for (let i = 0; i < countriesWithDisabledLength; i++) {
        if (this.countries[i]?.disabled) {
          disabledNumCountries++;
        }
      }

      assert.notEqual(
        disabledNumCountries,
        0,
        'There is at least one disabled option',
      );
      this.selected = countriesWithDisabled;
      await render<CountryContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.countries}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option.name}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );
      assert
        .dom(
          '.ember-power-select-multiple-options .ember-power-select-multiple-option--disabled',
          getRootNode(this.element),
        )
        .exists(
          { count: disabledNumCountries },
          'The class "ember-power-select-multiple-option--disabled" is added to disabled options',
        );
    });

    test<NumbersContext>('The title is rendered in the trigger of multiple selects', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @title="The title"
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasAttribute('title', 'The title');
    });

    test<NumbersContext>('triggerComponent argument could be passed with undefined', async function (assert) {
      const self = this;

      this.numbers = numbers;
      this.selected = numbers.slice(0, 1);

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @triggerComponent={{undefined}}
              @options={{self.numbers}}
              @onChange={{fn (mut self.selected)}}
              @selected={{self.selected}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'Shows selected option');
    });

    test<NumbersContext>('buildSelection argument could be passed with undefined', async function (assert) {
      const self = this;

      this.numbers = numbers;

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @buildSelection={{undefined}}
              @options={{self.numbers}}
              @onChange={{fn (mut self.selected)}}
              @selected={{self.selected}}
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
          '.ember-power-select-option',
        ) as HTMLElement,
      );

      assert
        .dom('.ember-power-select-multiple-option', getRootNode(this.element))
        .exists({ count: 1 }, 'Shows selected option');
    });

    test<NumbersContext>('Multiple selects: The label was rendered when it was passed with `@labelText="Label for select` and is matching with trigger id', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @labelText="Label for select"
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-label', getRootNode(this.element))
        .exists('Label is present');

      assert
        .dom('.ember-power-select-label', getRootNode(this.element))
        .hasText('Label for select');

      assert
        .dom('.ember-power-select-label', getRootNode(this.element))
        .hasTagName('div');
    });

    test<NumbersContext>('Multiple selects: The label was rendered when it was passed with `@labelText="Label for select`, `@labelTag="label"` and is matching with trigger id', async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @labelText="Label for select"
              @labelTag="label"
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-label', getRootNode(this.element))
        .exists('Label is present');

      assert
        .dom('.ember-power-select-label', getRootNode(this.element))
        .hasText('Label for select');

      assert
        .dom('.ember-power-select-label', getRootNode(this.element))
        .hasTagName('label');

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasAttribute(
          'id',
          getRootNode(this.element)
            .querySelector('.ember-power-select-label')
            ?.getAttribute('for') ?? '',
          'The for from label is matching with id of trigger',
        );
    });

    test<NumbersContext>('Multiple selects: The default label is rendered as a label element when @labelTag is not provided', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @labelText="Label for select"
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      const labelElement = getRootNode(this.element).querySelector(
        '.ember-power-select-label',
      );

      assert.equal(
        labelElement?.tagName,
        'DIV',
        'The label is rendered as a div element by default',
      );
    });

    test<NumbersContext>('Multiple selects: Test `@placeholder` and `@searchPlaceholder` with `@searchEnabled={{true}}` and `@searchFieldPosition="before-options"`', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @multiple={{true}}
              @options={{self.numbers}}
              @labelText="Label for select"
              @placeholder="Placeholder"
              @searchEnabled={{true}}
              @searchPlaceholder="Search Placeholder"
              @searchFieldPosition="before-options"
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-placeholder', getRootNode(this.element))
        .exists('Placeholder is present');

      assert
        .dom('.ember-power-select-placeholder', getRootNode(this.element))
        .hasText('Placeholder');

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );

      assert
        .dom('.ember-power-select-search-input', getRootNode(this.element))
        .hasAttribute(
          'placeholder',
          'Search Placeholder',
          'The placeholder in input field is present and has value "Search Placeholder"',
        );
    });

    test<StateContext>('BUGFIX: Rendering issue, when input field is in trigger and complete power select component will be destroyed (issue #1954)', async function (assert) {
      const self = this;

      assert.expect(1);

      this.state = new State();

      this.sort = <T,>(arr: T[]): T[] => arr.sort();

      await render<StateContext>(
        <template>
          <HostWrapper>
            {{#if self.state.selected}}
              <PowerSelect
                @multiple={{true}}
                @options={{array "a" "b" "c"}}
                @selected={{self.sort self.state.selected}}
                @searchEnabled={{true}}
                @onChange={{fn (mut self.state.selected)}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            {{/if}}
          </HostWrapper>
        </template>,
      );

      this.state.selected = undefined;

      assert.ok(true);
    });
  },
);
