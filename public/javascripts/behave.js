IngredientTypeCombo = Behavior.create({

  onchange: function() {
    in_combo_id = '#recipe_recipe_ingredients_attributes_' +idFromString(this.element.id)+ '_name';
    switch(this.element.value) {
      case 'Ingredient': $j(in_combo_id).autocomplete('option', 'source', '/ingredients/get/ajax'); break;
      case 'Recipe': $j(in_combo_id).autocomplete('option', 'source', '/recipes/get/ajax'); break;
    }
  }

});

AddIngredientRow = Behavior.create({

  onclick: function() {
    new_id = getNewID();
    template = assignNewID(recipe_ingredient, new_id);
    $('last_ingredient').insert({
      before: template
    });
    //reload behaviours due to new combo
    Event.addBehavior.reload();
    //
    new_element = $('recipe_'+new_id);
    new Effect.ScrollTo(new_element,
        {offset: -200, afterFinish: function() {
          new Effect.Highlight(new_element);
        }}
    );
    //
    return false;
  }

});

AddRecipeMethod = Behavior.create({

  onclick: function() {
    new_id = getNewID();
    template = assignNewID(recipe_step, new_id);
    $('last_step').insert({
      before: template
    });
    //reload behaviours due to new combo
    Event.addBehavior.reload();
    //set step number
    setStepRowValue($('recipe_steps_attributes_' +new_id+ '_step_no'), $$('.step_row').length);
    //
    new_element = $('step_'+new_id);
    new Effect.ScrollTo(new_element,
        {offset: -200, afterFinish: function() {
          new Effect.Highlight(new_element);
        }}
    );
    //
    return false;
  }

});


DeleteIngredientRow = Behavior.create({

  onclick: function() {
    //can delete rows only if .recipe_row count > 1
    if ($$('.recipe_row').length > 1) {
      fadeDelete(this.element, 'recipe_');
    }
    return false;
  }

});


DeleteStepRow = Behavior.create({

  onclick: function() {
    //can delete rows only if .recipe_row count > 1
    if ($$('.step_row').length > 1) {
      deleted_step = getStepRowStep(this.element).value;
      siblings = cleanStepSiblings($('step_'+ idFromElement(this.element)).nextSiblings()).without($('last_step'));
      fadeDelete(this.element, 'step_');
      redoStepsFrom(siblings, deleted_step);
    }
    return false;
  }

});


MoveStepRowUp = Behavior.create({

  onclick: function() {
    first = $('step_'+ idFromElement(this.element));
    second = cleanStepSiblings(first.previousSiblings());
    if (second.length > 1){  // > 1 as siblings would include header row
      second = second.first();
      swapSteps(first, second);
    }
    return false;
  }

});


MoveStepRowDown = Behavior.create({

  onclick: function() {
    first = $('step_'+ idFromElement(this.element));
    second = cleanStepSiblings(first.nextSiblings()).without($('last_step'))
    if (second.length > 0){
      second = second.first();
      swapSteps(second, first);
    }
    return false;
  }


});
