[![NPM](https://badge.fury.io/js/ember-power-select.svg)](https://www.npmjs.com/package/ember-power-select)
[![Ember Observer Score](https://emberobserver.com/badges/ember-power-select.svg)](https://emberobserver.com/addons/ember-power-select)
![Ember Version](https://img.shields.io/badge/ember-%3E%3D4.12-brightgreen?logo=emberdotjs&logoColor=white)
[![Discord](https://img.shields.io/badge/chat-discord-blue?style=flat&logo=discord)](https://discord.com/channels/480462759797063690/486202731766349824)
[![Build Status](https://github.com/ember-power-addons/ember-power-select/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/ember-power-addons/ember-power-select)

# ember-power-select

Ember Power Select is a select component written in Ember with a focus in flexibility and extensibility.

It is designed to work well with the way we build Ember apps, so it plays nicely with promises, ember-concurrency's tasks,
ember-data collections and follows idiomatic patterns.

### Features

* 🖊 **TypeScript support** – ships with type definitions for smooth TypeScript integration.
* ✨ **Glint support** – template type-checking out of the box for safer templates.
* 🚀 **FastBoot compatible** – works in server-rendered Ember apps.
* 🕶 **Shadow DOM support** – can be rendered inside shadow roots without breaking positioning or events.
* 🛠 **Addon v2 ready** – modern Ember Addon v2 format.
* 🔧 **Flexible API** – fully customizable; you control the markup and styling.
* ♿ **Accessible by default** – full keyboard navigation, ARIA attributes, and focus management built-in.

#### Selection & Search

* 🧩 **Single & multiple selection** – built-in support for both modes.
* 🔎 **Built-in search field** – optional search input for filtering options.
* 📍 **Flexible search placement** – render the search field inside the trigger *or* inside the dropdown list.
* 📝 **Rich content rendering** – render HTML or custom components inside options and triggers.
* 🔍 **Smart filtering** – diacritic-insensitive search with accent sanitization.
* 🧠 **Custom matchers** – plug in your own matching and scoring logic.
* ⚡ **Asynchronous search** – remote and delayed searching with debounce support.
* ⏳ **Promise-aware** – works with promises and async data.
* 🔄 **ember-concurrency friendly** – works seamlessly with task cancellation.

#### UX & Customization

* 🧺 **Grouping & placeholders** – grouped options (no nesting limit) and customizable placeholders.
* ❌ **Clearable selections** – easily reset or clear selected values.
* 🚫 **Disabled states** – disable the whole component or individual options.
* 🎨 **Theming support** – easy CSS-based theming and design customization.
* 🎞 **CSS animations & transitions** – smooth opening/closing and state-change animations.
* 🧩 **Fully composable** – replace any internal part with your own components or completely custom UI.

## Compatibility

- Embroider or ember-auto-import v2
- Ember.js v4.12 or above

## Installation

```
pnpm install ember-power-select
```

For more installation details see [documentation](https://ember-power-select.com/docs/installation)

## Usage

Check the full documentation with live examples at [www.ember-power-select.com](http://www.ember-power-select.com) and
please open an issue if something doesn't work or is not clear enough.

## Extensions

Ember-power-select's focus on flexibility enables the community to build richer and more tailor made
components on top of it, focused in solving one particular problem, using composition.

## Browser support

This addon was tested in modern browsers and there is no technical reason it
wouldn't work. If you find a problem please file an issue.

## Testing

In testing it requires ember-cli-qunit. This component also provides some convenient [test helpers](http://www.ember-power-select.com/docs/test-helpers)
to interact with the component in acceptance tests.

## Contributing

Any contribution is welcome. Please read our [guidelines](CONTRIBUTING.md).
However, if your contribution involves adding a new feature, please open an issue before to
share your plan and agree the details of the feature before starting implementing it.

## Troubleshooting

If something doesn't work visit the [Troubleshooting](http://www.ember-power-select.com/docs/troubleshooting)
section of the docs first and if your problem persist open an issue, specify the version of the component,
Ember and browser.

