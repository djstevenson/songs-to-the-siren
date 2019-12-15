package NeverTire::Test::Text::Markdown;
use Moose;
use namespace::autoclean;

use utf8;

# Tests for the NeverTire::Markdown preprocessor.
# Does not do detailed tests of standard markdown,
# as we use Text::Markdown which has its own tests.

use Test::More;
use Test::Exception;
use NeverTire::Markdown;

extends 'NeverTire::Test::Base';
with 'NeverTire::Test::Role';

has '+user_base' => (default => 'text_1');

sub run {
	my $self = shift;
	
    my $user = $self->create_admin_user;

	my $song_data = {
		summary_markdown => 'summary',
		full_markdown    => 'full',
		title            => 'title',
		artist           => 'artist',
		album            => 'album',
		image            => 'image',
		country          => $self->create_country('CO'),
		released_at      => 'release',
	};

	my $song1 = $user->admin_create_song($song_data);
	my $song2 = $user->admin_create_song($song_data);

	$song1->create_related('links', {
		identifier  => 'identifier1',
		class       => 'Default',
		url         => "https://id1.example.com/test.html",
		description => 'description 1',
		priority    => 0,
		extras      => undef,
	});

	$song1->create_related('links', {
		identifier  => 'identifier2',
		class       => 'Default',
		url         => "https://id2.example.com/test.html",
		description => 'description *2* embeds markdown',
		priority    => 0,
		extras      => undef,
	});

	$song2->create_related('links', {
		identifier  => 'identifier3',
		class       => 'Default',
		url         => "https://id3.example.com/test.html",
		description => 'identifier3 only exists for a different song',
		priority    => 0,
		extras      => undef,
	});

	$song1->create_related('links', {
		identifier  => 'identifier4',
		class       => 'YouTubeEmbedded',
		url         => "https://id4.example.com/test.html",
		description => 'description 4',
		priority    => 0,
		extras      => undef,
	});


	my $tests = [
		{
			test_name => 'No preprocessing required - plain text',
			input     => 'abc def',
			expected  => "<p>abc def</p>\n",
		},

		{
			test_name => 'No preprocessing required - markdown text',
			input     => 'abc *def*',
			expected  => qq{<p>abc <em>def</em></p>\n},
		},

		{
			test_name => 'Identifier not found in DB',
			input     => 'abc ^^identifierx^^',
			expected  => qq{<p>abc <strong>LINK IDENTIFIER NOT FOUND: identifierx</strong></p>\n},
		},

		{
			test_name => 'Identifier found in DB but for another song',
			input     => 'abc ^^identifier3^^',
			expected  => qq{<p>abc <strong>LINK IDENTIFIER NOT FOUND: identifier3</strong></p>\n},
		},

		{
			test_name => 'Identifier found',
			input     => 'abc ^^identifier1^^ def',
			expected  => qq{<p>abc <a href="https://id1.example.com/test.html">description 1</a> def</p>\n},
		},

		{
			test_name => 'Identifier found, description embeds markdown',
			input     => 'abc ^^identifier2^^ def',
			expected  => qq{<p>abc <a href="https://id2.example.com/test.html">description <em>2</em> embeds markdown</a> def</p>\n},
		},

		{
			test_name => 'Two identifiers, only 1st found',
			input     => 'abc ^^identifier1^^ ^^identifier3^^ def',
			expected  => qq{<p>abc <a href="https://id1.example.com/test.html">description 1</a> <strong>LINK IDENTIFIER NOT FOUND: identifier3</strong> def</p>\n},
		},

		{
			test_name => 'Two identifiers, only 2nd found',
			input     => 'abc ^^identifierx^^ ^^identifier1^^ def',
			expected  => qq{<p>abc <strong>LINK IDENTIFIER NOT FOUND: identifierx</strong> <a href="https://id1.example.com/test.html">description 1</a> def</p>\n},
		},

		{
			test_name => 'Two identifiers, neither found',
			input     => 'abc ^^identifierx^^ ^^identifierz^^ def',
			expected  => qq{<p>abc <strong>LINK IDENTIFIER NOT FOUND: identifierx</strong> <strong>LINK IDENTIFIER NOT FOUND: identifierz</strong> def</p>\n},
		},

		{
			test_name => 'Two identifiers, both found',
			input     => 'abc ^^identifier1^^ ^^identifier2^^ def',
			expected  => qq{<p>abc <a href="https://id1.example.com/test.html">description 1</a> <a href="https://id2.example.com/test.html">description <em>2</em> embeds markdown</a> def</p>\n},
		},

		{
			test_name => 'One link, non-default format: YouTubeEmbedded',
			input     => 'abc ^^identifier4^^ def',
			expected  => qq{<p>abc <iframe style="float:right" width="560" height="315" src="https://id4.example.com/test.html" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> def</p>\n},
		},
	];

	my $p = NeverTire::Markdown->new( song => $song1 );
	foreach my $test (@$tests) {
		my $actual = $p->markdown($test->{input});
		is($actual, $test->{expected}, $test->{test_name});
	}
	
	# Test with no song object, all lookups will fail:
	$p = NeverTire::Markdown->new;
	is($p->markdown('abc ^^identifier1^^ def'), qq{<p>abc <strong>LINK IDENTIFIER NOT FOUND: identifier1</strong> def</p>\n}, 'All links fail lookup without a song');

    done_testing;
}

__PACKAGE__->meta->make_immutable;
1;
