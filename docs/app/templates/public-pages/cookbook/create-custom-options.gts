import CodeExample from 'docs/components/code-example';
import { LinkTo } from '@ember/routing';
import CreateCustomOptions1 from '../../../components/snippets/create-custom-options-1';

<template>
  <h1 class="doc-page-title">Create custom options</h1>

  <p>
    Ember Power Select exposes an
    <code>onKeydown</code>
    action that allows you to react to keyboard events before the default
    behaviour takes place. This gives you the ability to enrich the component
    with very few lines of code.
  </p>

  <p>
    Let's create one component on top of the multiple select that, besides of
    allowing you to select among the selected options, lets you create new
    options on the fly.
  </p>

  <p>You guessed right, the typical tag creator.</p>

  <p>
    Just define an action called
    <code>onKeydown</code>. That action will check if the pressed key is the
    <kbd>Enter</kbd>
    key, it was pressed while the component is opened and there is no option
    highlighted and the used typed some text.
  </p>

  <p>
    If those 4 conditions are met, create a new item, add it to the list of
    options and use the
    <code>choose</code>
    action of the select (received as first argument) to select a new set of
    results.
  </p>

  <CodeExample @glimmerTs="create-custom-options-1.gts">
    {{CreateCustomOptions1}}
  </CodeExample>

  <p>
    <i>Et voilà</i>, you've created a component that allows you to create custom
    tags.
  </p>

  <p>
    For the sake of completeness, this example takes a naive approach that
    doesn't cover all edge cases. By example, it isn't possible to create a tag
    named "York" above because it would match "New York". Check the
    <a
      href="https://github.com/ember-power-addons/ember-power-select-with-create"
    >ember-power-select-with-create</a>
    addon for a more complete solution.
  </p>

  <div class="doc-page-nav">
    <LinkTo
      @route="public-pages.cookbook.debounce-searches"
      class="doc-page-nav-link-prev"
    >&lt; Debounce searches</LinkTo>
    {{! <LinkTo @route="public-pages.cookbook.navigable-select" class="doc-page-nav-link-next">Navigable select &gt;</LinkTo> }}
  </div>
</template>
