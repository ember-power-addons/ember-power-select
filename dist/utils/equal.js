function isEqual(a, b) {
  if (a && typeof a === 'object' && 'isEqual' in a && typeof a.isEqual === 'function') {
    return a.isEqual(b);
  }
  if (a instanceof Date && b instanceof Date) {
    return a.getTime() === b.getTime();
  }
  return a === b;
}

export { isEqual as default };
//# sourceMappingURL=equal.js.map
