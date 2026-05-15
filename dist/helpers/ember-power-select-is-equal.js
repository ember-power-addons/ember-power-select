import isEqual from '../utils/equal.js';

function emberPowerSelectIsEqual(option, selected) {
  if (selected === undefined || selected === null) {
    return false;
  }
  if (Array.isArray(selected)) {
    for (let i = 0; i < selected.length; i++) {
      if (isEqual(selected[i], option)) {
        return true;
      }
    }
    return false;
  } else {
    return isEqual(option, selected);
  }
}

export { emberPowerSelectIsEqual as default };
//# sourceMappingURL=ember-power-select-is-equal.js.map
