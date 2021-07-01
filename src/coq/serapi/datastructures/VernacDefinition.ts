/* eslint-disable no-unused-vars */
import {convertToASTComp} from '../ASTProcessor';
import CoqType, {Visitable} from './CoqType';
import LocInfo from './LocInfo';
import ASTVisitor from './visitor/ASTVisitor';

enum DefinitionObjectKind {
  Definition= 'Definition',
  Coercion = 'Coercion',
  SubClass = 'SubClass',
  CanonicalStructure = 'CanonicalStructure',
  Example = 'Example',
  Fixpoint = 'Fixpoint',
  CoFixpoint = 'CoFixpoint',
  Scheme = 'Scheme',
  StructureComponent = 'StructureComponent',
  IdentityCoercion = 'IdentityCoercion',
  Instance = 'Instance',
  Method = 'Method',
  Let = 'Let',
}

/**
 * A JavaScript equivalent of a Coq VernacDefinition object.
 * @see https://coq.github.io/doc/v8.12/api/coq/Vernacexpr/index.html#type-vernac_expr.VernacDefinition
 */
class VernacDefinition extends CoqType implements Visitable {
  discharge: boolean;
  defintionObjectKind: DefinitionObjectKind;
  nameDecl: { name: { locinfo: LocInfo; content: any; }; options: any; };
  defitionExpr: any;

  /**
   * Constructor for the VernacDefinition type
   * @param {Array} array Array to parse
   */
  constructor( array ) {
    super(array);

    this.discharge = array[1][0] === 'DoDischarge';
    this.defintionObjectKind = array[1][1];

    this.nameDecl = {
      name: {
        locinfo: new LocInfo(['loc', array[2][0].loc]),
        content: convertToASTComp(array[2][0].v),
      },
      options: array[2][1],
    };

    this.defitionExpr = convertToASTComp(array[3]);
  }

  /**
   * Pretty print the current type.
   * @param {number} indent current indentation
   * @return {string} representation of the current type with indentation
   * added to the front
   */
  pprint(indent = 0): string {
    const tab = '\n'.concat('\t'.repeat(indent+1));
    let output = '';
    output = output.concat('Discharge: ', this.discharge.toString(), tab);
    output = output.concat('Def: ', this.defintionObjectKind.toString(), tab);
    output = output.concat('Name: ', tab);
    output = output.concat('\tLoc: ',
        this.nameDecl.name.locinfo.pprint(indent+2), tab);
    output = output.concat('\t', this.cprint(this.nameDecl.name.content,
        indent+2));
    return this.sprintf(super.pprint(indent), output);
  }

  /**
   * Allows an ASTVisitor to traverse the current type
   * (part of the visitor pattern)
   * @param {ASTVisitor} visitor the visitor requiring
   * access to content of the current type
   */
  accept(visitor: ASTVisitor) {
    visitor.visitVernacDefinition(this);
  }
}

/* istanbul ignore next */
export default VernacDefinition;
