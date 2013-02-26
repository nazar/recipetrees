(function($) {

  $.fn.qtip.styles.recipe_style = { // Last part is the name of the style
     width: 305,
     border: {
        width: 3,
        radius: 3
     },
     tip: 'bottomLeft',
     name: 'light' // Inherit the rest of the attributes from the preset dark style
  };

  $.fn.qtip.styles.step_image = { // Last part is the name of the style
    width: 390,
    height: 270,
     tip: 'leftMiddle',
     name: 'recipe_style' // Inherit the rest of the attributes from the preset dark style
  };

  $.fn.qtip.styles.recipe_image = { // Last part is the name of the style
    width: 390,
    height: 270,
    tip: 'rightMiddle',
    name: 'recipe_style' // Inherit the rest of the attributes from the preset dark style
  };

  $.fn.qtip.styles.feed_recipe_image = { // Last part is the name of the style
    width: 390,
    height: 270,
    tip: 'leftMiddle',
    name: 'recipe_style' // Inherit the rest of the attributes from the preset dark style
  };

  $.fn.qtip.styles.tooltip = { // Last part is the name of the style
    width: 250,
    textAlign: 'left',
    tip: 'bottomMiddle',
    name: 'light' // Inherit the rest of the attributes from the preset dark style
  };

})(jQuery);