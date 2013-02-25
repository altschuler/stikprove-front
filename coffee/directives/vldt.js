// Generated by CoffeeScript 1.4.0
(function() {

  Site.directive('vldt', function() {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var DIGIT_REGEX, EMAIL_REGEX, handleErrors, messageForRule, messages, p, rawRule, rulePart, rules;
        EMAIL_REGEX = /^(([^<>()[\]\\.,;:\s@\”]+(\.[^<>()[\]\\.,;:\s@\”]+)*)|(\”.+\”))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        DIGIT_REGEX = /^\d+$/;
        rules = (function() {
          var _i, _j, _len, _len1, _ref, _ref1, _results;
          _ref = attrs.vldt.split(',');
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            rawRule = _ref[_i];
            p = {
              type: null,
              param: null,
              message: null
            };
            _ref1 = rawRule.split(/(?=[:|!])/);
            for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
              rulePart = _ref1[_j];
              $.trim(rulePart);
              switch (rulePart.charAt(0)) {
                case "!":
                  p.message = $.trim(rulePart.substring(1));
                  break;
                case ":":
                  p.param = $.trim(rulePart.substring(1));
                  break;
                default:
                  p.type = $.trim(rulePart);
              }
            }
            _results.push(p);
          }
          return _results;
        })();
        messages = {
          req: 'Feltet skal udfyldes',
          mail: 'Ikke en gyldig email',
          length: 'Mindst :param: karaktere',
          match: 'Er ikke ens',
          digit: 'Må kun indeholde tal'
        };
        messageForRule = function(rule) {
          var _ref;
          return ((_ref = rule.message) != null ? _ref : rule.message = messages[rule.type]).replace(':param:', rule.param);
        };
        handleErrors = function(rules) {
          if (rules.length === 0) {
            return element.removeClass('vldt-error');
          } else {
            return element.addClass('vldt-error');
          }
        };
        return $(element).on('change', function() {
          var failedRules, rule, val, _i, _len;
          failedRules = [];
          val = $(this).val();
          for (_i = 0, _len = rules.length; _i < _len; _i++) {
            rule = rules[_i];
            switch (rule.type) {
              case 'req':
                if (val.length === 0) {
                  failedRules.push(rule);
                }
                break;
              case 'mail':
                if (!EMAIL_REGEX.test(val)) {
                  failedRules.push(rule);
                }
                break;
              case 'length':
                if (val.length < parseInt(rule.param, 10)) {
                  failedRules.push(rule);
                }
                break;
              case 'match':
                if (val !== $(rule.param).val()) {
                  failedRules.push(rule);
                }
                break;
              case 'digit':
                if (!DIGIT_REGEX.test(val)) {
                  failedRules.push(rule);
                }
                break;
              default:
                throw new Error("Unknown rule type '" + rule.type + "'");
            }
          }
          return handleErrors(failedRules);
        });
      }
    };
  });

}).call(this);
