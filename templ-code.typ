//USAGE:
//#import "templ-code.typ": codebgcolor
//#show: doc => codebgcolor(doc)

#let codebgcolor(color: luma(240), doc) = {

    // inline code
    show raw.where(block: false): cont => {
        set text(font: "Monego", size: 8pt)
        box(
            fill: color,
            inset: (x: 0.3em, y: 0pt),
            outset: (y: 0.3em),
            radius: 2pt,
            cont
        )
    }

    // codeblocks
    show raw.where(block: true): block.with(
        fill: color,
        //width: 100%,
        radius: 3pt,
        inset: 0.5em,
    )

    doc
}
