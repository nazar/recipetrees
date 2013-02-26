/*
 * INFORMATION
 * ---------------------------
 * Owner:     jquery.webspirited.com
 * Developer: Matthew Hailwood
 * ---------------------------
 *
 * CHANGELOG:
 * ---------------------------
 * 1.1
 * Fixed bug 01
 * 1.2
 * Added select option
 * * hidden select so tags may be submitted via normal form.
 * 1.3
 * Fixed bug 02
 * 1.4
 * Fixed bug 03
 * Fixed bug 04
 *
 * ---------------------------
 * Bug Fix Credits:
 * --
 * * Number: 01
 * * Bug:  Clicking autocomplete option does not add it to the array
 * * Name: Ed <tastypopsicle.com>
 * --
 * * Number: 02
 * * Bug: Unable to give select a name
 * * Name: Ed <tastypopsicle.com>
 * --
 * * Number 03
 * * Bug: reference to incorrect variable (tagArray vs tagsArray)
 * * Name: claudio <unknown>
 * --
 * * Number 04
 * * Bug: console.log() left in code
 * * Name: claudio <unknown>
 */

(function($) {
    $.widget("ui.tagit", {

        // default options
        options: {
            tagSource:   [],
            triggerKeys: ['enter', 'space', 'comma', 'tab'],
            initialTags: [],
            minLength:   1,
            select:      false

        },

        _keys: {
            backspace: 8,
            enter:     13,
            space:     32,
            comma:     44,
            tab:       9
        },

        //initialization function
        _create: function() {

            var self = this;
            this.tagsArray = [];

            //store reference to the ul
            this.element = this.element;

            //add class "tagit" for theming
            this.element.addClass("tagit");

            //add any initial tags added through html to the array
            this.element.children('li').each(function() {
                self.options.initialTags.push($(this).text());
            });

            //add the html input
            this.element.html('<li class="tagit-new"><input class="tagit-input" type="text" /></li>');

            this.input = this.element.find(".tagit-input");

            //setup click handler
            $(this.element).click(function(e) {
                if ($(e.target).hasClass('tagit-close')) {
                    // Removes a tag when the little 'x' is clicked.
                    $(e.target).parent().remove();
                    var text = $(e.target).parent().attr('data-item-id');
                    self._popTag(text);
                }
                else {
                    self.input.focus();
                }
            });

            //setup autcomplete handler
            var os = this.options.select;
            this.options.appendTo = this.element;
            this.options.source = this.options.tagSource;
            this.options.select = function(event, ui) {
//              self._removeTag();
              self._addTag('i:'+ui.item.id+':'+ui.item.value);
              return false;
            };
            //
            this.input.autocomplete(this.options);
            this.options.select = os;

            //setup keydown handler
            this.input.keydown(function(e) {
                var lastLi = self.element.children(".tagit-choice:last");
                if (e.which == self._keys.backspace)
                    return self._backspace(lastLi);

                if (self._isInitKey(e.which)) {
                    e.preventDefault();
                    if ($(this).val().length >= self.options.minLength)
                        self._addTag($(this).val());
                }

                if (lastLi.hasClass('selected'))
                    lastLi.removeClass('selected');

                self.lastKey = e.which;
            });

            //setup blur handler
            this.input.blur(function(e) {
                self._addTag($(this).val());
                $(this).val('');
                return false;
            });

            //define missing trim function for strings
            String.prototype.trim = function() {
                return this.replace(/^\s+|\s+$/g, "");
            };

            if (this.options.select) {
                this.element.after('<select class="tagit-hiddenSelect" name="'+this.element.attr('name')+'" multiple="multiple"></select>');
                this.select = this.element.siblings('.tagit-hiddenSelect');
            }
            this._initialTags();

        },

        _popSelect: function(text) {
            this.select.children('option[value="' + text + '"]').remove();
        }
        ,

        _addSelect: function(value) {
            this.select.append('<option selected="selected" value="' + value + '">' + value + '</option>');
        }
        ,

        _popTag: function(text) {
            $.inArray(text, this.tagsArray);
            if (text == undefined) {
                text = this.tagsArray.pop();
            }
            else {
                var index = ($.inArray(text, this.tagsArray) == -1 ? this.tagsArray.length - 1 : $.inArray(text, this.tagsArray));
                this.tagsArray.splice(index, 1);
            }
            if (this.options.select)
                this._popSelect(text);
        }
        ,

        _addTag: function(value) {
            this.input.val("");
            value = value.replace(/,+$/, "");
            value = value.trim();
            if (value == "" || this._exists(value))
                return false;

            var tag = "";
            var extra_class = this._typeToClass(value);
            var text_from_tag = this._textFromTag(value);

            tag = '<li class="tagit-choice '+extra_class+'" data-item-id="'+value+'">' + text_from_tag + '<a class="tagit-close">x</a></li>';
            $(tag).insertBefore(this.input.parent());
            this.input.val("");
            this.tagsArray.push(value);
            if (this.options.select)
                this._addSelect(value);
            if (!this._validEntry(value))
              this._removeTag();
            return true;
        }
        ,

        _exists: function(value) {
            if (this.tagsArray.length == 0 || $.inArray(value, this.tagsArray) == -1)
                return false;
            return true;
        }
        ,

        _isInitKey : function(keyCode) {
            var keyName = "";
            for (var key in this._keys)
                if (this._keys[key] == keyCode)
                    keyName = key

            if ($.inArray(keyName, this.options.triggerKeys) != -1)
                return true;
            return false;
        }
        ,

        _removeTag: function() {
            this._popTag();
            this.element.children(".tagit-choice:last").remove();
        }
        ,

        _backspace: function(li) {
            if (this.input.val() == "") {
                // When backspace is pressed, the last tag is deleted.
                if (this.lastKey == this._keys.backspace) {
                    this._popTag();
                    li.remove();
                    this.lastKey = null;
                } else {
                    li.addClass('selected');
                    this.lastKey = this._keys.backspace;
                }
            }
            return true;
        }
        ,

        _initialTags: function() {
            if (this.options.initialTags.length != 0) {
                for (i=0; i <this.options.initialTags.length; i++)
                    if (!this._exists(this.options.initialTags[i]))
                        this._addTag(this.options.initialTags[i]);
            }
        }
        ,

        _textFromTag: function(text) {
           if ( m = text.match(/\w:\d+:(.+)/ ) ) {
             return m[1];
           } else {
             return '';
           }
        },

        _typeToClass: function(text) {
          if ( m = text.match(/(\w):\d+:/ ) ) {
            type_code = m[1];
            switch(type_code) {
              case 'i': type_class = 'ingredient'; break;
              case 'c': type_class = 'category'; break;
              case 'q': type_class = 'cuisine'; break;
              case 't': type_class = 'tag'; break;
            }
            return type_class;
          } else {
            return '';
          }

        },

        _validEntry: function(text) {
          return m = text.match(/\w:\d+:(.+)/);
        },

        _removeRecipeElement: function(tag) {
          tag = tag.trim();
          this.element.find('li:[data-item-id='+tag+']').remove();
          this._popTag(tag);
        },

        tags: function() {
            return this.tagsArray;
        }
        ,

        destroy: function() {
            $.Widget.prototype.destroy.apply(this, arguments); // default destroy
            this.tagsArray = [];
        },

        addCategory: function(element) {
          this._addTag('c:'+element.val()+':'+element.attr('name'));
        },

        removeCategory: function(element) {
          tag = 'c:' + element.val() +':'+ element.attr('name');
          this._removeRecipeElement(tag);
        },


        addCuisine: function(element) {
          this._addTag('q:'+element.val()+':'+element.attr('name'));
        },

        removeCuisine: function(element) {
          tag = 'q:' + element.val() +':'+ element.attr('name');
          this._removeRecipeElement(tag);
        },

        addTag: function(element) {
          this._addTag('t:'+element.val()+':'+element.attr('name'));
        },

        removeTag: function(element) {
          tag = 't:' + element.val() +':'+ element.attr('name');
          this._removeRecipeElement(tag);
        },

        addTagLink: function(link) {
          tag = 't:' + link.attr('data_tag');
          this._addTag(tag);
        },

        addCategoryLink: function(link) {
          tag = 'c:' + link.attr('data_category');
          this._addTag(tag);
        },

        addIngredient: function(element) {
          tag = 'i:' + element.val() +':'+ element.attr('name');
          this._addTag(tag);
        },

        removeIngredient: function(element) {
          tag = 'i:' + element.val() +':'+ element.attr('name');
          this._removeRecipeElement(tag);
        }

    });
})(jQuery);