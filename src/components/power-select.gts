import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action, get } from '@ember/object';
import { guidFor } from '@ember/object/internals';
import isEqual from '../utils/equal.ts';
import { assert } from '@ember/debug';
import {
  indexOfOption,
  filterOptions,
  findOptionWithOffset,
  countOptions,
  defaultHighlighted,
  advanceSelectableOption,
  defaultMatcher,
  defaultTypeAheadMatcher,
  pathForOption,
} from '../utils/group-utils.ts';
import { task, timeout } from 'ember-concurrency';
import { modifier } from 'ember-modifier';
import PowerSelectLabel from './power-select/label.gts';
import PowerSelectTrigger from './power-select/trigger.gts';
import PowerSelectPlaceholderComponent from './power-select/placeholder.gts';
import PowerSelectBeforeOptions from './power-select/before-options.gts';
import SearchMessageComponent from './power-select/search-message.gts';
import NoMatchesMessageComponent from './power-select/no-matches-message.gts';
import PowerSelectOptions from './power-select/options.gts';
import PowerSelectGroupComponent from './power-select/power-select-group.gts';
import type { BasicDropdownDefaultBlock } from 'ember-basic-dropdown/components/basic-dropdown';
import type { Dropdown, TRootEventType } from 'ember-basic-dropdown/types';
import type Owner from '@ember/owner';
import type {
  CalculatePosition,
  HorizontalPosition,
  VerticalPosition,
} from 'ember-basic-dropdown/utils/calculate-position';
import type { ComponentLike } from '@glint/template';
import type { PowerSelectPlaceholderSignature } from './power-select/placeholder.gts';
import type { PowerSelectSearchMessageSignature } from './power-select/search-message.gts';
import type { PowerSelectNoMatchesMessageSignature } from './power-select/no-matches-message.gts';
import type { BasicDropdownTriggerSignature } from 'ember-basic-dropdown/components/basic-dropdown-trigger';
import type { BasicDropdownContentSignature } from 'ember-basic-dropdown/components/basic-dropdown-content';
import type { PowerSelectLabelSignature } from './power-select/label.gts';
import type { PowerSelectTriggerSignature } from './power-select/trigger.gts';
import type { PowerSelectBeforeOptionsSignature } from './power-select/before-options.gts';
import type { PowerSelectOptionsSignature } from './power-select/options.gts';
import type { PowerSelectPowerSelectGroupSignature } from './power-select/power-select-group.gts';
import type {
  DefaultHighlightedParams,
  MatcherFn,
  Option,
  PowerSelectAfterOptionsSignature,
  PowerSelectSelectedItemSignature,
  Select,
  Selected,
  TLabelClickAction,
  TSearchFieldPosition,
} from '../types.ts';
import BasicDropdown from 'ember-basic-dropdown/components/basic-dropdown';
import { on } from '@ember/modifier';
import { or, and, not, notEq } from 'ember-truth-helpers';
import { concat } from '@ember/helper';

interface PromiseProxy<T = unknown> extends Promise<T> {
  content: T;
}

interface CancellablePromise<T> extends Promise<T> {
  cancel: () => void;
}

interface Sliceable<T> {
  slice(): T[];
}

// Some args are not listed here because they are only accessed from the template. Should I list them?
export interface PowerSelectArgs<
  T,
  IsMultiple extends boolean = false,
  TExtra = unknown,
> {
  highlightOnHover?: boolean;
  placeholderComponent?:
    | ComponentLike<
        PowerSelectPlaceholderSignature<NoInfer<T>, TExtra, NoInfer<IsMultiple>>
      >
    | ComponentLike<PowerSelectPlaceholderSignature<unknown>>;
  searchMessage?: string;
  searchMessageComponent?:
    | ComponentLike<
        PowerSelectSearchMessageSignature<
          NoInfer<T>,
          TExtra,
          NoInfer<IsMultiple>
        >
      >
    | ComponentLike<PowerSelectSearchMessageSignature<unknown>>;
  noMatchesMessage?: string;
  noMatchesMessageComponent?:
    | ComponentLike<
        PowerSelectNoMatchesMessageSignature<
          NoInfer<T>,
          TExtra,
          NoInfer<IsMultiple>
        >
      >
    | ComponentLike<PowerSelectNoMatchesMessageSignature<unknown>>;
  matchTriggerWidth?: boolean;
  resultCountMessage?: (resultCount: number) => string;
  options?: readonly T[] | Promise<readonly T[]>;
  selected?: Selected<T, IsMultiple> | Promise<Selected<T, IsMultiple>>;
  multiple?: IsMultiple;
  destination?: string;
  destinationElement?: HTMLElement;
  closeOnSelect?: boolean;
  renderInPlace?: boolean;
  preventScroll?: boolean;
  defaultHighlighted?:
    | ((params: DefaultHighlightedParams<T>) => Option<T> | undefined)
    | Option<T>
    | undefined;
  searchField?: string;
  labelClass?: string;
  labelText?: string;
  labelTag?: keyof HTMLElementTagNameMap;
  labelClickAction?: TLabelClickAction;
  ariaLabel?: string;
  ariaLabelledBy?: string;
  loadingMessage?: string;
  placeholder?: string;
  dropdownClass?: string;
  allowClear?: boolean;
  searchEnabled?: boolean;
  animationEnabled?: boolean;
  tabindex?: number | string;
  searchPlaceholder?: string;
  searchFieldPosition?: TSearchFieldPosition;
  verticalPosition?: VerticalPosition;
  horizontalPosition?: HorizontalPosition;
  triggerId?: string;
  disabled?: boolean;
  title?: string;
  triggerRole?: string;
  required?: string;
  triggerClass?: string;
  ariaInvalid?: string;
  eventType?: BasicDropdownTriggerSignature['Args']['eventType'];
  rootEventType?: TRootEventType;
  ariaDescribedBy?: string;
  calculatePosition?: CalculatePosition;
  ebdTriggerComponent?: ComponentLike<BasicDropdownTriggerSignature>;
  ebdContentComponent?: ComponentLike<BasicDropdownContentSignature>;
  labelComponent?:
    | ComponentLike<
        PowerSelectLabelSignature<NoInfer<T>, TExtra, NoInfer<IsMultiple>>
      >
    | ComponentLike<PowerSelectLabelSignature<unknown>>;
  triggerComponent?:
    | ComponentLike<
        PowerSelectTriggerSignature<NoInfer<T>, TExtra, NoInfer<IsMultiple>>
      >
    | ComponentLike<PowerSelectTriggerSignature<unknown>>;
  selectedItemComponent?:
    | ComponentLike<
        PowerSelectSelectedItemSignature<
          NoInfer<T>,
          TExtra,
          NoInfer<IsMultiple>
        >
      >
    | ComponentLike<PowerSelectSelectedItemSignature<unknown>>;
  beforeOptionsComponent?:
    | ComponentLike<
        PowerSelectBeforeOptionsSignature<
          NoInfer<T>,
          TExtra,
          NoInfer<IsMultiple>
        >
      >
    | ComponentLike<PowerSelectBeforeOptionsSignature<unknown>>;
  optionsComponent?:
    | ComponentLike<
        PowerSelectOptionsSignature<NoInfer<T>, TExtra, NoInfer<IsMultiple>>
      >
    | ComponentLike<PowerSelectOptionsSignature<unknown>>;
  groupComponent?:
    | ComponentLike<
        PowerSelectPowerSelectGroupSignature<
          NoInfer<T>,
          TExtra,
          NoInfer<IsMultiple>
        >
      >
    | ComponentLike<PowerSelectPowerSelectGroupSignature<unknown>>;
  afterOptionsComponent?:
    | ComponentLike<
        PowerSelectAfterOptionsSignature<
          NoInfer<T>,
          TExtra,
          NoInfer<IsMultiple>
        >
      >
    | ComponentLike<PowerSelectAfterOptionsSignature<unknown>>;
  extra?: TExtra;
  matcher?: MatcherFn<T>;
  initiallyOpened?: boolean;
  typeAheadOptionMatcher?: MatcherFn<T>;
  buildSelection?: (
    selected: Option<T>,
    select: Select<T, IsMultiple>,
  ) => Selected<T, IsMultiple>;
  onChange: (
    selection: Selected<T, IsMultiple>,
    select: Select<T, IsMultiple>,
    event?: Event,
  ) => void;
  search?: (
    term: string,
    select: Select<T, IsMultiple>,
  ) => readonly T[] | Promise<readonly T[]> | Promise<void> | void;
  onOpen?: (
    select: Select<T, IsMultiple>,
    e: Event | undefined,
  ) => boolean | void | undefined;
  onClose?: (
    select: Select<T, IsMultiple>,
    e: Event | undefined,
  ) => boolean | void | undefined;
  onInput?: (
    term: string,
    select: Select<T, IsMultiple>,
    e: Event,
  ) => string | false | void | PromiseLike<void>;
  onKeydown?: (
    select: Select<T, IsMultiple>,
    e: KeyboardEvent,
  ) => boolean | void | undefined;
  onFocus?: (select: Select<T, IsMultiple>, event: FocusEvent) => void;
  onBlur?: (select: Select<T, IsMultiple>, event: FocusEvent) => void;
  scrollTo?: (option: Selected<T>, select: Select<T, IsMultiple>) => void;
  registerAPI?: (select: Select<T, IsMultiple>) => void;
}

export interface PowerSelectSignature<
  T,
  IsMultiple extends boolean = false,
  TExtra = undefined,
> {
  Element: Element;
  Args: PowerSelectArgs<T, IsMultiple, TExtra>;
  Blocks: {
    default: [option: Option<T>, select: Select<T, IsMultiple>];
  };
}

const isSliceable = <T,>(coll: unknown): coll is Sliceable<T> => {
  return Array.isArray(coll);
};

const isPromiseLike = <T,>(thing: unknown): thing is Promise<T> => {
  return (
    typeof thing === 'object' &&
    thing !== null &&
    typeof (thing as { then?: unknown }).then === 'function'
  );
};

const isCancellablePromise = <T,>(
  thing: unknown,
): thing is CancellablePromise<T> => {
  return (
    typeof thing === 'object' &&
    thing !== null &&
    typeof (thing as { cancel?: unknown }).cancel === 'function'
  );
};

const toPlainArray = <T,>(collection: T | T[] | Sliceable<T>): T[] | T => {
  if (isSliceable<T>(collection)) {
    return collection.slice();
  } else {
    return collection;
  }
};

function getOptionMatcher<T>(
  matcher: MatcherFn<T>,
  defaultMatcher: MatcherFn<T>,
  searchField: string | undefined,
): MatcherFn<T> {
  if (searchField && matcher === defaultMatcher) {
    return (option: T | undefined, text: string) =>
      matcher(get(option, searchField) as T | undefined, text);
  } else {
    return (option: T | undefined, text: string) => {
      assert(
        '<PowerSelect> If you want the default filtering to work on options that are not plain strings, you need to provide `@searchField`',
        matcher !== defaultMatcher || typeof option === 'string',
      );
      return matcher(option, text);
    };
  }
}

export default class PowerSelect<
  T,
  IsMultiple extends boolean = false,
  TExtra = undefined,
> extends Component<PowerSelectSignature<T, IsMultiple, TExtra>> {
  // Untracked properties
  _publicAPIActions = {
    search: this._search.bind(this),
    highlight: this._highlight.bind(this),
    select: this._select.bind(this),
    choose: this._choose.bind(this),
    scrollTo: this._scrollTo.bind(this),
    labelClick: this._labelClick.bind(this),
  };

  // Tracked properties
  @tracked private _resolvedOptions?: T | readonly T[];
  @tracked private _resolvedSelected?: Selected<T, IsMultiple> | undefined;
  @tracked private _repeatingChar = '';
  @tracked private _expirableSearchText = '';
  @tracked private _searchResult?: readonly T[];
  @tracked isActive = false;
  @tracked loading = false;
  @tracked searchText = '';
  @tracked lastSearchedText = '';
  @tracked highlighted?: Option<T> | undefined;
  storedAPI!: Select<T, IsMultiple>;

  private _uid = guidFor(this);
  private _lastOptionsPromise?: Promise<readonly T[]>;
  private _lastSelectedPromise?:
    | PromiseProxy<Selected<T, IsMultiple>>
    | Promise<Selected<T, IsMultiple>>;
  private _lastSearchPromise?:
    | Promise<readonly T[]>
    | CancellablePromise<readonly T[]>
    | Promise<void>;
  private _filterResultsCache: {
    results: T[];
    options: T[];
    searchText: string;
  } = { results: [], options: [], searchText: this.searchText };

  // Lifecycle hooks
  constructor(owner: Owner, args: PowerSelectArgs<T, IsMultiple, TExtra>) {
    super(owner, args);
    assert(
      '<PowerSelect> requires an `@onChange` function',
      this.args.onChange && typeof this.args.onChange === 'function',
    );
  }

  willDestroy() {
    super.willDestroy();
  }

  // Getters
  get highlightOnHover(): boolean {
    return this.args.highlightOnHover === undefined
      ? true
      : this.args.highlightOnHover;
  }

  get labelClickAction(): TLabelClickAction {
    return this.args.labelClickAction === undefined
      ? 'focus'
      : this.args.labelClickAction;
  }

  get highlightedIndex(): string {
    const results = this.results;
    const highlighted = this.highlighted;
    return pathForOption(results, highlighted);
  }

  get searchMessage(): string {
    return this.args.searchMessage === undefined
      ? 'Type to search'
      : this.args.searchMessage;
  }

  get noMatchesMessage(): string {
    return this.args.noMatchesMessage === undefined
      ? 'No results found'
      : this.args.noMatchesMessage;
  }

  get resultCountMessage(): string {
    if (typeof this.args.resultCountMessage === 'function') {
      return this.args.resultCountMessage(this.resultsCount);
    }

    if (this.resultsCount === 1) {
      return `${this.resultsCount} result`;
    }

    return `${this.resultsCount} results`;
  }

  get matchTriggerWidth() {
    return this.args.matchTriggerWidth === undefined
      ? true
      : this.args.matchTriggerWidth;
  }

  get mustShowSearchMessage(): boolean {
    return (
      !this.loading &&
      this.searchText.length === 0 &&
      !!this.args.search &&
      !!this.searchMessage &&
      this.resultsCount === 0
    );
  }

  get mustShowNoMessages(): boolean {
    return (
      !this.loading &&
      this.resultsCount === 0 &&
      (!this.args.search || this.lastSearchedText.length > 0)
    );
  }

  get results(): T[] {
    if (this.searchText.length > 0) {
      if (this.args.search) {
        return toPlainArray(this._searchResult || this.options) as T[];
      } else {
        if (
          this._filterResultsCache.options === this.options &&
          this._filterResultsCache.searchText === this.searchText
        ) {
          // This is an optimization to avoid filtering several times, which may be a bit expensive
          // if there are many options, if neither the options nor the searchtext have changed
          return this._filterResultsCache.results;
        }
        const results = this._filter(this.options, this.searchText);
        // eslint-disable-next-line ember/no-side-effects
        this._filterResultsCache = {
          results,
          options: this.options,
          searchText: this.searchText,
        };
        return results;
      }
    } else {
      return this.options;
    }
  }

  get options(): T[] {
    if (this._resolvedOptions) {
      return toPlainArray(this._resolvedOptions) as T[];
    }
    if (this.args.options) {
      return toPlainArray(this.args.options as T[]) as T[];
    } else {
      return [];
    }
  }

  get resultsCount(): number {
    return countOptions(this.results);
  }

  get selected(): Selected<T, IsMultiple> | undefined {
    if (this._resolvedSelected) {
      return toPlainArray(this._resolvedSelected) as Selected<T, IsMultiple>;
    } else if (
      this.args.selected !== undefined &&
      this.args.selected !== null &&
      !isPromiseLike(this.args.selected)
    ) {
      return toPlainArray(this.args.selected) as Selected<T, IsMultiple>;
    }
    return undefined;
  }

  get ariaMultiSelectable(): boolean {
    return Array.isArray(this.args.selected);
  }

  get triggerId(): string {
    return this.args.triggerId || `${this._uid}-trigger`;
  }

  get labelId(): string {
    return `${this._uid}-label`;
  }

  get ariaLabelledBy(): string | undefined {
    if (this.args.ariaLabelledBy) {
      return this.args.ariaLabelledBy;
    }

    if (this.args.labelText || this.args.labelComponent) {
      return this.labelId;
    }
  }

  get searchFieldPosition(): TSearchFieldPosition {
    if (this.args.searchFieldPosition !== undefined) {
      return this.args.searchFieldPosition;
    }

    if (this.args.multiple) {
      return 'trigger';
    }

    return 'before-options';
  }

  get tabindex(): string | number {
    if (this.args.multiple) {
      if (this.args.triggerComponent === undefined && this.args.searchEnabled) {
        return '-1';
      } else {
        return this.args.tabindex || '0';
      }
    }

    if (
      this.args.searchEnabled &&
      this.args.tabindex === undefined &&
      this.searchFieldPosition === 'trigger'
    ) {
      return '-1';
    }

    return this.args.tabindex || '0';
  }

  get buildSelection(): PowerSelectArgs<
    T,
    IsMultiple,
    TExtra
  >['buildSelection'] {
    if (this.args.buildSelection) {
      return this.args.buildSelection;
    }

    if (this.args.multiple) {
      return this._defaultMultipleBuildSelection.bind(this);
    }
  }

  get labelComponent(): ComponentLike<
    PowerSelectLabelSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.labelComponent ?? PowerSelectLabel) as ComponentLike<
      PowerSelectLabelSignature<T, TExtra, IsMultiple>
    >;
  }

  get triggerComponent(): ComponentLike<
    PowerSelectTriggerSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.triggerComponent ?? PowerSelectTrigger) as ComponentLike<
      PowerSelectTriggerSignature<T, TExtra, IsMultiple>
    >;
  }

  get placeholderComponent(): ComponentLike<
    PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.placeholderComponent ??
      PowerSelectPlaceholderComponent) as ComponentLike<
      PowerSelectPlaceholderSignature<T, TExtra, IsMultiple>
    >;
  }

  get beforeOptionsComponent(): ComponentLike<
    PowerSelectBeforeOptionsSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.beforeOptionsComponent ??
      PowerSelectBeforeOptions) as ComponentLike<
      PowerSelectBeforeOptionsSignature<T, TExtra, IsMultiple>
    >;
  }

  get searchMessageComponent(): ComponentLike<
    PowerSelectSearchMessageSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.searchMessageComponent ??
      SearchMessageComponent) as ComponentLike<
      PowerSelectSearchMessageSignature<T, TExtra, IsMultiple>
    >;
  }

  get noMatchesMessageComponent(): ComponentLike<
    PowerSelectNoMatchesMessageSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.noMatchesMessageComponent ??
      NoMatchesMessageComponent) as ComponentLike<
      PowerSelectNoMatchesMessageSignature<T, TExtra, IsMultiple>
    >;
  }

  get optionsComponent(): ComponentLike<
    PowerSelectOptionsSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.optionsComponent ?? PowerSelectOptions) as ComponentLike<
      PowerSelectOptionsSignature<T, TExtra, IsMultiple>
    >;
  }

  get groupComponent(): ComponentLike<
    PowerSelectPowerSelectGroupSignature<T, TExtra, IsMultiple>
  > {
    return (this.args.groupComponent ??
      PowerSelectGroupComponent) as ComponentLike<
      PowerSelectPowerSelectGroupSignature<T, TExtra, IsMultiple>
    >;
  }

  get selectedItemComponent():
    | ComponentLike<PowerSelectSelectedItemSignature<T, TExtra, IsMultiple>>
    | undefined {
    return this.args.selectedItemComponent as
      | ComponentLike<PowerSelectSelectedItemSignature<T, TExtra, IsMultiple>>
      | undefined;
  }

  get afterOptionsComponent():
    | ComponentLike<PowerSelectAfterOptionsSignature<T, TExtra, IsMultiple>>
    | undefined {
    return this.args.afterOptionsComponent as
      | ComponentLike<PowerSelectAfterOptionsSignature<T, TExtra, IsMultiple>>
      | undefined;
  }

  // Actions
  @action
  handleOpen(_select: Dropdown, e: Event | undefined): boolean | void {
    if (this.args.onOpen && this.args.onOpen(this.storedAPI, e) === false) {
      return false;
    }

    this.focusInput(this.storedAPI);

    if (e) {
      if (
        e instanceof KeyboardEvent &&
        e.type === 'keydown' &&
        (e.key === 'ArrowUp' || e.key === 'ArrowDown')
      ) {
        e.preventDefault();
      }
    }
    this._resetHighlighted();
  }

  @action
  handleClose(_select: Dropdown, e: Event | undefined): boolean | void {
    // Prevent closing, when somebody was in input field and has clicked into an other position of input field
    if (
      this.searchFieldPosition === 'trigger' &&
      this.storedAPI.isOpen &&
      e?.type === 'mousedown' &&
      document.activeElement === e?.target &&
      (e?.target as HTMLElement).tagName === 'INPUT' &&
      (e?.target as HTMLElement)?.closest(
        '[data-ebd-id="' + this.storedAPI.uniqueId + '-trigger"]',
      )
    ) {
      return false;
    }

    if (this.args.onClose && this.args.onClose(this.storedAPI, e) === false) {
      return false;
    }
    this._highlight(undefined);
  }

  @action
  handleInput(e: InputEvent): void {
    if (e.target === null) return;
    const term = (e.target as HTMLInputElement).value;
    let correctedTerm;
    if (this.args.onInput) {
      correctedTerm = this.args.onInput(term, this.storedAPI, e);
      if (correctedTerm === false) {
        return;
      }
    }
    this._publicAPIActions.search(
      typeof correctedTerm === 'string' ? correctedTerm : term,
    );
  }

  @action
  handleKeydown(e: KeyboardEvent): boolean | void {
    if (
      this.args.onKeydown &&
      this.args.onKeydown(this.storedAPI, e) === false
    ) {
      return false;
    }

    if (this.args.multiple && e.key === 'Enter' && this.storedAPI.isOpen) {
      e.stopPropagation();
      if (this.storedAPI.highlighted !== undefined) {
        if (
          !Array.isArray(this.storedAPI.selected) ||
          this.storedAPI.selected.indexOf(this.storedAPI.highlighted) === -1
        ) {
          this.storedAPI.actions.choose(this.storedAPI.highlighted, e);
          return false;
        } else {
          this.storedAPI.actions.close(e);
          return false;
        }
      } else {
        this.storedAPI.actions.close(e);
        return false;
      }
    }

    if (
      this.searchFieldPosition === 'trigger' &&
      !this.storedAPI.isOpen &&
      e.key !== 'Tab' && // TAB
      e.key !== 'Enter' && // ENTER
      e.key !== 'Escape' // ESC
    ) {
      this.storedAPI.actions.open(e);
    }
    return this._routeKeydown(this.storedAPI, e);
  }

  @action
  handleTriggerKeydown(e: KeyboardEvent) {
    if (
      this.args.onKeydown &&
      this.args.onKeydown(this.storedAPI, e) === false
    ) {
      e.stopImmediatePropagation();
      return;
    }
    if (e.ctrlKey || e.metaKey) {
      e.stopImmediatePropagation();
      return;
    }
    if (e.key?.length === 1 && /^[a-z0-9]$/i.test(e.key)) {
      // Keys 0-9, a-z or numpad keys
      void this.triggerTypingTask.perform(e);
    } else if (e.key === ' ') {
      // Space
      this._handleKeySpace(this.storedAPI, e);
    } else {
      return this._routeKeydown(this.storedAPI, e);
    }
  }

  @action
  _labelClick(event: MouseEvent) {
    if (!this.storedAPI) {
      return;
    }

    // Double-click, do nothing
    if (event.detail > 1) {
      return;
    }

    if (this.labelClickAction === 'open') {
      this.storedAPI.actions.open();
      return;
    } else if (this.labelClickAction === 'focus') {
      const trigger = this.storedAPI.actions.getTriggerElement();

      if (!trigger) {
        return;
      }

      trigger.focus();
    }

    return true;
  }

  @action
  handleFocus(event: FocusEvent): void {
    if (!this.isDestroying) {
      void Promise.resolve().then(() => {
        this._updateIsActive(true);
      });
    }
    if (this.searchFieldPosition === 'trigger') {
      if (event.target) {
        const target = event.target as HTMLElement;
        const input = target.querySelector<HTMLInputElement>(
          'input[type="search"]',
        );
        input?.focus();
      }
    }
    if (this.args.onFocus) {
      this.args.onFocus(this.storedAPI, event);
    }
  }

  @action
  handleBlur(event: FocusEvent): void {
    if (!this.isDestroying) {
      void Promise.resolve().then(() => {
        this._updateIsActive(false);
      });
    }
    if (this.args.onBlur) {
      this.args.onBlur(this.storedAPI, event);
    }
  }

  // Methods
  @action
  _search(term: string): void {
    if (this.searchText === term) return;
    this.searchText = term;
    if (!this.args.search) {
      this.lastSearchedText = term;
      this._resetHighlighted();
    }
  }

  @action
  _updateHighlighted(): void {
    if (this.storedAPI.isOpen) {
      this._resetHighlighted();
    }
  }

  @action
  _highlight(opt: Option<T> | undefined): void {
    if (opt && typeof opt === 'object' && 'disabled' in opt && opt.disabled) {
      return;
    }
    this.highlighted = opt;
  }

  @action
  _select(selected: Selected<T, IsMultiple>, e?: Event): void {
    if (!isEqual(this.storedAPI.selected, selected)) {
      this.args.onChange(selected, this.storedAPI, e);
    }
  }

  @action
  _choose(selected: Option<T>, e?: Event): void {
    const buildSelection = this.buildSelection;
    const selection = buildSelection
      ? buildSelection(selected, this.storedAPI)
      : selected;
    this.storedAPI.actions.select(selection as Selected<T, IsMultiple>, e);
    if (this.args.closeOnSelect !== false) {
      this.storedAPI.actions.close(e);
      if (this.searchFieldPosition === 'trigger') {
        this.searchText = '';
      }
      // return false;
    }
  }

  @action
  _scrollTo(option: Selected<T>): void {
    const select = this.storedAPI;
    if (!document || !option) {
      return;
    }
    if (this.args.scrollTo) {
      return this.args.scrollTo(option, select);
    }

    let root: Document | HTMLElement;

    const triggerElement = select.actions.getTriggerElement();
    if (triggerElement && triggerElement.getRootNode() instanceof ShadowRoot) {
      root = triggerElement.getRootNode() as HTMLElement;
    } else {
      root = document;
    }

    const optionsList = root.querySelector(
      `#ember-power-select-options-${select.uniqueId}`,
    ) as HTMLElement;
    if (!optionsList) {
      return;
    }
    const index = indexOfOption(select.results, option);
    if (index === -1) {
      return;
    }
    const optionElement = optionsList.querySelector(
      `[data-option-index='${index}']`,
    ) as HTMLElement;
    if (!optionElement) {
      return;
    }
    const optionTopScroll = optionElement.offsetTop - optionsList.offsetTop;
    const optionBottomScroll = optionTopScroll + optionElement.offsetHeight;
    if (optionBottomScroll > optionsList.offsetHeight + optionsList.scrollTop) {
      optionsList.scrollTop = optionBottomScroll - optionsList.offsetHeight;
    } else if (optionTopScroll < optionsList.scrollTop) {
      optionsList.scrollTop = optionTopScroll;
    }
  }

  updateOptions = modifier(
    () => {
      this.__updateOptions();
    },
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    { eager: false },
  );

  updateSelected = modifier(
    () => {
      this.__updateSelected();
    },
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    { eager: false },
  );

  updateRegisterAPI = modifier(
    (triggerElement: Element, [publicAPI]: [Select<T, IsMultiple>]) => {
      this.__registerAPI(triggerElement, [publicAPI]);
    },
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    { eager: false },
  );

  updatePerformSearch = modifier(
    (triggerElement: Element, [term]: [string]) => {
      this.__performSearch(triggerElement, [term]);
    },
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    { eager: false },
  );

  private __updateOptions() {
    if (!this.args.options) return;
    if (isPromiseLike(this.args.options)) {
      if (this._lastOptionsPromise === this.args.options) return; // promise is still the same
      const currentOptionsPromise = this.args.options;
      this._lastOptionsPromise = currentOptionsPromise;
      this.loading = true;
      this._lastOptionsPromise
        .then((resolvedOptions) => {
          if (this._lastOptionsPromise === currentOptionsPromise) {
            this.loading = false;
            this._resolvedOptions = resolvedOptions;
            this._resetHighlighted();
          }
        })
        .catch(() => {
          if (this._lastOptionsPromise === currentOptionsPromise) {
            this.loading = false;
          }
        });
    } else {
      void Promise.resolve().then(() => {
        this._resetHighlighted();
      });
    }
  }

  private __updateSelected(): void {
    if (this.args.selected === undefined || this.args.selected === null) return;
    if (isPromiseLike(this.args.selected)) {
      if (this._lastSelectedPromise === this.args.selected) return; // promise is still the same
      const currentSelectedPromise = this.args.selected;
      this._lastSelectedPromise = currentSelectedPromise;
      void this._lastSelectedPromise.then((resolvedSelected) => {
        if (this._lastSelectedPromise === currentSelectedPromise) {
          this._resolvedSelected = resolvedSelected;
          if (!Array.isArray(resolvedSelected)) {
            this._highlight(resolvedSelected as Option<T>);
          }
        }
      });
    } else {
      this._resolvedSelected = undefined;
      // Don't highlight args.selected array on multi-select
      if (!Array.isArray(this.args.selected)) {
        this._highlight(this.args.selected as Option<T>);
      }
    }
  }

  private __registerAPI(
    _: Element,
    [publicAPI]: [Select<T, IsMultiple>],
  ): void {
    this.storedAPI = publicAPI;
    if (this.args.registerAPI) {
      void Promise.resolve().then(() => {
        if (this.args.registerAPI) {
          this.args.registerAPI(publicAPI);
        }
      });
    }
  }

  private __performSearch(_: Element, [term]: [string]): void {
    if (!this.args.search) return;
    if (term === '') {
      this.loading = false;
      this.lastSearchedText = term;
      if (this._lastSearchPromise !== undefined) {
        if (isCancellablePromise(this._lastSearchPromise)) {
          this._lastSearchPromise.cancel(); // Cancel ember-concurrency tasks
        }
        this._lastSearchPromise = undefined;
      }
      return;
    }
    const searchResult = this.args.search(term, this.storedAPI);
    if (searchResult && isPromiseLike(searchResult)) {
      this.loading = true;
      if (
        this._lastSearchPromise !== undefined &&
        isCancellablePromise(this._lastSearchPromise)
      ) {
        this._lastSearchPromise.cancel(); // Cancel ember-concurrency tasks
      }
      this._lastSearchPromise = searchResult;
      searchResult
        .then((results) => {
          if (this._lastSearchPromise === searchResult) {
            this._searchResult = results || undefined;
            this.loading = false;
            this.lastSearchedText = term;
            void Promise.resolve().then(() => {
              this._resetHighlighted();
            });
          }
        })
        .catch(() => {
          if (this._lastSearchPromise === searchResult) {
            this.loading = false;
            this.lastSearchedText = term;
          }
        });
    } else {
      this.lastSearchedText = term;
      this._searchResult = searchResult || undefined;
      void Promise.resolve().then(() => {
        this._resetHighlighted();
      });
    }
  }

  @action
  private _defaultMultipleBuildSelection(
    selected: Option<T>,
    select: Select<T, IsMultiple>,
  ): Selected<T, IsMultiple> {
    if (!this.args.multiple) {
      throw new Error('The defaultBuildSelection is only allowed for multiple');
    }

    const newSelection: Option<T>[] = Array.isArray(select.selected)
      ? (select.selected as Option<T>[]).slice(0)
      : [];
    let idx = -1;
    for (let i = 0; i < newSelection.length; i++) {
      if (isEqual(newSelection[i], selected)) {
        idx = i;
        break;
      }
    }
    if (idx > -1) {
      newSelection.splice(idx, 1);
    } else {
      newSelection.push(selected);
    }

    return newSelection as Selected<T, IsMultiple>;
  }

  focusInput(select: Select<T, IsMultiple>) {
    if (select) {
      const input = document.querySelector(
        `#ember-power-select-trigger-input-${select.uniqueId}`,
      ) as HTMLElement;
      if (input) {
        input.focus();
      }
    }
  }

  _routeKeydown(
    select: Select<T, IsMultiple>,
    e: KeyboardEvent,
  ): boolean | void {
    if (e.key === 'ArrowUp' || e.key === 'ArrowDown') {
      // Up & Down
      return this._handleKeyUpDown(select, e);
    } else if (e.key === 'Enter') {
      // ENTER
      return this._handleKeyEnter(select, e);
    } else if (e.key === 'Tab') {
      // Tab
      return this._handleKeyTab(select, e);
    } else if (e.key === 'Escape') {
      // ESC
      return this._handleKeyESC(select, e);
    }
  }

  _handleKeyTab(select: Select<T, IsMultiple>, e: KeyboardEvent): void {
    select.actions.close(e);
  }

  _handleKeyESC(select: Select<T, IsMultiple>, e: KeyboardEvent): void {
    select.actions.close(e);
  }

  _handleKeyEnter(
    select: Select<T, IsMultiple>,
    e: KeyboardEvent,
  ): boolean | void {
    if (select.isOpen && select.highlighted !== undefined) {
      select.actions.choose(select.highlighted, e);
      e.stopImmediatePropagation();
      return false;
    }
  }

  _handleKeySpace(select: Select<T, IsMultiple>, e: KeyboardEvent): void {
    if (
      e.target !== null &&
      ['TEXTAREA', 'INPUT'].includes((e.target as Element).nodeName)
    ) {
      e.stopImmediatePropagation();
    } else if (select.isOpen && select.highlighted !== undefined) {
      e.stopImmediatePropagation();
      e.preventDefault(); // Prevents scrolling of the page.
      select.actions.choose(select.highlighted, e);
    }
  }

  _handleKeyUpDown(select: Select<T, IsMultiple>, e: KeyboardEvent): void {
    if (select.isOpen) {
      e.preventDefault();
      e.stopPropagation();
      const step: 1 | -1 = e.key === 'ArrowDown' ? 1 : -1;
      const newHighlighted = advanceSelectableOption(
        select.results,
        select.highlighted,
        step,
      );
      select.actions.highlight(newHighlighted);
      select.actions.scrollTo(newHighlighted);
    } else {
      select.actions.open(e);
    }
  }

  _resetHighlighted(): void {
    let highlighted: Option<T> | undefined;
    const defHighlighted = this.args.defaultHighlighted || defaultHighlighted;
    if (typeof defHighlighted === 'function') {
      highlighted = (defHighlighted as typeof defaultHighlighted)({
        results: this.results,
        highlighted: this.highlighted,
        selected: this.selected,
      });
    } else {
      highlighted = defHighlighted;
    }
    this._highlight(highlighted);
  }

  _filter(options: T[], term: string, skipDisabled = false): T[] {
    const matcher = this.args.matcher || defaultMatcher;
    const optionMatcher = getOptionMatcher(
      matcher as MatcherFn<T>,
      defaultMatcher as MatcherFn<T>,
      this.args.searchField,
    );
    return filterOptions(options || [], term, optionMatcher, skipDisabled);
  }

  _updateIsActive(value: boolean) {
    this.isActive = value;
  }

  findWithOffset(
    options: readonly T[],
    term: string,
    offset: number,
    skipDisabled = false,
  ): Option<T> | undefined {
    const typeAheadOptionMatcher = getOptionMatcher(
      this.args.typeAheadOptionMatcher ||
        (defaultTypeAheadMatcher as MatcherFn<T>),
      defaultTypeAheadMatcher as MatcherFn<T>,
      this.args.searchField,
    );
    return findOptionWithOffset(
      options || [],
      term,
      typeAheadOptionMatcher,
      offset,
      skipDisabled,
    );
  }

  publicAPI = (dropdown: BasicDropdownDefaultBlock): Select<T, IsMultiple> => {
    return Object.assign({}, dropdown, {
      selected: this.selected,
      multiple: this.args.multiple ?? false,
      highlighted: this.highlighted,
      options: this.options,
      results: this.results,
      resultsCount: this.resultsCount,
      loading: this.loading,
      isActive: this.isActive,
      searchText: this.searchText,
      lastSearchedText: this.lastSearchedText,
      actions: Object.assign({}, dropdown.actions, this._publicAPIActions),
    }) as Select<T, IsMultiple>;
  };

  // Tasks
  triggerTypingTask = task({ restartable: true }, async (e: KeyboardEvent) => {
    // In general, a user doing this interaction means to have a different result.
    let searchStartOffset = 1;
    let repeatingChar = this._repeatingChar;
    let term;

    // Check if user intends to cycle through results. _repeatingChar can only be the first character.
    const c = e.key?.length === 1 ? e.key : '';
    if (c === this._repeatingChar) {
      term = c;
    } else {
      term = this._expirableSearchText + c;
    }

    if (term.length > 1) {
      // If the term is longer than one char, the user is in the middle of a non-cycling interaction
      // so the offset is just zero (the current selection is a valid match).
      searchStartOffset = 0;
      repeatingChar = '';
    } else {
      repeatingChar = c;
    }

    // When the select is open, the "selection" is just highlighted.
    if (this.storedAPI.isOpen && this.storedAPI.highlighted) {
      searchStartOffset += indexOfOption(
        this.storedAPI.options,
        this.storedAPI.highlighted,
      );
    } else if (
      !this.storedAPI.isOpen &&
      this.selected !== undefined &&
      this.selected !== null
    ) {
      searchStartOffset += indexOfOption(this.storedAPI.options, this.selected);
    } else {
      searchStartOffset = 0;
    }

    // The char is always appended. That way, searching for words like "Aaron" will work even
    // if "Aa" would cycle through the results.
    this._expirableSearchText = this._expirableSearchText + c;
    this._repeatingChar = repeatingChar;
    const match = this.findWithOffset(
      this.storedAPI.options,
      term,
      searchStartOffset,
      true,
    );
    if (match !== undefined) {
      if (this.storedAPI.isOpen) {
        this.storedAPI.actions.highlight(match);
        this.storedAPI.actions.scrollTo(match);
      } else {
        let selected: Option<T> | Option<T>[] = match;
        if (this.args.multiple) {
          selected = [match];
        }

        this.storedAPI.actions.select(selected as Selected<T, IsMultiple>, e);
      }
    }
    await timeout(1000);
    this._expirableSearchText = '';
    this._repeatingChar = '';
  });

  <template>
    {{#if (or @labelText @labelComponent)}}
      <this.labelComponent
        @select={{this.storedAPI}}
        @labelText={{@labelText}}
        @labelId={{this.labelId}}
        @triggerId={{this.triggerId}}
        @labelTag={{@labelTag}}
        @extra={{@extra}}
        class={{@labelClass}}
      />
    {{/if}}
    <BasicDropdown
      @horizontalPosition={{@horizontalPosition}}
      @destinationElement={{@destinationElement}}
      @destination={{@destination}}
      @initiallyOpened={{@initiallyOpened}}
      @matchTriggerWidth={{this.matchTriggerWidth}}
      @preventScroll={{or @preventScroll false}}
      @onClose={{this.handleClose}}
      @onOpen={{this.handleOpen}}
      @renderInPlace={{@renderInPlace}}
      @verticalPosition={{@verticalPosition}}
      @disabled={{@disabled}}
      @calculatePosition={{@calculatePosition}}
      @triggerComponent={{@ebdTriggerComponent}}
      @contentComponent={{@ebdContentComponent}}
      @rootEventType={{or @rootEventType "mousedown"}}
      as |dropdown|
    >
      {{#let
        (this.publicAPI dropdown)
        (concat "ember-power-select-options-" dropdown.uniqueId)
        as |publicAPI listboxId|
      }}
        {{! template-lint-disable no-positive-tabindex }}
        <dropdown.Trigger
          @eventType={{or @eventType "mousedown"}}
          {{this.updateOptions @options}}
          {{this.updateSelected @selected}}
          {{this.updateRegisterAPI publicAPI}}
          {{this.updatePerformSearch this.searchText}}
          {{on "keydown" this.handleTriggerKeydown}}
          {{on "focus" this.handleFocus}}
          {{on "blur" this.handleBlur}}
          class="ember-power-select-trigger
            {{if @multiple ' ember-power-select-multiple-trigger'}}
            {{@triggerClass}}{{if
              publicAPI.isActive
              ' ember-power-select-trigger--active'
            }}"
          aria-activedescendant={{if
            dropdown.isOpen
            (unless
              @searchEnabled
              (concat publicAPI.uniqueId "-" this.highlightedIndex)
            )
          }}
          aria-controls={{if
            (and dropdown.isOpen (not @searchEnabled))
            listboxId
          }}
          aria-describedby={{@ariaDescribedBy}}
          aria-haspopup={{unless @searchEnabled "listbox"}}
          aria-invalid={{@ariaInvalid}}
          aria-label={{@ariaLabel}}
          aria-labelledby={{this.ariaLabelledBy}}
          aria-owns={{if (and dropdown.isOpen (not @searchEnabled)) listboxId}}
          aria-required={{@required}}
          aria-autocomplete={{if @searchEnabled "list"}}
          role={{or @triggerRole "combobox"}}
          title={{@title}}
          id={{this.triggerId}}
          tabindex={{and (not @disabled) (or this.tabindex "0")}}
          ...attributes
        >
          <this.triggerComponent
            @allowClear={{@allowClear}}
            @buildSelection={{this.buildSelection}}
            @loadingMessage={{or @loadingMessage "Loading options..."}}
            @selectedItemComponent={{this.selectedItemComponent}}
            @select={{publicAPI}}
            @searchEnabled={{@searchEnabled}}
            @searchField={{@searchField}}
            @searchFieldPosition={{this.searchFieldPosition}}
            @onFocus={{this.handleFocus}}
            @onBlur={{this.handleBlur}}
            @extra={{@extra}}
            @listboxId={{listboxId}}
            @onInput={{this.handleInput}}
            @onKeydown={{this.handleKeydown}}
            @placeholder={{@placeholder}}
            @searchPlaceholder={{@searchPlaceholder}}
            @placeholderComponent={{this.placeholderComponent}}
            @ariaActiveDescendant={{concat
              publicAPI.uniqueId
              "-"
              this.highlightedIndex
            }}
            @ariaLabelledBy={{this.ariaLabelledBy}}
            @ariaDescribedBy={{@ariaDescribedBy}}
            @ariaLabel={{@ariaLabel}}
            @role={{@triggerRole}}
            @tabindex={{@tabindex}}
            as |opt select|
          >
            {{yield opt select}}
          </this.triggerComponent>
        </dropdown.Trigger>
        <dropdown.Content
          class="ember-power-select-dropdown{{if
              publicAPI.isActive
              ' ember-power-select-dropdown--active'
            }}
            {{@dropdownClass}}"
          @animationEnabled={{@animationEnabled}}
        >
          {{#if (notEq @beforeOptionsComponent null)}}
            <this.beforeOptionsComponent
              @select={{publicAPI}}
              @searchEnabled={{@searchEnabled}}
              @onInput={{this.handleInput}}
              @onKeydown={{this.handleKeydown}}
              @onFocus={{this.handleFocus}}
              @onBlur={{this.handleBlur}}
              @placeholder={{@placeholder}}
              @placeholderComponent={{this.placeholderComponent}}
              @extra={{@extra}}
              @listboxId={{listboxId}}
              @ariaActiveDescendant={{if
                this.highlightedIndex
                (concat publicAPI.uniqueId "-" this.highlightedIndex)
              }}
              @selectedItemComponent={{this.selectedItemComponent}}
              @searchPlaceholder={{@searchPlaceholder}}
              @searchFieldPosition={{this.searchFieldPosition}}
              @ariaLabel={{@ariaLabel}}
              @ariaLabelledBy={{this.ariaLabelledBy}}
              @ariaDescribedBy={{@ariaDescribedBy}}
              @triggerRole={{@triggerRole}}
            />
          {{/if}}
          <div class="ember-power-select-options-wrapper">
            {{#if this.mustShowSearchMessage}}
              <this.searchMessageComponent
                @searchMessage={{this.searchMessage}}
                @select={{publicAPI}}
                @extra={{@extra}}
                id={{listboxId}}
                aria-label={{@ariaLabel}}
                aria-labelledby={{this.ariaLabelledBy}}
              />
            {{else if this.mustShowNoMessages}}
              <this.noMatchesMessageComponent
                @noMatchesMessage={{this.noMatchesMessage}}
                @select={{publicAPI}}
                @extra={{@extra}}
                id={{listboxId}}
                aria-label={{@ariaLabel}}
                aria-labelledby={{this.ariaLabelledBy}}
              />
            {{else}}
              <this.optionsComponent
                @loadingMessage={{or @loadingMessage "Loading options..."}}
                @select={{publicAPI}}
                @options={{publicAPI.results}}
                @groupIndex=""
                @optionsComponent={{this.optionsComponent}}
                @extra={{@extra}}
                @highlightOnHover={{this.highlightOnHover}}
                @groupComponent={{this.groupComponent}}
                role="listbox"
                aria-multiselectable={{if this.ariaMultiSelectable "true"}}
                id={{listboxId}}
                class="ember-power-select-options"
                as |option select|
              >
                {{yield option select}}
              </this.optionsComponent>
            {{/if}}

            {{#if this.afterOptionsComponent}}
              {{#let this.afterOptionsComponent as |AfterOptions|}}
                <AfterOptions @extra={{@extra}} @select={{publicAPI}} />
              {{/let}}
            {{/if}}
            <div
              role="status"
              aria-live="polite"
              aria-atomic="true"
              class="ember-power-select-visually-hidden"
            >
              {{this.resultCountMessage}}
            </div>
          </div>
        </dropdown.Content>
      {{/let}}
    </BasicDropdown>
  </template>
}
