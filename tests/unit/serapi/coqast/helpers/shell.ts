const repl = require('repl');

const ds = require('../../../../../src/coq/serapi/datastructures/index.ts');
import {toAST, toASTWithTime} from './CoqASTHelpers';
import {sexp1, veryLongSexpr} from './SExprList';

function addToContext(repl, k, v, options) {
  Object.defineProperty(repl.context, k, {
    configurable: options.configurable ?? false,
    enumerable: options.enumerable ?? true,
    value: v,
  });
}

const msg = 'message';
console.log('Node REPL');

const r = repl.start({prompt: '\u001b[35mλ\u001b[0m ', useColors: true});

addToContext(r, 'm', msg, {});
addToContext(r, 'toAST', toAST, {});
addToContext(r, 'toASTWithTime', toASTWithTime, {});
addToContext(r, 'goodSExp', sexp1, {});
addToContext(r, 'badSExp', '(CoqAST ((Bad data() () () ))', {});
addToContext(r, 'longSexp', veryLongSexpr, {});

Object.keys(ds.default).forEach((prop) => {
  addToContext(r, prop, ds.default[prop], {});
});
