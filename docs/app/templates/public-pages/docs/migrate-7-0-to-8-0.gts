import CodeExample from 'docs/components/code-example';
import { LinkTo } from '@ember/routing';

<template>
  <h1 class="doc-page-title">Migrate from 7.0 to 8.0</h1>

  <p>The addon is now a
    <a href="https://rfcs.emberjs.com/id/0507-embroider-v2-package-format/">V2
      Embroider Addon</a>. The following changes are necessary:</p>

  <ul>
    <li>
      <p><code>ember-basic-dropdown</code>
        and
        <code>ember-concurrency</code>
        are now peerDependencies. You need to add into your devDependencies</p>
      <p>
        <div class="code-block">
          <pre>$ ember install ember-basic-dropdown ember-concurrency</pre>
        </div>
      </p>

      <p>As
        <code>ember-concurrency</code>
        is now also a V2 addon. There are some manual steps necessary see
        <a
          href="https://ember-concurrency.com/docs/installation"
          target="_blank"
          rel="noopener noreferrer"
        >ember-concurrency installation</a></p>
    </li>
    <li>
      <p>Add following line to your
        <code>application.gts/gjs</code>
        (necessary because
        <code>ember-basic-dropdown</code>
        is a V2 addon)</p>

      <CodeExample
        @glimmerTs="installation-0.gts"
        @showResult={{false}}
        @activeTab="glimmer-ts"
      />
    </li>
    <li>
      <p>OptionsComponent: Group options were detected over js since now with
        <code>role="group"</code>. To fix a11y we have replaced the role on
        options with
        <code>role="presentation"</code>. If you have passed
        <code>@optionsComponent</code>
        add in your component on the options
        <code>data-optgroup="true"</code>. See our
        <a
          href="https://github.com/ember-power-addons/ember-power-select/blob/8ffe2bc74373f7b1ec8e244bff218c39ba70c19e/ember-power-select/src/components/power-select/options.hbs#L23"
          target="_blank"
          rel="noopener noreferrer"
        >options.hbs</a>
      </p>
    </li>
    <li>
      <p>Test helpers: The
        <code>registerPowerSelectHelpers</code>
        is not required anymore. Please, remove this from
        <code>/tests/helpers/start-app.js</code>.</p>
    </li>
    <li>
      <p>Helper: The helper
        <code>ember-power-select-is-selected</code>
        was renamed to
        <code>ember-power-select-is-equal</code>. If you have used in your
        custom components, you need to replace it</p>
    </li>
    <li>
      <p>
        Vanilla JS: If you have used vanilla js you must now import the css in
        <code>app.js</code>
        manually like (for other css adding examples see under installation)
        <br />
        If you have used a theme you need to import like described in section
        <a
          href="https://ember-power-select.com/cookbook/bootstrap-theme"
        >bootstrap</a>
        /
        <a
          href="https://ember-power-select.com/cookbook/material-theme"
        >material</a>
      </p>
      <CodeExample
        @js="installation-1.js.txt"
        @showResult={{false}}
        @activeTab="js"
      />
    </li>
    <li>
      <p>LESS: If you are using with less you need to add
        <code>lessOptions</code>
        into your
        <code>ember-cli-build.js</code>
        file</p>

      <CodeExample
        @js="installation-2.js.txt"
        @showResult={{false}}
        @activeTab="js"
      />
    </li>
    <li>
      <p>Typo fix: If you have a custom
        <code>&lt;PlaceholderComponent /&gt;</code>
        you need to replace
        <code>@isMutlipleWithSearch</code>
        with
        <code>@isMultipleWithSearch</code></p>
    </li>
    <li>
      <p>Typescript: There were added / modified / fixed the typescript
        declarations. This could be braking for consumer app</p>
    </li>
  </ul>

  <div class="doc-page-nav">
    <LinkTo
      @route="public-pages.docs.migrate-8-0-to-9-0"
      class="doc-page-nav-link-prev"
    >&lt; Migrate from 8.0 to 9.0</LinkTo>
    <LinkTo
      @route="public-pages.docs.typescript"
      class="doc-page-nav-link-next"
    >TypeScript &gt;</LinkTo>
  </div>
</template>
