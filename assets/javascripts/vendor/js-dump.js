define(function () {
/**
 * jsDump
 * Copyright (c) 2008 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Licensed under BSD (http://www.opensource.org/licenses/bsd-license.php)
 * Date: 5/15/2008
 * @projectDescription Advanced and extensible data dumping for Javascript.
 * @version 1.0.0
 * @author Ariel Flesler
 * @link {http://flesler.blogspot.com/2008/05/jsdump-pretty-dump-of-any-javascript.html}
 *
 * Edited by Michal Srb 23/10/2012
 */
var jsDump;

(function(){
  function quote( str ){
    return '"' + str.toString().replace(/"/g, '\\"') + '"';
  }
  function emptyQuote( str ){
    str = str.toString()
    if (str.length == 0)
      return '""'
    return str;
  }
  function literal( o ){
    return o + '';
  }
  //TODO: add the indentation size so this is perfect
  function size( arr, sep ) {  
    if( !arr || !arr[0] ) return 0;
    var sepLength = sep.length;
    var length = arr[0].length;
    for( var i = 1; i < arr.length; i++ ){
      length += sepLength + arr[i].length;
    }
    return length;
  }
  function join( pre, arr, post ){        
    var comma     = ',',
        inlineSep = jsDump.separator(false),
        base      = jsDump.indent();        


    // Inline if short   
    var inline = size(arr, comma + inlineSep) < jsDump.lineLimit
    var s = inline ? inlineSep : jsDump.separator(true);
    var inner = inline ? '' : jsDump.indent(1);
    if( arr.join )      
      arr = arr.join( comma + s + inner);
    if( !arr )
      return pre + post;
    return inline ? pre + arr + post : [ pre, inner + arr, base + post ].join(s);
  }
  function array( arr ){
    var i = arr.length, ret = Array(i);
    this.up();
    while( i-- )
      ret[i] = this.parse( arr[i] );
    this.down();
    return join( '[', ret, ']' );
  }
  
  var reName = /^function (\w+)/;
  
  jsDump = {
    parse:function( obj, type ){//type is used mostly internally, you can fix a (custom)type in advance
      var parser = this.parsers[ type || this.typeOf(obj) ];
      parserType = typeof parser;

      return parserType == 'function' ? parser.call( this, obj ) :
        parserType == 'string' ? parser :
        this.parsers.error;
    },
    typeOf:function( obj ){
      var type = typeof obj,
        kind;

      if ( type == 'object' || type == 'function' ) {
        if ( obj === null )
          return 'null';

        // Extract Stuff from [Object Stuff]
        kind = Object.prototype.toString.call(obj).slice(8, -1);
        switch ( kind ) {
          case 'Array':
            return 'array';

          case 'Date':
            return 'date';

          case 'RegExp':
            return 'regexp';

          case 'Window': //Firefox, IE, Opera
          case 'DOMWindow': //WebKit
          case 'global':
            return 'window';

          case 'HTMLDocument': //WebKit, Firefox, Opera
          case 'Document': // IE
            return 'document';

          case 'NodeList':
            return 'nodelist';

          default:
            if ( 'callee' in obj )
              // Opera: Object.prototype.toString.call(arguments) == 'Object' :(
              return 'arguments';
            else if (window.jQuery && obj instanceof window.jQuery)
              return 'jquery';
            else if ( 'ownerDocument' in obj && 'defaultView' in obj.ownerDocument && obj instanceof obj.ownerDocument.defaultView.Node )
              return 'node';
        }
      }
      return type;
    },
    lineLimit: 80,
    separator:function(multiline){      
      return this.multiline && multiline ? this.HTML ? '<br />' : '\n' : this.HTML ? '&nbsp;' : ' ';
    },
    indent:function( extra ){// extra can be a number, shortcut for increasing-calling-decreasing
      if( !this.multiline )
        return '';
      var chr = this.indentChar;
      if( this.HTML )
        chr = chr.replace(/\t/g,'   ').replace(/ /g,'&nbsp;');
      return Array( this._depth_ + (extra||0) ).join(chr);
    },
    up:function( a ){
      this._depth_ += a || 1;
    },
    down:function( a ){
      this._depth_ -= a || 1;
    },
    setParser:function( name, parser ){
      this.parsers[name] = parser;
    },
    // The next 3 are exposed so you can use them
    quote:quote, 
    literal:literal,
    join:join,
    _depth_: 1,
    // This is the list of parsers, to modify them, use jsDump.setParser
    parsers:{
      window: '[Window]',
      document: '[Document]',
      error:'[ERROR]', //when no parser is found, shouldn't happen
      unknown: '[Unknown]',
      'null':'null',
      undefined:'undefined',
      'function':function( fn ){
        // OVERRIDING FUNCTION definition
        return '[Function]';
        var ret = 'function',
          name = 'name' in fn ? fn.name : (reName.exec(fn)||[])[1];//functions never have name in IE
        if( name )
          ret += ' ' + name;
        ret += '(';
        ret = [ ret, this.parse( fn, 'functionArgs' ), '){'].join('');
        return join( ret, this.parse(fn,'functionCode'), '}' );
      },
      array: array,
      nodelist: array,
      arguments: array,
      jquery:array,
      object:function( map ){
        if (this._depth_ >= this.maxDepth) {
          this._depth_ = 1; // Reset for future use
          throw new Error("Object nesting exceeded jsDump.maxDepth (" + jsDump.maxDepth + ")");          
        }
        var ret = [ ];
        this.up();
        for( var key in map )
          ret.push( this.parse(key,'key') + ': ' + this.parse(map[key]) );
        this.down();
        return join( '{', ret, '}' );
      },
      node:function( node ){
        var open = this.HTML ? '&lt;' : '<',
          close = this.HTML ? '&gt;' : '>';
        var tag = node.nodeName.toLowerCase(),
          ret = open + tag;
        for( var a in this.DOMAttrs ){
          var val = node[this.DOMAttrs[a]];
          if( val )
            ret += ' ' + a + '=' + this.parse( val, 'attribute' );
        }
        return ret + close + open + '/' + tag + close;
      },
      functionArgs:function( fn ){//function calls it internally, it's the arguments part of the function
        var l = fn.length;
        if( !l ) return '';
        var args = Array(l);
        while( l-- )
          args[l] = String.fromCharCode(97+l);//97 is 'a'
        return ' ' + args.join(', ') + ' ';
      },
      key:literal, //object calls it internally, the key part of an item in a map
      functionCode:'[code]', //function calls it internally, it's the content of the function
      attribute:quote, //node calls it internally, it's an html attribute value
      string:emptyQuote,
      date:quote,
      regexp:literal, //regex
      number:literal,
      'boolean':literal
    },
    DOMAttrs:{//attributes to dump from nodes, name=>realName
      id:'id',
      name:'name',
      'class':'className'
    },
    HTML:false,//if true, entities are escaped ( <, >, \t, space and \n )
    indentChar:'   ',//indentation unit
    multiline:true, //if true, items in a collection, are separated by a \n, else just a space.
    maxDepth:100 //maximum depth of object nesting
  };

})();

return jsDump;
});