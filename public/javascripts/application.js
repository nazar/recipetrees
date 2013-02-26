var $j = jQuery.noConflict();

$j.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript, text/html, application/xml, text/xml, */*");
  }
});

String.prototype.format = function() {
    var formatted = this;
    for(arg in arguments) {
        formatted = formatted.replace("{" + arg + "}", arguments[arg]);
    }
    return formatted;
};


function idFromString(id){
  return id.match(/(\d+)/g);
}

function idFromElement(element) {
  return idFromString(element.id);
}

function getNewID() {
  return new Date().getTime();
}

function getStepRowStep(row){
  return $('recipe_steps_attributes_' +idFromElement(row)+  '_step_no');
}

function setStepRowValue(row, value) {
  $('recipe_steps_attributes_' +idFromElement(row)+  '_step_no').value = value;
  $('recipe_steps_attributes_' +idFromElement(row)+  '_step_actual').value = value;
}

function cleanStepSiblings(elements) {
  ignore = $$('input[type=hidden]')
  return elements.reject(function(n) { return (ignore.indexOf(n) > -1) })
}

function fadeDelete(element, ident){
  row_id = idFromElement(element);
  row = ident + row_id;
  new Effect.Fade(row,
      {afterFinish: function() {
        $(row).remove();
      }}
  );
}

function assignNewID(template, new_id){
  result = template.replace(/NEW_RECORD/g, new_id * -1);
  return result.replace(/_-/g,'_');
}

function redoStepsFrom(siblings, from_step) {
  start = Number(from_step);
  siblings.each( function(row) {
    if (row.id != 'last_step') {
      setStepRowValue(row, start);
      start += 1;
    }
  });
}

function swapSteps(first, second) {
  first = first.remove();
  second.insert({before: first});
  //swap step values
  first_value = getStepRowStep(first).value;
  setStepRowValue(first, getStepRowStep(second).value);
  setStepRowValue(second, first_value);
  //shiny
  new Effect.Highlight(first);
}

function assignIngredientID(event, ui) {
  target = 'recipe_recipe_ingredients_attributes_' +idFromString(this.id)+ '_recipe_item_id';
  $(target).value = ui.item.id;
}

function FormMapTips() {

  $j('area').each(function() {

    $j(this).qtip({
      content: {
        test: 'Loading...',
        url: this.href,
        method: 'get'
      },
      position: {
        corner: {
          target: 'topRight',
          tooltip: 'bottomLeft'
        },
        adjust: {screen: true}
      },
      style: 'recipe_style'
    });

  });
}


function stepImagePopups() {
  $j('a.step_image_thumb').each(function() {
    $j(this).qtip({
      content: {
        text: 'Loading...',
        url: this.href,
        method: 'get'
      },
      position: {
        corner: {
          target: 'rightMiddle',
          tooltip: 'leftMiddle'
        },
        adjust: {screen: true}
      },
      style: 'step_image'
    });
    //disable click
    $j(this).click(function() {
      return false;
    })
  });

}


function recipeImagePopups() {
  $j('a.recipe_image_thumb').each(function() {
    $j(this).qtip({
      content: {
        text: 'Loading...',
        url: this.href,
        method: 'get'
      },
      position: {
        corner: {
          target: 'leftMiddle',
          tooltip: 'rightMiddle'
        }
      },
      show: {delay: 300},
      style: 'recipe_image'
    });
    //disable click
    $j(this).click(function() {
      return false;
    })
  })
}

function recipeImageFeedPopups() {
  $j('a.recipe_feed_image_thumb').each(function() {
    $j(this).qtip({
      content: {
        text: 'Loading...',
        url: this.href + '/image',
        method: 'get'
      },
      position: {
        corner: {
          target: 'rightMiddle',
          tooltip: 'leftMiddle'
        }
      },
      style: 'feed_recipe_image'
    });
  })
}

function ingredientImagePopups() {
  $j('a.ingredient_image_thumb').each(function() {
    $j(this).qtip({
      content: {
        text: 'Loading...',
        url: this.href,
        method: 'get'
      },
      position: {
        corner: {
          target: 'leftMiddle',
          tooltip: 'rightMiddle'
        }
      },
      style: 'recipe_image'
    });
    //disable click
    $j(this).click(function() {
      return false;
    })
  })
}

function hookRecipeIngredientsPopup() {
  $j('.ingredient_image_hook').each(function() {
    $j(this).css({opacity: 0.35});
    $j(this).qtip({
      content: {
        text: 'Loading...',
        url: $j(this).attr('data_path'),
        method: 'get'
      },
      position: {
        corner: {
          target: 'rightMiddle',
          tooltip: 'leftMiddle'
        }
      },
      style: 'feed_recipe_image'
    });
    $j(this).hover(
      function() {
        //$j(this).addClass('over')
        $j(this).fadeTo('fast', 1.0)
      },
      function() {
        $j(this).fadeTo('fast', 0.35)
      });
  });
}


function hookCategoryFilters() {
  $j('input.category_box').each(function() {
    $j(this).click(function() {
      //add as a filter to taggit box as c:name
      if ($j(this).is(':checked')) {
        $j('#ingredient_filter').tagit('addCategory', $j(this));
        showFilterBox();
      } else {
        $j('#ingredient_filter').tagit('removeCategory', $j(this));
      }
    });
  });
}

function hookIngredientFilters() {
  $j('input.ingredient_box').each(function() {
    $j(this).click(function() {
      //add as a filter to taggit box as c:name
      if ($j(this).is(':checked')) {
        $j('#ingredient_filter').tagit('addIngredient', $j(this));
        showFilterBox();
      } else {
        $j('#ingredient_filter').tagit('removeIngredient', $j(this));
      }
    });
  });
}

function hookCuisineFilters() {
  $j('input.cuisine_box').each(function() {
    $j(this).click(function() {
      //add as a filter to taggit box as c:name
      if ($j(this).is(':checked')) {
        $j('#ingredient_filter').tagit('addCuisine', $j(this));
        showFilterBox();
      } else {
        $j('#ingredient_filter').tagit('removeCuisine', $j(this));
      }
    });
  });
}

function hookTagFilters() {
  $j('input.tag_box').each(function() {
    $j(this).click(function() {
      //add as a filter to taggit box as c:name
      if ($j(this).is(':checked')) {
        $j('#ingredient_filter').tagit('addTag', $j(this));
        showFilterBox();
      } else {
        $j('#ingredient_filter').tagit('removeTag', $j(this));
      }
    });
  });
}

function hookTagLinkFilter() {
  $j('a.tag_link').each(function() {
    $j(this).click(function() {
      //add as a filter to taggit box as c:name
      $j('#ingredient_filter').tagit('addTagLink', $j(this));
      showFilterBox();
      //disable click
      return false;
    });
  });
}

function hookCategoryLinkFilter() {
  $j('a.category_link').each(function() {
    $j(this).click(function() {
      //add as a filter to taggit box as c:name
      $j('#ingredient_filter').tagit('addCategoryLink', $j(this));
      showFilterBox();
      //disable click
      return false;
    });
  });
}

function hookLoginLink() {

  (function($) {
    var $loading = $('<img src="/images/ui-anim_basic_16x16.gif" alt="loading" class="loading">');

    $('a.login').each(function() {
      var $dialog = $('<div></div>').append($loading.clone());
      var $link = $(this).one('click', function() {
        $dialog.load($link.attr('href') + ' #login')
                .dialog({
                          title: $link.attr('title'),
                          width: 500,
                          height: 400
                        });

        $link.click(function() {
          $dialog.dialog('open');

          return false;
        });

        return false;
      });
    });
  })(jQuery);

}

function hookIngredientAddNutrition() {

  (function($) {
    var $loading = $('<img src="/images/ui-anim_basic_16x16.gif" alt="loading" class="loading">');

    $('a.add_nutrition').each(function() {
      var $dialog = $('<div></div>').append($loading.clone());
      var $link = $(this).one('click', function() {
        $dialog.load($link.attr('href'))
                .dialog({
                          title: $link.attr('title'),
                          width: 800,
                          height: 600,
                          modal: true,
                          resizable: true,
                          buttons: {
                            'Save Nutrition': function() {
                              //console.log('form', $('form', $dialog).attr('action'));
                              $.post($('form', $dialog).attr('action'), $('form', $dialog).serialize());
                              $(this).dialog('close');
                            },
                            'Cancel': function() {
                              $(this).dialog('close');
                            }
                          }
                        });

        $link.click(function() {
          $dialog.dialog('open');

          return false;
        });

        return false;
      });
    });
  })(jQuery);

}

function hookAddByOthersDiag() {

  (function($) {
    var $loading = $('<img src="/images/ui-anim_basic_16x16.gif" alt="loading" class="loading">');

    $('a.add_by_other').each(function() {
      var $dialog = $('<div></div>').append($loading.clone());
      var $link = $(this).one('click', function() {
        $dialog.load($link.attr('href'), function()  {$('#recipe_by_others_comments').markItUp(mySettings); })
               .dialog({
                  title: $link.attr('title'),
                  width: 600,
                  height: 410,
                  modal: true,
                  buttons: {
                    'Save': function() {
                      $('form', $dialog).submit();
                    },
                    'Cancel': function() {
                      $(this).dialog('close');
                    }
                  }
               });

        $link.click(function() {
          $dialog.dialog('open');
          return false;
        });
        return false;
      });
    });
  })(jQuery);
}


function hookByOtherImages() {
  (function($) {

    $('a.by_other_image').each(function() {
      $(this).qtip({
        content: {
          text: 'Loading...',
          url: this.href,
          method: 'get'
        },
        position: {
          corner: {
            target: 'leftMiddle',
            tooltip: 'rightMiddle'
          }
        },
        style: 'recipe_image'
      });
      //disable click
      $(this).click(function() {
        return false;
      })
    })

  })(jQuery);
}

function hookFoodRadio(context) {

  (function($) {

    $('input.food', context).each(function() {
      $(this).click(function() {
        id = idFromString($(this).attr('id'));
        ingredient = $(this).attr('data_ingredient');
        var $loading = $('<img src="/images/ui-anim_basic_16x16.gif" alt="loading" class="loading">');

        var $servings = $('#servings_' + ingredient).html($loading.clone());
        $servings.load( '/nutritions/servings/', {food_id: id, ingredient: ingredient} );
      });
    });

  })(jQuery);


}

function hookServingRadio(context) {

  (function($) {

    $('input.serving', context).each(function() {

      $(this).click(function(){
        row = $(this).parent().parent();

        $('input.serving_amount', context).val( $('.serving_amount', row).text()  );
        $('input.fiber', context)         .val( $('.fiber', row).text()  );
        $('input.protein', context)       .val( $('.protein', row).text()  );
        $('input.sugar', context)         .val( $('.sugar', row).text()  );
        $('input.sodium', context)        .val( $('.sodium', row).text()  );
        $('input.potassium', context)     .val( $('.potassium', row).text()  );
        $('input.calories', context)      .val( $('.calories', row).text()  );
        $('input.carbohydrate', context)  .val( $('.carbohydrate', row).text()  );
        $('input.fat', context)           .val( $('.fat', row).text()  );
        $('input.saturated_fat', context) .val( $('.saturated_fat', row).text()  );
        $('input.cholesterol', context)   .val( $('.cholesterol', row).text()  );
        $('input.serving_url', context)   .val( $('.serving_url', row).text()  );
      });

    });

  })(jQuery);


}

function hookFormTip() {
  (function($) {
    $('.question').each(function() {
      id = '/tips/' + $(this).attr('data_page');
      link = "<a href='" +id+ "'><img src='/images/question.png' /></a>";
      orig = $(this).text();
      $(this).html(orig + link);
      $('a', this).each(function() {
        $(this).click(function() {return false});
        $(this).qtip({
          content: {
            text: 'Loading...',
            url: this.href,
            method: 'get'
          },
          position: {
            corner: {
              target: 'topMiddle',
              tooltip: 'bottomMiddle'
            },
            adjust: {screen: true}
          },
          show: {delay: 500},
          style: 'tooltip'
        });
      });

    });
  })(jQuery);

}

function hookInfoSpans(){

  (function($) {
    $('span.info, a.info').each(function() {
      link = '/tips/' + $(this).attr('data_page');
      //longer delay for links
      if ($(this).is('span')) {
        delay = 500;
      } else {
        delay = 1500;
      }
      $(this).qtip({
        content: {
          text: 'Loading...',
          url: link,
          method: 'get'
        },
        position: {
          corner: {
            target: 'topMiddle',
            tooltip: 'bottomMiddle'
          },
          adjust: {screen: true}
        },
        show: {delay: delay},
        style: 'tooltip'
      })
    });
  })(jQuery);


}

function hookIngredientSelects() {
  (function($) {
    $('select.group_select').each(function() {
      $(this).change(function() {
        id = $(this).attr('name').match(/(\d+)/g)[0];
        $.post('/ingredients/category_update', {id: id, group: $(this).val()})
      })
    });
  })(jQuery);
}

function hookSearchArea() {
  (function($) {

    var $filter = $('#filter');
    var $filter_button = $('a.search');
    //hide filter if both search boxes are empty
    no_tags = !($('#ingredient_filter').tagit('tags').length > 0);
    no_search = $('#recipe_title').val() == '';
    if (no_tags && no_search) {
      $filter.hide();
    }
    //hook search button
    $filter_button.click(function() {
      $("#filter").slideToggle();
      return false;
    });

  })(jQuery);

}

function showFilterBox() {
  if ($j('#filter').css('display') == 'none')
    $j("#filter").slideDown();
}





