#!/bin/sh
sed 's/title: CV/title: Edoardo Negri/g' cv.md | pandoc -V geometry:margin=1in -o cv.pdf
