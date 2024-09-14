// requires "Fira Math" font
// jump: TODO, DEBUG, CHECK, TAG

#let mytitle = "Understanding Typst"
#set document(title: mytitle)
#set text(lang: "en", hyphenate: false)
#set par(justify: true)
#set heading(numbering: "1.")
#set table(stroke: silver) // TAG:table_silver

#set page(
    paper: "a4",
    numbering: "1",
)

#stack(
    align(center,
        text(size: 22pt, weight: "bold")[#mytitle]
    ),
    4em,
    [
        _Typst-Versions: 0.11.1_

        _This does not aim to cover the entire documentation of typst,
        but to explain core concepts, the builtin shorthand syntax and
        tables._
    ],
    1fr,
    outline(
        title: none,
        //target: selector(heading).before(<appendix>, inclusive: true),
    ),
    1fr,
)

= Overview

A typst document is a plain text file with the extension `.typ`. The
instructions in a typst document are executed by the typst compiler in
order, meaning they do not effect the previous text.

Code between dollar-signs is interpreted in *`$formula$`* mode, which
allows to typeset formulas beautifully. If there is no whitespace
between the dollar-signs and the formula, like
```typ $a^2 + b^2 = c^2$```, an inline element, like $a^2 + b^2 = c^2$,
is created, otherwise the formula is its own paragraph:
```typ
$ x_(1,2) = (-b plus.minus sqrt(b^2 - 4 a c))/(2 a) $
```
$ x_(1,2) = (-b plus.minus sqrt(b^2 - 4 a c))/(2 a) $

A hash-sign enables *`#code`* mode until the end of the expression,
which is usually the end of the word or the corresponding closing
parenthesis. For single-line keyword expressions, it is the end of the
line or a semicolon. This mode is for interacting with the typst
scripting language, which is used to define the look of the resulting
document.
```typ
#let foo = "foo"
Redefining #foo inline #let foo() = 4; and using it: #text(fill: red,
    lorem(foo())
) Cool!
```
#let foo = "foo"
Redefining #foo inline #let foo() = 4; and using it: #text(fill: red,
    lorem(foo())
) Cool!

The default mode is *`[markup]`* mode, which is used to write the
document's content and can also be used in `#code` mode by surrounding
the relevant text with brackets. It enables markdown-like syntax as
shorthand for common functions.
```typ
- Syntax examples: #text(fill: red, [*bold* _italic_ *_bold+italic_*])
```
- Syntax examples: #text(fill: red, [*bold* _italic_ *_bold+italic_*])

Last, but not least, there are *comments*, which are not officially a
"mode" because they do not do anything: they are simply ignored by
the compiler, is if they did not exist.
```typ
- in all modes this /* anything between */ is ignored
- and in `[markup]` and `#code` mode the following ignores the rest of
  the line // rest of line
```
- in all modes this /* anything between */ is ignored
- and in `[markup]` and `#code` mode the following ignores the rest of
  the line // rest of line

To *escape* the special meaning of of a symbol, prefix it with `\`. For
example, `\\` inserts a regular backslash (\\). Sometimes, mostly in
strings in `#code` mode, backslash instead activates some special
meaning; an example (which not only works in strings but also works in
[markup] mode) is `\u{hex}`, which inserts the given unicode codepoint:
\u{03bc}. Backslash escapes do not work in `raw` text (backtick
surrounded)!

#pagebreak(weak: true)
= `[Markup]` mode

All `[markup]` blocks return `content`, which is a type of object and
different from the type `string`. In many cases functions which take
content arguments, also accept strings; sometimes strings are required
and content objects are not allowed.

The following syntax available in `[markup]` mode, is only shorthand for
calling the respective functions:

#table(columns: 3,

    table.header([*syntax*], [*function equivalent*], [*note*]),
    table.hline(stroke: black),

    `\`,
    ```typ #linebreak()```,
    [ new line (same paragraph); if followed by symbol: escapes it's
    special meaning ],

    [ empty line ],
    ```typ #parbreak()```,
    [ new paragraph ],

    `== Text`,
    ```typ #heading(depth: 2, [Text])```,
    [ heading of _depth_ 2 ],

    `*\*bold*text\**`,
    ```typ #strong("*bold*text*")```,
    [ *\*bold*text\** ],

    `_\_italic_text\__`,
    ```typ #emph("_italic_text_")```,
    [ _\_italic_text\__ ],

    [
        ``` `` ``` \
        ``` `string` ``` \
        ```` ``` string``` ```` \
        ```` ```lang string``` ````

        ````
        ```lang
            string
            ```
        ````

        ```
        `foo
            indent: 4
            `
        ```

        ````
        ```lang  indent: 1
            indent: 0
                indent: 4
            ```
        ````
    ],
    par(justify:false,)[
        ```typ #raw("")``` \
        ```typ #raw("string")``` \
        ```typ #raw("string")``` \
        ```typ #raw("string", lang: "lang")```

        ```typ #raw("string", lang: "lang",
        block: true)
        ```

        #v(1em)

        ```typ #raw(
        "foo\n    indent: 4\n    ",
        block: false, lang: none)
        ```

        ```typ
        #raw(" indent: 1
        indent: 0
            indent: 4",
        block: true, lang: "lang")
        ```
    ], [
    `raw/literal` text, must start and end with same number (must not be
    2 which is for empty content) of backticks. If 3+ are used, a single
    leading space is trimmed or the _word_ following _without
    whitespace_ specifies the `lang` argument; unlike markdown _all
    following_ characters of the opening line go into the output!
    Moreover, the common indent of the lines following the opening line,
    including the line with the end-marker is stripped! Single backtick
    blocks don't trim anything and don't have a `lang` argument.
    Backslash-escapes don't work in any `raw` block. ],

    `- text`,
    ```typ
        #let e=([text],)
        #list(..e)
        ```,
    [ - bullet-list element, also passable as: `list.item([text])` ],

    `+ text`,
    ```typ
        #let e=([text],)
        #enum(..e)
        ```,
    [ + numbered-list element, also passable as: `enum.item([text])` ],

    `/ text1: text2`,
    ```typ
        #let e=([text1], [text2])
        #terms(..e)
        ```, [
    / Term-list element: also passable as:
         `terms.item([text1], [text2])`
    ],

    [
        `http://example.com` \
        `https://example.com`
    ], [
        ```typ #link("http://example.com")``` \
        ```typ #link("https://example.com")```
    ], [
    link to https://example.com The function also allows
    other link-types and changing the text. ],

    `<string>`,
    ```typ #label("string")```,
    [ tags the previous element (in the same scope) to be able to
    reference it; only one label per element allowed ],

    `@string`,
    ```typ #ref("string")```,
    [ reference to `<string>` which may be defined later ],

    `"text" "`,
    ```typ #smartquote(double: true)```,
    [ language-, start-, end-aware "quotes": " ],

    `'text' '`,
    ```typ #smartquote(double: false)```,
    [ language-, start-, end-aware 'quotes': ' ],

    `a~z`,
    ```typ a#(sym.space.nobreak)z```,
    [ unbreakable space ],

    `a-?z`,
    ```typ a#(sym.hyphen.soft)z```,
    [ #set text(hyphenate: true)
    // CHECK: first az should be on two lines to show the hyphen
    this hyphen only appears if needed: #h(5pt) a-?z a-?z ],

    `-3`,
    ```typ #(sym.minus)3```,
    [ the dash in -3, but not a- b-c or -d nor - ],

    `--`,
    ```typ #sym.dash.en```,
    [ This is a -- so called -- _en_-dash. ],

    `---`,
    ```typ #sym.dash.em```,
    [ This is a dash --- an _em_-dash. ],

    `...`,
    ```typ #sym.dots.h```,
    [ An ellipsis... ],

)

Some constructs, like lists, consider the indentation of a line to
determine to which element it belongs. As long as a line is indented
more than the item's marker and at maximum as deep as the marker of a
previous deeper nested item, it is attributed to this (outer) item. Note
that in indented `[markup]` blocks, the relevant distance is the one
from the start of the line and not the one from the opening bracket!

// I want to keep this together such that the indents are obvious
#box[```typ
     #table[ - outer
                outer

                List items may have paragraphs if indented correctly!
                - nested
                    nested
                outer
            Not part of the list.
     ]
     ```
]

#box(table[ - outer
                outer

                List items may have paragraphs if indented correctly!
                - nested
                    nested
                outer
            Not part of the list.
])

#pagebreak(weak: true)
= `$Formula$` mode (aka math mode)

// reset this at end of chapter TAG:table_formulas
#set table(
    align: start + horizon,
    inset: 0.5em,
)

`$formula$` mode is a special `[markup]` mode for typesetting
mathematical formulas and thus also creates `content` objects; however,
it has completely different shorthand syntax... The element function
(see below) of `$formulas$` is `math.equation`, which can be used for
example to change the math-font:

#let eq = $ n! := product_(k=1)^n k = 1 dot 2 dot 3 dot ... dot n $
#box(grid(
    columns: (3fr, 4fr),
    inset: 0.3em,

    [], [```typ #show math.equation: set text(font: "Fira Math") ```],

    eq,
    {
        show math.equation: set text(font: "Fira Math")
        eq
    }
))


As mentioned above, when there is whitespace between the dollar-signs
and the formula, a block element is created, which is its own paragraph,
while omitting the whitespace padding produces an inline element. This
also influences the text size and positioning of bottom- and
top-attachments.

== Symbols

Since `$formula$` mode imports the `sym` module, all those symbols are
available without having to enter `#code` mode and prefixing them with
the module name. Symbol objects may have subfields accessible with
dot-notation and many use this to make variants available with logical
names; for example:

#table(columns: 2,

    [```typ $#sym.plus$```], $#sym.plus$,

    [```typ $plus$```], $plus$,

    [```typ $#sym.plus.minus$```], $#sym.plus.minus$,

    [```typ $plus.minus$```], $plus.minus$,
)

Some character combinations are interpreted as shorthand for certain
symbols:

#{
    set grid(
        align: center + horizon,
        inset: 0.5em,
        stroke: silver,
    )
    set stack(
        dir: ltr,
        spacing: 0.5em,
    )

    stack(
        grid(columns: 5,
            [`+`], [`-`], [`*`], [`'` ], [`...`],
            $+$, $-$, $*$, $'$, $...$,
        ),
        grid(columns: 3,
            [`[|`], [`||`], [`|]`],
            $[|$, $||$, $|]$,
        ),
    )

    stack(
        grid(columns: 3,
            [`<<<`], [`<<`], [`<=`],
            $<<<$, $<<$, $<=$,
        ),
        grid(columns: 1,
            [`!=`],
            $!=$,
        ),
        grid(columns: 3,
            [`>=`], [`>>`], [`>>>`],
            $>=$, $>>$, $>>>$,
        ),
    )

    stack(
        grid(columns: 3,
            [`->`], [`=>`], [`~>`],
            $->$, $=>$, $~>$,
        ),
        grid(columns: 2,
            [`<-`], [`<~`],
            $<-$,   $<~$,
        ),
        grid(columns: 3,
            [`-->`],[`==>`], [`~~>`],
            $-->$,  $==>$,   $~~>$,
        ),
        grid(columns: 3,
             [`<--`],[`<==`], [`<~~`],
             $<--$,  $<==$,   $<~~$,
        ),
    )

    stack(
        grid(columns: 2,
            [`<->`], [`<=>`],
            $<->$, $<=>$,
        ),
        grid(columns: 2,
            [`<-->`], [`<==>`],
            $<-->$, $<==>$,
        ),
        grid(columns: 2,
            [`->>`], [`<<-`],
            $->>$, $<<-$,
        ),
        grid(columns: 2,
            [`>->`], [`<-<`],
            $>->$, $<-<$,
        ),
        grid(columns: 2,
            [`|->`], [`|=>`],
            $|->$, $|=>$,
        ),
    )
}

== Mathematical functions

Since `$formula$` mode imports the `math` module, all those functions
are available without having to enter `#code` mode and prefixing them
with the module name. Arguments of functions called in this way (without
entering `#code` mode) are interpreted in `$formula$` mode!

#table(columns: 2,

    ```typ $#math.sqrt($1/2$)$```, $#math.sqrt($1/2$)$,

    ```typ $sqrt(1/2)$```, $sqrt(1/2)$,
)

== Variables

As explained, unquoted words in `$formula$` mode are looked up --- with
the notable exception of single letters, which are the most common names
of mathematical variables. Multi-letter mathematical variables need to
be quoted (with `"` not `'`). Quoted strings can also be used to
insert text into a formula. To access single-letter typst variables, use
`#code` mode.

#table(columns: (auto, 1fr), align: (start, center),

    [```typ #let x = 3; $"foo" = 2 dot x = 2 dot #x = #(2 * x)$```],
    [#let x = 3; $"foo" = 2 dot x = 2 dot #x = #(2 * x)$],
)

The mathematical convention of implying multiplication is denoted by
separating the factors with whitespace: ```typ $a b$``` produces $a b$

== Shorthand Operators

The shorthand symbols combining two elements only operate on those
immediately next to them. To apply them to more elements, these have to
be wrapped in parentheses, which are not shown in the output but
another pair can be added, which is then shown.

#table(columns: 4,
    align: horizon,
    inset: 0.7em,

    table.cell(rowspan: 4)[fraction],
    ```typ $a/b$```,
    $a/b$,
    ```typ $frac(a,b)$```,

    /**/
    ```typ $a b / c d$```,
    $a b / c d$,
    ```typ $a frac(b,c) d$```,

    /**/ ```typ $(a b)/ c d$```, $(a b)/ c d$,
    ```typ $frac(a b, c) d$```,

    /**/ ```typ $((a b))/ c d$```, $((a b))/ c d$,
    ```typ $frac((a b), c) d$```,

    [superscript], ```typ $a^b$```, $a^b$, ```typ $attach(a, t: b)$```,

    [subscript], ```typ $a_b$```, $a_b$, ```typ $attach(a, b: b)$```,

)

== Attachment Style

Wrapping a base in the `limits` function, allows it to place its
attachments _directly_ above or below it. This is (one of) the reasons
why there is a separate `sum` symbol when there is also `Sigma`. Placing
attachments directly above or below the base can be avoided in inline
formulas by passing `inline: #false` when applying `limits`. To force
the other style, wrap the base in the `scripts` function or pass the
attachment as argument `tr` or `br` of `attach`.

#table(columns: 2, inset: 0.7em,
    ```typ $ macron(x) = 1/n         sum ^n_(i=1) x_i $```,
    $ macron(x) = 1/n sum^n_(i=1) x_i $,

    ```typ  $macron(x) = 1/n         sum ^n_(i=1) x_i$```,
    $macron(x) = 1/n sum^n_(i=1) x_i$,

    ```typ $ macron(x) = 1/n scripts(sum)^n_(i=1) x_i $```,
    $ macron(x) = 1/n scripts(sum)^n_(i=1) x_i $,

    ```typ  $macron(x) = 1/n  limits(sum)^n_(i=1) x_i$```,
    $macron(x) = 1/n limits(sum)^n_(i=1) x_i$,

)

#pagebreak() // CHECK: avoid table alone on next page
== Layout, Alignment

`$formula$` mode behaves like a table with invisible borders and the
argument `align: (right, left)`; this allows to easily align the formula
along the equal sign for example. Rows must be separated with `\ ` (or
`#linebreak()`; `\` also escapes characters as in `[markup]` mode) and
columns with `&`. Skip a column to change alignment.

#table(columns: (auto, 1fr), inset: (top: 0.5em, bottom: 0.5em),

    table.cell(breakable: false, ```typ $
    "right" & "left" & "right" && "right" \
    "aligned" & "aligned" & "aligned" && "aligned"
    $
    ```), $
    "right" & "left" & "right" && "right" \
    "aligned" & "aligned" & "aligned" && "aligned"
    $,

    ```typ $ a\^2 + b\^2 &= c\^2 \ c &= sqrt(a^2 + b^2) $```,
    $ a\^2 + b\^2 &= c\^2 \ c &= sqrt(a² + b²) $,
)

// resetting TAG:table_formulas
#set table(
    align: auto,
    inset: 5pt,
)

#pagebreak(weak: true)
= `#Code` mode: The typst scripting language

Expressions in the typst scripting language can be inserted into
`[markup]` or `$formulas$` by starting them with a hash-sign. These
expressions are parsed in `#code` mode, which ends with the end of the
expression, which for keyword expressions is the end of the line, or a
semicolon. Some expressions, such as binary operators like
```typ #(1+2)```, need to be parenthesized to be recognized.

`[Markup]` can be inserted in `#code` mode, by wrapping it in brackets;
`[markup]` and `#code` mode can be recursively nested. The same applies
to `$formulas$`.

Functions are invoked by putting the parenthesized arguments without
whitespace after their name. Named arguments separate the name with a
colon from the value; they can be placed anywhere in the argument list,
as positional arguments only care about their order among themselves.
(A sequence of) `[markup]` blocks (not separated by anything, not even
whitespace!) can be appended to the closing parenthesis (without
whitespace!) and will be appended to the list of positional arguments.
An empty argument list, as in ```typ #strike()[not]```, which produces
#strike[not], can be omitted if followed by `[markup]` blocks:
```typ #strike[not]```. Appending `[markup]` blocks is optional but can
improve readability if the closing parenthesis would otherwise come many
lines later, or it allows to omit the noise of empty parentheses.

#table(columns: (2fr, 1fr),
    table.header([*Markup*], [*Result*]),

    ```typ `#Code` mode only applies to #linebreak() the expression.```,
    [`#Code` mode only applies to #linebreak() the expression.],

    ```typ #table(columns: 2)[a][b][c][d] [not a cell] ```,
    [#table(columns: 2)[a][b][c][d] [not a cell]],

```typ
// previous example is equivalent to this:
#table(
    [a],[b],
    columns: 2,
    [c],[d],
) [not a cell]
```, [#table(
            [a],[b],
            columns: 2,
            [c],[d],
        ) [not a cell]],

)

== Output

Values returned by code expressions are inserted into the output, thus
```typ #(1+2)``` inserts the result #(1+2). Expressions which should not
influence the output (like assignments), return `none`.

It is possible to stay longer in `#code` mode than for a single
expression by using a `{codeblock}` which is a code wrapped in braces.
The return-values from all expressions in a `{codeblock}` are joined and
inserted into the output; for this to work, the values need to be
joinable; often it is enough to cast values to strings with `str`. This
is not necessary for expressions with a single return value, as they are
implicitly cast to something joinable with the surrounding content. Here
is an example:
```typ
#(-1)
#{
    str(-1 + 1)
    [ insert some *markup* ]
    str(0 + 1)
}
```
Produces: #(-1) #{
    str(-1 + 1)
    [ insert some *markup* ]
    str(0 + 1)
}

== Namespaces/Scopes

Every variable is associated with a namespace/scope. Every `[markup]`
block, `{codeblock}` and function crates their own namespace, meaning
after exiting from the block or function variables defined there are not
available anymore. Generally, scopes have read- and write-access to
names defined in their parent scopes, meaning writing to a name from a
parent scope preserves the change even after leaving the child scope;
however, the *scope of a function* only has read-access to the inherited
namespaces! When a name is declared (meaning newly created in the
current scope) while there is the same name, inherited from a parent
scope, available, the name from the parent scope stays untouched and
becomes unavailable for the rest of the scope. Variables are declared
with the `let` keyword; this initializes its value to `none` unless the
declaration is combined with an assignment (`=` operator). Declaring a
variable multiple times in the same scope is fine, it just overrides the
old value.
```typ
#let var = "global "        // declaration + assignment in one
#{
    {
        var                 // "global "
        var = "changed "    // var must exist! changes it in origin scope
        let var             // declare in current scope, init to none
        [#str(type(var)) ]  // [none ]
    }
    var                     // "changed "
    let var = "foo "
    var                     // "foo "
}
#var                        // "changed "
```
Produces:
#let var = "global "
#{
    {
        var
        var = "changed "
        let var
        [#str(type(var)) ]
    }
    var
    let var = "foo "
    var
}
#var

// TODO: state variables (changeable from functions)

== Types (incl. Functions)

The following value types might be familiar from other programming
languages:

#table(columns: 3 * (auto,), align: start+top,

    table.header([*Name*], [*Examples*], [*Notes*]),

    [none], ```typc table(stroke: none)```, [ Represents nothing. Can be
    joined with anyting without changing it, thus assignments and other
    expressions which should not be shown in the output return `none`.
    ],

    [bool], [ ```typc true``` \ ```typc false```], [ The only values
    which have truthiness thus other values like `none` _cannot_ be used
    in their place! ],

    [integer], [
        ```typc 3``` \
        ```typc int("3")``` \
        ```typc int(3.14)       // floored``` \
        ```typc int(true)==1``` \
        ```typc int(false)==0```
    ], [ 64-bit number from $ZZ$ \
    Hexadecimal-, octal- and binary-numbers are prefixed with `0x`,
    `0o`, `0b` respectively. Division by zero is not allowed.
    ```typ #(0 == -0)``` and \
    ```typ #((0).signum() == (-0).signum())``` ],

    [float], [
        ```typc .12 == 0.12``` \
        ```typc 12e-2 == 0.12``` \
        ```typc float.is-infinite(-calc.inf)``` \
        ```typc float.is-nan(calc.nan)```
    ], [ 64-bit floating-point number. The constructor `float` can be
    used to cast the types supported by `int` as well as ratios to
    floats. `calc.inf` and `calc.nan` are floats! Division by zero is
    not allowed, division by infinity is zero. ```typ #(0.0==-0.0)```
    _but_ ```typ #((0.0).signum() != (-0.0).signum())``` ],

    [string], ```typc set page(numbering: "- 1 -")```, [ Strings are
    sequences of unicode-codepoints and must be double-quoted (`"`).
    They do not interpret `[markup]` shorthand syntax, but support the
    following escape sequences: `\\` (backslash), `\"` (double quote),
    `\n` (newline), `\r` (carriage return), `\t` (horizontal tab),
    `\u{HEX}` (unicode character HEX). Using literal newlines in strings
    is equivalent to inserting `\n` without breaking the line. ],

    [array], [
        ```typc ()``` \
        ```typc (0,)``` \
        ```typc (0, "one", 2.0)``` \
        ```typc (0,1,2).at(0)```
    ], [ A list of values of arbitrary type. Note the required trailing
    comma of single element lists. The first element has index `0`,
    negative indices count from the back (thus `-1` is the last
    element). ],

    [dictionary], [
        ```typc (:)``` \
        ```typc ("key": "value", k2: 2)``` \
        ```typc (one: 1).at("one")``` \
        ```typc ("one": 1).one```
    ], [ Dictionaries are collections mapping _string_ keys (quotes may
    be omitted if unambiguous) to values of arbitrary type; iterating
    over them yields the items in the order they were inserted. Use
    method `insert` for both adding and updating items. ],

    [function], [
        ```typc let f(x, y: 1) = {x + y}``` \
        ```typc let f= (x, y: 1) => [#(x+y)]``` \
        ```typc let f(x,y) = x + y``` \
        ```typc let f = x => x + 1``` \
        \
        ```typc
            let add1(x) = {
                return x + 1
                x + 2 // not executed
            }
            ```
        ```typc
            let add1(x) = {
                x + 1
                return
                x + 2 // not executed
            }
            ``` \
        ```typc
            // closure:
            let adder(n) = x => x+n
            let add1 = adder(1)
            add1(1)
            ```
    ], [ A function is defined with an assignment of a function body to
    a name, which is followed without whitespace by an argspec, and has
    its own namespace/scope. An argspec combines the syntax of arrays
    and dictionaries to name positional and keyword arguments, which
    have to be passed by name and if omitted keep the default value
    assigned in the argspec; however, names may not be quoted and no
    trailing comma is required. An anonymous function is only an argspec
    followed by `=>` and a function body; if it takes only a single
    positional argument, the parentheses may be omitted. A function body
    can be a single expression, like a `[markup]` block, or a
    `{codeblock}`, which returns its last evaluated value and may be
    terminated early with *keyword `return`*, which may prefix the
    expression after which to exit. See also: `..`~operator and the
    sections on namespaces/scopes and function invocation! ],
)

The following types are more unusual, but some might be known from CSS:
#table(columns: 3 * (auto,), align: start+top,

    table.header([*Name*], [*Examples*], [*Notes*]),

    [arguments], 
    ```typc let f(x,y:1,..args)=repr(args)```,
    [ The argument prefixed with `..` (see: `..` operator) in a
    function's definition captures all supplied arguments which were not
    named in the definition. Method `pos` returns an array with the
    positional arguments, method `named` a dictionary with the named
    arguments. ],

    [auto],
    ```typc table(columns: 3 * (auto,))```,
    [ Represents a "smart default" value. ],

    [length], [
        ```typc text(size: 12pt)``` \
        ```typc line(length: 4cm, stroke: 1mm)``` \
        ```typc table(inset: 1em)```
    ], [
    Unit indicators are appended to a number: `pt` (point), `mm`
    (millimeters), `cm` (centimeters), `in` (inches), `em` (relative to
    font height) ],

    [angle], [
        ```typc rotate(3.14rad)[foo]``` \
        ```typc rotate(-45deg)[foo]```
    ], [
    Represents a clockwise rotation around a starting point. Supported
    suffixes are `deg` for degrees and `rad` for radians. There is no
    constructor for these types. ],

    [fraction],
    ```typc table(columns: (1fr, 2fr))```,
    [ Represents a part of the remaining available space after
    subtracting all other units. ],

    [ratio],
    ```typc scale(x: 300%, reflow: true)```,
    [ Percentage of something. Prefer fractions over rations when
    describing relative lengths, because percentages are computed from
    the available space _before_ subtracting other units! ],

    [label],
    ```typc show <mylabel>: set text(red)```,
    [ Refers to the label with name `"mylabel"`. Labels can only be
    attached to elements in `[markup]` mode. ],

    [content], [
        ```typc [pi]``` \
        ```typc $pi$``` \
        ```typc `pi` ``` \
        ```typc lorem(10)``` \
        ````typ
        ```lang
        pi
        ```
        ````
    ], [
    Represents an element of the document produced by a certain
    function, which can be obtained with the content's `func` method.
    Depending on which element they represent, content objects have
    different fields, which can be obtained with the `fields` method. \
    All these examples produce type `content`. ],

)

There are many more types, like `color`, `stroke` or `counter`, which
won't be covered here. Moreover, most types have more methods than were
mentioned! Most of these methods can be called in one of two ways:

+ The type's constructor is indexable; retrieve the method this way and
    pass the value to it: ```typ #str.rev("abc")``` produces:
    #str.rev("abc") This is not allowed for methods like `array.insert`
    which modify the value in-place.
+ A value of a given type has this type's methods as fields; the value
    is prepended to the list of given positional arguments.
    ```typc "abc".rev()``` produces: #"abc".rev()

== Operators

_Infixes except where mentioned otherwise:_
#table(columns: (auto, 1fr),
    align: (center+horizon, start),

    `+`, [
    *As prefix* of numbers: returns number unchanged \
    *As infix:* adds numbers, adds content, appends strings, appends
    lists, joins dictionaries, combines alignments
    ```typc (align: center+horizon)```, combines colors and lengths to
    strokes ```typc (stroke: 1pt+red)``` ],

    `-`, [
    *As prefix:* negates numbers \
    *As infix:* subtracts numbers ],

    `*`, [ multiplies numbers, multiplies lengths with numbers
    (```typc 12pt*2```), repeats content, repeats strings, repeats lists
    ],

    `/`, [ divides numbers, divides lengths with numbers
    (```typc 12pt/3```), divides lengths resulting in a float ],

    `=>`, [ Separates the argspec of an anonymous function from the
    function's body. ],

    `=`, [ Assigns the value on the right to the name on the left.
    This can be combined with one of the basic mathematical operations
    according to the pattern ```typc x += y``` is equivalent to
    #box(```typc x = x+y```). The resulting operators are:
    #align(center, table(columns: 4, inset: 0.7em,
        [`+=`], [`-=`], [`*=`], [`/=`]
    ))
    Assignments also allow to destructure values, meaning parts of the
    collection on the right side are extracted into multiple variables
    named on the left. For lists, this is easy: use a list with the
    wanted names on the left side: ```typc let (x, y) = (1,2)```. For
    dictionaries, one assigns to a list of the keys to extract, or to
    a dictionary with the keys to extract and the names to use as their
    values: \
    #box(```typc
    let location = (lat: 0, long: 0, name: "Null Island")
    let (name,) = location
    let (lat: y, long: x) = location
    [#name is located at (#x, #y)]
    ```) \
    See also the `..` operator!
    ],

    [*`..`*], [ *As prefix:* In a function argument definition or when
    destructuring a dictionary (see `=` operator) it denotes the
    variable which shall capture everything which was not explicitly
    mentioned in the argument definition or destructuring: \
    #box(```typc
    let f(x, y:1, ..rest) = [
        You provided #rest.pos().len() unexpected positional-,
        and #rest.named().len() unexpected named-arguments!
    ]
    let (user: name, ..info) = (user: "Alice", age: 18, score: 100)
    [#name got a score of #info.score]
    ```) \
    In other cases it is used to replace the value it prefixes with its
    items: \
    #box(```typc
    let foo = (1,2,3)
    (0,1,2,3,4) == (0, ..foo, 4)
    let foo = (one: 1)
    (one: 1, two: 2) == (two: 2, ..foo)
    ```) \
    *As independent token* when destructuring a list it can be used
    _once_ to skip values: #box(```typc let (x, .., y) = (1,2,3,4)```)
    ],

    [*`.`*], [ Interprets the right side as a string with which to index
    the left side: #box(`calc . pi`)\; usually the spaces are omitted,
    like so `calc.pi`, because this is recognized by `#code` mode
    without parentheses: \
    #box(```typ The digit #(one: 1).one reads "one".```) \
    Retrieved functions can be called immediately by appending the
    argument-list without whitespace to the index:
    ```typc calc.pow(2,3)``` ],

    //CHECK: ensure this is not last row on page
    table.cell(colspan: 2, fill: silver)[Comparison Operators:],

    table.cell(colspan: 2, align: start)[
        They cannot be chained, meaning an expression
        like `(0 == 0.0 == -0)` is not allowed and has to be rewritten
        using the `and`, `or` and `not` keyword-operators:
        `(0 == 0.0 and 0 == -0)`

        The (in)equality operators can basically compare anything:
        #align(center, table(columns: 2, align: center + horizon,
            inset: 0.7em, column-gutter: 0.5em,
            [`==`], [`!=`],
            $=$, $!=$, 
        ))

        The other comparison operators are less widely applicable:
        they work on numbers, strings (seems to be a lexicographical
        comparison: `("A" < "a")`) and lengths with the same unit.

        #align(center, table(columns: 4, align: center + horizon,
            inset: 0.7em, column-gutter: 0.5em,
            [`<`], [`<=`], [`>=`], [`>`],
              $<$,     $<=$,     $>=$,     $>$,
        ))
    ],

    //CHECK: ensure this is not last row on page
    table.cell(colspan: 2, fill: silver)[Keyword Operators:],

    `and`, [ `true` if left side _and_ right side are `true`. A sequence
    of `and` and `or` expressions only executes as many parts as
    necessary ("short-circuits").],

    `or`, [ `true` if at least one side is `true`. A sequence
    of `and` and `or` expressions only executes as many parts as
    necessary ("short-circuits").],

    `not`, [ negates a boolean ],

    align(end+horizon)[`in` \ `not in`], [ `true` if left side is (not)
    an element of the collection on the right side. On arrays, this
    checks if left is (not) an element; for strings this checks whether
    left is (not) a substring of right; for dictionaries this checks if
    left is (not) a key of right.
    (```typc "ac" not in "abc"```),
    (```typc (1,2) not in (0,1,2,3)```),
    (```typc "foo" not in (bar: "foo")```)
    ]
)

== Control structures

Control structures are recognized as a single expression and can be
written inline without parenthesizing them.

#table(columns: (1fr, 2fr),

    ```
    if COND
        BLOCK
    else if COND
        BLOCK
    else
        BLOCK
    ```, [ A conditional only executes at most one branch; there may be
    none or multiple `else if` branches and at most one `else` branch,
    which executes if all other conditions failed. Omitting the `else`
    branch implicitly returns `none` when necessary. Branch-bodies must
    not be bare expressions, but either be a `{codeblock}` or a
    `[markup]` block. Conditionals can be used as values. Checking for
    `none` or a "truthy" value _implicitly_ is not possible. See also:
    comparison-, keyword-operators ],

    //CHECK: ensure this is not last row on page
    table.cell(colspan: 2, fill: silver, align: center)[Loops:],

    ```
    while COND
        BLOCK
    ```, [ A loop which checks the condition before every iteration.
    Loops join each iteration's result before inserting this into the
    output; this is of no big relevance since loop bodies have to be
    either a `[markup]` block or a `{codeblock}` and thus are joinable
    anyways. ],

    ```
    for NAME in COL
        BLOCK
    ```, [ Executes BLOCK once for each item in collection COL making
    this item available as NAME. NAME is scoped to the loop and may be a
    destructuring pattern; see: `=` and `..` operators. If collection
    COL is a dictionary, it yields `(key, value)` pairs. Loops join each
    iteration's result before inserting this into the output; this is of
    no big relevance since loop bodies have to be either a `[markup]`
    block or a `{codeblock}` and thus are joinable anyways. ],

    //CHECK: ensure this is not last row on page
    table.cell(colspan: 2, fill: silver, align: center)[Loop Keywords:],

    `break`, [ Immediately exits the loop entirely; neither does the
    current iteration finish, nor does the loop continue with the next
    iteration. ],
    `continue`, [ Immediately ends the current iteration and the loop
    continues with the next iteration (if there is one). ],
)

== Element functions

The functions which create specific document elements are called element
functions; for example `table` creates table elements. These functions
can be used in `set` and `show` rules (see keyword expressions), as well
as as selectors. They also expose many of their arguments with dot
notation to `context` expressions (see: `context`). Specific elements
will be discussed later...

== Keyword expressions

Keyword expressions, except `context`, consume the rest of the line
unless it was explicitly ended early with a semicolon.

#table(columns: (auto, 1fr),

    `include`, [ Can only access current directory and its descendants!
    #box(`include "NAME.typ"`) evaluates the specified file and inserts
    its _content_. ],

    `import`, [ Can only access current directory and its descendants!
    #box(`import "./NAME.typ" as NAME`) or equivalently
    #box(`import "./NAME.typ"`) evaluates the specified file and _makes
    its namespace available_ as variable `NAME`. It is possible to only
    load specified names directly into the current namespace by putting
    them comma-separated after a colon; `as` can be used to rename them:
    #box(`import "file.typ" : bar as baz, foo`) ],

    `let`, [`let NAME` declares (meaning creates) a name in the current
    scope, hiding inherited values of the same name and destroying
    earlier values of this name in the current scope. If not combined
    with an assignment (see: `=` operator), it initializes the value to
    `none`. There are only few restrictions for variable names, such as
    don't start with a number or a symbol other than underscore. By
    convention, irrelevant names, for example unskipable positions in
    destructuring patterns, are named with a sole underscore.
    ],

    `set`, [
        Having to pass all arguments to an element function every time,
        is tedious, thus it is not necessary for most arguments: If
        arguments are omitted, their default values are used instead.
        These defaults can be changed for all _following_ code in the
        current _scope_ and its descendants using the `set` keyword:
        After the keyword invoke the function with the new defaults.

        #grid(columns: (2fr, 1fr), //stroke: silver,

            ```typ
            #{
                set table(columns: 2, stroke: 2pt + red)
                table([foo], [bar]) // uses the new defaults
                { // child scope is affected:
                    table(
                        // compound types keep defaults
                        // of unspecified parts: 2pt
                        stroke: green,
                        [foo], [bar]
                    )
                }
            }
            // outside scope isn't affected:
            #table([foo], [bar])
            ```, [
                #v(2em)
                #{
                    set table(columns: 2, stroke: 2pt + red)
                    table([foo], [bar])
                    {
                        table(
                            stroke: green,
                            [foo], [bar]
                        )
                    }
                }
                #v(5em)
                #table([foo], [bar], stroke: black)
            ],
        )
    ],

    `show`, [
        The `show` keyword is for selecting and transforming this
        selection in some way; the selector argument is separated from
        the transformer argument with a colon.Instead of passing a
        function (with one positional argument: the selected element) as
        transformer, it is also possible to pass content or a string, or
        a `set` expression which is applied to the selection.

        A missing selector argument means everything from here one; if
        it is not missing it can be:
        - a `selector` type: for example one returned by the `where`
            method of an element function; all other valid selector
            arguments can be converted to this type by passing them to
            the constructor `selector`; this type also has useful
            methods, like `before` and `after`, to combine such objects
        - a `location` type: for example the one returned by the
            `locate` function; selects the element at the given location
        - a label: selects the tagged element
        - a string: selects every further occurrence of this text
        - a regular expression: selects every further occurrence of this
            pattern. Regular expressions are constructed with the
            `regex` function, which takes a string; they are
            unicode-aware and the specific syntax can be looked up at:
            #box()[https://docs.rs/regex/latest/regex/#syntax]
    ],

    `context`, [ To access the context in which an expression runs, it
    needs to be prepended with the `context` keyword; some expressions,
    like `show` rules, implicitly pass context. This is possible because
    the compiler does not process a document once, but multiple times,
    until it resolves completely or the maximum number of compiler
    iterations (5) is reached. \ For example to access style information
    like the current font use `#context text.font;` which gives:
    #context text.font; Context also knows about the current position in
    the document --- the `counter` type uses this information to provide
    the current value of whatever it counts with its `get` method:
    Currently we are in #context [
        #let info = counter(heading).get()
        subchapter #info.at(1) of chapter #info.at(0)], which we know
    from the following expression: \
    #box(```typ
        #context [ #let info = counter(heading).get()
            subchapter #info.at(1) of chapter #info.at(0)]
        ```) \
    See the official docs for more info about counters, how to create
    custom ones and other methods returning locations. \
    Expressions using context, always use the context from when the
    `context` keyword was used; thus when context changes in a context
    block, the `context` keyword has to be used again to reflect this: \
    #box(```typ
        #context [ #set text(lang: "de")
            Text lang in this block is "#context text.lang",
            but outside it is "#text.lang"! ]
        ```) \
    Produces: #context [
        #set text(lang: "de")
        Text language in this block is "#context text.lang",
        but outside it is "#text.lang"! ]

    ],

)

/*
#set heading(numbering: "A.1")
#counter(heading).update(0)
= Appendix <appendix>

#outline(
    title: none,
    target: selector(heading).after(inclusive: false, <appendix>),
)
*/

#pagebreak(weak: true)
= Tables and Grids
#set table(stroke: black) // resetting TAG:table_silver

A `grid` is just a `table` with different default values, such as no
borders, and usually used for layout purposes.

== Constructor and Gutters

Individual cells are passed to the element function as positional
arguments, which are either content or `table.cell` (`grid.cell`)
elements, which allow to customize the specific cell, for example to
make is span multiple rows or columns. The cells are layed out in order
in text direction, skipping occupied (due to the `colspan` or `rowspan`
value of previous cells) places and starting new rows as needed
according to the `columns` keyword-argument. Trailing empty cells may be
omitted. `gutter` specifies the space between cells.

#grid(columns: (auto, 1fr), align: (start, end+horizon),
```typ
#table(columns: 4, gutter: 3pt,
    table.cell(rowspan: 2)[1\ 5], table.cell(colspan: 2)[2 3], /**/ [4],
    /**/ [/*empty*/], [7], /*[omitted empty trailing cell]*/
)
```,
table(columns: 4, gutter: 3pt,
    table.cell(rowspan: 2)[1\ 5], table.cell(colspan: 2)[2 3], /**/ [4],
    /**/ [/*empty*/], [7], /*[empty trailing cell]*/
),
)

== Width and Height

Instead of passing the number of columns, it is also possible to pass a
list of column widths, which may be absolute lengths, or relative
values, where percentages act like absolute values computed from the
available space _before_ laying out the table (which can lead to
problems if there is not enough space or when using gutters) and
fractions are computed from the remaining space _after_ determining the
widths of the columns with absolute lengths. `auto` tries to take as
little space as needed.

```typ
#stack(
    table(columns: 2*(50%,) + (auto,),
        [50% of available space], [50%], [auto], ),
    table(columns: 2*(25%,) + (auto,), [25%], [25%], [auto]),
    block(width: 50%,
        table(columns: 2*(1fr,) + (auto,), [1fr], [1fr], [auto]) ),
)
```
#box(stack(
    table(columns: 2*(50%,) + (auto,),
        [50% of available space], [50%], [auto], ),
    table(columns: 2*(25%,) + (auto,), [25%], [25%], [auto]),
    block(width: 50%,
        table(columns: 2*(1fr,) + (auto,), [1fr], [1fr], [auto]) ),
))

#grid(columns: 3, inset: (0pt, (left: 1em), (left: 1em)),
    [
        The _minimum_ number of rows and their heights can be specified
        in the same way using the `rows` argument. When there are more
        cells supplied than fit into the specified rows, more rows are
        added, using the last specified height.
        ```typ
        #table(rows: (1em, 2em, 3em,), [1], [2])
        #table(rows: (auto, 3em), [?], [3], [3])
        ```
    ],
    box(table(rows: (1em, 2em, 3em,), [1], [2])),
    box(table(rows: (auto, 3em), [?], [3], [3])),
)

#v(-1em) // CHECK: keeps next table example on this page
== Padding

To pad content _within_ its cell, use argument `inset`, which allows
supplying a dictionary (valid keys: `top`, `bottom`, `left`, `right`,
`x` (left and right), `y` (top and bottom), `rest` (those not explicitly
mentioned)) instead of a single value for all sides, a list which
specifies values per column and is repeated as needed, or a function,
which will be called with the x- and y-index of each cell for which it
has to return an appropriate value.

#grid(columns: (1fr, 1fr), align: (start, (center+horizon)),
    ```typ
    #table(columns: 5,
        inset: (0.5em, (x: 0pt, rest: 0.5em)),
        [1], [2], [3], [4], [5], )
    ```,
    table(columns: 5,
        inset: (0.5em, (x: 0pt, rest: 0.5em)),
        [1], [2], [3], [4], [5]
    )
)

== Alignment

Argument `align` specifies how to align content within its cell. There
are the following alignment values, of which horizontal ones can be
combined (using the `+` operator) with vertical ones: `start` and `end`
(of text direction), `center` (horizontally), `horizon` (vertically),
`left`, `right`, `top`, `bottom`. Value `auto` reuses the alignment from
context; a list specifies alignments per column and is repeated as
needed; a function will be called with the x- and y-index of each cell
for which it has to return an appropriate value.

#v(-0.5em)
#grid(columns: (1.25fr, 1fr), align: horizon, inset: (top: 0.5em),
    ```typ
    #table(columns: 2*(1fr,), gutter: 1em,
        table(columns: 3em, [1]),
        align(end, table(columns: 3em, [1])),
    )```,
    table(columns: 2*(1fr,), gutter: 1em,
        table(columns: 3em, [1]),
        align(end, table(columns: 3em, [1])),
    ),

    ```typ
    #table(columns: 5*(1fr,),
        align: (right, left),
        .. for i in range(1, 11) { ([#i],) },
    )```,
    table(columns: 5*(1fr,),
        align: (right, left),
        .. for i in range(1, 11) { ([#i],) },
    )

)

== Borders

Borders are specified with the `stroke` argument, which not only allows
`stroke` objects, but also `color`s, `length`s and their combination
(using `+`). It is also possible to specify border lines explicitly by
passing `table.hline` and `table.vline` (`grid.hline`, `grid.vline`)
elements as positional arguments after the cells before this border;
arguments `start` and `end` take a (zero-based) row/column index to
restrict their length. However, `hline`s and `vline`s extend into the
gutter, while borders drawn due to a `stroke` argument only draw the
border of cells.

#grid(columns: (3fr,1fr), align: (start, end+horizon),
    ```typ
    #table(columns: 3, stroke: black,
        [1], [2], table.vline(end: 2, stroke: red + 2pt), [3],
        [4], [5], [6],
        table.hline(start: 1, end: 2, stroke: 3pt),
        table.cell(stroke: (right: 0pt, rest: none))[7], [8], [9],
    )```, grid.cell(breakable: false, table(columns: 3, stroke: black,
        [1], [2], table.vline(end: 2, stroke: red + 2pt), [3],
        [4], [5], [6],
        table.hline(start: 1, end: 2, stroke: 3pt),
        table.cell(stroke: (right: 0pt, rest: none))[7], [8], [9],
    )),
)

As the example showed,
- every cell has four borders which can be addressed separately by
    supplying a dictionary (valid keys: `top`, `bottom`, `left`,
    `right`, `x` (left and right), `y` (top and bottom), `rest` (those
    not explicitly mentioned)) and
- touching borders do not draw over each other, but merge their values;
    when (parts of) values conflict, a later drawn cell's value
    prevails, unless some border value is more specific: the `stroke`
    value of a `vline`/`hline` trumps a `table.cell`'s (`grid.cell`'s)
    which trumps the table's (grid's) which trumps inherited (`set`)
    values. `none` values never prevail over other values of the _same
    specificity_ and specify not to draw a border.

A list as value specifies `stroke` per column and is repeated as
needed; a function will be called with the x- and y-index of each cell
for which it has to return an appropriate value. There is no way to
explicitly address the last cell in a row or column without knowing the
table's dimensions. However, using the touching-border-behaviour it is
possible to achieve the intended effect in some cases: Set the `stroke`
value intended for an outer edge border on all cells and remove it from
the unwanted cells by setting (again on all cells) the opposite border
to a different value. Due to the edge borders not having a neighbour,
their value is kept; however, this also means the approach does not work
with gutters and leads to unexpected results if a table is split.

```typ
#let tbl = table(columns: 3, align: center+horizon,
    .. for i in range(3) { for j in range(3) { ([#i #j],) } }
)
```
#let tbl = table(columns: 3, align: center+horizon,
    .. for i in range(3) { for j in range(3) { ([#i #j],) } }
)

#v(-1em)
#grid(columns: (4fr, 1fr),
    align: (start, end+horizon),
    inset: (top: 1em),

    ```typ
    #let with_outer_border(x, y) = (
        bottom: black,          // all cells get bottom border
        top: if y == 0 {black}  // top row cells get top border
            else { 0pt },       // in other rows override top border
        // same approach for left and right borders:
        right: black, left: if x == 0 { black } else { 0pt },
    )
    #{set table(stroke: with_outer_border); tbl}
    ```, grid.cell(breakable: false, {
    let with_outer_border(x, y) = (
        bottom: black,          // all cells get bottom border
        top: if y == 0 {black}  // top row cells get top border
            else { 0pt },       // in other rows override top border
        // same approach for left and right borders:
        right: black, left: if x == 0 { black } else { 0pt },
    )
    {set table(stroke: with_outer_border); tbl} }),

    ```typ
    #let no_outer_border(x,y) = (
        bottom: none,           // all cells have no bottom border
        top: if y == 0 { none } // top row cells don't have top border
            else { black },     // cells in other rows get top border
        // same approach for left and right borders:
        right: none, left: if x == 0 { none } else { black }
    )
    #{set table(stroke: no_outer_border); tbl}
    ```, grid.cell(breakable: false, {
    let no_outer_border(x,y) = (
        bottom: none,           // all cells have no bottom border
        top: if y == 0 { none } // top row cells don't have top border
            else { black },     // cells in other rows get top border
        // same approach for left and right borders:
        right: none, left: if x == 0 { none } else { black }
    )
    {set table(stroke: no_outer_border); tbl} }),

)

== Colors

Cell colors are specified with the `fill` argument. Passing a list
specifies colors per column; it is repeated as needed. A function as
value of `fill` will be called with the x- and y-index of each cell for
which it has to return an appropriate value.

```typ
#let tbl = table(columns: 5, stroke: none, align: center+horizon,
    .. for i in (range(1, 26)) { ([#i],) }
)
```
#let tbl = table(columns: 5, stroke: none, align: center+horizon,
    .. for i in (range(1, 26)) {([#i],)}
)

#v(-1em)
#grid(
    columns: (2fr, 1fr),
    align: (start+horizon, end+horizon),

    ```typ #{
        set table(
            fill: (none, silver, gray)
        )
        tbl
    }```, grid.cell(breakable: false,
    { set table( fill: (none, silver, gray)); tbl }),

    ```typ #{
        set table(
            fill: (x,y) =>
                if      0 == calc.rem(y,3) {none}
                else if 1 == calc.rem(y,3) {silver}
                else if 2 == calc.rem(y,3) {gray},
        )
        tbl
    }```, grid.cell(breakable: false, {
        set table(
            fill: (x,y) =>
                if      0 == calc.rem(y,3) {none}
                else if 1 == calc.rem(y,3) {silver}
                else if 2 == calc.rem(y,3) {gray},
        )
        tbl
    }),
)

== Misc.

- *Headers and footers* may be wrapped in `table.header` and
    `table.footer` (`grid.header` and `grid.footer`), which repeats them
    when the table is split (unless `repeat=false`) and will allow to
    apply style rules to them in later typst versions. There is no
    element for a heading which is not in the first row.
- *Horizontal cells* can be created by applying
    ```typc rotate(-90deg, reflow: true)``` to them.
