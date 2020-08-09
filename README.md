# mobi2mdict
MOBI dictionary to MDict convertor

This script can convert *SOME* MOBI dictionaries to Octopus MDict source without any guarantee.

Dependency:

* Perl 5

How to:

1. Unpack MOBI file to html.
2. Simply run `./mobi2mdict.pl file_got_in_step_1.html`

Outputs:

1. Converted MDict source file.
2. Copyright information `copyright.txt`.

N.B.

Please check whether your `file_got_in_step_1.html` is encoded in UTF-8. If not so, convert it using `iconv` or `vim` before running `mobi2mdict.pl`.
