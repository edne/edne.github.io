#!/bin/sh
sed 's/^Edoardo Negri$//g' cv.md |
sed -e 's/title: CV/title: Edoardo Negri/g' |
pandoc -V geometry:margin=1in -o cv.pdf
