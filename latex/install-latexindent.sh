#!/usr/local/env bash

# documentation of commands used to install latexindent on mac 18
# based on this:
# https://github.com/Glavin001/atom-beautify/issues/1792
# https://github.com/ketan/BeautifyLatex
# https://tex.stackexchange.com/questions/445521/latexindent-cant-locate-log-log4perl-pm-in-inc-you-may-need-to-install-the-l/521463#521463

# check if latexindent is available in /library/tex/texbin
which latexindent

# add some cpan moudles
 sudo cpan App::cpanminus
 sudo cpan YAML::Tiny
 sudo cpan Unicode::GCString
 # optionally...
 brew install cpanminus

# and run..
 sudo perl -MCPAN -e 'install "File::HomeDir"'
