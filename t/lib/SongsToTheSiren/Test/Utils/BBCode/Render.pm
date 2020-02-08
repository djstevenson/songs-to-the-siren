package SongsToTheSiren::Test::Utils::BBCode::Render;
use Moose;
use namespace::autoclean;

use utf8;

use Test::More;
use Test::Exception;
use Test::Deep qw/ cmp_deeply /;

use SongsToTheSiren::BBCode;

extends 'SongsToTheSiren::Test::Base';
with 'SongsToTheSiren::Test::Role';

has '+user_base' => (default => 'utils_3');

my %tests = (
	'Plain text, single line, no links' => {
		bbcode => qq(abc def),
		html   => qq(<p>abc def</p>),
	},

	'Plain text, three paras, no links' => {
		bbcode => qq(abc def\n\nghi\n\nklm\n123),
		html   => qq(<p>abc def</p><p>ghi</p><p>klm<br />123</p>),
	},

	'Plain text, with one URL at start of code' => {
		bbcode => qq(http://ytfc.com/ abc def),
		html   => qq(<p><a href="http://ytfc.com/">http://ytfc.com/</a> abc def</p>),
	},

	'Plain text, with one URL at start of code, no trailing slash' => {
		bbcode => qq(http://ytfc.com abc def),
		html   => qq(<p><a href="http://ytfc.com">http://ytfc.com</a> abc def</p>),
	},

	'Plain text, with one URL at start of code, https' => {
		bbcode => qq(https://ytfc.com abc def),
		html   => qq(<p><a href="https://ytfc.com">https://ytfc.com</a> abc def</p>),
	},

	'Plain text, with one URL at end of code' => {
		bbcode => qq(abc def http://ytfc.com/),
		html   => qq(<p>abc def <a href="http://ytfc.com/">http://ytfc.com/</a></p>),
	},

	'Plain text, with one URL in middle of code' => {
		bbcode => qq(abc def http://ytfc.com/ ghi),
		html   => qq(<p>abc def <a href="http://ytfc.com/">http://ytfc.com/</a> ghi</p>),
	},

	'Plain text, with two URLs' => {
		bbcode => qq(abc def http://ytfc.com/\n\nhttps://google.com/\n\nghi),
		html   => qq(<p>abc def <a href="http://ytfc.com/">http://ytfc.com/</a></p><p><a href="https://google.com/">https://google.com/</a></p><p>ghi</p>),
	},


	'Turn off URL detection if there is an explicit link' => {
		bbcode => qq(http://ytfc.com [url]https://en.wikipedia.org[/url] def),
		html   => qq(<p>http://ytfc.com <a href="https://en.wikipedia.org" rel="nofollow">https://en.wikipedia.org</a> def</p>),
	},


	'HTML is escaped' => {
		bbcode => qq(<b>bold</b> <i>italic</i> <script></script>),
		html   => qq(<p>&lt;b&gt;bold&lt;/b&gt; &lt;i&gt;italic&lt;/i&gt; &lt;script&gt;&lt;/script&gt;</p>),
	},

	'URLs with text' => {
		bbcode => qq([url=http://ytfc.com]My defunct club site[/url]),
		html   => qq(<p><a href="http://ytfc.com" rel="nofollow">My defunct club site</a></p>),
	},

	'Email url' => {
		bbcode => qq([email]will.bounce\@ytfc.com[/email]),
		html   => qq(<p><a href="mailto:will.bounce\@ytfc.com">will.bounce\@ytfc.com</a></p>),
	},

	'Disallow style' => {
		bbcode => qq([style size="30px"]Large Text[/style]),
		html   => qq(<p>[style size="30px"]Large Text[/style]</p>),
	},

	'Disallow size' => {
		bbcode => qq([size=30]big[/size]),
		html   => qq(<p>[size=30]big[/size]</p>),
	},

	'Disallow colo[u]r' => {
		bbcode => qq([color=red]red[/color] [colour=red]red[/colour]),
		html   => qq(<p>[color=red]red[/color] [colour=red]red[/colour]</p>),
	},

	'Some styles' => {
		bbcode => qq([b]bold[/b] [i]italic[/i] [s]strikethrough[/s] [u]underlined[/u]),
		html   => qq(<p><b>bold</b> <i>italic</i> <s>strikethrough</s> <u>underlined</u></p>),
	},

	'Image' => {
		bbcode => qq([img]https://ytfc.com/some_image.jpg[/img]),
		html   => qq(<p><img src="https://ytfc.com/some_image.jpg" alt="[https://ytfc.com/some_image.jpg]" title="https://ytfc.com/some_image.jpg"></p>),
	},

	'Quote' => {
		bbcode => qq([quote]To be, or not to be, that is the question:[/quote]),
		html   => qq(<p><blockquote>To be, or not to be, that is the question:</blockquote></p>),
	},

	'Code' => {
		bbcode => qq(Something [code]some code[/code] some other thing),
		html   => qq(<p>Something <pre>some code</pre> some other thing</p>),
	},

	'Cannot force explicit HTML support via html tag' => {
		bbcode => qq(Something [html]some <b>bold</b>[/html] some other thing),
		html   => qq(<p>Something [html]some &lt;b&gt;bold&lt;/b&gt;[/html] some other thing</p>),
	},

	'Cannot use noparse tag' => {
		bbcode => qq(Something [noparse]some <b>bold</b>[/noparse] some other thing),
		html   => qq(<p>Something [noparse]some &lt;b&gt;bold&lt;/b&gt;[/noparse] some other thing</p>),
	},

	'Unordered list' => {
		bbcode => qq([list]\n[*]Entry A\n[*]Entry b\n[/list]),
		html   => qq(<p><ul><li>Entry A</li><li>Entry b</li></ul></p>),
	},

	'Ordered list' => {
		bbcode => qq([list=1]\n[*]Entry A\n[*]Entry b\n[/list]),
		html   => qq(<p><ol><li>Entry A</li><li>Entry b</li></ol></p>),
	},
);

sub run {
	my $self = shift;
	
	my $renderer = SongsToTheSiren::BBCode->new;

	foreach my $desc (keys %tests) {
		my $t = $tests{$desc};
		my $actual   = $renderer->render($t->{bbcode});
		my $expected = $t->{html};

		cmp_deeply($actual, $expected, $desc);
	}

    done_testing;
}



__PACKAGE__->meta->make_immutable;
1;
