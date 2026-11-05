export default function emberPowerSelectIsArray<T>(
  maybeArray: T | readonly T[] | undefined,
): maybeArray is readonly T[] {
  return Array.isArray(maybeArray);
}
