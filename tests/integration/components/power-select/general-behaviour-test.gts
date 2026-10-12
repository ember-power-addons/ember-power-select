import { module, test } from 'qunit';
import { setupRenderingTest } from '../../../helpers';
import {
  render,
  click,
  triggerKeyEvent,
  focus,
  settled,
  waitFor,
  type TestContext,
} from '@ember/test-helpers';
import {
  typeInSearch,
  clickTrigger,
  findContains,
} from '#src/test-support/helpers.ts';
import RSVP from 'rsvp';
import { tracked } from '@glimmer/tracking';
import {
  numbers,
  names,
  countries,
  digits,
  type Country,
} from '../../../../demo-app/utils/constants';
import { modifier } from 'ember-modifier';
import PowerSelectBeforeOptions, {
  type PowerSelectBeforeOptionsSignature,
} from '#src/components/power-select/before-options.gts';
import type { ComponentLike } from '@glint/template';
import type {
  DefaultHighlightedParams,
  MatcherFn,
  Selected,
} from '#src/types.ts';
import type { CalculatePosition } from 'ember-basic-dropdown/utils/calculate-position';
import PowerSelect from '#src/components/power-select.gts';
import { fn } from '@ember/helper';
import HostWrapper from '../../../../demo-app/components/host-wrapper.gts';
import { createDescriptor } from 'dom-element-descriptors';
import { timeout } from 'ember-concurrency';

interface NumbersContext<
  IsMultiple extends boolean = false,
> extends TestContext {
  element: HTMLElement;
  numbers: string[] | Promise<string[]>;
  selected: IsMultiple extends true
    ? (string | Promise<string>)[]
    : string | undefined | Promise<string | undefined>;
  search: () => Promise<string[]> | string[];
  proxy: string[] | Promise<string[]>;
  endsWithMatcher: MatcherFn<string>;
  defaultHighlighted?:
    string | ((params: DefaultHighlightedParams<string>) => string);
  destinationElement?: HTMLElement | undefined;
  ref: any;
  foo: () => void;
  renderInPlace?: boolean;
  calculatePosition: CalculatePosition;
  beforeOptionsComponent: ComponentLike<
    PowerSelectBeforeOptionsSignature<string, unknown, IsMultiple>
  >;
}

interface NamesContext extends TestContext {
  element: HTMLElement;
  names: string[];
  foo: () => void;
}

interface PromiseProxy<T = unknown> extends Promise<T> {
  content: T;
}

interface CountriesContext extends TestContext {
  element: HTMLElement;
  countries: Country[];
  country: Selected<Country>;
  proxy: PromiseProxy<Country | undefined>;
  foo: () => void;
  updateProxy: () => void;
}

interface Person {
  name: string;
  surname: string;
}

interface PeopleContext extends TestContext {
  element: HTMLElement;
  people: Person[];
  nameOrSurnameNoDiacriticsCaseSensitive: MatcherFn<Person>;
  foo: () => void;
}

interface UserContext extends TestContext {
  element: HTMLElement;
  selected: Selected<User>;
  search: (term: string) => User[];
  onChange: (user: Selected<User>) => void;
}

interface DigitsContext extends TestContext {
  element: HTMLElement;
  digits: typeof digits;
  selected: Selected<typeof digits>;
}

interface Pet {
  name: string;
}

interface MainUserContext extends TestContext {
  element: HTMLElement;
  mainUser: {
    pets: Pet[];
    selected: Selected<Pet> | Promise<Selected<Pet>>;
  };
  foo: (selected: Selected<Pet>) => void;
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

function getRootNode(element: Element): HTMLElement {
  const shadowRoot = element.querySelector('[data-host-wrapper]')?.shadowRoot;
  if (shadowRoot) {
    return shadowRoot as unknown as HTMLElement;
  }

  return element.getRootNode() as HTMLElement;
}

module(
  'Integration | Component | Ember Power Select (General behavior)',
  function (hooks) {
    setupRenderingTest(hooks);

    test<NumbersContext>('Click in the trigger of a closed select opens the dropdown', async function (assert) {
      const self = this;

      assert.expect(2);
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

      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
    });

    test<NumbersContext>('Click in the trigger of an opened select closes the dropdown', async function (assert) {
      const self = this;

      assert.expect(2);

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
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');
    });

    test<NumbersContext>('Search functionality is disabled by default', async function (assert) {
      const self = this;

      assert.expect(1);

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
        .dom('.ember-power-select-search', getRootNode(this.element))
        .doesNotExist('The search box is NOT rendered');
    });

    test<NumbersContext>('The label was rendered when it was passed with `@labelText="Label for select`, `@labelTag="label"` and is matching with trigger id', async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
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

    test<NumbersContext>('The default label is rendered as a label element when @labelTag is not provided', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
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

    test<NumbersContext>('The labelTag="span" renders a span element instead of a label element for better accessibility', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @labelText="Label for select"
              @labelTag="span"
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
        'SPAN',
        'The label is rendered as a span element',
      );
    });

    test<NumbersContext>('The search functionality can be enabled by passing `@searchEnabled={{true}}`', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @searchEnabled={{true}}
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
        .exists('Dropdown is rendered');
      assert
        .dom('.ember-power-select-search', getRootNode(this.element))
        .exists('The search box is rendered');
    });

    test<NumbersContext>('The search box position is inside the trigger by passing `@searchFieldPosition="trigger"`', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @searchEnabled={{true}}
              @searchFieldPosition="trigger"
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom(
          '.ember-power-select-trigger input[type="search"]',
          getRootNode(this.element),
        )
        .exists('The search box is rendered in trigger');

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
      assert
        .dom('.ember-power-select-search', getRootNode(this.element))
        .doesNotExist('The search box does not exists in dropdown');
    });

    test<NumbersContext>("The search box shouldn't gain focus if autofocus is disabled", async function (assert) {
      const self = this;

      assert.expect(1);
      this.numbers = numbers;
      this.foo = () => {};

      this.beforeOptionsComponent = PowerSelectBeforeOptions;

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            {{#let
              (component self.beforeOptionsComponent autofocus=false)
              as |BeforeOptionsComponent|
            }}
              <PowerSelect
                @options={{self.numbers}}
                @onChange={{self.foo}}
                @searchEnabled={{true}}
                @beforeOptionsComponent={{BeforeOptionsComponent}}
                as |option|
              >
                {{option}}
              </PowerSelect>
            {{/let}}
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-search-input', getRootNode(this.element))
        .isNotFocused('The search box is not focused after opening select');
    });

    test<NumbersContext>('Each option of the select is the result of yielding an item', async function (assert) {
      const self = this;

      assert.expect(4);

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
        .exists(
          { count: numbers.length },
          'There is as many options in the markup as in the supplied array',
        );
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('one');
      assert
        .dom(
          '.ember-power-select-option:nth-child(10)',
          getRootNode(this.element),
        )
        .hasText('ten');
      assert
        .dom(
          '.ember-power-select-option:nth-child(14)',
          getRootNode(this.element),
        )
        .hasText('fourteen');
    });

    test<NumbersContext>("If the passed options is a promise and it's not resolved the component shows a Loading message", async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = [];
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

      this.set(
        'numbers',
        (async () => {
          await timeout(150);
          return numbers;
        })(),
      );

      void clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await waitFor(
        createDescriptor({
          element: getRootNode(this.element),
          description: '.ember-power-select-options',
        }),
      );
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText(
          'Loading options...',
          'The loading message appears while the promise is pending',
        );
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasClass(
          'ember-power-select-option--loading-message',
          'The row has a special class to differentiate it from regular options',
        );
      await settled();
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .doesNotIncludeText('Loading options', 'The loading message is gone');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists(
          { count: 20 },
          'The results appear when the promise is resolved',
        );
    });

    // loadingMessage with false brings default text, so the test and checks are incorrect
    // test<NumbersContext>("If the passed options is a promise and it's not resolved but the `loadingMessage` attribute is false, no loading message is shown", async function (assert) {
    //   assert.expect(2);
    //   this.numbers = [];
    //   this.foo = () => {};

    //   await render<NumbersContext>(hbs`
    //   <PowerSelect @options={{this.numbers}} @onChange={{this.foo}} @loadingMessage={{false}} as |option|>
    //     {{option}}
    //   </PowerSelect>
    // `);

    //   this.set(
    //     'numbers',
    //     new RSVP.Promise((resolve) => {
    //       runTask(
    //         this,
    //         function () {
    //           resolve(numbers);
    //         },
    //         100,
    //       );
    //     }),
    //   );
    //   clickTrigger(getRootNode(this.element).querySelector(
    //     '.ember-power-select-trigger',
    //   ) as HTMLElement);

    //   assert
    //     .dom('.ember-power-select-option', getRootNode(this.element))
    //     .doesNotExist('No loading options message is displayed');
    //   await settled();
    //   assert
    //     .dom('.ember-power-select-option', getRootNode(this.element))
    //     .exists(
    //       { count: 20 },
    //       'The results appear when the promise is resolved',
    //     );
    // });

    test<NumbersContext>('If a placeholder is provided, it shows while no element is selected', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @placeholder="abracadabra"
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom(
          '.ember-power-select-trigger .ember-power-select-placeholder',
          getRootNode(this.element),
        )
        .hasText(
          'abracadabra',
          'The placeholder is rendered when there is no element',
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
        .dom(
          '.ember-power-select-trigger .ember-power-select-placeholder',
          getRootNode(this.element),
        )
        .doesNotExist('The placeholder is gone');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('four', 'The selected item replaced it');
    });

    test<NumbersContext>('If a `@searchPlaceholder` is provided, it shows on the searchbox of single selects while nothing is there', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
              @searchPlaceholder="foobar yo!"
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
        .dom('.ember-power-select-search-input', getRootNode(this.element))
        .hasAttribute(
          'placeholder',
          'foobar yo!',
          'The searchbox has the proper placeholder',
        );
    });

    test<NumbersContext>("If the `@selected` value changes the select gets updated, but the `@onChange` action doesn't fire", async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.selected = undefined;
      this.foo = function () {
        assert.ok(false, 'The onchange action is never fired');
      };

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @selected={{self.selected}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      this.set('selected', 'three');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('three', 'The `three` element is selected');
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
        .hasText('three', 'The proper option gets highlighed');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .hasText('three', 'The proper option gets selected');
    });

    test<NumbersContext>('If the user selects a value and later on the selected value changes from the outside, the components updates too', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.selected = undefined;
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

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('', 'Nothing is selected');
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
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('four', '"four" has been selected');
      this.set('selected', 'three');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText(
          'three',
          '"three" has been selected because a change came from the outside',
        );
    });

    test<NumbersContext>('If the user passes `@renderInPlace={{true}}` the dropdown is added below the trigger instead of in the root', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @renderInPlace={{true}}
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
        .exists('The dropdown is inside the component');
    });

    test<NumbersContext>('If the user passes `@closeOnSelect={{false}}` the dropdown remains visible after selecting an option with the mouse', async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @closeOnSelect={{false}}
              @onChange={{fn (mut self.selected)}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(4)',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('four', '"four" has been selected');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
    });

    test<NumbersContext>('If the user passes `@closeOnSelect={{false}}` the dropdown remains visible after selecting an option with the with the keyboard', async function (assert) {
      const self = this;

      assert.expect(4);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @closeOnSelect={{false}}
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
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');
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
          '.ember-power-select-search-input',
        ) as HTMLElement,
        'keydown',
        13,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('one', '"one" has been selected');
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
    });

    test<NumbersContext>('If the content of the options is refreshed (starting with empty array proxy) the available options should also refresh', async function (assert) {
      const self = this;

      const done = assert.async();
      assert.expect(2);

      class NumberClass {
        @tracked data: string[] = [];
      }

      const numberClass = new NumberClass();

      this.proxy = numberClass.data;
      this.search = () => {
        return new RSVP.Promise((resolve) => {
          resolve(numberClass.data);
          (async () => {
            await timeout(100);
            numberClass.data = [...numberClass.data, 'one'];
          })();
        });
      };

      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.proxy}}
              @search={{self.search}}
              @searchEnabled={{true}}
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
      void typeInSearch('', 'o', getRootNode(this.element));

      setTimeout(function () {
        assert
          .dom('.ember-power-select-option', getRootNode(self.element))
          .exists(
            { count: 1 },
            'The dropdown is opened and results shown after proxy is updated',
          );
        assert
          .dom('.ember-power-select-option', getRootNode(self.element))
          .hasText('one');
        done();
      }, 150);
    });

    test<NumbersContext>('If the content of the options is updated (starting with populated array proxy) the available options should also refresh', async function (assert) {
      const self = this;

      const done = assert.async();
      assert.expect(5);

      class NumberClass {
        @tracked data: string[] = ['one'];
      }

      const numberClass = new NumberClass();

      this.proxy = numberClass.data;
      this.search = () => {
        return new RSVP.Promise((resolve) => {
          resolve(numberClass.data);
          (async () => {
            await timeout(100);
            numberClass.data = [...numberClass.data, 'owner'];
          })();
        });
      };

      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.proxy}}
              @searchEnabled={{true}}
              @search={{self.search}}
              @onChange={{self.foo}}
              as |option|
            > {{option}} </PowerSelect>
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
        .exists(
          'The dropdown is opened and results shown with initial proxy contents',
        );
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('one');

      void typeInSearch('', 'o', getRootNode(this.element));

      setTimeout(function () {
        assert
          .dom('.ember-power-select-option', getRootNode(self.element))
          .exists(
            { count: 2 },
            'The dropdown is opened and results shown after proxy is updated',
          );
        assert
          .dom(
            '.ember-power-select-option:nth-child(1)',
            getRootNode(self.element),
          )
          .hasText('one');
        assert
          .dom(
            '.ember-power-select-option:nth-child(2)',
            getRootNode(self.element),
          )
          .hasText('owner');
        done();
      }, 150);
    });

    test<NumbersContext>('If the content of the options is refreshed while opened the first element of the list gets highlighted', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
              @closeOnSelect={{false}}
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
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-search-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('two', 'The second options is highlighted');
      this.set('numbers', ['foo', 'bar', 'baz']);
      await settled();
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('foo', 'The first element is highlighted');
    });

    test<NumbersContext>('If the user passes `dropdownClass` the dropdown content should have that class', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = [];
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @dropdownClass="this-is-a-test-class"
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
        .hasClass('this-is-a-test-class', 'dropdownClass can be customized');
    });

    test<NumbersContext>('The filtering is reverted after closing the select', async function (assert) {
      const self = this;

      assert.expect(2);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <div id="outside-div"></div>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'th', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'the dropdown has filtered the results');
      await click(
        getRootNode(this.element).querySelector('#outside-div') as HTMLElement,
      );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists(
          { count: numbers.length },
          'the dropdown has shows all results',
        );
    });

    test<NumbersContext>('The publicAPI is yielded as second argument in single selects', async function (assert) {
      const self = this;

      assert.expect(2);
      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
              @onChange={{fn (mut self.selected)}}
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
        .hasText('tw:two', 'Each option receives the public API');
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
        .hasText('thr:two', 'The trigger also receives the public API');
    });

    test<NumbersContext>('If there is no search action and the options is empty the select shows the default "No results found" message', async function (assert) {
      const self = this;

      this.numbers = [];
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
        .exists({ count: 1 });
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasClass(
          'ember-power-select-option--no-matches-message',
          'The row has a special class to differentiate it from regular options',
        );
    });

    test<NumbersContext>('If there is a search action and the options is empty it shows the `searchMessage`, and if after searching there is no results, it shows the `noResults` message', async function (assert) {
      const self = this;

      this.numbers = [];
      this.search = () => [];
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @search={{self.search}}
              @options={{self.numbers}}
              @searchEnabled={{true}}
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
        .exists({ count: 1 });
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('Type to search');
      await typeInSearch('', 'foo', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 });
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found');
    });

    test<NumbersContext>('The default "no options" message can be customized passing `noMatchesMessage="other message"`', async function (assert) {
      const self = this;

      this.numbers = [];
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @noMatchesMessage="Nope"
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
        .exists({ count: 1 });
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('Nope');
    });

    test<NumbersContext>("If there is a search action, the options are empty and the `searchMessage` in intentionally empty, it doesn't show anything, and if you search and there is no results it shows the `noResultsMessage`", async function (assert) {
      const self = this;

      this.numbers = [];
      this.search = () => [];
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @search={{self.search}}
              @searchMessage=""
              @searchEnabled={{true}}
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
        .exists({ count: 0 });
      await typeInSearch('', 'foo', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 });
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found');
    });

    // skip('The content of the dropdown when there are no options can be completely customized using the inverse block', async function(assert) {
    //   this.options = [];
    //   await render(hbs`
    //     <PowerSelect @options={{this.options}} @noMatchesMessage="Nope" @onChange={{fn (mut this.foo)}} as |option|>
    //       {{option}}
    //     {{else}}
    //       <span class="empty-option-foo">Foo bar</span>
    //     </PowerSelect>
    //   `);
    //   await clickTrigger(getRootNode(this.element).querySelector(
    //     '.ember-power-select-trigger',
    //   ) as HTMLElement);
    //   assert.dom('.ember-power-select-option', getRootNode(this.element)).doesNotExist('No list elements, just the given alternate block');
    //   assert.dom('.empty-option-foo', getRootNode(this.element)).exists();
    // });

    test<NumbersContext>('When no `selected` is provided, the first item in the dropdown is highlighted', async function (assert) {
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
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .exists({ count: 1 }, 'One element is highlighted');
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasAttribute('aria-current', 'true', 'The first one to be precise');
    });

    test<NumbersContext>('When `selected` option is provided, it appears in the trigger yielded with the same block as the options', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @selected="three"
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
        .hasText('three', 'The selected option show in the trigger');

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @selected="three"
              @options={{self.numbers}}
              @onChange={{self.foo}}
              as |option|
            >
              Selected:
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText(
          'Selected: three',
          'The selected option uses the same yielded block as the options',
        );
    });

    test<NumbersContext>('When `selected` option is provided, it is highlighted when the dropdown opens (string options)', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @selected="three"
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
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .exists({ count: 1 }, 'One element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('three', 'The third option is highlighted');
    });

    test<NumbersContext>('When `selected` option is provided, that option is marked as `.selected`', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @selected="three"
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
        .dom(
          '.ember-power-select-option:nth-child(3)',
          getRootNode(this.element),
        )
        .hasAttribute(
          'aria-selected',
          'true',
          'The third option is marked as selected',
        );
    });

    test<NamesContext>('The default search strategy matches disregarding diacritics differences and capitalization', async function (assert) {
      const self = this;

      assert.expect(8);

      this.names = names;
      this.foo = () => {};
      await render<NamesContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.names}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'mar', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'Only 2 results match the search');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('María');
      assert
        .dom(
          '.ember-power-select-option:nth-child(2)',
          getRootNode(this.element),
        )
        .hasText('Marta');
      await typeInSearch('', 'mari', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 1 }, 'Only 1 results match the search');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('María');
      await typeInSearch('', 'o', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 2 }, 'Only 2 results match the search');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('Søren Larsen');
      assert
        .dom(
          '.ember-power-select-option:nth-child(2)',
          getRootNode(this.element),
        )
        .hasText('João');
    });

    test<NumbersContext>('You can pass a custom marcher with `matcher=myFn` to customize the search strategy', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.endsWithMatcher = function (
        option: string | undefined,
        text: string,
      ) {
        return option?.slice(text.length * -1) === text ? 0 : -1;
      };
      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @matcher={{self.endsWithMatcher}}
              @searchEnabled={{true}}
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
      await typeInSearch('', 'on', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .hasText('No results found', 'No number ends in "on"');
      await typeInSearch('', 'teen', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 7 }, 'There is 7 number that end in "teen"');
    });

    test<CountriesContext>('When no `selected` is provided, the first item in the dropdown is highlighted', async function (assert) {
      const self = this;

      assert.expect(3);

      this.countries = countries;
      this.foo = () => {};
      await render<CountriesContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.countries}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option.code}}:
              {{option.name}}
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
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .exists({ count: 1 }, 'One element is highlighted');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasAttribute('aria-current', 'true', 'The first one to be precise');
    });

    test<CountriesContext>('When a option is provided that options is rendered in the trigger using the same block as the options', async function (assert) {
      const self = this;

      assert.expect(1);

      this.countries = countries;
      this.country = countries[1]; // Spain
      this.foo = () => {};
      await render<CountriesContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.countries}}
              @selected={{self.country}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option.code}}:
              {{option.name}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText(
          'ES: Spain',
          'The selected country is rendered in the trigger',
        );
    });

    test<CountriesContext>('When `selected` option is provided, it is highlighted when the dropdown opens (object options)', async function (assert) {
      const self = this;

      assert.expect(2);

      this.countries = countries;
      this.country = countries[1]; // Spain
      await render<CountriesContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.countries}}
              @selected={{self.country}}
              @onChange={{fn (mut self.country)}}
              as |option|
            >
              {{option.code}}:
              {{option.name}}
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
        .exists('One element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('ES: Spain', 'The second option is highlighted');
    });

    test<CountriesContext>('When `selected` option (object) is provided, that option is marked as `.selected`', async function (assert) {
      const self = this;

      assert.expect(1);

      this.countries = countries;
      this.country = countries[1]; // Spain
      await render<CountriesContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.countries}}
              @selected={{self.country}}
              @onChange={{fn (mut self.country)}}
              as |option|
            >
              {{option.code}}:
              {{~option.name}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await settled();

      const selectedOption = findContains(
        '.ember-power-select-option',
        'ES:Spain',
        getRootNode(this.element),
      );
      assert
        .dom(selectedOption, getRootNode(this.element))
        .hasAttribute(
          'aria-selected',
          'true',
          'The second option is marked as selected',
        );
    });

    test<PeopleContext>('The default search strategy matches disregarding diacritics differences and capitalization', async function (assert) {
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
              @options={{self.people}}
              @searchField="name"
              @searchEnabled={{true}}
              @onChange={{self.foo}}
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
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
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

    test<PeopleContext>('You can pass a custom marcher with `matcher=myFn` to customize the search strategy', async function (assert) {
      const self = this;

      assert.expect(4);

      this.people = [
        { name: 'María', surname: 'Murray' },
        { name: 'Søren', surname: 'Williams' },
        { name: 'João', surname: 'Jin' },
        { name: 'Miguel', surname: 'Camba' },
        { name: 'Marta', surname: 'Stinson' },
        { name: 'Lisa', surname: 'Simpson' },
      ];

      this.nameOrSurnameNoDiacriticsCaseSensitive = function (
        person: Person | undefined,
        term: string,
      ) {
        return `${person?.name} ${person?.surname}`.indexOf(term);
      };

      this.foo = () => {};

      await render<PeopleContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.people}}
              @searchEnabled={{true}}
              @matcher={{self.nameOrSurnameNoDiacriticsCaseSensitive}}
              @onChange={{self.foo}}
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
      await typeInSearch('', 's', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 3 }, 'Only 3 results match the search');
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
        .hasText('Marta Stinson');
      assert
        .dom(
          '.ember-power-select-option:nth-child(3)',
          getRootNode(this.element),
        )
        .hasText('Lisa Simpson');
    });

    test<NumbersContext>('BUGFIX: The highlighted element is reset when single selects are closed', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.selected = 'three';
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
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
        .hasText('three', 'The third element is highlighted');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-search-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('four', 'The forth element is highlighted');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
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
        .hasText('three', 'The third element is highlighted again');
    });

    test<NumbersContext>('BUGFIX: The highlighted element is reset when multiple selects are closed', async function (assert) {
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
              @searchEnabled={{true}}
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
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one', 'The first element is highlighted');
      await triggerKeyEvent(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger-multiple-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('two', 'The second element is highlighted');
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
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
        .hasText('one', 'The first element is highlighted again');
    });

    test<NumbersContext>('If the passed options is a promise that is resolved, searching should filter the results from a promise', async function (assert) {
      const self = this;

      assert.expect(5);

      this.numbers = (async () => {
        await timeout(100);
        return numbers;
      })();

      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @searchEnabled={{true}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await new RSVP.Promise((resolve) => setTimeout(resolve, 150));

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'o', getRootNode(this.element));
      assert
        .dom('.ember-power-select-option', getRootNode(this.element))
        .exists({ count: 4 }, 'The dropdown is opened and results shown.');
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasText('one');
      assert
        .dom(
          '.ember-power-select-option:nth-child(2)',
          getRootNode(this.element),
        )
        .hasText('two');
      assert
        .dom(
          '.ember-power-select-option:nth-child(3)',
          getRootNode(this.element),
        )
        .hasText('four');
      assert
        .dom(
          '.ember-power-select-option:nth-child(4)',
          getRootNode(this.element),
        )
        .hasText('fourteen');
    });

    test<NumbersContext>('An empty-string selection is treated as an empty select', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.selected = '';
      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @allowClear={{true}}
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
        .hasText('', 'The trigger stays empty');
      assert
        .dom('.ember-power-select-clear-btn', getRootNode(this.element))
        .doesNotExist('Empty strings do not render a clear button');
    });

    test<NumbersContext>("Disabled single selects don't have a clear button even if `allowClear` is true", async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.selected = numbers[2];
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @allowClear={{true}}
              disabled={{true}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('ember-power-select-clear-btn', getRootNode(this.element))
        .doesNotExist('There is no clear button');
    });

    test<NumbersContext>('If the passed selected element is a pending promise, the first element is highlighted and the trigger is empty', async function (assert) {
      const self = this;

      assert.expect(3);
      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      this.set(
        'selected',
        (async () => {
          await timeout(100);
          return numbers[3];
        })(),
      );
      void clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await waitFor(
        createDescriptor({
          element: getRootNode(this.element),
          description: '.ember-power-select-options',
        }),
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one', 'The first element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .doesNotExist('no element is selected');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('', 'Nothing is selected yet');
    });

    test<NumbersContext>('If the passed selected element is a resolved promise, that element is selected and the trigger contains the proper text', async function (assert) {
      const self = this;

      assert.expect(3);

      this.numbers = numbers;
      this.selected = RSVP.resolve(numbers[3]);
      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
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
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('four', 'The 4th element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .hasText('four', 'The 4th element is highlighted');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('four', 'The trigger has the proper content');
    });

    test<NumbersContext>('If the passed selected element is a pending promise that resolves while the select is opened, the highlighted & selected elements get updated, along with the trigger', async function (assert) {
      const self = this;

      assert.expect(6);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );
      this.set(
        'selected',
        (async () => {
          await timeout(100);
          return numbers[3];
        })(),
      );

      void clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await waitFor(
        createDescriptor({
          element: getRootNode(this.element),
          description: '.ember-power-select-options',
        }),
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one', 'The first element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .doesNotExist('no element is selected');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('', 'Nothing is selected yet');

      await this.selected;
      await waitFor(
        createDescriptor({
          element: getRootNode(this.element),
          description: '.ember-power-select-options',
        }),
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('four', 'The 4th element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .hasText('four', 'The 4th element is highlighted');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('four', 'The trigger has the proper content');
    });

    test<NumbersContext>("When a promise resolves it doesn't overwrite a previous value if it isn't the same promise it resolved from", async function (assert) {
      const self = this;

      assert.expect(5);
      this.numbers = numbers;
      this.foo = () => {};

      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @onChange={{self.foo}}
              as |option|
            >
              {{option}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      const promise1 = (async () => {
        await timeout(400);
        return numbers[3];
      })();

      const promise2 = (async () => {
        await timeout(300);
        return numbers[4];
      })();

      this.set('selected', promise1);
      await timeout(20);
      this.set('selected', promise2);

      void clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await waitFor(
        createDescriptor({
          element: getRootNode(this.element),
          description: '.ember-power-select-options',
        }),
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one', 'The first element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .doesNotExist('no element is selected');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('', 'Nothing is selected yet');

      await promise1;
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .hasText('five', 'The 5th element is markes as selected');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('five', 'The trigger has the proper content');
    });

    // This test also fails randomly. Refactor.
    // test('When both `selected` and `options` are async, and `selected` resolves before `options`, the proper options are selected/highlighted after each resolution', function(assert) {
    //   let done = assert.async();
    //   assert.expect(6);

    //   this.asyncOptions = new Ember.RSVP.Promise((resolve) => {
    //     setTimeout(() => resolve(numbers), 200);
    //   });
    //   this.asyncSelected = new Ember.RSVP.Promise((resolve) => {
    //     setTimeout(() => resolve('four'), 10);
    //   });

    //   this.render(hbs`
    //     <PowerSelect options=asyncOptions selected=asyncSelected @onChange={{fn (mut this.foo)}} as |option|>
    //       {{option}}
    //     </PowerSelect>
    //   `);

    //   await clickTrigger(getRootNode(this.element).querySelector(
    //     '.ember-power-select-trigger',
    //   ) as HTMLElement);

    //   assert.dom('.ember-power-select-option[aria-selected="true"]').doesNotExist('no element is selected');
    //   assert.dom('.ember-power-select-trigger', getRootNode(this.element)).hasText('', 'Nothing is selected yet');

    //   setTimeout(function() {
    //     assert.dom('.ember-power-select-trigger', getRootNode(this.element)).hasText('four', 'The trigger has the proper content');
    //   }, 20);

    //   setTimeout(function() {
    //     assert.dom('.ember-power-select-option[aria-current="true"]').hasText('four', 'The 4th element is highlighted');
    //     assert.dom('.ember-power-select-option[aria-selected="true"]').hasText('four', 'The 4th element is selected');
    //     assert.dom('.ember-power-select-trigger', getRootNode(this.element)).hasText('four', 'The trigger has the proper content');
    //     done();
    //   }, 220);
    // });

    // This test has been commented because it was randomly failing. It's still a valuable test,
    // and I should revisit it to fix it.

    // test('When both `selected` and `options` are async, and `options` resolves before `selected`, the proper options are selected/highlighted after each resolution', function(assert) {
    //   let done = assert.async();
    //   assert.expect(7);

    //   this.asyncOptions = new Ember.RSVP.Promise((resolve) => {
    //     setTimeout(() => resolve(numbers), 10);
    //   });
    //   this.asyncSelected = new Ember.RSVP.Promise((resolve) => {
    //     setTimeout(() => resolve('four'), 300);
    //   });

    //   this.render(hbs`
    //     <PowerSelect options=asyncOptions selected=asyncSelected @onChange={{fn (mut this.foo)}} as |option|>
    //       {{option}}
    //     </PowerSelect>
    //   `);

    //   await clickTrigger(getRootNode(this.element).querySelector(
    //     '.ember-power-select-trigger',
    //   ) as HTMLElement);

    //   assert.dom('.ember-power-select-option[aria-selected="true"]').doesNotExist('no element is selected');
    //   assert.dom('.ember-power-select-trigger', getRootNode(this.element)).hasText('', 'Nothing is selected yet');

    //   setTimeout(function() {
    //     assert.dom('.ember-power-select-trigger', getRootNode(this.element)).hasText('', 'The trigger is still empty');
    //     assert.dom('.ember-power-select-option[aria-current="true"]').hasText('one', 'The 1st element is highlighted');
    //   }, 100);

    //   setTimeout(function() {
    //     assert.dom('.ember-power-select-option[aria-current="true"]').hasText('four', 'The 4th element is highlighted');
    //     assert.dom('.ember-power-select-option[aria-selected="true"]').hasText('four', 'The 4th element is selected');
    //     assert.dom('.ember-power-select-trigger', getRootNode(this.element)).hasText('four', 'The trigger has the proper content');
    //     done();
    //   }, 350);
    // });

    test<NumbersContext>('When the input inside the select gets focused the entire component gains the `ember-power-select-trigger--active` class', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @searchEnabled={{true}}
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
          "The select doesn't have the class yet",
        );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await focus(
        getRootNode(this.element).querySelector(
          '.ember-power-select-search-input',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasClass(
          'ember-power-select-trigger--active',
          'The select has the class now',
        );
    });

    test<NumbersContext>('[BUGFIX] When the component opens, if the selected option is not visible the list is scrolled to make it visible', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected="nine"
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
        .hasText('nine');
      assert.ok(
        (getRootNode(this.element).querySelector('.ember-power-select-options')
          ?.scrollTop ?? 0) > 0,
        'The list has scrolled',
      );
    });

    test<NumbersContext>('The destination where the content is rendered can be customized by passing a `destination=id-of-the-destination`', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @destination="alternative-destination"
              as |option|
            >
              {{option}}
            </PowerSelect>
            <div id="alternative-destination"></div>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom(
          '#alternative-destination .ember-power-select-dropdown',
          getRootNode(this.element),
        )
        .exists('Dropdown is rendered inside the destination element');
    });

    test<NumbersContext>('The destination where the content is rendered can be customized by passing a `destinationElement=element`', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.ref = modifier((element) => {
        this.set('destinationElement', element);
      });
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
              @destinationElement={{self.destinationElement}}
              as |option|
            >
              {{option}}
            </PowerSelect>
            <div class="alternative-destination" {{self.ref}}></div>
          </HostWrapper>
        </template>,
      );

      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .doesNotExist('Dropdown is not rendered');

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom(
          '.alternative-destination .ember-power-select-dropdown',
          getRootNode(this.element),
        )
        .exists('Dropdown is rendered inside the destination element');
    });

    test<NumbersContext>('[BUGFIX] When the component is open and it has a `search` action, if options get updated the highlighted items is reset', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.selected = undefined;
      this.search = () => [];
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @selected={{self.selected}}
              @searchEnabled={{true}}
              @onChange={{fn (mut self.selected)}}
              @search={{self.search}}
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
          '.ember-power-select-search-input',
        ) as HTMLElement,
        'keydown',
        40,
      );
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('two');
      this.set('numbers', ['one', 'three', 'five', 'seven', 'nine']);
      await settled();
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('one');
    });

    test<NumbersContext>('the item that is highlighted by default can be customized passing a value to `@defaultHighlighted`', async function (assert) {
      const self = this;

      assert.expect(2);

      this.numbers = numbers;
      this.defaultHighlighted = numbers[4];
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @onChange={{self.foo}}
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
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
      assert
        .dom(
          '.ember-power-select-option[aria-current=true]',
          getRootNode(this.element),
        )
        .hasText(
          'five',
          'the given element is highlighted instead of the first, as usual',
        );
    });

    test<NumbersContext>('the item that is highlighted by default can be customized passing a function to `@defaultHighlighted`', async function (assert) {
      const self = this;

      assert.expect(6);

      this.numbers = numbers;
      this.selected = numbers[1];

      this.defaultHighlighted = (
        params: DefaultHighlightedParams<string>,
      ): string => {
        const { selected, results } = params;
        assert.ok(results instanceof Array, 'select.results is an array');
        assert.strictEqual(selected, numbers[1]);
        return 'five';
      };
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @selected={{self.selected}}
              @options={{self.numbers}}
              @onChange={{self.foo}}
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
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .exists('Dropdown is rendered');
      assert
        .dom(
          '.ember-power-select-option[aria-current=true]',
          getRootNode(this.element),
        )
        .hasText(
          'five',
          'the given element is highlighted instead of the first, as usual',
        );
    });

    test<UserContext>('If the options of a single select implement `isEqual`, that option is used to determine whether or not two items are the same', async function (assert) {
      const self = this;

      this.search = (term: string) => {
        return names
          .filter((n) => n.indexOf(term) > -1)
          .map((name) => new User(name));
      };

      let onChangeInvocationsCount = 0;
      this.onChange = (selected) => {
        onChangeInvocationsCount++;
        this.set('selected', selected);
      };

      await render<UserContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @selected={{self.selected}}
              @onChange={{self.onChange}}
              @searchEnabled={{true}}
              @search={{self.search}}
              as |user|
            >
              {{user.name}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'M', getRootNode(this.element));
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(2)',
        ) as HTMLElement,
      );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      await typeInSearch('', 'i', getRootNode(this.element));
      assert
        .dom(
          '.ember-power-select-option:nth-child(1)',
          getRootNode(this.element),
        )
        .hasAttribute(
          'aria-selected',
          'true',
          'The item in the list is marked as selected',
        );
      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(1)',
        ) as HTMLElement,
      );
      assert.strictEqual(onChangeInvocationsCount, 1);
    });

    test<NumbersContext>('If the select receives a `@calculatePosition` option, it uses it to calculate the position of the floating content', async function (assert) {
      const self = this;

      this.numbers = numbers;
      this.renderInPlace = false;
      this.calculatePosition = function (_, _2, _3, { renderInPlace }) {
        if (renderInPlace) {
          return {
            horizontalPosition: 'left',
            verticalPosition: 'below',
            style: {
              top: 333,
              right: 444,
            },
          };
        } else {
          return {
            horizontalPosition: 'right',
            verticalPosition: 'above',
            style: {
              top: 111,
              right: 222,
            },
          };
        }
      };
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.numbers}}
              @renderInPlace={{self.renderInPlace}}
              @selected={{self.selected}}
              @onChange={{fn (mut self.selected)}}
              @calculatePosition={{self.calculatePosition}}
              as |num|
            >
              {{num}}
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
        .hasClass(
          'ember-basic-dropdown-content--above',
          'The dropdown is above',
        );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .hasClass(
          'ember-basic-dropdown-content--right',
          'The dropdown is in the right',
        );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .hasAttribute(
          'style',
          /top: 111px; right: 222px;/,
          'The style attribute is the expected one',
        );
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );

      this.set('renderInPlace', true);
      await clickTrigger(
        getRootNode(this.element).querySelector(
          '.ember-power-select-trigger',
        ) as HTMLElement,
      );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .hasClass(
          'ember-basic-dropdown-content--below',
          'The dropdown is below',
        );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .hasClass(
          'ember-basic-dropdown-content--left',
          'The dropdown is in the left',
        );
      assert
        .dom('.ember-power-select-dropdown', getRootNode(this.element))
        .hasAttribute(
          'style',
          /top: 333px; right: 444px;/,
          'The style attribute is the expected one',
        );
    });

    test<MainUserContext>('The `selected` option can be a thenable', async function (assert) {
      const self = this;

      assert.expect(6);
      const pets = [
        { name: 'Toby' },
        { name: 'Rex' },
        { name: 'Lucius' },
        { name: 'Donatello' },
      ];
      this.mainUser = { pets, selected: undefined };
      this.foo = () => {};

      await render<MainUserContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.mainUser.pets}}
              @selected={{self.mainUser.selected}}
              @searchField="name"
              @onChange={{self.foo}}
              as |option|
            >
              {{option.name}}
            </PowerSelect>
          </HostWrapper>
        </template>,
      );

      this.set(
        'mainUser.selected',
        new RSVP.Promise((resolve) => {
          setTimeout(() => resolve(pets[2]), 90);
        }),
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
        .hasText('Toby', 'The first element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .doesNotExist('no element is selected');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('', 'Nothing is selected yet');

      await this.mainUser.selected;
      await settled();
      assert
        .dom(
          '.ember-power-select-option[aria-current="true"]',
          getRootNode(this.element),
        )
        .hasText('Lucius', 'The 4th element is highlighted');
      assert
        .dom(
          '.ember-power-select-option[aria-selected="true"]',
          getRootNode(this.element),
        )
        .hasText('Lucius', 'The 4th element is highlighted');
      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText('Lucius', 'The trigger has the proper content');
    });

    test<NumbersContext>('The title is rendered in the trigger', async function (assert) {
      const self = this;

      assert.expect(1);

      this.numbers = numbers;
      this.foo = () => {};
      await render<NumbersContext>(
        <template>
          <HostWrapper>
            <PowerSelect
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

    test<DigitsContext>('works with numbers', async function (assert) {
      const self = this;

      assert.expect(3);

      this.selected = digits[0];
      this.digits = digits;
      await render<DigitsContext>(
        <template>
          <HostWrapper>
            <PowerSelect
              @options={{self.digits}}
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
        .hasText(`${digits[0]}`, 'number "0" is shown in the trigger');

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
          `${digits[0]}`,
          'The option containing "0" has been highlighted',
        );

      await click(
        getRootNode(this.element).querySelector(
          '.ember-power-select-option:nth-child(4)',
        ) as HTMLElement,
      );

      assert
        .dom('.ember-power-select-trigger', getRootNode(this.element))
        .hasText(`${digits[3]}`, 'number "5" is shown in the trigger');
    });
  },
);
