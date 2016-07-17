#!/bin/sh

sed 's/title: CV//g' cv.md |
pandoc -V geometry:margin=1in -o cv.pdf
