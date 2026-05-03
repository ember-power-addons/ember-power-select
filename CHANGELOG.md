



















## v8.12.1 (2025-12-07)

#### :bug: Bug Fix
* [#1955](https://github.com/ember-power-addons/ember-power-select/pull/1955) Fix rendering bug when input field is in trigger ([@mkszepp](https://github.com/mkszepp))
* [#1952](https://github.com/ember-power-addons/ember-power-select/pull/1952) Typing on trigger should always return an array for multiple select ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1956](https://github.com/ember-power-addons/ember-power-select/pull/1956) Update installation docs and fixes in readme ([@mkszepp](https://github.com/mkszepp))
* [#1953](https://github.com/ember-power-addons/ember-power-select/pull/1953) Move docs to vite ([@mkszepp](https://github.com/mkszepp))

#### :house: Internal
* [#1957](https://github.com/ember-power-addons/ember-power-select/pull/1957) Update to @embroider/addon-dev v8 ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.12.0 (2025-11-03)

#### :rocket: Enhancement
* [#1949](https://github.com/ember-power-addons/ember-power-select/pull/1949) Add `@labelTag` to allow overriding the default label tag ([@kexposito](https://github.com/kexposito))

#### :bug: Bug Fix
* [#1950](https://github.com/ember-power-addons/ember-power-select/pull/1950) Fix `@placeholder` for multiple select field with `@searchEnabled={{true}}` and `@searchFieldPosition="before-options"` ([@mkszepp](https://github.com/mkszepp))
* [#1948](https://github.com/ember-power-addons/ember-power-select/pull/1948) Allow void in all `on` events ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1947](https://github.com/ember-power-addons/ember-power-select/pull/1947) Convert docs to gts ([@mkszepp](https://github.com/mkszepp))

#### Committers: 2
- Kevin Expósito ([@kexposito](https://github.com/kexposito))
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.11.0 (2025-10-01)

#### :rocket: Enhancement
* [#1939](https://github.com/ember-power-addons/ember-power-select/pull/1939) Add `@multiple` parameter to `<PowerSelect>` and deprecate `<PowerSelectMultiple>` ([@mkszepp](https://github.com/mkszepp))

#### :bug: Bug Fix
* [#1943](https://github.com/ember-power-addons/ember-power-select/pull/1943) Add check to avoid auto focus for input field in trigger ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1942](https://github.com/ember-power-addons/ember-power-select/pull/1942) Update docs to new multiple select field way ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.10.0 (2025-09-30)

#### :rocket: Enhancement
* [#1940](https://github.com/ember-power-addons/ember-power-select/pull/1940) Add support for shadow dom ([@mkszepp](https://github.com/mkszepp))
* [#1938](https://github.com/ember-power-addons/ember-power-select/pull/1938) Remove use of `ember-lifeline` (addon & docs) ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.9.0 (2025-09-16)

#### :rocket: Enhancement
* [#1937](https://github.com/ember-power-addons/ember-power-select/pull/1937) Allow `ember-truth-helpers` v5 as dependency ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1935](https://github.com/ember-power-addons/ember-power-select/pull/1935) Fix ember-concurrency usages in docs (replace `@task`) ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.8.0 (2025-08-18)

#### :rocket: Enhancement
* [#1933](https://github.com/ember-power-addons/ember-power-select/pull/1933) Allow `ember-concurrency` v5 ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.7.3 (2025-06-03)

#### :bug: Bug Fix
* [#1884](https://github.com/ember-power-addons/ember-power-select/pull/1884) Inputfield in trigger - Avoid clearing input field when dropdown is open ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.7.2 (2025-05-26)

#### :bug: Bug Fix
* [#1882](https://github.com/ember-power-addons/ember-power-select/pull/1882) Fix before options component (add input when position is undefined) & Add tests for `@beforeOptionsComponent` with search field ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.7.1 (2025-05-13)

#### :bug: Bug Fix
* [#1879](https://github.com/ember-power-addons/ember-power-select/pull/1879) Fix empty ariaLabelledBy ([@mkszepp](https://github.com/mkszepp))
* [#1877](https://github.com/ember-power-addons/ember-power-select/pull/1877) Remove ember-source and glimmer tracking as a peer dependency ([@runspired](https://github.com/runspired))

#### :memo: Documentation
* [#1872](https://github.com/ember-power-addons/ember-power-select/pull/1872) DOCS: Add `@required` and `attributes` ([@andrew-paterson](https://github.com/andrew-paterson))

#### :house: Internal
* [#1873](https://github.com/ember-power-addons/ember-power-select/pull/1873) Remove incorrect lock files ([@mkszepp](https://github.com/mkszepp))

#### Committers: 3
- Andrew Paterson ([@andrew-paterson](https://github.com/andrew-paterson))
- Chris Thoburn ([@runspired](https://github.com/runspired))
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.7.0 (2025-01-27)

#### :rocket: Enhancement
* [#1867](https://github.com/ember-power-addons/ember-power-select/pull/1867) Allow `@ember/test-helpers` v5.x and update ember-cli to 6.1 ([@mkszepp](https://github.com/mkszepp))

#### :house: Internal
* [#1868](https://github.com/ember-power-addons/ember-power-select/pull/1868) Update `ember-basic-dropdown` to `^8.5.0` ([@mkszepp](https://github.com/mkszepp))
* [#1867](https://github.com/ember-power-addons/ember-power-select/pull/1867) Allow `@ember/test-helpers` v5.x and update ember-cli to 6.1 ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.6.2 (2024-12-27)

#### :bug: Bug Fix
* [#1866](https://github.com/ember-power-addons/ember-power-select/pull/1866) Fix a11y error for single select with search field position trigger ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.6.1 (2024-12-19)

#### :bug: Bug Fix
* [#1865](https://github.com/ember-power-addons/ember-power-select/pull/1865) Fix multiple select error `TypeError Cannot read properties of null (reading 'length')` ([@johanrd](https://github.com/johanrd))

#### Committers: 1
- [@johanrd](https://github.com/johanrd)

## v8.6.0 (2024-12-11)

#### :rocket: Enhancement
* [#1864](https://github.com/ember-power-addons/ember-power-select/pull/1864) Add `@searchFieldPosition` argument ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.5.0 (2024-12-05)

#### :rocket: Enhancement
* [#1863](https://github.com/ember-power-addons/ember-power-select/pull/1863) Pass destinationElement to basic-dropdown ([@andreyfel](https://github.com/andreyfel))

#### :bug: Bug Fix
* [#1862](https://github.com/ember-power-addons/ember-power-select/pull/1862) Remove incorrect `Element` from args in `PowerSelectMultipleTrigger` ([@mkszepp](https://github.com/mkszepp))

#### Committers: 2
- Andrey Fel ([@andreyfel](https://github.com/andreyfel))
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.4.0 (2024-11-12)

#### :rocket: Enhancement
* [#1859](https://github.com/ember-power-addons/ember-power-select/pull/1859) Allow `@glimmer/component` v2 ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1858](https://github.com/ember-power-addons/ember-power-select/pull/1858) Remove `ember-prism`, use `primsjs` in docs ([@mkszepp](https://github.com/mkszepp))

#### :house: Internal
* [#1857](https://github.com/ember-power-addons/ember-power-select/pull/1857) Replace scss to css compiler while rollup ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.3.1 (2024-09-09)

#### :rocket: Enhancement
* [#1853](https://github.com/ember-power-addons/ember-power-select/pull/1853) Allow `@ember/test-helpers` to v4 ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.3.0 (2024-07-31)

#### :rocket: Enhancement
* [#1843](https://github.com/ember-power-addons/ember-power-select/pull/1843) Copy custom group properties in `group-utils` copyGroup function ([@lukasnys](https://github.com/lukasnys))

#### :bug: Bug Fix
* [#1846](https://github.com/ember-power-addons/ember-power-select/pull/1846) Use correct typing for rootEventType ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1842](https://github.com/ember-power-addons/ember-power-select/pull/1842) Docs: remove test helper setup ([@wozny1989](https://github.com/wozny1989))
* [#1841](https://github.com/ember-power-addons/ember-power-select/pull/1841) Add `ember-inflector` in docs to fix docs page (cause ember-data bug) ([@mkszepp](https://github.com/mkszepp))
* [#1810](https://github.com/ember-power-addons/ember-power-select/pull/1810) Fix direct links to sub pages ([@mkszepp](https://github.com/mkszepp))

#### :house: Internal
* [#1840](https://github.com/ember-power-addons/ember-power-select/pull/1840) Add push dist workflow ([@mkszepp](https://github.com/mkszepp))
* [#1806](https://github.com/ember-power-addons/ember-power-select/pull/1806) Add missing addon blueprint config & update blueprint ([@mkszepp](https://github.com/mkszepp))

#### Committers: 5
- Adam Woźny ([@wozny1989](https://github.com/wozny1989))
- Arnaud Weyts ([@ArnaudWeyts](https://github.com/ArnaudWeyts))
- Lukas Nys ([@lukasnys](https://github.com/lukasnys))
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))
- Yelin Zhang ([@Yelinz](https://github.com/Yelinz))

## v8.2.0 (2024-05-06)

#### :rocket: Enhancement
* [#1802](https://github.com/ember-power-addons/ember-power-select/pull/1802) Replace `@ember/runloop` with `ember-lifeline` ([@mkszepp](https://github.com/mkszepp))
* [#1801](https://github.com/ember-power-addons/ember-power-select/pull/1801) Use `ember-modifier` instead of `@ember/render-modifiers` ([@mkszepp](https://github.com/mkszepp))
* [#1795](https://github.com/ember-power-addons/ember-power-select/pull/1795) Remove last Ember.Array (A()) using in addon, examples & tests ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- Markus Sanin ([@mkszepp](https://github.com/mkszepp))

## v8.1.0 (2024-03-18)

#### :rocket: Enhancement
* [#1746](https://github.com/ember-power-addons/ember-power-select/pull/1746) Type improvements ([@bendemboski](https://github.com/bendemboski))
* [#1743](https://github.com/ember-power-addons/ember-power-select/pull/1743) Migrate test helpers to TypeScript ([@andreyfel](https://github.com/andreyfel))

#### :house: Internal
* [#1744](https://github.com/ember-power-addons/ember-power-select/pull/1744) Remove NodeJs info (not necessary for v2 addon) ([@mkszepp](https://github.com/mkszepp))

#### Committers: 3
- Andrey Fel ([@andreyfel](https://github.com/andreyfel))
- Ben Demboski ([@bendemboski](https://github.com/bendemboski))
- [@mkszepp](https://github.com/mkszepp)

## v8.0.2 (2024-03-13)

#### :bug: Bug Fix
* [#1742](https://github.com/ember-power-addons/ember-power-select/pull/1742) Fix theme imports for vanilla js ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- [@mkszepp](https://github.com/mkszepp)

## v8.0.1 (2024-03-12)

#### :bug: Bug Fix
* [#1739](https://github.com/ember-power-addons/ember-power-select/pull/1739) Fix rollup config (style.js -> styles.js) ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1740](https://github.com/ember-power-addons/ember-power-select/pull/1740) Mark ember-power-select-is-equal as public & add as note in migrate docs ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0 (2024-03-12)

For upgrade from v7 to v8 see [here](https://ember-power-select.com/docs/migrate-7-0-to-8-0)

#### :memo: Documentation
* [#1727](https://github.com/ember-power-addons/ember-power-select/pull/1727) Minor Typo correction. ([@incredible-dev](https://github.com/incredible-dev))

#### Committers: 2
- Sanjeev Singh ([@incredible-dev](https://github.com/incredible-dev))
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.8 (2024-03-05)

#### :boom: Breaking Change
* [#1690](https://github.com/ember-power-addons/ember-power-select/pull/1690) Improve a11y & make easier to fullfill all requirements out of the box ([@mkszepp](https://github.com/mkszepp))

#### :rocket: Enhancement
* [#1690](https://github.com/ember-power-addons/ember-power-select/pull/1690) Improve a11y & make easier to fullfill all requirements out of the box ([@mkszepp](https://github.com/mkszepp))

#### :bug: Bug Fix
* [#1717](https://github.com/ember-power-addons/ember-power-select/pull/1717) Fix `BeforeOptions` search input having invalid `aria-activedescendant` when no results are found ([@alex-ju](https://github.com/alex-ju))
* [#1716](https://github.com/ember-power-addons/ember-power-select/pull/1716) Fix `BeforeOptions` search input missing `aria-expanded` ([@alex-ju](https://github.com/alex-ju))
* [#1715](https://github.com/ember-power-addons/ember-power-select/pull/1715) Fix `NoMatchesMessage` component missing splattributes ([@alex-ju](https://github.com/alex-ju))
* [#1714](https://github.com/ember-power-addons/ember-power-select/pull/1714) fix: `Type error: (n.selected || []).slice is not a function` in multiple select ([@johanrd](https://github.com/johanrd))

#### :memo: Documentation
* [#1694](https://github.com/ember-power-addons/ember-power-select/pull/1694) docs: update repo link to variables ([@derrabauke](https://github.com/derrabauke))

#### Committers: 4
- Alex ([@alex-ju](https://github.com/alex-ju))
- Falk Neumann ([@derrabauke](https://github.com/derrabauke))
- [@johanrd](https://github.com/johanrd)
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.7 (2024-02-12)

## v8.0.0-beta.6 (2024-02-12)

#### :boom: Breaking Change
* [#1685](https://github.com/ember-power-addons/ember-power-select/pull/1685) Update ember-concurrency to v4 and move to peerDependencies ([@mkszepp](https://github.com/mkszepp))

#### :rocket: Enhancement
* [#1683](https://github.com/ember-power-addons/ember-power-select/pull/1683) Add `template-registry` and activate glint in `docs` / `test-app` ([@mkszepp](https://github.com/mkszepp))
* [#1682](https://github.com/ember-power-addons/ember-power-select/pull/1682) Convert `@task` to the async-arrow fn ([@mkszepp](https://github.com/mkszepp))

#### :bug: Bug Fix
* [#1687](https://github.com/ember-power-addons/ember-power-select/pull/1687) Forward @highlightOnHover & @typeAheadOptionMatcher on multiple select ([@mkszepp](https://github.com/mkszepp))
* [#1674](https://github.com/ember-power-addons/ember-power-select/pull/1674) fix: support numbers selection for `PowerSelect` component ([@artemgurzhii](https://github.com/artemgurzhii))

#### :memo: Documentation
* [#1686](https://github.com/ember-power-addons/ember-power-select/pull/1686) DOCS: Add section "Migrate from 7.0 to 8.0" ([@mkszepp](https://github.com/mkszepp))
* [#1660](https://github.com/ember-power-addons/ember-power-select/pull/1660) DOCS: Fix scss import statement ([@mkszepp](https://github.com/mkszepp))

#### :house: Internal
* [#1684](https://github.com/ember-power-addons/ember-power-select/pull/1684) Stricter dep management ([@mkszepp](https://github.com/mkszepp))

#### Committers: 2
- Artem Hurzhii ([@artemgurzhii](https://github.com/artemgurzhii))
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.5 (2024-01-18)

#### :boom: Breaking Change
* [#1641](https://github.com/ember-power-addons/ember-power-select/pull/1641) Fix input width in PowerSelectMultiple ([@mkszepp](https://github.com/mkszepp))
* [#1630](https://github.com/ember-power-addons/ember-power-select/pull/1630) types: Separate Args and Signature ([@johanrd](https://github.com/johanrd))

#### :rocket: Enhancement
* [#1650](https://github.com/ember-power-addons/ember-power-select/pull/1650) Set `args.selected` as optional ([@johanrd](https://github.com/johanrd))
* [#1649](https://github.com/ember-power-addons/ember-power-select/pull/1649) Set `args.options` as optional ([@johanrd](https://github.com/johanrd))
* [#1637](https://github.com/ember-power-addons/ember-power-select/pull/1637) Allow to highlight an object option without use the same reference ([@rogeraraujo90](https://github.com/rogeraraujo90))
* [#1632](https://github.com/ember-power-addons/ember-power-select/pull/1632) Add option to use `ember-power-select.scss` ([@mkszepp](https://github.com/mkszepp))

#### :bug: Bug Fix
* [#1641](https://github.com/ember-power-addons/ember-power-select/pull/1641) Fix input width in PowerSelectMultiple ([@mkszepp](https://github.com/mkszepp))
* [#1638](https://github.com/ember-power-addons/ember-power-select/pull/1638) Update appReexports & remove unused util ([@mkszepp](https://github.com/mkszepp))
* [#1631](https://github.com/ember-power-addons/ember-power-select/pull/1631) Define `destination` as optional ([@johanrd](https://github.com/johanrd))
* [#1630](https://github.com/ember-power-addons/ember-power-select/pull/1630) types: Separate Args and Signature ([@johanrd](https://github.com/johanrd))

#### :memo: Documentation
* [#1640](https://github.com/ember-power-addons/ember-power-select/pull/1640) DOCS: Remove `ember-href-to` package & replace usings ([@mkszepp](https://github.com/mkszepp))
* [#1635](https://github.com/ember-power-addons/ember-power-select/pull/1635) DOCS: Fix typo & usings ([@mkszepp](https://github.com/mkszepp))

#### Committers: 3
- Roger ([@rogeraraujo90](https://github.com/rogeraraujo90))
- [@johanrd](https://github.com/johanrd)
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.4 (2024-01-04)

## v8.0.0-beta.3 (2024-01-04)

#### :bug: Bug Fix
* [#1628](https://github.com/ember-power-addons/ember-power-select/pull/1628) Fix theme export for SCSS/LESS & fix primary less file ([@mkszepp](https://github.com/mkszepp))

#### :memo: Documentation
* [#1627](https://github.com/ember-power-addons/ember-power-select/pull/1627) DOCS: Add additional option for css import ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.2 (2024-01-02)

#### :bug: Bug Fix
* [#1626](https://github.com/ember-power-addons/ember-power-select/pull/1626) Fix blueprint ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.1 (2024-01-02)

#### :bug: Bug Fix
* [#1625](https://github.com/ember-power-addons/ember-power-select/pull/1625) Fix test-support export & remove deprecated code ([@mkszepp](https://github.com/mkszepp))
* [#1624](https://github.com/ember-power-addons/ember-power-select/pull/1624) Fix blueprint export ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- [@mkszepp](https://github.com/mkszepp)

## v8.0.0-beta.0 (2024-01-02)

#### :boom: Breaking Change
* [#1619](https://github.com/ember-power-addons/ember-power-select/pull/1619) Addon to v2 ([@mkszepp](https://github.com/mkszepp))
* [#1615](https://github.com/ember-power-addons/ember-power-select/pull/1615) Update ember cli v4.12.1 to v5.4.1 & drop node v16 ([@mkszepp](https://github.com/mkszepp))

#### :house: Internal
* [#1621](https://github.com/ember-power-addons/ember-power-select/pull/1621) Fix doc ([@mkszepp](https://github.com/mkszepp))
* [#1618](https://github.com/ember-power-addons/ember-power-select/pull/1618) Remove overrides in `package.json` ([@mkszepp](https://github.com/mkszepp))
* [#1617](https://github.com/ember-power-addons/ember-power-select/pull/1617) Update typescript, drop mocha, testdouble (unused) ([@mkszepp](https://github.com/mkszepp))
* [#1616](https://github.com/ember-power-addons/ember-power-select/pull/1616) Drop `ember-text-measurer` from dependencies ([@mkszepp](https://github.com/mkszepp))
* [#1614](https://github.com/ember-power-addons/ember-power-select/pull/1614) Drop outdated devDependencies ([@mkszepp](https://github.com/mkszepp))

#### Committers: 1
- [@mkszepp](https://github.com/mkszepp)

## v7.2.0 (2023-11-16)

#### :rocket: Enhancement
* [#1593](https://github.com/ember-power-addons/ember-power-select/pull/1593) Allow `ember-truth-helpers` v4 as dependency ([@mkszepp](https://github.com/mkszepp))

#### :bug: Bug Fix
* [#1612](https://github.com/ember-power-addons/ember-power-select/pull/1612) Add missing dependency `@ember/render-modifiers` ([@mkszepp](https://github.com/mkszepp))
* [#1603](https://github.com/ember-power-addons/ember-power-select/pull/1603) isSliceable is not working for ember data 3.x hasmany relationships ([@betocantu93](https://github.com/betocantu93))

#### :house: Internal
* [#1613](https://github.com/ember-power-addons/ember-power-select/pull/1613) Update release-it to v16 ([@mkszepp](https://github.com/mkszepp))
* [#1610](https://github.com/ember-power-addons/ember-power-select/pull/1610) Use ember-data 3.28 in ember 3.28 test & add ember 5 test ([@mkszepp](https://github.com/mkszepp))
* [#1609](https://github.com/ember-power-addons/ember-power-select/pull/1609) Update `ember-cli-mirage` to stable v3 ([@mkszepp](https://github.com/mkszepp))
* [#1595](https://github.com/ember-power-addons/ember-power-select/pull/1595) Update compatibility in readme ([@mkszepp](https://github.com/mkszepp))
* [#1594](https://github.com/ember-power-addons/ember-power-select/pull/1594) Add missing release notes for v7 ([@mkszepp](https://github.com/mkszepp))

#### Committers: 2
- Alberto Cantú Gómez ([@betocantu93](https://github.com/betocantu93))
- [@mkszepp](https://github.com/mkszepp)

## v7.1.2 (2023-08-23)
- Update ember-basic-dropdown which uses a newer ember-element-helper.

## v7.1.1 (2023-08-18)

#### :bug: Bug Fix
* [#1589](https://github.com/ember-power-addons/ember-power-select/pull/1589) fix: Update invalid type imports ([@HeroicEric](https://github.com/HeroicEric))

#### :house: Internal
* [#1591](https://github.com/ember-power-addons/ember-power-select/pull/1591) build: Fix embroider optimized CI builds ([@HeroicEric](https://github.com/HeroicEric))

#### Committers: 1
- Eric Kelly ([@HeroicEric](https://github.com/HeroicEric))

## v7.1.0
- Make it compatible with Ember 5.

## v7.0.0 (2023-03-06)
* [#1572](https://github.com/ember-power-addons/ember-power-select/pull/1572) Fix tests for embroider-optimized ([@mkszepp](https://github.com/mkszepp))
* [#1570](https://github.com/ember-power-addons/ember-power-select/pull/1570) Update to ember 4.8 & packages. Require node >= 16, Ember >= 3.28 ([@mkszepp](https://github.com/mkszepp))
* [#1564](https://github.com/ember-power-addons/ember-power-select/pull/1564) Remove ember-data array deprecation ([@mkszepp](https://github.com/mkszepp))
* [#1567](https://github.com/ember-power-addons/ember-power-select/pull/1567) Pass along the @animationEnabled argument to dropdown.Content, bump ember-basic-dropdown ([@ArnaudWeyts](https://github.com/ArnaudWeyts))
* [#1560](https://github.com/ember-power-addons/ember-power-select/pull/1560) Fix import from ember-basic-dropdown ([@wagenet](https://github.com/wagenet))
* [#1548](https://github.com/ember-power-addons/ember-power-select/pull/1548) Add type declarations ([@charlesfries](https://github.com/charlesfries))
* [#1544](https://github.com/ember-power-addons/ember-power-select/pull/1544) fix: redirects in netlify ([@wozny1989](https://github.com/wozny1989))
* [#1306](https://github.com/ember-power-addons/ember-power-select/pull/1306) Fix a11y issues with inputs ([@mydea](https://github.com/mydea))
* [#1545](https://github.com/ember-power-addons/ember-power-select/pull/1545) chore: snippet improvements ([@wozny1989](https://github.com/wozny1989))
* [#1542](https://github.com/ember-power-addons/ember-power-select/pull/1542) fix: display code snippets in documentation ([@wozny1989](https://github.com/wozny1989))
* [#1540](https://github.com/ember-power-addons/ember-power-select/pull/1540) be more permissive on ember-truth-helpers ([@miguelcobain](https://github.com/miguelcobain))
* [#1305](https://github.com/ember-power-addons/ember-power-select/pull/1305) Ensure multiple select ul has only li children ([@mydea](https://github.com/mydea))
* [#1495](https://github.com/ember-power-addons/ember-power-select/pull/1495) Fix error when pressing backspace in empty multiple-select component ([@gvdp](https://github.com/gvdp))

## v6.0.1 (2022-08-23)

#### :rocket: Enhancement
* [#1406](https://github.com/ember-power-addons/ember-power-select/pull/1406) Add support for stylus (Apple Pencil) ([@krasnoukhov](https://github.com/krasnoukhov))

#### Committers: 1
- Dmitry Krasnoukhov ([@krasnoukhov](https://github.com/krasnoukhov))

## v6.0.0 (2022-08-05)

#### :boom: Breaking Change
* [#1533](https://github.com/ember-power-addons/ember-power-select/pull/1533) Require node >= 14, Ember >= 3.24 ([@rwwagner90](https://github.com/rwwagner90))
* [#1526](https://github.com/ember-power-addons/ember-power-select/pull/1526) Delete files array to fix TS, require ember-basic-dropdown 6+ ([@rwwagner90](https://github.com/rwwagner90))

#### :rocket: Enhancement
* [#1530](https://github.com/ember-power-addons/ember-power-select/pull/1530) embroider-optimized support ([@rwwagner90](https://github.com/rwwagner90))
* [#1529](https://github.com/ember-power-addons/ember-power-select/pull/1529) Allow a wider range of ember-basic-dropdown versions ([@cibernox](https://github.com/cibernox))

#### :house: Internal
* [#1535](https://github.com/ember-power-addons/ember-power-select/pull/1535) Add rwjblue release-it ([@rwwagner90](https://github.com/rwwagner90))
* [#1532](https://github.com/ember-power-addons/ember-power-select/pull/1532) Fix embroider-optimized ([@rwwagner90](https://github.com/rwwagner90))
* [#1531](https://github.com/ember-power-addons/ember-power-select/pull/1531) Update linting config, comply with prettier ([@rwwagner90](https://github.com/rwwagner90))
* [#1506](https://github.com/ember-power-addons/ember-power-select/pull/1506) Cleans up scrollTo's element finding ([@matthew-robertson](https://github.com/matthew-robertson))

#### Committers: 4
- Chris Manson ([@mansona](https://github.com/mansona))
- Matthew Robertson ([@matthew-robertson](https://github.com/matthew-robertson))
- Miguel Camba ([@cibernox](https://github.com/cibernox))
- Robert Wagner ([@rwwagner90](https://github.com/rwwagner90))

# Master

# 5.0.4
- Improve compatibility with embroider
# 5.0.2
- Make the component compatible with Embroider builds.
- Revert #1470. It turned out to be a breaking change.
# 5.0.1
- (#1470) [ENHANCEMENT] For multiselects, ensure that, if an option is disabled, AND that option is selected, then we can't "remove" that option from the selection
- Allow the addon to work with ember-basic-dropdown 3 and 4.

# 5.0.0
- (#1481) [MAYBE BREAKING] Big overhaul of the a11y of the component. Now it uses `aria-activedescendant` to properly announce highlighted options.
- (#1483) [BREAKING] Now options always have `role=option`. Before the selected option had `role=alert` instead but with the recent
  a11y enhancements this is more correct.
# 4.1.7
- Forward in `@animationEnabled` from PowerSelectMultiple to inner select #1475
- Remove debugger statements introduced by mistake
# 4.1.5
- [ENHACEMENT] Update ember-basic-dropdown to 3.0.17 which includes updated `ember-element-helper` and should
  be more friendly with embroider.
- [BUGFIX] Ensure searchbox in multiple select doesn't submit its enclosing form when enter is pressed.

# 4.1.4
- [BUGFIX] Fix arrays appended to multiple selects' selected array (#1447)
# 4.1.3
- [CHORE] Move from travis to github actions, fixing the test suite along the way. This has also
  updated the version of ember-basic-dropdown.

# 4.1.2
- [BUGFIX] Fix problem when passing `@initiallyOpened` along with `@selected`.

# 4.1.1
- [ENHANCEMENT] Allow to customize what's displayed when no item matches the search by passing a `@noMatchesMessageComponent`.

# 4.1.0
- [ENHANCEMENT] Makes changed to aria roles so the currently highlighted option can be announced by assistive
  technology like Voice Over.
- [CHORE] Relax allowed versions of ember-truth-helpers so projects are less likely to have to resolve dependencies.

# 4.0.5
- [BUGFIX] Remove event listeners on destroy.

# 4.0.4
- [BUGFIX] Ensure observers set when selected/options are promise proxies are properly removed when
  the component is destroyed, to prevent memory leaks.

# 4.0.3
- Update `ember-concurrency-decorators` to 2.0

# 4.0.0-beta.6
- [BUGFIX] Multiple selects can receive an ember-data collection in the `@selected` attribute.

# 4.0.0-beta.5
- [BUGFIX] Fix component when the `@search` action return an ember-data collection
- [CHORE] Convert addon to typescript.

# 4.0.0-beta.4
- [BUGFIX] When `@options` is an ember-data collection, transform to a plain array for the public API
- [BUGFIX] Update ember-basic-dropdown to 3.0.0-beta.3 to fix select not recalculating its position
  after scrolling or resizing the window.

# 4.0.0-beta.3
- [BUGFIX] Moved `ember-assign-helpers` from devDependencies to dependencies in `package.json`
- [ENHANCEMENT] Cache filtered results for better performance when selects have many items.

# 4.0.0-beta.2
- [CHORE] Update `@glimmer/component` to 1.0.0 and EBD to next beta.

# 4.0.0-beta.1
- [MAYBE-BREAKING] Update to glimmer components and EBD

# 3.0.4
- [BUGFIX] Allow to customize `calculatePosition` by extending from PowerSelect.
- [BUGFIX] Fix default values for `triggerComponent` and `buildSelection` in `<PowerSelectMultiple>`

# 3.0.3
- [BUGFIX] Allow `@triggerRole` to be used to remove completely the role of the trigger by passing `false`/`null`

# 3.0.2
- [BUGFIX] Put `@ember-decorators/component` in dependencies.

# 3.0.1
- [BUGFIX] Fix bug in `<PowerSelectMultiple>` that caused it to render the search term in both the
  trigger and the before options component.

# 3.0.0
- [CHORE] Update to Ember Basic Dropdown 2.0 final.

# 3.0.0-beta.3
- [CHORE] Update version of ember-basic-dropdown

# 3.0.0-beta.1

- [BREAKING] Now this addon requires Ember 3.11 (in beta at the moment of this writing)
- [BREAKING] This component now expects to be invoked with `<AngleBracket>` syntax.
- [BREAKING] All actions starting with `on` (e.g. `onchange` and `onopen`) are now spelled with camelCase (`@onChange` and `@onOpen`)
- [BREAKING] @searchEnabled is now false by default

# 2.3.5
- [BUGFIX] Could not find module ember-compatibility-helpers

# 2.3.4
- [BUGFIX] Add back node 6 in the list of supported engines

# 2.3.3
- [CHORE] Allow ember-concurrency 1.0

# 2.3.2
- [BUGFIX] Fix bug that caused disabled options to be selectable on touch devices.

# 2.3.1
- [BUGFIX] Allow both ember-concurrency 0.9.X and 0.8.X to support octane and older versions of Ember

# 2.3.0
- [UPDATE] Depend on ember-concurrency 0.9 for better octane support

# 2.2.3
- [ENHANCEMENT] Allow styles to work on apps using Module Unification.

# 2.2.2
- [BUGFIX] Prevent scroll only if target is body

# 2.2.1
- [BUGFIX] Update test helpers so they work with latest version of EBD

# 2.2.0
- [BUGFIX] `{{power-select-multiple}}` should be a tagless component unless otherwise specified.

# 2.1.0
- [ENHANCEMENT] Create a new sass/less styles that are then imported from the main style. This should
  not change the public API

# 2.0.15
- [BUGFIX] Forward `triggerRole` from the multiple-select to the inner select

# 2.0.14
- [BUGFIX] Fix bug when multiple selects are tagless

# 2.0.13
- [INTERNAL] Forward `_triggerTagName` in multiple selects

# 2.0.12
- [BUGFIX] Fix focusing of the searchbox in recent versions of Ember.

# 2.0.11
- [BUGFIX] Forward `eventType` in multiple selects

# 2.0.10
- [ENHANCEMENT] Allow select to be open with `click` instead of `mousedown`

# 2.0.9
- [BUGFIX] Add `highlightOnHover` option (defaults to `true`) that decides if
  hovering an option with the mouse highlights it.

# 2.0.8
- [BUGFIX] Fix the previous bugfix.

# 2.0.7
- [BUGFIX] Avoid polyfilling the DOM in fastboot.

# 2.0.6
- [BUGFIX] Better support `ObjectProxy` to adapt to changes in EmberData > 3.1

# 2.0.5
- [BUGFIX] Ensure the active/deactivate actions are not called if the component is already being destroyed.

# 2.0.4
- [BUGFIX] Fix a bug in which the multiple select opened immediately when renderedin IE11 when using Ember 3.1+ (3.0 and below did not have this bug).
  It has to do with the way placeholders are set and a bug in IE11 that setting the placeholder trigger a `input` event.
- [FEATURE] You can add a title to the trigger by passing `title="The title"` to `{{power-select}}` or `{{power-select-multiple}}`

# 2.0.3
- [BUGFIX] Remove forgoten console statement in test helper

# 2.0.2
- [INTERNAL] Ensure the addon checks if an object is "thenable" using `Ember.get`.

# 2.0.1
- [ENHANCEMENT] Pass the `extra` option to the `selectedItemComponent`
- [CLEANUP] Remove support for node 4.

# 2.0.0
- [INTERNAL] Update to `ember-basic-dropdown` 1.0.0!!
- [INTERNAL] Stop using `ember-native-dom-helpers`. Use regular helpers in `@ember/test-helpers`. This
  causes some subtle changes in asynchrony on the provided test helpers, but if people are using them
  as intended (with async/await) there should be no noticeable changes.

# 2.0.0-beta.5
- [BUGFIX] Remove redundant `self.` preceeding many well know globals like document or window

# 2.0.0-beta.4
- [BUGFIX] Fixes big un Ember 3.1 accessing the getter `selected.then`

# 2.0.0-beta.0
- [BREAKING] Remove long-time-deprecated behavior to support _some_ usages of the `:eq` pseudoselector from jQuery.
- [DEPRECATE] Deprecate global async test helpers: `selectChoose`, `selectSearch`, `removeMultipleOption`
  and `clearSelected`. They are still available, but we recomend explicitly importing them from `ember-power-select/test-support/helpers`
- [BREAKING] Update to ember-basic-dropdown 1.0.0-beta.0, which drops support for Ember 2.9 and below.
  In exchange, the component is now lighter and presumably faster.
- [BREAKING] Change the behaviour of the select when the user types on the focused trigger to mimic
  how native selects work: Repeating a char cycles though the options that start with that char, but
  not repeating performs a search (from be beginning, it will not match substrings in the middle of
  a word). This matcher is called `typeAheadMatcher`, and can also be provided by the user if they
  want a different behaviour. This change in behaviour kicks the 2.0 cycle.

# 1.10.4
- [INTERNAL] Refactor test suite to use the new testing API

# 1.10.3
- [DEPRECATION] Add deprecation to all test helpers when imported from `../../test-support/ember-power-select`.
  Users should use the helpers that live in `/addon-test-selectors`, whose import part is stable regardless
  of the nesting of the file from where they are imported. P.e. `import { selectChoose } from 'ember-power-select/test-support/helpers';`

# 1.10.2
- [ENHANCEMENT] Upgrade to `ember-basic-dropdown` 0.33.10, which supports the `horizontalPosition` property
  on selects rendered in-place.
- [BUGFIX] Fix edge case in which an observer could be fired on a being destroyed (this could probably only
  happen during tests)

# 1.10.1
- [ENHANCEMENT] Add `triggerRole` option to customize the role of the trigger component down in
  ember-basic-dropdown.

# 1.10.0
- [UPDATE] Update `ember-basic-dropdown`, which removes compatibility with IE10 (which was very poor to
  begin with)
- [ENHANCEMENT] Update `ember-text-measurer` to 0.4.0, which uses the latest babel, allowing consumer
  apps to drop `ember-cli-shims`.
- [BUGFIX] Ensure selecting an option by pressing the spacebar on a select without searchbox does not
  cause a page scroll.

# 1.9.11
- [ENHANCEMENT] Update `ember-truth-helpers` to ^2.0
- [ENHANCEMENT] Update `ember-cli-babel` to ^6.8.2

# 1.9.10
- [ENHANCEMENT] Pass the `placeholder` and the `placeholderComponent` to the `beforeOptionsComponent`,
  to allow more customizations on it.
- [BUGFIX] Allow to specify negative margins in Sass variables

# 1.9.9
- [ENHANCEMENT] If the options is a `PromiseArrayProxy`, the content of the array is set immediately
  and updated later when the promise resolves.

# 1.9.8
- [BUGFIX] The Y-axis validation of the click coordinates when opening is disabled in testing because
  there is some chance that, due to the weird positioning selects can have in testing, it throws false
  negatives.

# 1.9.7
- [ENHANCEMENT] The trigger component also receives the loadingMessage.

# 1.9.6
- [ENHANCEMENT] Allow `buildSelection` to fallback to the default one when the provided one
  is undefined.
- [ENHANCEMENT] Add assertion to ensure developers pass a `searchField` option if the options are not plain strings.

# 1.9.5
- [BUGFIX] Allow the to use the num-pad of the keyboard to highlight/select items while the trigger
  is focused. Prior to this, only numbers above the keyboard would work.

# 1.9.4
- [BUGFIX] `selectChoose` and `selectSearch` test helpers now make sure that the trigger is scrolled
  into the viewport before clicking it, as it might cause problems to click in an outside-view item.

# 1.9.3
- [BUGFIX] Ensure that keys pressed with `ctrl` or `alt` on a focused trigger do not call the autoselection/autohighlighting
  feature.

# 1.9.2
- [BUGFIX] Ensure new import paths work regardless of the babel version on the consumer app

# 1.9.1
- [INTERNAL] Remove one forgotten use of the old shims

# 1.9.0
- [INTERNAL] Do not import the `Ember` global or the old shims anymore. Use the new and definitive import paths.
- [INTERNAL] Update to a version of `ember-basic-dropdown` that uses the new import paths

# 1.8.5
- [BUGFIX] Fix bug in iOS that prevented taps in items to be selected. Bug was introduced in 1.7.

# 1.8.4
- [ENHANCEMENT] Allow to use `selectChoose` in integration.

# 1.8.3
- [BUGFIX] Improve smoothness of the scroll of the list of options in iOS devices.
- [ENHANCEMENT] Add an assertion in dev/test to warn the user that having promises inside
  groups is not supported.
- [ENHANCEMENT] Update `ember-basic-dropdown` to `^0.32.5` so it uses `ember-cli-babel` 6.1 and
  `ember-native-dom-helpers` 0.4.0
- [INTERNAL] Use new `assert` helper provided by ember-cli-babel 6.1 that are automatically
  removed in production.

# 1.8.2
- [ENHANCEMENT] Allow developers to pass a function to customize how the select should scroll
  to display an element of the list outside the viewport. Pass `scrollTo=scrollTo`. It receives
  `option, select, event`.

# 1.8.1
- [ENHANCEMENT] The HTMLElement passed to `selectChoose` can now be an ancestor of the trigger instead of only the trigger itself. This was made for consistency with the behaviour of the helper when it receives a CSS selector instead of an element.

# 1.8.0
- [ENHANCEMENT] Update to EBD 0.32, which allows the select to work when nested inside
  elements with scroll. It also fixes positioning when the body is not not positioned at 0,0

# 1.7.2
- [BUGFIX] Fix page scroll when component is opened after refactor to remove jQuery. Fixed
  by bumping the version of ember-basic-dropdown.

# 1.7.1
- [ENHANCEMENT] `selectChoose` and `selectSearch` now accept the HTMLElement of the trigger
  instead of the string with the CSS selector as first arguments.

# 1.7.0
- [ENHANCEMENT] Remove jQuery totally. Saved 29.28KB (min + gzip) on the docs.
- [ENHANCEMENT] Acceptance helpers do not use jQuery, so can be used in apps without jQuery. The
  addon itself it tested without jQuery to ensure it remains jQuery free.
- [DEPRECATION] Passing selectors with `:eq()` is supported but deprecated.
- [ENHANCEMENT] Added a third numeric option to the `selectChoose` helper to select the
  nth element that matches the given selector. E.g: `selectChoose('.language-select', '.power-select-option', 3)`.
- [INTERNAL] Fully refactor to use `ember-native-dom-helpers` both in acceptance and integration.
- [ENHANCEMENT] The component should work without jQuery. It isn't tested yet tho since
  ember-data doesn't work without it. Added an `Element.closest` polyfill for it.

# 1.6.1
- [BUGFIX] Fix double render bug when disabling a component a select. It was caused
  because several blur events were modifying the same property twice. Now changes
  to `isActive` are coalesced.

# 1.6.0
- [INTERNAL] Bump a few internal dependencies and relese babel 6 in stable.

# 1.6.0-beta.0
- [INTERNAL/BREAKING??] Update to Babel 6. There is no reason to think this should be
  breaking, but releasing a beta first, just in case.

# 1.5.0

# 1.5.0-beta.2
- [ENHANCEMENT] Allow to pass a `calculatePosition` function that allows to customize
  how the content is placed and resized. This option has been available in EBD for a long
  time, but now EPS allows it too.

# 1.5.0-beta.1
- [ENHANCEMENT] Now the selected option in the trigger of multiple select have the
  `ember-power-select-multiple-option--disabled` class if that option is disabled. This
  can be used to hide with CSS the `x` button on those options.
- [INTERNAL] Some new **very-private-you-should-not-use-them** options to customize the
  tagName of the trigger and the content.

# 1.5.0-beta.0
- [ENHANCEMENT/BREAKING-ISH] `ember-basic-dropdown` has improved the experience with A11y
  for screen readings. Some `aria-*` have changed and there is an invisible div that wasn't
  there before. EPS doens't rely on those attributes and it's unlikely that this will
  break for anyone, but just in case I'll bump a minor version number and keep it in
  beta for some days.

# 1.4.3
- [ENHANCEMENT] `typeInSearch` integration test helper now accepts an options scope to
  target specific selects when there is more than one in the screen.

# 1.4.2
- [BUGFIX] Fix wrong rgba color in LESS stylesheets of bootstrap theme

# 1.4.1
- [ENHANCEMENT] The id of the trigger can be customize now with `triggerId="foo"`. Useful to relate
  selects with `<label>` tags.

# 1.4.0
- [ENHANCEMENT] Added new `placeholderComponent` option. By default is used in single selects only.

# 1.3.0
- [ENHANCEMENT] Added LESS support, on pair with the SASS one.
- [BUGFIX] If the addon is installed in the presence of an `app.scss` file, it will automatically
  append `@import 'ember-power-select';` to it instead of replacing it.

# 1.2.1
- [BUGFIX] Properly pass the `extra` option to the `optionsComponent`. It used to receive it but
  somehow it was removed by mistake during the 1.0.0-beta cycle.

# 1.2.0
- [INTERNAL] Update to Ember Basic Dropdown 0.20. This will break ember-paper because it uses
  private api, but will be fixed shortly.

# 1.1.0
- [ENHANCEMENT] Compare elemets using `Ember.isEqual` instead of `===`. This gaves use better
  support for dates and allows users to define `isEqual` methods on their objects when keeping
  a constant reference is hard.

# 1.0.3
- [CLEANUP] Depend on a newer version of `ember-cli-sass`, and remove `node-sass`.
- [BUGFIX] Call `registerAPI` with `null` on `willDestroy` to avoid memory leaks

# 1.0.2
- [BUGFIX] REVERT the `overflow: scroll` change in 1.0.1. It makes all selects show scrollbar even
  if the content doesn't need it.

# 1.0.1
- [BUGFIX] The list of options now has `overflow: scroll` instead of `overflow: auto`, which cause
  some issues in firefox for windows

# 1.0.0
- [DOC] Finally 1.0.0. No new features, just stability without stagnation.

# 1.0.0-beta.31
- [BUGFIX] Fix double render error in glimmer2
- [BUGFIX] Ensure that options are not considered a group when they have `groupName` but lack of an `options` property.
- [BUGFIX] The clear button is now activate in touchstart, fixing a bug where in iOS the button was effectively unoperative.

# 1.0.0-beta.30
- [BUGFIX] Update version of ember-basic-dropdown, which fixes several positioning issues involving pages
  with horizontal scroll.

# 1.0.0-beta.29
- [BUGFIX] Improve default bootstrap theme.
- [NOOP] Republish, since something weird happened while publishing beta.28

# 1.0.0-beta.28
- [BUGFIX] Fix helpers that fire events in IE11.

# 1.0.0-beta.27
- [INTERNAL] Update to ember-basic-dropdown 0.17. This version has a breaking change that does not affect ember-power-select,
  but might (unlikely) affect people using ember-basic-dropdown directly.

# 1.0.0-beta.26
- [ENHANCEMENT] Define bootstrap and material themes variables with `!default` so they also can be overriden.

# 1.0.0-beta.25
- [BUGFIX] Ensure EPS depends on a bug-free version of ember-concurrency. Versions from 0.7.11 to 0.7.14 produced a memory leak.

# 1.0.0-beta.24
- [ENHANCEMENT] Return an string from the `oninput` action uses that string in the search instead of the original one.

# 1.0.0-beta.23
- [ENHANCEMENT] Add a `defaultHighlighted` option that can be used to customize what item is highlighted by default with the component is opened.
  It can either be a value, or a function that gets called with the select and returns that value.
- [ENHANCEMENT] Add `@onBlur` event for symmetry with `@onFocus`, and also clarify that both are fired for any element of
  the select gaining the focus, so the `event.target` should be used to disambiguate the origin.
- [BUGFIX] Fix SHIFT+TAB in multiple select: In multiple selects with search enabled that use the default component,
  the tabindex is applied to the searchbox, and the trigger has -1.

# 1.0.0-beta.22
- [ENHANCEMENT] Added a material-design theme!
- [INTERNAL] Internal refactor to leverage ember-concurrency. OMG, this is so much better!

# 1.0.0-beta.21
- [ENHANCEMENT] Add support for cancellables (p.e ember-concurrecy tasks) in the search action.
- [DOCS] Use `ember-code-snippet` to finally have proper syntax highlighting in DOCs. Now snippets are also
  evaluated as partials, which servers as an insurance policy agains typos.
- [INTERNAL] Switch from JSHint to ESLint + `eslint-plugin-ember-suave` for better code uniformity.
- [ENHANCEMENT] The `selectChoose` and `selectSearch` helpers now throw explicative errors when something goes wrong.
- [ENHANCEMENT] The `selectChoose` helper now also allows to receive a CSS selector as second argument (instead of
  the text value of the option). This makes easier for selects with complex HTML inside their options
  to be interacted with.
- [DOCS] Add not explaining that automatic animation detection doesn't work with CSS transitions,
  only with CSS animations.

# 1.0.0-beta.20
- [TESTING] Ensure the addon is tested in 2.4LTS
- [BUGFIX] Fix bug in versions of Ember <= 2.6
- [INTERNAL] Update to ember-cli 2.9

# 1.0.0-beta.19
- [BUGFIX] Update EBD to fix a bug. This prevents open/close actions to be invoked in a destroyed component.

# 1.0.0-beta.17
- [BUGFIX] Widewalk a bug with `Ember.A` in fastboot. See https://github.com/ember-fastboot/ember-cli-fastboot/issues/251
- [INTERNAL] Upgrade to 2.8 family.

# 1.0.0-beta.15
- [BUGFIX] Fix bad memory leak in multiple selects. Probably messing with people's app in testing.
- [BUGFIX] Avoid polluting styles of ember-basic-dropdown.

# 1.0.0-beta.14
- [BUGFIX] Ensure scrolling to the selected option works if another select is still on the page being animated out.
- [BUGFIX] A disabled select won't have tabindex at all (it used to have -1)
- [BUGFIX] If `tabindex=false`, the component won't have tabindex (it used to have -1)

# 1.0.0-beta.13
- [ENHANCEMENT] Acceptance helpers `selectChose` and `selectSearch` now work both passing the css
  selector of an ancestor of the trigger (as usual) or passing the selector of the trigger itself (new behaviour).
- [BREAKING] The `select.uniqueId` should is of the shape `ember1234` to it can safely be used for
  construct DOM ids (which can't start with number according to the spec).

# 1.0.0-beta.12
- [BUGFIX] Component corrently closes when clicked outside of the boundary of the application (in apps not attached to the body but to some internal element).

# 1.0.0-beta.11
- [BREAKING] The `select._id` property of the publicAPI has been promoted to public API and renamed as `select.uniqueId`.
- [ENHANCEMENT] Multiple selects without a search can have a placeholder now.

# 1.0.0-beta.10
- [BUGFIX] Avoid messing with the scroll when the select contains an input with autofocus in the content.
  Fixed in EBD by making the first reposition use a fastpath.

# 1.0.0-beta.9
- [BUGFIX] Fix problem when a select is disabled and then re-enabled (the bug was in EBD).

# 1.0.0-beta.8
- [BUGFIX] Depend on a version of EPS that doesn't rely on `ember-cli-shims` 0.1.3.

# 1.0.0-beta.7
- [BUGFIX] Having more than one component with `renderInPlace=true` attempted to register views with id null.
  Fixed in EBD 0.13.0-beta.2

# 1.0.0-beta.6
- [ENHANCEMENT/BREAKING] IMMUTABLE API! This is a big step towards 1.0.0 final. Now the public API
  received by all actions and subcomponents is immutable. That means that any change of any property
  creates a new publicAPI object. That means in practice that sub-components can rely on `didReceiveAttrs`
  to be notified when any state of the parent component changes.
  This also means that utilities like time-travel debugging are close to be possible.

# 1.0.0-beta.5
- [BUGFIX] Reset highlighted element when options change, regardless of of the search is sync or async

# 1.0.0-beta.4
- [BUGFIX] Don't assume that `action.open` will receive an event.

# 1.0.0-beta.3
- [BUGFIX] Pressing up/down arrown on selects without a search wasn't default prevented and the page scrolled.
- [ENHANCEMENT] Setting `theme` to false in the addon config entirely disables the styles.
- [ENHANCEMENT] Added optional `autofocus` property to `before-options` component of single selects
  to prevent autofocusing of the search box, when the dropdown is opened.

# 1.0.0-beta.2
- [ENHANCEMENT] Input placeholders have no opacity now, to be consistent with span-based placeholder.

# 1.0.0-beta.1
- [ENHANCEMENT] The color of the placeholder has been unified when it's an element and when it's a
  placeholder inside an input.
- [BREAKING] The trigger now has no padding on the left. It's the content inside the one that has
  margin on the left now. This may be breaking for people customizing the triggerComponent.

# 1.0.0-beta.0
- No changes since alpha.15

# 1.0.0-alpha.15
- [BUGFIX] Prevent accidental reset of attributes when options are replaced with the same options

# 1.0.0-alpha.13
- [ENHANCEMENT] Close select automatically if it gets disabled while it's open.

# 1.0.0-alpha.12
- [BUGFIX] The `registerAPI` must be called on multiple selects too.

# 1.0.0-alpha.11
- [BUGFIX] Update to EBD 0.12.0-beta.21 which allows to nest dropdowns up to 2 levels.

# 1.0.0-alpha.10
- [BUGFIX] Update to EBD 0.12.0-beta.20 which fixes enter animations.

# 1.0.0-alpha.9
- [BUGFIX] Fix `searchPlaceholder` config option broken in 1.0.0
- [BUGFIX] Allow to render the component in an alternative wormhole destination passing `destination=foo`.
  It broke in 1.0.0. Added test to prevent regression.

# 1.0.0-alpha.8
- [BUGFIX] ENTER/SPACE when no option is highlighted doesn’t selects undefined

# 1.0.0-alpha.7
- [BUGFIX] Ensure `select.selected` is always an array in multiple selects, not undefined/null.
- [BUGFIX] Fix search box width calculation

# 1.0.0-alpha.6
- [BUGFIX] Update EBD to beta.18 to fix positioning bug when rendered in place
- [BUGFIX/BREAKING] After some bikesheding, consensus was that despite of the spacebar being commonly
  used by selects to choose the highlighted option, pressing `SPACE` while the focused element is a
  searchbox is usually expected to add a space to the search term, not perform a selection, so that
  behaviour has been removed.
  If the spacebar is pressed on selects without a searchbox, then it works as native selects.
- [INTERNAL] Simplify keydown management.
- [BUGFIX] Calling preventDefault over the event of the `keydown` action does not prevent the component's
  behaviour. Returning false does.

# 1.0.0-alpha.5
- [BUGFIX] The component properly reacts to changes in the value of the `disabled` property.

# 1.0.0-alpha.4
- [INTERNAL] Stop relying in `this.elementId` and remove depreaction for using a CP for the `tagName` property.
- [BUGFIX] Fix styles of selects that are rendered in place so they are full width.

# 1.0.0-alpha.3
- [BUGFIX] `@onKeydown` in multiple selects is also called for keypresses in the A-Z range.
- [ENHANCEMENT] Add a `registerAPI` public action than can be used to store a reference to the public
  API of the component from the outside.

# 1.0.0-alpha.2
- [ENHANCEMENT] Make `disabled` part of the public API
- [BUGFIX] Fixed a lot of bugs, some related to changes in Ember 2.7, and others.

# 1.0.0-alpha.1
- [BUGFIX] Fix positioning of the status icon.
- [BUGFIX] Update to EBD to fix position classes being wiped on rerenders.

# 1.0.0-alpha.0

- [NO CHANGES] After some though I'm more or less ready to commit to stablility for both the component's
  options and the "publicAPI" object that is passes/yielded as second argument in many places. Maybe
  the API surface can adjust a little bit as @miguelcobain stresses it to be used inside ember-paper,
  but I expect changes, if any, to be additive. In any case, this is an alpha version.

# 0.11.0-beta.2
- [INTERNAL] Huge refactor to centralize (most) state inside the public API object. tl;dr; The
  component inside is totally new.
- [INTERNAL] Use fine-grained imports from ember-cli-shims. It expects ember-cli-shims >= 0.1.1.
- [BREAKING] The options received by internal subcomponents has changed (simplified) because most
  of the state has been centralized in the public API object (named `select` inside alls sub components).
- [BREAKING] The second argument yielded to the block is now the public API instead of the search term.
  This gives more flexibility to the user. To retaing old behaviour just change `|opt term|}} {{term}}` by
  `|opt select|}} {{select.lastSearchedText}}`
- [BREAKING] The `--focus-inside` class has been replaced by an `--active` class, which is more meaningful.

# 0.11.0-beta.1
- [INTERNAL] Update EBD to fix scroll problem cause by the dropdown being too slow to reposition
- [INTERNAL] Use a regular input for the search. Now that the component is 2.3.1+, no hacks are needed.

# 0.11.0-beta.0

- [BREAKING] Dropped support for old versions of Ember. Now only 2.3.1+
- [BREAKING] Huge internal refactor to migrate to the new Ember Basic Dropdown. The public API
  of the component is exactly the same in theory. However the component is now tagless, so there is
  no `.ember-power-select` wrapper around the trigger.
  Also some classes might have changed that can affect people customizing the styles. A more detailed
  entry will be added to the docs.

# 0.10.10
- [BUGFIX] Fix filtering/selection by typing when the trigger is focused and the options are groups.
- [CLEANUP] Remove deprecated behaviour: Return a boolean from custom matches is not longer allowed.
- [BUGFIX] Fix IE9/10 bug because `element.dataset` doesn't work :facepalm:

# 0.10.9
- [INTERNAL] Add `ember-cli-template-lint`.
- [BUGFIX] Make removeMultipleOption and clearSelected async friendly
- [INTERNAL] Add a class to the search input of single selects so the CSS hierarchy is flat.
- [ENHANCEMENT] Make `typeInSearch` helper less dependent on the actual markup of the component.

# 0.10.8
- Nothing relevant.

# 0.10.7
- [BUGFIX] Update `ember-text-measurer` to 0.3.0 and properly move it to runtime dependencies.
- [BUGFIX] Ensure `ember-power-select` runs before `ember-cli-sri`.

# 0.10.6
- [BUGFIX] Perform pixel-perfect text measurements using `ember-text-measurer` instead of using the
  naive `0.5em * numberOfChars` that yields to imperfect results.
- [BUGFIX] Calling `preventDefault` on the events that trigger an open or a close no longer prevent
  the component's default behaviour. Only `return false` can do that.

# 0.10.5
- [BUGFIX] Depend on EBS ^0.11.5 to fix issue with touch devices.
- [BUGFIX] Depend on EBS ^0.11.4 to fix some issues with IE9
- [ENHANCEMENT] If a group is disabled, its options (or the options of nested groups) are automatically
  considered disabled too.

# 0.10.4
- [ENHANCEMENT] Groups can contain disabled=true property that will add aria-disabled="true" to the group.
- [BUGFIX] Select doesn't scroll to make the selection visible on open. Regression introduced in 0.10.0.
- [BUGFIX] Highlight and scrolling has been decouple, so now highlighting a partially hidden option
  with the mouse not longer triggers a scroll on the list, which was wrong behaviour.
  However, using the arrow keys still scrolls the list is necessary.
- [BUGFIX] Ensure customMatchers receive always receive the entire option, even when used in conjunction
  with `searchField` option.
- [ENHANCEMENT] The option containing the loading message has a a distinctive `.ember-power-select-option--loading-message`
  class.

# 0.10.3
- [ENHANCEMENT] The `selectChoose` helper is less dependent on the class names of the input, and will
  *probably* work with any markup as long as the searchbox has `[type=search]`.
- [BUGFIX] Fixed bug selecting options with touch events.

# 0.10.2
- [BUGFIX] The highlighted element can be selected with the spacebar when the trigger is focused.
- [BUGFIX] The component can and closed with the spacebar while the trigger is focused.

# 0.10.1
- [ENHANCEMENT] Allow trigger the `@onFocus` action from within the trigger component.

# 0.10.0

- No changes since beta.13

# 0.10.0-beta.13
- [BUGFIX] Ensure that returning `false` from the `@onKeydown` action prevents the default behaviour
  even when that default behaviour is handled by ember-basic-dropdown.

# 0.10.0-beta.12

- I don't remember, but nothing important :D

# 0.10.0-beta.11
- [BREAKING] `e.preventDefault()` no longer affects the behaviour of the component, just prevents
  the native browser behaviour. Return `false` instead.
- [BUGFIX/BREAKING] `onopen`/`onclose` actions are called **before** the component is opens/closes,
  giving the user the change to prevent that from happening by returning false.
- [BUGFIX] `select.actions.select` doesn't call `stopPropagation` or `preventDefault` in the given
  event anymore. It's not it's responsability.
- [INTERNAL] Update Ember-basic-dropdown to 0.9.5-beta.14. PublicAPI should be the same, but
  internal have been simplified and responsibilities better divided across components. Nothing should
  break, but given the size of the changes ¯\_(ツ)_/¯
- [BUGFIX] The trigger of the single select applies overflow if the content is too long

# 0.10.0-beta.9
- [FEATURE] Selects can now be nested inside other dropdowns.
- [FEATURE] Allow to pass WAI-ARIA states (ariaDescribedBy, ariaInvalid, ariaLabel, ariaLabelledBy and required)

# 0.10.0-beta.8
- [BUGFIX] Avoid highlight disabled options when they are the first option after a search. Instead,
  highlight the first non-disabled option in the list. When all results are disabled, nothing gets
  highlighted.
- [ENHANCEMENT] Add a class to the component when an element inside has the focus. This allows to
  style the component not only when the component itself is focused but when an input inside
  is, which was previously impossible.
- [BUGFIX] Allow to pass `horizontalPosition` to customize to which edge of the trigger
  the dropdown is anchored to.

# 0.10.0-beta.7
- [FEATURE] The `selected` option can now also be a promise. When it's a promise, the component
  won't have any selection (the trigger will be empty, no option of the list will be
  highlighted) until that promise resolves. Once it resolves, the trigger and the highlighted
  option will update.
- [BUGFIX] Fixed bug after event-delegation refactor where mouseovering the list itself
  (which happens when options are disabled) throwed an error.
- [BUGFIX] Disabled select shouldn't be clearable even if `allowClear=true`.
- [BUGFIX] In multiple selects when test in the searchbox was too long the text overflowed the trigger.

# 0.10.0-beta.5
- [REMOVE FEATURE] The `opened` property (the only using double bindings instead of DDAU) has been
  removed. It was the cause of some errors due to race conditions in the bindings propagation.
  It is still possible to pass `initiallyOpened=true` to render a select already opened, but it is
  a one time property. It won't onpen/close the select when mutated nor will be mutated when the
  select is opened or closed.

# 0.10.0-beta.4
- [BUGFIX] Fix option highlighting when the use mouseovers in an element inside the `<li>`s

# 0.10.0-beta.3
- [BUGFIX] Fix option selection when the use click in an element inside the `<li>`s
- [BUGFIX] In multiple selects, deleting the last element of the list using BACKSPACE to trigger a
  search must open the dropdown if not already opened.

# 0.10.0-beta.2
- [FEATURE] Added `oninput` action that will be fired by changes in the search input. If the user
  returns `false` from this action the default behaviour (perform a search) is not run.
  This is particular useful for addons than need to preprocess the text being typed, by example to
  tokenize it and add entries instead of performing a search.
- [ENHANCEMENT] Improve accuracy `selectChoose`. Before `selectChoose('.my-select', 'User')` might,
  erroneously, select the option containing the text `User team` if it was before than `User` in the
  list. Now if there is more than one option containing the given text it but the content of
  one of the options is *identical*, then that one is chosen. If none is identical, the first one.

# 0.10.0-beta.1
- [BUGFIX] Fix bug with the new delegation methods when the list of options was not an Ember.A()

# 0.10.0-beta.0
- [BREAKING CHANGE] Use event delegations in the list of options. This might break tests not using
  the provided acceptance helpers in Ember < 2.5. Also, people customizing the `optionsComponent`
  will have to revisit the component, but is a component very few people customizes.
- [FEATURE] Added support for touch events in the options list. Faster response, no fastclick issues.
- [BUGFIX] Allow to remove elements on the power-select-multiple with touch events.

# 0.9.3-beta.2
- [BUGFIX] Fix bug when the outer array was mutated in place and then changing the selection performed
  an outdated selection. This was done by addin a new feature
- [FEATURE] The component accepts a `buildSelection` action that, given an option, constructs the
  new array of options from it. This allowed some internal cleanup.

# 0.9.3-beta.1
- [ENHANCEMENT] Update EBS to have better animation support

# 0.9.3-beta.0

- [FEATURE] Add support for CSS transitions and animations. When the dropdown is rendered, it gets
  a `.ember-basic-dropdown--transitioned-in` class after it's first rendered, so it's trivial to add
  transitions when opened. The closed, the dropdown gets a `ember-basic-dropdown--transitioning-out`
  class, and if there is any CSS animation or transition on that element, dropdown is not closed
  until that animation finishes. All this behaviour is actually part of ember-basic-dropdown.
- [BUGFIX] Ensure the `triggerClass` and `dropdownClass` can change in runtime
- [BUGFIX] The the public API received by the `search` action now has the searchText up to date
  with the value entered by the user.
- [BUGFIX] Acceptance tests helpers are now async inside. They used to be fully async before 0.9.2.
- [ENHANCEMENT] Pass the public API of the component as second argument to the search action, as it is
  the case with the rest of the public actions.

# 0.9.2
- [BUGFIX] Fix acceptance helpers (`selectChoose` & co) to fire native events even in Ember < 2.5.
  Fixes a bug with Ember Basic Dropdown 0.9.2.

# 0.9.1
- [BUGFIX] Disable placeholder of multiple select in Internet Explorer. There is a bug in IE that
  prevents the component from loosing the focus because the placeholder is updated. Very weird.
  This is less than ideal, but it's better to have a component without placeholder in IE than to
  have a component than once opened cannot be closed. I have to get to the bottom of this.

# 0.9.0 Final
- [BREAKING CHANGE] Passing `class="my-foo"` to the component just customizes the class of the top-most
  component, but doesn't try to derive classes from it for the trigger and the dropdown. This behavour
  was unexpected, confusing, didn't work with multiple classes `class="foo bar baz"` and doesn't enables
  any feature that `triggerClass=` and `dropdownClass=` don't allow already. Ditched.

# 0.9.0-beta.8
- [BUGFIX] Allow to type in closed multiple selects. Before the default behaviour of keydown events
  was being prevented, disallowing the typing.
- [BUGFIX] Ensure the public API passed to the components and to the ourside world is the same, by
  making it a CP and and use it as single source of truth.

# 0.9.0-beta.7
- [BUGFIX] Fix a bug filtering when the given options is a promise.
- [ENHANCEMENT] The custom matchers defined by the user now can and should return numbers instead of
  `true/false`. Returning a boolean still works, but support for this might be deprecated and later
  on removed. The reason is that returning a number gives us more posibilities, like sorting the
  results.
- [BUGFIX] Ensure the placeholder text of simple selects doesn't overflow the container trigger.

# 0.9.0-beta.6
- [FEATURE] Allow to customize the destination element used by ember-wormhole on a per-component basis

# 0.9.0-beta.5
- [FEATURE] Update to `ember-basic-dropdown` 0.9.0 final. This allows to customize the wormhole destination
  of all dropdowns of the app, including ember-power-select's dropdowns.

# 0.9.0-beta.4
- [BUGFIX] Ensure `triggerComponent` receives the `loading` property to allow showing spinners and things like that.

# 0.9.0-beta.3
- [BUGFIX] Ensure `beforeOptionsComponent` and `afterOptionsComponent` receive the `extra` object.

# 0.9.0-beta.2
- [FEATURE] Now you can type in closed single selects and automatically select the first match as you type.
  The typed text is erased after one second. It doesn't work in closed multiple select without searchbox (what would be the correct behavior?)
- [FEATURE] Now you can type in opened selects witout searcbox (multiple or single) to highlight the
  first marching option as you type. The typed text is erased after one second.
- [FEATURE] Search can be disabled in multiple selects, instead of only in single selects.
- [BUGFIX] Pressing enter in a select without searchbox correctly selects the highlighted element

# 0.9.0-beta.1
- [FEATURE] Proper Accesibility!! Lots of roles and `aria-*` tags have been added to make the component
  friendly, according with the guidelines in [the RFC](https://github.com/ember-power-addons/ember-power-select/issues/293)
- [BUGFIX] When the component received a promise as `options` and also a `search` action, clearing
  the search must show the content of that promise.
- [FEATURE] The `.ember-power-select-option`s added to wrap the `noMatchesMessage` and the `searchMessage`
  have special classes to help styling them (`ember-power-select-option--no-matches-message` & `ember-power-select-option--search-message`)
- [BUGFIX] Single selects without searchbox can be focused normally. Fixed updating ember-basic-dropdown.
  Ember basic dropdown was calling `preventDefault` on the mousedown event to prevent the user to
  select text when moving the mouse between the mouseup and the mousedown. Now the event is not defaultPrevented,
  it uses another technique.
- [BUGFIX] When the list of options is empty but the component is given a search action, it should
  not show the `No results found` until the user actually performs a search and there and it comes
  empty.
- [BREAKING] The `ember-power-select-options--nested` class is not used anymore. Now nested groups
  have `role=group`, and the top-most one has `role=listbox`.
- [BREAKING] The `*--open` class on the `.ember-power-select` div has been removed. Now styles
  target `[aria-expanded=true/false]`, and it applies to the trigger, not to the top-most div.
  People explicitly targeting this class in they styles will need to update.
- [BREAKING] **Warning**. Classes ending in `--disabled`, `--highlighted` and `--selected` have been
  replaced by aria attributes `[aria-disabled="true"]`, `[aria-current="true"]` and `[aria-selected="true"]`
  respectively. Those attributes are needed for a11y and the recommendation is to style based on them
  instead of classes.
  Styles have been updated accordingly, so people using them and customizing the appearance using the
  sass variables won't notice anything, but people that relied on those classes for overriding styles
  will have to update them.
- [TESTING] Run fasboot tests as part of CI
- [TESTING] Add fastboot tests harness.
- [FEATURE] Initial Fastboot support!!
- [INTERNAL] Removed deprecated properties
- [INTERNAL] Updated mirage, liquidfire, ember-try and others.
- [FEATURE] `$ember-power-select-line-height` variable can have units now.

# 0.9.0-beta.0
- [IMPROVEMENT] Multiple select's trigger uses flexbox to improve appearance and behavior. In browsers
  without flexbox works as it did before.
- [FEATURE] Multiple selects have a distintive class in the trigger so they be styled accordingly.
- [BUGFIX] Modify the searchText programatically (through the `select.actions.search('foo')` per example)
  updates the input, respecting the cursor position.

# 0.8.6
- [BUGFIX] If the trigger grows in height because the input becomes too long to fit in one line,
  the list of options is repositioned automatically.
- [PERF] A couple of perf improved like avoiding some extra calls to `action` to wrap what already
  are closure actions. The ember-basic-dropdown also uses `Ember.run.join` to avoid one extra runloop.
- [FEATURE] The select exposes an action to manually trigger a reposition. This is a very low level
  thing that probably nobody but me will use.
- [BUGFIX] The input of the multiple component should have a transparent background by default. It's
  probably the desired behaviour almost all situations.
- [BUGFIX] Ensure the input of the multiple select flows to the next line when number of selections
  make the select grow to a second line.

# 0.8.5
- [BUGFIX] Disabled components are not focusable.
- [BUGFIX] Ensure the second argument yielded to the block is the searchText corresponding to the
  results being displayed. This is formally more correct and also save an expensive re-render that
  can cause the component to jank in sufficiently bug/complex selects. This is potentially breaking,
  but very unlikely.

# 0.8.4
- [BUGFIX] Ensure that if the component is destroyed while an async search is in
  progress it doesn't fail.
- [BUGFIX] Ensure that when clearing the search input any pending search

# 0.8.3
- [BUGFIX] Ensure that pressing enter when there is no highlighted element (p.e after a search without results)
  closes the component without calling the onchange function.
- [BUGFIX] Update ember-basic-dropdown to 0.8.5+ fixes positioning issues in IE11 and fatal error in browsers without
  MutationObserver (effectively only ie10 )
- [BUGFIX] the "publicAPI" object passed as penultimate object to the public actions includes a `highlighted`
  property and the `action.select` function to enable more customization.
- [DOC] Document architectural decissions of the component.

# 0.8.2
- [BUGFIX] Update ember-basic-dropdown again to fix bad positioning issue.
- [INTERNAL] Stop using ArrayProxy internally. That saves some double render, improving performance
  when filtering greatly (+100%) and very slightly in initial openinig (+5%)
- [BUGFIX] The `search` and `highlight` functions in the public API weren't working because they
  missed a binding to the dropdown.

# 0.8.1
- [BUGFIX] Update ember-basic-dropdown.

# 0.8.0
- [INTERNAL] Update to ember-cli 2.3.0-beta.1
- [ENHANCEMENT] The mouseup over on element of the list doesn't selects that element if the mouse is
  still in the same coordinates (+/- 2px) of the mousedown that opened the component. This allows the
  options list to be rendered over the trigger and not wrongly select the element above the trigger

# 0.8.0-beta.12
- [BUGFIX] default `beforeOptions` component only clear the search on destroy when the search is enabled.

# 0.8.0-beta.11
- [BUGFIX] Not it's responsability of the component holding the searchbox to clear (or not) clear the
  search when the component is closed. The default components (single/multiple) do it. Maybe breaking??

# 0.8.0-beta.10
- [BUGFIX] Trigger should use clearfix so when the amount of options selected (multiple selects) overflows
  the available width is grows.

# 0.8.0-beta.9
- [BUGFIX] Do not use `let` in node code (unless you want node 0.12 to break)

# 0.8.0-beta.8
- [BUGFIX] Ensure that the `included` hook works when invoked from another addon (being a dependency)
  instead of directly by the consumer app, and also that the function is a noop the 2nd time it's invoked.

# 0.8.0-beta.7
- [BUGFIX] Not returning from the `search` action but instead setting `options` to a promise does not
  prevent subsequent searches.
- [BUGFIX] Pressing Backspace to delete the last selected option in multiple select when options are not
  plain strings now works as expected. It makes `searchField` mandatory, and asserts its presence.
- [INTERNAL] Refactor internals to don't force people providing custom components for slots to
  implement that much logic on it. Also logic for the `closeOnSelect` configuration lies in a single place.

# 0.8.0-beta.6
- [INTERNAL] Remove unnecesary action. Makes customization of triggerComponent easier.

# 0.8.0-beta.5
- [BUGFIX] Do not rely on significant whitepace + inlineBlock for styling selections in multiple select.
  Use float: left

# 0.8.0-beta.4
- [FEATURE] Added a new slot that can be customized with the `selectedItemComponent`. This allows to
  customize the markup of the selected option(s) without forcing the user to customize the entire
  trigger component. This doesn't enable any new pattern but makes customization easier.
- [BREAKING] `dropdownPosition` is now `verticalPosition`. It will continue to work until 0.9 but throwing
  a deprecation warning.

# 0.8.0-beta.3
- [BUGFIX] `{{power-select-multiple}}` has fallback values for the component names. Makes it composable.
- [BREAKING] Renamed `selectedComponent` to `triggerComponent`, which is more accurate, in preparation
  to add a `selectedItemComponent` soon. `selectedComponent` continues to work, but throws a deprecation.
- [FEATURE] Add new sass variables for customize the border & padding of each option in multiple mode,
  and the padding of the trigger in ltr/rtl modes.

# 0.8.0-beta.2
- [INTERNAL] Update ember-cli
- [BUGFIX] Update deps to ember-basic-dropdown 0.7.2. Fixed duplicated wormhole placeholder when
  ember-basic-dropdown is also a direct dependency of the project.

# 0.8.0-beta.1

- [BREAKING] Eliminame multiple mode and create `{{#power-select-multiple}}` as a separated component
  for dogfooding
- [BREAKING] The name of the selected property inside the custom components is now `selected` instead of `selection`
  for consistency with the external API.
- [BREAKING] More bahaviour has been transfered from the main components to the default implementation
  of the `selectedComponent`, `optionsComponent` and `beforeOptionsComponent`. This makes the component
  more flexible but less straigtforward to extend. The API for extending the component was never publish
  but still, expect things to break.


# 0.7.2
- [FEATURE] Allow to pass a component name under in `afterOptionsComponent` to customize the content after the options list.
- [FEATURE] Allow to pass a component name under in `beforeOptionsComponent` to customize the content before the options list.
  of the dropdown before the list of option. In single mode the default is the search input. In multiple mode the default is empty.
- [BREAKING] Remove the need of different templates between multiple and single mode, by having a
  new `beforeOptions` component that can be customized, and by moving the `loadingMessage` logic
  to the `optionsComponent`. This might be breaking, but quite unlikely.

# 0.7.1

- [INTERNAL] Make integration test helpers runloop aware to dry tests.
- [BUGFIX] The highliged element is reseted to default when the component is closed.
- [BUGFIX] Update ember-basic-dropdown to defaultPrevent the behavior if the mousedown that opens the
  component, so the user does not select text if moves the finger before releasing the mouse.

# 0.7.0
- [FEATURE] Finalize implementation of `selectChoose` and `selectSearch` that work in all supported
  versions of ember. Added docs for them.

# 0.7.0-beta.6
- [FEATURE] Add initial implementation of `selectChoose` acceptance helper to make
  interaction with the component nicer.
- [FEATURE] Add ARIA roles for basic accesibility. Still more work on this area.
- [FEATURE] Expose test helpers to the consumer app to make integration tests nicer.

# 0.7.0-beta.5
- [BUGFIX] Use `onmousedown` also in clear button (single and multiple modes) to ensure list is not opened.
- [BREAKING] EPS no longer exports the `defaultConfig` because it's not needed anymore.
  Passing an undefined values for default values does not overrides the default values (null/false do).
  This makes composability easy because creating a wrapper around the component can just forward
  all properties `{{#power-select searchEnabled=searchEnabled selectedComponent=selectedComponent}}`
  without worrying about if this values is defined or not.

# 0.7.0-beta.4
- [BUGFIX] On a select with a selected value, if the selected value is not among the results, the
  first results becomes the highlighted one. Before this fix none was highlighted.

# 0.7.0-beta.3
- [BREAKING] The event the triggers the selection of an item is mouseup, not click, meaning that the only
  thing that matters is where the finger is lifted. This is how real selects work in chrome/safari/firefox,
  and so should this. Given that the component opens on mousedown, this allows the user to open and select
  with only one movement.
  Real usage shouldn't break, not acceptance tests, but integration tests using `$().click()` will. Replace
  this `$().mouseup()`.
- [FEATURE] EPS now accepts a `triggerClass` which is applied to the trigger.

# 0.7.0-beta.2
- [FEATURE] All actions (onchange, onKeydown and onFocus) now receive a richer public API object
  that is identical in shape to the one they received before but also contains `highlight(option)`
  and `search(term)` actions
- [BREAKING] Delegate the rendering of the list's topmost element to `optionsComponent`. This
  allows a better customization of the list. If you use `optionsComponent` make sure you make it render
  the topmost element, e.g an `<ul>`.

# 0.7.0-beta.1
- [BREAKING] Update to ember-basic-dropdown 0.7.0-beta.1. This means that the component is opened/
  closed using mousedown instead of click. This makes the component feel more snappy. It is unlikeliy
  that this breaks real world usage but might break integration tests of people where people rely
  on `$('.ember-power-select-trigger').click()`.
- [FEATURE] New action: `@onFocus`. Unsurprisingly it is invoked when the component gains focus.
  It receives `(dropdown, event)` and can be used, by example, to open the component on focus.
- [FEATURE] EPS now accepts a `opened` boolean property used to open/close the component
  without triggering events on it. Useful to render the component already opened.

# 0.6.3
- [BUGFIX] Fix rendenring issue triggered somehow by Ember 2.2. Fixed in ember-basic-dropdown.
- [REFACTOR] The list of results and the highlighted element are not computed properties, so they are lazy.

# 0.6.2
- [BUGFIX] Use getOwner polyfill to avoid deprecations in ember 2.3

# 0.6.1
- [DOCS] Add API reference table to the docs
- [FEATURE] Yielded block receives the search term as a second argument

# 0.6.0
- [DOCS] Fix async search using github API example

# 0.6.0-beta.6
- [DOCS] Document how to disable specific option
- [DOCS] Add troubleshooting section with most common pitfalls.
- [FEATURE] The user can provide a `@onKeydown` action that will be invoked whenever the user
  presses a key being the component (of the searchbox inside) focused. This enables to create
  selects components that can create options on the fly (tags).
  This action received the dropdown as first argument and the event as second argument

# 0.6.0-beta.5
- [BUGFIX] Update ember-basic-dropdown to be sure dropdown reposition is runloop aware.

# 0.6.0-beta.4
- [BUGFIX] Component not detects aditions aditions/removals to the `options`, not just substututions
  of the entire collection.
- [BUGFIX] The overflow-y should be auto to not show the bar until it's required by the height of the
  option list.

# 0.6.0-beta.3
- [BUGFIX] Remove loading state if a promise fullfils after the dropdown has been closed

# 0.6.0-beta.2
- [BUGFIX] Update to ember-cli 1.13.13 to remove `[DEPRECATED] this.Funnel ...`  message.
- [BUGFIX] Fix styles when rendering the component in place
- [BUGFIX] Fix position calculation in firefox.
- [BUGFIX] Using `dropdownPosition=above|below` adds the proper class names to the component.
- [DOCS] Fixed typos and outdated links.

# 0.6.0-beta.1
- [BUGFIX] Add missing `this._super.included(app);` in the included hook so runtime dependencies are
  required.

# 0.6.0-beta.0
- [BREAKING CHANGE] The arguments received by the `selectComponent` and `optionsComponent` have changed
  significantly as a result of an internal refactor. It should not affect to people that have not created
  their own customized versions of ember-power-select.
- [BUGFIX] Ensure that open the dropdown after a search does not clear the results. Results are not
  cleared when the component is closed, like the `searchText`.
- [BUGFIX] Ensure `options` and `search` play nicely toguether. The given options are the initial set of
  results until the user performs the first search. From that point on they diverge.
- [BUGFIX] Not return from the `search` action is now legal. If you do so, you need to take care
  of updating the `options` yourself, and unless you make options a promise, you will loose the
  loading state.

# 0.5.2
- [BUGFIX] Don't render one option for the Loading message if this is falsey

# 0.5.1
- [BUGFIX] Fix automatic scroll when navigating using arrows.

# 0.5.0
- [BREAKING CHANGE] Some classes have changed to be more BEMy and avoid class collisions. You can expect
  things like `.nested`, `.selected`, `.highlighted`, etc.. to be not copies of the default class of that
  element but with `--nested`, `--selected`, etc... modifiers.
- [BREAKING CHANGE] The arrow of the dropdown is not longer a background image, but an `<span class="ember-power-select-status-icon">`,
  that you can style in more complex ways. By default is still a triangle (but done with css borders instead)
- [BUGFIX] Fixed `rtl`/`ltr` styles.

# 0.4.4
- [ENHANCEMENT] Allow to customize tabindex of the trigger
- [ENHANCEMENT] Pass `select` action and `highlighted` option to the selectedComponent to allow better
  customization

# 0.4.3
- [ENHANCEMENT] Pass `search` action to the selected component also for single component.
  This enables ember-power-select to to be the base for typeahead-like components.
- [BUGFIX] Fix placeholder of multiple select showing "null".

# 0.4.2
- [BUGFIX] Stop propagation of the events that trigger the `select` action. This was preventing
  to use this component within another component that closes when clicking on the body, like
  the ember-basic-dropdown

# 0.4.1
- [BUGFIX] Get subpixed precission on Y coordinates too by updating to ember-basic-dropdown 0.4.7

# 0.4.0
- [BREAKING] Remove {{ember-power-select}} deprecated alias for {{power-select}}
- [BREAKING] Remove `ember-power-select-wrapper` wrapped div that was not customizable and made styling harder.
             Now the topmost element is the `ember-power-select` itself.
- [BUGFIX] Update ember-basic-dropdown to fix rounding error that caused list of options have 1px mismatch in HD screens
- [TOOLING] Update to ember-cli 1.13.10

# 0.3.9
- [BUGFIX] Apply `dropdownClass` to the dropdown

# 0.3.8
- [BUGFIX] Disable the input of multiple selects when the entire component is disabled
- [BUGFIX] Don't show the cross to remove items when the entire component is disabled
- [ACCESIBILITY] Add aria-label to cross to remove items in multiple mode

# 0.3.7
- [BUGFIX] Open multiple select when the user types on the input of the trigger

# 0.3.6
- [REFACTOR] Variables in it's own file for encapsulations and allow more fine-grained customizations

# 0.3.5
- [BUGFIX] Update ember-basic-dropdown to fix deprecation warning coming from accessing `_actions`.
- [INTERNAL] For consistency, since the component's name was shortened to {{power-select}}, all internal
  components have been renamed too. No public API changes.

# 0.3.4
- [BUGFIX] Fix placeholder bug in multiple selects (show "null" as placeholder)
- [BUGFIX] Fix unused scss variable ($ember-power-select-text-color) and make it `inherit` by default instead of `#444`.
- [DOCS] Clarify that in "How to use" section selects are broken intentionally to explain why explicitness is good.

# 0.3.3
- [DEPRECATION] Renamed component from {{ember-power-select}} to just {{power-select}} and deprecate the long name.
- [BUGFIX] Increate z-index to 1000 (same that bootstrap uses for dropdowns)
- [BUGFIX] Add support for placeholder in multiple mode
- ... some internal refactors to make the selected item easier to customize

# 0.3.2
- [BUGFIX] Pressing enter on a closed multiple select should open it.
- [ENHANCEMENT] Pressing UP/DOWN arrows on a closed select (single or multiple) opens it

# 0.3.1
- [ENHANCEMENT] Added `closeOnSelect` option (defaults to true) to customize that behavior.
- [ENHANCEMENT] The `onchange` action is not invoked with the `dropdown` as second argument. That
  object contains methods like `open`, `close` and `toggle` that give control over the
  dropdown to the user.
- [BUGFIX] Select that specify a `search` action can also receive `options` now, and that collection
  is displayed until the user performs the first search.
- [BUGFIX] The `search` action now is also triggered when the search term is an empty string.

# 0.3.0
- [BREAKING CHANGE] The component is truly immutable now. The value inside the trigger (the selected value) won't update unless
  the user explicitly does so inside the `onchange` action. Since selection never were propagated upstream this shouldn't
  bite anyone: A select component without an action handles was pointless anyway. Now there is an assertion that will raise
  an error if no `onchange` action is provided (or it's not a function).
- [ENHANCEMENT] The component used to render the list is not replaceable. That allows almost complete customization.


# 0.2.6
- [BUGFIX] Workaround bug in ember <= 1.13.8
- [ENHANCEMENT] Added basic bootstrap styles.

# 0.2.1
- [REFACTOR] Divide component internally into ember-power-select/simple and ember-power-select/multiple
- [BUGFIX] Fix bug where dropdown didn't close when selecting an option inside a group.
- [BUGFIX] Fix ember-wormhole destination not being added to the body footer. Solved by calling contentFor of dependencies.
- [ENHANCEMENT] Update to ember-basic-dropdown 2.0. That yields a hash with public API on it.

# 0.2.0

- [BUGFIX] Fix compatibility with Ember 1.13 and add it to ember-try
- [ENHANCEMENT] Simplified code greatly by using ember-basic-dropdown underneath.
- [DOCS] Several typos
