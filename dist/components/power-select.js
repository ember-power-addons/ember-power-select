import { buildTask } from 'ember-concurrency/async-arrow-runtime';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action, get } from '@ember/object';
import { guidFor } from '@ember/object/internals';
import isEqual from '../utils/equal.js';
import { assert } from '@ember/debug';
import { pathForOption, countOptions, indexOfOption, advanceSelectableOption, defaultHighlighted, defaultMatcher, filterOptions, defaultTypeAheadMatcher, findOptionWithOffset } from '../utils/group-utils.js';
import { timeout } from 'ember-concurrency';
import { modifier } from 'ember-modifier';
import PowerSelectLabel from './power-select/label.js';
import PowerSelectTrigger from './power-select/trigger.js';
import PowerSelectPlaceholder from './power-select/placeholder.js';
import PowerSelectBeforeOptions from './power-select/before-options.js';
import PowerSelectSearchMessage from './power-select/search-message.js';
import PowerSelectNoMatchesMessage from './power-select/no-matches-message.js';
import PowerSelectOptions from './power-select/options.js';
import PowerSelectPowerSelectGroup from './power-select/power-select-group.js';
import BasicDropdown from 'ember-basic-dropdown/components/basic-dropdown';
import { on } from '@ember/modifier';
import { notEq, not, and, or } from 'ember-truth-helpers';
import { concat } from '@ember/helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i, n } from 'decorator-transforms/runtime-esm';

const isSliceable = coll => {
  return Array.isArray(coll);
};
const isPromiseLike = thing => {
  return typeof thing === 'object' && thing !== null && typeof thing.then === 'function';
};
const isCancellablePromise = thing => {
  return typeof thing === 'object' && thing !== null && typeof thing.cancel === 'function';
};
const toPlainArray = collection => {
  if (isSliceable(collection)) {
    return collection.slice();
  } else {
    return collection;
  }
};
function getOptionMatcher(matcher, defaultMatcher, searchField) {
  if (searchField && matcher === defaultMatcher) {
    return (option, text) => matcher(get(option, searchField), text);
  } else {
    return (option, text) => {
      assert('<PowerSelect> If you want the default filtering to work on options that are not plain strings, you need to provide `@searchField`', matcher !== defaultMatcher || typeof option === 'string');
      return matcher(option, text);
    };
  }
}
class PowerSelect extends Component {
  // Untracked properties
  _publicAPIActions = {
    search: this._search.bind(this),
    highlight: this._highlight.bind(this),
    select: this._select.bind(this),
    choose: this._choose.bind(this),
    scrollTo: this._scrollTo.bind(this),
    labelClick: this._labelClick.bind(this)
  };
  // Tracked properties
  static {
    g(this.prototype, "_resolvedOptions", [tracked]);
  }
  #_resolvedOptions = (i(this, "_resolvedOptions"), void 0);
  static {
    g(this.prototype, "_resolvedSelected", [tracked]);
  }
  #_resolvedSelected = (i(this, "_resolvedSelected"), void 0);
  static {
    g(this.prototype, "_repeatingChar", [tracked], function () {
      return '';
    });
  }
  #_repeatingChar = (i(this, "_repeatingChar"), void 0);
  static {
    g(this.prototype, "_expirableSearchText", [tracked], function () {
      return '';
    });
  }
  #_expirableSearchText = (i(this, "_expirableSearchText"), void 0);
  static {
    g(this.prototype, "_searchResult", [tracked]);
  }
  #_searchResult = (i(this, "_searchResult"), void 0);
  static {
    g(this.prototype, "isActive", [tracked], function () {
      return false;
    });
  }
  #isActive = (i(this, "isActive"), void 0);
  static {
    g(this.prototype, "loading", [tracked], function () {
      return false;
    });
  }
  #loading = (i(this, "loading"), void 0);
  static {
    g(this.prototype, "searchText", [tracked], function () {
      return '';
    });
  }
  #searchText = (i(this, "searchText"), void 0);
  static {
    g(this.prototype, "lastSearchedText", [tracked], function () {
      return '';
    });
  }
  #lastSearchedText = (i(this, "lastSearchedText"), void 0);
  static {
    g(this.prototype, "highlighted", [tracked]);
  }
  #highlighted = (i(this, "highlighted"), void 0);
  storedAPI;
  _uid = guidFor(this);
  _lastOptionsPromise;
  _lastSelectedPromise;
  _lastSearchPromise;
  _filterResultsCache = {
    results: [],
    options: [],
    searchText: this.searchText
  };
  // Lifecycle hooks
  constructor(owner, args) {
    super(owner, args);
    assert('<PowerSelect> requires an `@onChange` function', this.args.onChange && typeof this.args.onChange === 'function');
  }
  willDestroy() {
    super.willDestroy();
  }
  // Getters
  get highlightOnHover() {
    return this.args.highlightOnHover === undefined ? true : this.args.highlightOnHover;
  }
  get labelClickAction() {
    return this.args.labelClickAction === undefined ? 'focus' : this.args.labelClickAction;
  }
  get highlightedIndex() {
    const results = this.results;
    const highlighted = this.highlighted;
    return pathForOption(results, highlighted);
  }
  get searchMessage() {
    return this.args.searchMessage === undefined ? 'Type to search' : this.args.searchMessage;
  }
  get noMatchesMessage() {
    return this.args.noMatchesMessage === undefined ? 'No results found' : this.args.noMatchesMessage;
  }
  get resultCountMessage() {
    if (typeof this.args.resultCountMessage === 'function') {
      return this.args.resultCountMessage(this.resultsCount);
    }
    if (this.resultsCount === 1) {
      return `${this.resultsCount} result`;
    }
    return `${this.resultsCount} results`;
  }
  get matchTriggerWidth() {
    return this.args.matchTriggerWidth === undefined ? true : this.args.matchTriggerWidth;
  }
  get mustShowSearchMessage() {
    return !this.loading && this.searchText.length === 0 && !!this.args.search && !!this.searchMessage && this.resultsCount === 0;
  }
  get mustShowNoMessages() {
    return !this.loading && this.resultsCount === 0 && (!this.args.search || this.lastSearchedText.length > 0);
  }
  get results() {
    if (this.searchText.length > 0) {
      if (this.args.search) {
        return toPlainArray(this._searchResult || this.options);
      } else {
        if (this._filterResultsCache.options === this.options && this._filterResultsCache.searchText === this.searchText) {
          // This is an optimization to avoid filtering several times, which may be a bit expensive
          // if there are many options, if neither the options nor the searchtext have changed
          return this._filterResultsCache.results;
        }
        const results = this._filter(this.options, this.searchText);
        // eslint-disable-next-line ember/no-side-effects
        this._filterResultsCache = {
          results,
          options: this.options,
          searchText: this.searchText
        };
        return results;
      }
    } else {
      return this.options;
    }
  }
  get options() {
    if (this._resolvedOptions) {
      return toPlainArray(this._resolvedOptions);
    }
    if (this.args.options) {
      return toPlainArray(this.args.options);
    } else {
      return [];
    }
  }
  get resultsCount() {
    return countOptions(this.results);
  }
  get selected() {
    if (this._resolvedSelected) {
      return toPlainArray(this._resolvedSelected);
    } else if (this.args.selected !== undefined && this.args.selected !== null && !isPromiseLike(this.args.selected)) {
      return toPlainArray(this.args.selected);
    }
    return undefined;
  }
  get ariaMultiSelectable() {
    return Array.isArray(this.args.selected);
  }
  get triggerId() {
    return this.args.triggerId || `${this._uid}-trigger`;
  }
  get labelId() {
    return `${this._uid}-label`;
  }
  get ariaLabelledBy() {
    if (this.args.ariaLabelledBy) {
      return this.args.ariaLabelledBy;
    }
    if (this.args.labelText || this.args.labelComponent) {
      return this.labelId;
    }
  }
  get searchFieldPosition() {
    if (this.args.searchFieldPosition !== undefined) {
      return this.args.searchFieldPosition;
    }
    if (this.args.multiple) {
      return 'trigger';
    }
    return 'before-options';
  }
  get tabindex() {
    if (this.args.multiple) {
      if (this.args.triggerComponent === undefined && this.args.searchEnabled) {
        return '-1';
      } else {
        return this.args.tabindex || '0';
      }
    }
    if (this.args.searchEnabled && this.args.tabindex === undefined && this.searchFieldPosition === 'trigger') {
      return '-1';
    }
    return this.args.tabindex || '0';
  }
  get buildSelection() {
    if (this.args.buildSelection) {
      return this.args.buildSelection;
    }
    if (this.args.multiple) {
      return this._defaultMultipleBuildSelection.bind(this);
    }
  }
  get labelComponent() {
    return this.args.labelComponent ?? PowerSelectLabel;
  }
  get triggerComponent() {
    return this.args.triggerComponent ?? PowerSelectTrigger;
  }
  get placeholderComponent() {
    return this.args.placeholderComponent ?? PowerSelectPlaceholder;
  }
  get beforeOptionsComponent() {
    return this.args.beforeOptionsComponent ?? PowerSelectBeforeOptions;
  }
  get searchMessageComponent() {
    return this.args.searchMessageComponent ?? PowerSelectSearchMessage;
  }
  get noMatchesMessageComponent() {
    return this.args.noMatchesMessageComponent ?? PowerSelectNoMatchesMessage;
  }
  get optionsComponent() {
    return this.args.optionsComponent ?? PowerSelectOptions;
  }
  get groupComponent() {
    return this.args.groupComponent ?? PowerSelectPowerSelectGroup;
  }
  get selectedItemComponent() {
    return this.args.selectedItemComponent;
  }
  get afterOptionsComponent() {
    return this.args.afterOptionsComponent;
  }
  // Actions
  handleOpen(_select, e) {
    if (this.args.onOpen && this.args.onOpen(this.storedAPI, e) === false) {
      return false;
    }
    this.focusInput(this.storedAPI);
    if (e) {
      if (e instanceof KeyboardEvent && e.type === 'keydown' && (e.key === 'ArrowUp' || e.key === 'ArrowDown')) {
        e.preventDefault();
      }
    }
    this._resetHighlighted();
  }
  static {
    n(this.prototype, "handleOpen", [action]);
  }
  handleClose(_select, e) {
    // Prevent closing, when somebody was in input field and has clicked into an other position of input field
    if (this.searchFieldPosition === 'trigger' && this.storedAPI.isOpen && e?.type === 'mousedown' && document.activeElement === e?.target && (e?.target).tagName === 'INPUT' && e?.target?.closest('[data-ebd-id="' + this.storedAPI.uniqueId + '-trigger"]')) {
      return false;
    }
    if (this.args.onClose && this.args.onClose(this.storedAPI, e) === false) {
      return false;
    }
    this._highlight(undefined);
  }
  static {
    n(this.prototype, "handleClose", [action]);
  }
  handleInput(e) {
    if (e.target === null) return;
    const term = e.target.value;
    let correctedTerm;
    if (this.args.onInput) {
      correctedTerm = this.args.onInput(term, this.storedAPI, e);
      if (correctedTerm === false) {
        return;
      }
    }
    this._publicAPIActions.search(typeof correctedTerm === 'string' ? correctedTerm : term);
  }
  static {
    n(this.prototype, "handleInput", [action]);
  }
  handleKeydown(e) {
    if (this.args.onKeydown && this.args.onKeydown(this.storedAPI, e) === false) {
      return false;
    }
    if (this.args.multiple && e.key === 'Enter' && this.storedAPI.isOpen) {
      e.stopPropagation();
      if (this.storedAPI.highlighted !== undefined) {
        if (!Array.isArray(this.storedAPI.selected) || this.storedAPI.selected.indexOf(this.storedAPI.highlighted) === -1) {
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
    if (this.searchFieldPosition === 'trigger' && !this.storedAPI.isOpen && e.key !== 'Tab' &&
    // TAB
    e.key !== 'Enter' &&
    // ENTER
    e.key !== 'Escape' // ESC
    ) {
      this.storedAPI.actions.open(e);
    }
    return this._routeKeydown(this.storedAPI, e);
  }
  static {
    n(this.prototype, "handleKeydown", [action]);
  }
  handleTriggerKeydown(e) {
    if (this.args.onKeydown && this.args.onKeydown(this.storedAPI, e) === false) {
      e.stopImmediatePropagation();
      return;
    }
    if (e.ctrlKey || e.metaKey) {
      e.stopImmediatePropagation();
      return;
    }
    if (e.key.length === 1 && /^[a-z0-9]$/i.test(e.key)) {
      // Keys 0-9, a-z or numpad keys
      void this.triggerTypingTask.perform(e);
    } else if (e.key === ' ') {
      // Space
      this._handleKeySpace(this.storedAPI, e);
    } else {
      return this._routeKeydown(this.storedAPI, e);
    }
  }
  static {
    n(this.prototype, "handleTriggerKeydown", [action]);
  }
  _labelClick(event) {
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
  static {
    n(this.prototype, "_labelClick", [action]);
  }
  handleFocus(event) {
    if (!this.isDestroying) {
      void Promise.resolve().then(() => {
        this._updateIsActive(true);
      });
    }
    if (this.searchFieldPosition === 'trigger') {
      if (event.target) {
        const target = event.target;
        const input = target.querySelector('input[type="search"]');
        input?.focus();
      }
    }
    if (this.args.onFocus) {
      this.args.onFocus(this.storedAPI, event);
    }
  }
  static {
    n(this.prototype, "handleFocus", [action]);
  }
  handleBlur(event) {
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
  static {
    n(this.prototype, "handleBlur", [action]);
  }
  _search(term) {
    if (this.searchText === term) return;
    this.searchText = term;
    if (!this.args.search) {
      this.lastSearchedText = term;
      this._resetHighlighted();
    }
  }
  static {
    n(this.prototype, "_search", [action]);
  }
  _updateHighlighted() {
    if (this.storedAPI.isOpen) {
      this._resetHighlighted();
    }
  }
  static {
    n(this.prototype, "_updateHighlighted", [action]);
  }
  _highlight(opt) {
    if (opt && typeof opt === 'object' && 'disabled' in opt && opt.disabled) {
      return;
    }
    this.highlighted = opt;
  }
  static {
    n(this.prototype, "_highlight", [action]);
  }
  _select(selected, e) {
    if (!isEqual(this.storedAPI.selected, selected)) {
      this.args.onChange(selected, this.storedAPI, e);
    }
  }
  static {
    n(this.prototype, "_select", [action]);
  }
  _choose(selected, e) {
    const buildSelection = this.buildSelection;
    const selection = buildSelection ? buildSelection(selected, this.storedAPI) : selected;
    this.storedAPI.actions.select(selection, e);
    if (this.args.closeOnSelect !== false) {
      this.storedAPI.actions.close(e);
      if (this.searchFieldPosition === 'trigger') {
        this.searchText = '';
      }
      // return false;
    }
  }
  static {
    n(this.prototype, "_choose", [action]);
  }
  _scrollTo(option) {
    const select = this.storedAPI;
    if (!document || !option) {
      return;
    }
    if (this.args.scrollTo) {
      return this.args.scrollTo(option, select);
    }
    let root;
    const triggerElement = select.actions.getTriggerElement();
    if (triggerElement && triggerElement.getRootNode() instanceof ShadowRoot) {
      root = triggerElement.getRootNode();
    } else {
      root = document;
    }
    const optionsList = root.querySelector(`#ember-power-select-options-${select.uniqueId}`);
    if (!optionsList) {
      return;
    }
    const index = indexOfOption(select.results, option);
    if (index === -1) {
      return;
    }
    const optionElement = optionsList.querySelector(`[data-option-index='${index}']`);
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
  static {
    n(this.prototype, "_scrollTo", [action]);
  }
  updateOptions = modifier(() => {
    this.__updateOptions();
  },
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  {
    eager: false
  });
  updateSelected = modifier(() => {
    this.__updateSelected();
  },
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  {
    eager: false
  });
  updateRegisterAPI = modifier((triggerElement, [publicAPI]) => {
    this.__registerAPI(triggerElement, [publicAPI]);
  },
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  {
    eager: false
  });
  updatePerformSearch = modifier((triggerElement, [term]) => {
    this.__performSearch(triggerElement, [term]);
  },
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  {
    eager: false
  });
  __updateOptions() {
    if (!this.args.options) return;
    if (isPromiseLike(this.args.options)) {
      if (this._lastOptionsPromise === this.args.options) return; // promise is still the same
      const currentOptionsPromise = this.args.options;
      this._lastOptionsPromise = currentOptionsPromise;
      this.loading = true;
      this._lastOptionsPromise.then(resolvedOptions => {
        if (this._lastOptionsPromise === currentOptionsPromise) {
          this.loading = false;
          this._resolvedOptions = resolvedOptions;
          this._resetHighlighted();
        }
      }).catch(() => {
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
  __updateSelected() {
    if (this.args.selected === undefined || this.args.selected === null) return;
    if (isPromiseLike(this.args.selected)) {
      if (this._lastSelectedPromise === this.args.selected) return; // promise is still the same
      const currentSelectedPromise = this.args.selected;
      this._lastSelectedPromise = currentSelectedPromise;
      void this._lastSelectedPromise.then(resolvedSelected => {
        if (this._lastSelectedPromise === currentSelectedPromise) {
          this._resolvedSelected = resolvedSelected;
          if (!Array.isArray(resolvedSelected)) {
            this._highlight(resolvedSelected);
          }
        }
      });
    } else {
      this._resolvedSelected = undefined;
      // Don't highlight args.selected array on multi-select
      if (!Array.isArray(this.args.selected)) {
        this._highlight(this.args.selected);
      }
    }
  }
  __registerAPI(_, [publicAPI]) {
    this.storedAPI = publicAPI;
    if (this.args.registerAPI) {
      void Promise.resolve().then(() => {
        if (this.args.registerAPI) {
          this.args.registerAPI(publicAPI);
        }
      });
    }
  }
  __performSearch(_, [term]) {
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
      if (this._lastSearchPromise !== undefined && isCancellablePromise(this._lastSearchPromise)) {
        this._lastSearchPromise.cancel(); // Cancel ember-concurrency tasks
      }
      this._lastSearchPromise = searchResult;
      searchResult.then(results => {
        if (this._lastSearchPromise === searchResult) {
          this._searchResult = results || undefined;
          this.loading = false;
          this.lastSearchedText = term;
          void Promise.resolve().then(() => {
            this._resetHighlighted();
          });
        }
      }).catch(() => {
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
  _defaultMultipleBuildSelection(selected, select) {
    if (!this.args.multiple) {
      throw new Error('The defaultBuildSelection is only allowed for multiple');
    }
    const newSelection = Array.isArray(select.selected) ? select.selected.slice(0) : [];
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
    return newSelection;
  }
  static {
    n(this.prototype, "_defaultMultipleBuildSelection", [action]);
  }
  focusInput(select) {
    if (select) {
      const input = document.querySelector(`#ember-power-select-trigger-input-${select.uniqueId}`);
      if (input) {
        input.focus();
      }
    }
  }
  _routeKeydown(select, e) {
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
  _handleKeyTab(select, e) {
    select.actions.close(e);
  }
  _handleKeyESC(select, e) {
    select.actions.close(e);
  }
  _handleKeyEnter(select, e) {
    if (select.isOpen && select.highlighted !== undefined) {
      select.actions.choose(select.highlighted, e);
      e.stopImmediatePropagation();
      return false;
    }
  }
  _handleKeySpace(select, e) {
    if (e.target !== null && ['TEXTAREA', 'INPUT'].includes(e.target.nodeName)) {
      e.stopImmediatePropagation();
    } else if (select.isOpen && select.highlighted !== undefined) {
      e.stopImmediatePropagation();
      e.preventDefault(); // Prevents scrolling of the page.
      select.actions.choose(select.highlighted, e);
    }
  }
  _handleKeyUpDown(select, e) {
    if (select.isOpen) {
      e.preventDefault();
      e.stopPropagation();
      const step = e.key === 'ArrowDown' ? 1 : -1;
      const newHighlighted = advanceSelectableOption(select.results, select.highlighted, step);
      select.actions.highlight(newHighlighted);
      select.actions.scrollTo(newHighlighted);
    } else {
      select.actions.open(e);
    }
  }
  _resetHighlighted() {
    let highlighted;
    const defHighlighted = this.args.defaultHighlighted || defaultHighlighted;
    if (typeof defHighlighted === 'function') {
      highlighted = defHighlighted({
        results: this.results,
        highlighted: this.highlighted,
        selected: this.selected
      });
    } else {
      highlighted = defHighlighted;
    }
    this._highlight(highlighted);
  }
  _filter(options, term, skipDisabled = false) {
    const matcher = this.args.matcher || defaultMatcher;
    const optionMatcher = getOptionMatcher(matcher, defaultMatcher, this.args.searchField);
    return filterOptions(options || [], term, optionMatcher, skipDisabled);
  }
  _updateIsActive(value) {
    this.isActive = value;
  }
  findWithOffset(options, term, offset, skipDisabled = false) {
    const typeAheadOptionMatcher = getOptionMatcher(this.args.typeAheadOptionMatcher || defaultTypeAheadMatcher, defaultTypeAheadMatcher, this.args.searchField);
    return findOptionWithOffset(options || [], term, typeAheadOptionMatcher, offset, skipDisabled);
  }
  publicAPI = dropdown => {
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
      actions: Object.assign({}, dropdown.actions, this._publicAPIActions)
    });
  };
  // Tasks
  triggerTypingTask = buildTask(() => ({
    context: this,
    generator: function* (e) {
      // In general, a user doing this interaction means to have a different result.
      let searchStartOffset = 1;
      let repeatingChar = this._repeatingChar;
      let term;
      // Check if user intends to cycle through results. _repeatingChar can only be the first character.
      const c = e.key.length === 1 ? e.key : '';
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
        searchStartOffset += indexOfOption(this.storedAPI.options, this.storedAPI.highlighted);
      } else if (!this.storedAPI.isOpen && this.selected !== undefined && this.selected !== null) {
        searchStartOffset += indexOfOption(this.storedAPI.options, this.selected);
      } else {
        searchStartOffset = 0;
      }
      // The char is always appended. That way, searching for words like "Aaron" will work even
      // if "Aa" would cycle through the results.
      this._expirableSearchText = this._expirableSearchText + c;
      this._repeatingChar = repeatingChar;
      const match = this.findWithOffset(this.storedAPI.options, term, searchStartOffset, true);
      if (match !== undefined) {
        if (this.storedAPI.isOpen) {
          this.storedAPI.actions.highlight(match);
          this.storedAPI.actions.scrollTo(match);
        } else {
          let selected = match;
          if (this.args.multiple) {
            selected = [match];
          }
          this.storedAPI.actions.select(selected, e);
        }
      }
      yield timeout(1000);
      this._expirableSearchText = '';
      this._repeatingChar = '';
    }
  }), {
    restartable: true
  }, "triggerTypingTask", null);
  static {
    setComponentTemplate(precompileTemplate("{{#if (or @labelText @labelComponent)}}\n  <this.labelComponent @select={{this.storedAPI}} @labelText={{@labelText}} @labelId={{this.labelId}} @triggerId={{this.triggerId}} @labelTag={{@labelTag}} @extra={{@extra}} class={{@labelClass}} />\n{{/if}}\n<BasicDropdown @horizontalPosition={{@horizontalPosition}} @destinationElement={{@destinationElement}} @destination={{@destination}} @initiallyOpened={{@initiallyOpened}} @matchTriggerWidth={{this.matchTriggerWidth}} @preventScroll={{or @preventScroll false}} @onClose={{this.handleClose}} @onOpen={{this.handleOpen}} @renderInPlace={{@renderInPlace}} @verticalPosition={{@verticalPosition}} @disabled={{@disabled}} @calculatePosition={{@calculatePosition}} @triggerComponent={{@ebdTriggerComponent}} @contentComponent={{@ebdContentComponent}} @rootEventType={{or @rootEventType \"mousedown\"}} as |dropdown|>\n  {{#let (this.publicAPI dropdown) (concat \"ember-power-select-options-\" dropdown.uniqueId) as |publicAPI listboxId|}}\n    {{!-- template-lint-disable no-positive-tabindex --}}\n    <dropdown.Trigger @eventType={{or @eventType \"mousedown\"}} {{this.updateOptions @options}} {{this.updateSelected @selected}} {{this.updateRegisterAPI publicAPI}} {{this.updatePerformSearch this.searchText}} {{on \"keydown\" this.handleTriggerKeydown}} {{on \"focus\" this.handleFocus}} {{on \"blur\" this.handleBlur}} class=\"ember-power-select-trigger\n        {{if @multiple \" ember-power-select-multiple-trigger\"}}\n        {{@triggerClass}}{{if publicAPI.isActive \" ember-power-select-trigger--active\"}}\" aria-activedescendant={{if dropdown.isOpen (unless @searchEnabled (concat publicAPI.uniqueId \"-\" this.highlightedIndex))}} aria-controls={{if (and dropdown.isOpen (not @searchEnabled)) listboxId}} aria-describedby={{@ariaDescribedBy}} aria-haspopup={{unless @searchEnabled \"listbox\"}} aria-invalid={{@ariaInvalid}} aria-label={{@ariaLabel}} aria-labelledby={{this.ariaLabelledBy}} aria-owns={{if (and dropdown.isOpen (not @searchEnabled)) listboxId}} aria-required={{@required}} aria-autocomplete={{if @searchEnabled \"list\"}} role={{or @triggerRole \"combobox\"}} title={{@title}} id={{this.triggerId}} tabindex={{and (not @disabled) (or this.tabindex \"0\")}} ...attributes>\n      <this.triggerComponent @allowClear={{@allowClear}} @buildSelection={{this.buildSelection}} @loadingMessage={{or @loadingMessage \"Loading options...\"}} @selectedItemComponent={{this.selectedItemComponent}} @select={{publicAPI}} @searchEnabled={{@searchEnabled}} @searchField={{@searchField}} @searchFieldPosition={{this.searchFieldPosition}} @onFocus={{this.handleFocus}} @onBlur={{this.handleBlur}} @extra={{@extra}} @listboxId={{listboxId}} @onInput={{this.handleInput}} @onKeydown={{this.handleKeydown}} @placeholder={{@placeholder}} @searchPlaceholder={{@searchPlaceholder}} @placeholderComponent={{this.placeholderComponent}} @ariaActiveDescendant={{concat publicAPI.uniqueId \"-\" this.highlightedIndex}} @ariaLabelledBy={{this.ariaLabelledBy}} @ariaDescribedBy={{@ariaDescribedBy}} @ariaLabel={{@ariaLabel}} @role={{@triggerRole}} @tabindex={{@tabindex}} as |opt select|>\n        {{yield opt select}}\n      </this.triggerComponent>\n    </dropdown.Trigger>\n    <dropdown.Content class=\"ember-power-select-dropdown{{if publicAPI.isActive \" ember-power-select-dropdown--active\"}}\n        {{@dropdownClass}}\" @animationEnabled={{@animationEnabled}}>\n      {{#if (notEq @beforeOptionsComponent null)}}\n        <this.beforeOptionsComponent @select={{publicAPI}} @searchEnabled={{@searchEnabled}} @onInput={{this.handleInput}} @onKeydown={{this.handleKeydown}} @onFocus={{this.handleFocus}} @onBlur={{this.handleBlur}} @placeholder={{@placeholder}} @placeholderComponent={{this.placeholderComponent}} @extra={{@extra}} @listboxId={{listboxId}} @ariaActiveDescendant={{if this.highlightedIndex (concat publicAPI.uniqueId \"-\" this.highlightedIndex)}} @selectedItemComponent={{this.selectedItemComponent}} @searchPlaceholder={{@searchPlaceholder}} @searchFieldPosition={{this.searchFieldPosition}} @ariaLabel={{@ariaLabel}} @ariaLabelledBy={{this.ariaLabelledBy}} @ariaDescribedBy={{@ariaDescribedBy}} @triggerRole={{@triggerRole}} />\n      {{/if}}\n      <div class=\"ember-power-select-options-wrapper\">\n        {{#if this.mustShowSearchMessage}}\n          <this.searchMessageComponent @searchMessage={{this.searchMessage}} @select={{publicAPI}} @extra={{@extra}} id={{listboxId}} aria-label={{@ariaLabel}} aria-labelledby={{this.ariaLabelledBy}} />\n        {{else if this.mustShowNoMessages}}\n          <this.noMatchesMessageComponent @noMatchesMessage={{this.noMatchesMessage}} @select={{publicAPI}} @extra={{@extra}} id={{listboxId}} aria-label={{@ariaLabel}} aria-labelledby={{this.ariaLabelledBy}} />\n        {{else}}\n          <this.optionsComponent @loadingMessage={{or @loadingMessage \"Loading options...\"}} @select={{publicAPI}} @options={{publicAPI.results}} @groupIndex=\"\" @optionsComponent={{this.optionsComponent}} @extra={{@extra}} @highlightOnHover={{this.highlightOnHover}} @groupComponent={{this.groupComponent}} role=\"listbox\" aria-multiselectable={{if this.ariaMultiSelectable \"true\"}} id={{listboxId}} class=\"ember-power-select-options\" as |option select|>\n            {{yield option select}}\n          </this.optionsComponent>\n        {{/if}}\n\n        {{#if this.afterOptionsComponent}}\n          {{#let this.afterOptionsComponent as |AfterOptions|}}\n            <AfterOptions @extra={{@extra}} @select={{publicAPI}} />\n          {{/let}}\n        {{/if}}\n        <div role=\"status\" aria-live=\"polite\" aria-atomic=\"true\" class=\"ember-power-select-visually-hidden\">\n          {{this.resultCountMessage}}\n        </div>\n      </div>\n    </dropdown.Content>\n  {{/let}}\n</BasicDropdown>", {
      strictMode: true,
      scope: () => ({
        or,
        BasicDropdown,
        concat,
        and,
        not,
        on,
        notEq
      })
    }), this);
  }
}

export { PowerSelect as default };
//# sourceMappingURL=power-select.js.map
