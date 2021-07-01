import {convertToASTComp} from '../ASTProcessor';
import CoqType from './CoqType';
import LocInfo from './LocInfo';
import ASTVisitor from './visitor/ASTVisitor';

/**
 * A JavaScript equivalent of a Coq DefineBody object.
 */
class DefineBody extends CoqType {
  localExprList: any;
  rawRedExprOption: any;
  expr: { locinfo: LocInfo; content: any; };
  exprOption: any;

  /**
   * Constructor for DefineBody type.
   * @param {array} array Array to parse
   */
  constructor( array ) {
    super(array);
    this.localExprList = array[1];
    this.rawRedExprOption = array[2];
    this.expr = {
      locinfo: new LocInfo(['loc', array[3].loc]),
      content: convertToASTComp(array[3].v),
    };
    this.exprOption = array[4];
  }

  /**
   * Pretty print the current type.
   * @param {number} indent current indentation
   * @return {string} representation of the current type with indentation
   * added to the front
   */
  pprint(indent = 0): string {
    const tab = '\n'.concat('\t'.repeat(indent + 1));
    let output = '';
    output = output.concat('Local expr: ', this.localExprList.toString(), tab);
    output = output.concat('Red exp: ', this.rawRedExprOption.toString(), tab);
    output = output.concat('Loc: ', this.expr.locinfo.pprint(indent + 1), tab);
    output = output.concat(this.cprint(this.expr.content, indent));
    output = output.concat('Expr option: ', this.exprOption.toString(), tab);
    return this.sprintf(super.pprint(indent), output);
  }

  /**
   * Allows an ASTVisitor to traverse the current type
   * (part of the visitor pattern)
   * @param {ASTVisitor} v the visitor requiring
   * access to content of the current type
   */
  accept(v: ASTVisitor) : void {
    v.visitDefineBody(this);
  }
}

/* istanbul ignore next */
export default DefineBody;
