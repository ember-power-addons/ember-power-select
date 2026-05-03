import CodeExample from 'docs/components/code-example';
import { LinkTo } from '@ember/routing';

<template>
  <h1 class="doc-page-title">Styles</h1>

  <p>
    This component
    <strong>does not</strong>
    provide any option to customize its visual appearance.
  </p>

  <p>
    You can apply styles to it just with CSS variables, plain CSS or even adding
    the classes your favorite CSS framework gives you.
  </p>

  <p>
    Ember Power Select exposes 53 variables, which you can override styles with
    css variables. Here the default variables:
  </p>

  <CodeExample
    @css="styles-0.css"
    @showResult={{false}}
    @activeTab="css"
    @codeBlockClass="max-500-height"
  />

  <p>
    However if you are using SASS or LESS you can use to customize the styles
    without overriding them.
  </p>

  <CodeExample @scss="styles-1.scss" @showResult={{false}} @activeTab="scss" />

  <p>
    Will make your selects to have pale blue borders with no rounded corners.
  </p>

  <p>
    You can find the entire list of available SCSS variables in
    <a
      href="https://github.com/ember-power-addons/ember-power-select/blob/master/ember-power-select/scss/variables.scss"
    >the source code</a>.
  </p>

  <p>
    This approach is powerful enough to build entire themes like
    <LinkTo @route="public-pages.cookbook.bootstrap-theme">Bootstrap theme</LinkTo>
    or
    <LinkTo @route="public-pages.cookbook.material-theme">Material theme</LinkTo>
    on top of Ember Power Select.
  </p>

  <div class="doc-page-nav">
    <LinkTo
      @route="public-pages.docs.the-search"
      class="doc-page-nav-link-prev"
    >&lt; The search</LinkTo>
    <LinkTo
      @route="public-pages.docs.custom-search-action"
      class="doc-page-nav-link-next"
    >Advanced customization &gt;</LinkTo>
  </div>
</template>
