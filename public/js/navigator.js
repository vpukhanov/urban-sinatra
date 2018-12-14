/**
 * I know that the code is terrible, does not make sense whatsoever
 * AND uses jQuery. However, I wanted to make a custom single page
 * transition AND I wanted it as soon as possible. So please don't
 * judge this abomination.
 * 
 * P. S. Yes, it literally requests a full web page every single time
 * and yes it does replace parts of the page using jQuery. I know.
 */
(function () {
  var $mainSearch, $definitionBlock;

  window.onpopstate = function (e) {
    if (e.state) {
      if (e.state.term) {
        goToTerm(e.state.term, true);
      } else if (e.state.mainPage) {
        goToMainPage();
      }
    } else {
      window.location.reload();
    }
  };

  function goToMainPage() {
    $definitionBlock.fadeOut();
    $mainSearch.fadeOut();

    fetch('/')
      .then(function (response) {
        return response.text();
      })
      .then(function (html) {
        var
          parser = new DOMParser(),
          doc = parser.parseFromString(html, 'text/html'),
          mainForm = $(doc.querySelector('.main-search').outerHTML);

        mainForm.hide();

        if ($definitionBlock.get(0)) {
          $definitionBlock.replaceWith(mainForm);
        } else {
          $mainSearch.replaceWith(mainForm);
        }

        initPage();

        mainForm.fadeIn();
      })
  }

  function goToTerm(term, noPushState) {
    var encodedTerm = encodeURIComponent(term);

    $definitionBlock.fadeOut();
    $mainSearch.fadeOut();

    fetch('/' + encodedTerm)
      .then(function (response) {
        return response.text();
      })
      .then(function (html) {
        var
          parser = new DOMParser(),
          doc = parser.parseFromString(html, 'text/html'),
          definition = $(doc.querySelector('.definition-block').outerHTML);

        definition.hide();

        if (!noPushState) {
          window.history.pushState({ term: term }, term + ' | Urban Sinatra', '/' + encodedTerm);
        }

        if ($definitionBlock.get(0)) {
          $definitionBlock.replaceWith(definition);
        } else {
          $mainSearch.replaceWith(definition);
        }

        initPage();
        definition.fadeIn();
      });
  }

  function getCurrentTerm() {
    return $definitionBlock.find('#current-term').text().trim();
  }

  function setupForm(form) {
    form.on('submit', function (e) {
      e.preventDefault();

      var
        $termInput = form.find('#term-input'),
        term = $termInput.val().trim();

      if (term) {
        goToTerm(term);
      }
    });
  }

  function setupLinks(definition) {
    definition.on('click', 'a', function (e) {
      e.preventDefault();
      goToTerm($(this).text());
    });
  }

  function initPage() {
    $mainSearch = $('.main-search'),
      $definitionBlock = $('.definition-block');

    if ($mainSearch.get(0)) {
      setupForm($mainSearch);
      document.title = 'Urban Sinatra';
    }
    if ($definitionBlock.get(0)) {
      setupLinks($definitionBlock);
      document.title = getCurrentTerm() + ' | Urban Sinatra';
    }
  }

  $(function () {
    initPage();

    if ($mainSearch.get(0)) {
      window.history.replaceState({ mainPage: true }, document.title);
    } else {
      window.history.replaceState({ term: getCurrentTerm() }, document.title);
    }
  });
})();