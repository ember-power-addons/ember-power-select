import { click, settled, fillIn } from '@ember/test-helpers';

async function openIfClosedAndGetContentId(trigger) {
  const contentId = `ember-basic-dropdown-content-${trigger.getAttribute('data-ebd-id')?.replace('-trigger', '')}`;
  const content = contentId ? trigger.getRootNode().querySelector(`#${contentId}`) : undefined;
  // If the dropdown is closed, open it
  if (!content || content.classList.contains('ember-basic-dropdown-content-placeholder')) {
    await click(trigger);
  }
  return contentId;
}
async function selectChoose(cssPathOrTrigger, valueOrSelector, optionIndex) {
  let trigger = null;
  let target;
  if (cssPathOrTrigger instanceof HTMLElement) {
    if (cssPathOrTrigger.classList.contains('ember-power-select-trigger')) {
      trigger = cssPathOrTrigger;
    } else {
      trigger = cssPathOrTrigger.querySelector('.ember-power-select-trigger');
    }
  } else {
    trigger = document.querySelector(`${cssPathOrTrigger} .ember-power-select-trigger`);
    if (!trigger) {
      trigger = document.querySelector(cssPathOrTrigger);
    }
  }
  if (!trigger) {
    throw new Error(`You called "selectChoose" with '${valueOrSelector}' but no select was found`);
  }
  trigger.scrollIntoView();
  const contentId = await openIfClosedAndGetContentId(trigger);
  const rootElement = trigger.getRootNode();
  // Select the option with the given text
  const options = rootElement.querySelectorAll(`#${contentId} .ember-power-select-option`);
  let potentialTargets = Array.from(options).filter(opt => (opt.textContent ?? '').indexOf(valueOrSelector) > -1);
  if (potentialTargets.length === 0) {
    potentialTargets = Array.from(rootElement.querySelectorAll(`#${contentId} ${valueOrSelector}`));
  }
  if (potentialTargets.length > 1) {
    const filteredTargets = potentialTargets.filter(t => t.textContent?.trim() === valueOrSelector);
    if (optionIndex === undefined) {
      target = filteredTargets[0] ?? potentialTargets[0];
    } else {
      target = filteredTargets[optionIndex] ?? potentialTargets[optionIndex];
    }
  } else {
    target = potentialTargets[0];
  }
  if (!target) {
    throw new Error(`You called "selectChoose" with '${valueOrSelector}' but "${valueOrSelector}" didn't match any option`);
  }
  await click(target);
  return settled();
}
async function selectSearch(cssPathOrTrigger, value) {
  let trigger;
  if (cssPathOrTrigger instanceof HTMLElement) {
    if (cssPathOrTrigger.classList.contains('ember-power-select-trigger')) {
      trigger = cssPathOrTrigger;
    } else {
      trigger = cssPathOrTrigger.querySelector('.ember-power-select-trigger');
    }
  } else {
    let triggerPath = `${cssPathOrTrigger} .ember-power-select-trigger`;
    trigger = document.querySelector(triggerPath);
    if (!trigger) {
      triggerPath = cssPathOrTrigger;
      trigger = document.querySelector(triggerPath);
    }
  }
  if (!trigger) {
    throw new Error(`You called "selectSearch" with '${value}' but no select was found`);
  }
  trigger.scrollIntoView();
  const isMultipleSelect = !!trigger.querySelector('.ember-power-select-trigger-multiple-input');
  const rootElement = trigger.getRootNode();
  const contentId = await openIfClosedAndGetContentId(trigger);
  const isDefaultSingleSelect = !!rootElement.querySelector('.ember-power-select-search-input');
  if (isMultipleSelect) {
    const multiSelectTrigger = trigger.querySelector('.ember-power-select-trigger-multiple-input');
    if (multiSelectTrigger) {
      await fillIn(multiSelectTrigger, value);
    }
  } else if (isDefaultSingleSelect) {
    await fillIn(rootElement.querySelector('.ember-power-select-search-input'), value);
  } else {
    // It's probably a customized version
    const triggerInput = trigger.querySelector('.ember-power-select-trigger input[type=search]');
    if (triggerInput) {
      await fillIn(triggerInput, value);
    } else {
      await fillIn(`#${contentId} .ember-power-select-search-input[type=search]`, 'input');
    }
  }
  return settled();
}
async function removeMultipleOption(cssPath, value, rootElement) {
  let elem = null;
  const items = (rootElement || document).querySelectorAll(`${cssPath} .ember-power-select-multiple-options > li`);
  const item = Array.from(items).find(el => (el.textContent ?? '').indexOf(value) > -1);
  if (item) {
    elem = item.querySelector('.ember-power-select-multiple-remove-btn');
  }
  if (!elem) {
    throw new Error(`You called "removeMultipleOption('${cssPath}', '${value}')" but no remove button was found using selector "${cssPath}" for value "${value}"`);
  }
  await click(elem);
  return settled();
}
async function clearSelected(cssPath, rootElement) {
  const elem = (rootElement || document).querySelector(`${cssPath} .ember-power-select-clear-btn`);
  if (!elem) {
    throw new Error(`You called "clearSelected('${cssPath}')" but no clear button was found using selector "${cssPath}"`);
  }
  await click(elem);
  return settled();
}

/* *
 * @param {String} selector CSS3 selector of the elements to check the content
 * @returns {Array} returns all the elements present in the dropdown
 * */
async function getDropdownItems(cssPathOrTrigger) {
  let trigger = null;
  if (cssPathOrTrigger instanceof HTMLElement) {
    if (cssPathOrTrigger.classList.contains('ember-power-select-trigger')) {
      trigger = cssPathOrTrigger;
    } else {
      trigger = cssPathOrTrigger.querySelector('.ember-power-select-trigger');
    }
  } else {
    trigger = document.querySelector(`${cssPathOrTrigger} .ember-power-select-trigger`);
    if (!trigger) {
      trigger = document.querySelector(cssPathOrTrigger);
    }
  }
  if (!trigger) {
    throw new Error(`You called "getDropdownItems" but no select was found`);
  }
  trigger.scrollIntoView();
  const contentId = await openIfClosedAndGetContentId(trigger);
  const rootElement = trigger.getRootNode();
  // Select the option with the given selector
  const rawOptions = rootElement.querySelectorAll(`#${contentId} .ember-power-select-option`);
  return Array.from(rawOptions).map(opt => opt.textContent?.trim());
}

export { clearSelected, getDropdownItems, removeMultipleOption, selectChoose, selectSearch };
//# sourceMappingURL=test-support.js.map
