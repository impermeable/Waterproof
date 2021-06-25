/* eslint-disable require-jsdoc */
import ASTVisitor from './visitor/ASTVisitor';

/**
 * Abstract class representing a generic type returned by SerApi
 */
abstract class CoqType implements Visitable {
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  // abstract pprint() : string; // TODO add parameter indent.
  constructor(array) {
    if (!Array.isArray(array)) {
      throw new TypeError(
          `Wrong arguments provided to ${this.constructor.name}`);
    }
  }

  pprint(indent = 0): string {
    const tab = '\n'.concat('\t'.repeat(indent));
    let output = tab.concat(`(${this.constructor.name})`, tab);
    output = output.concat('\t(%s)', tab);
    return output;
  }

  sprintf(format, ...args): string {
    let i = 0;
    return format.replace(/%s/g, function() {
      return args[i++];
    });
  }

  cprint(content, indent): string {
    const tab = '\n'.concat('\t'.repeat(indent+1));
    let output = 'Content: ';
    if (!Array.isArray(content)) {
      output = output.concat(content.pprint(indent+1), tab);
    } else {
      output = output.concat(tab, '\t', content.toString(), tab);
    }
    return output;
  }

  // eslint-disable-next-line require-jsdoc
  accept(visitor: ASTVisitor): void {
    // throw new Error('Method not implemented.');
    visitor.visitCoqType(this);
  }
}

export interface Visitable {
  accept(visitor: ASTVisitor) : void;
}

export default CoqType;