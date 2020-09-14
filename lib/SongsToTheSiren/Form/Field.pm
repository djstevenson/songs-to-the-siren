package SongsToTheSiren::Form::Field;
use Moose;
use namespace::autoclean;

use HTML::Entities qw/ encode_entities /;

use Carp;

has name => (is => 'ro', isa => 'Str', required => 1);

has label => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self  = shift;
        my $label = ucfirst($self->name);

        $label =~ s/[_\-]/ /g;

        return $label;
    },
);

has type => (is => 'ro', isa => 'Str', required => 1);

has validators => (is => 'ro', isa => 'ArrayRef', default => sub { return []; });

has filters => (is => 'ro', isa => 'ArrayRef', default => sub { return []; });

has autofocus => (is => 'ro', isa => 'Bool', required => 1, default => 0);

has autocomplete => (is => 'ro', isa => 'Str', predicate => 'has_autocomplete');

has autocorrect => (is => 'ro', isa => 'Str', predicate => 'has_autocorrect');

has autocapitalize => (is => 'ro', isa => 'Str', predicate => 'has_autocapitalize');

has spellcheck => (is => 'ro', isa => 'Str', predicate => 'has_spellcheck');

has inputmode => (is => 'ro', isa => 'Str', predicate => 'has_inputmode');

# Hashref, or coderef that returns hashref.
# Coderef is called with ($self, $form)
# $self being the field object
has options => (is => 'ro', isa => 'HashRef|CodeRef', default => sub { return {}; });

# For radio buttons and select menus
has selections => (is => 'ro', isa => 'CodeRef', predicate => 'has_selections');

has value => (is => 'rw', isa => 'Maybe[Str]', clearer => 'clear_value', predicate => 'has_value');

has error => (is => 'rw', isa => 'Str', clearer => 'clear_error', predicate => 'has_error');

# Document this. If present, then
# { abc => 1, def => 'blah', ghi => undef }
# would render attributes like:
# <tag data-abc="1" data-def="blah" data-ghi>
#
# Defined values are stringified.
has data => (is => 'ro', isa => 'HashRef|CodeRef', predicate => 'has_data');

sub process {
    my ($self, $schema, $value) = @_;

    my $filtered_value = $value // q{};
    my $filters        = SongsToTheSiren::Form::Utils::load_form_objects(
        $self->filters,
        'SongsToTheSiren::Form::Field::Filter',
        {schema => $schema},
    );

    foreach my $filter ( @{ $filters } ) {
        $filtered_value = $filter->filter($filtered_value);
    }
    $self->value($filtered_value);

    # Would be better to nstantiate these once, not on every form POST
    #      e.g. get them via a factory, they can be cached
    #           so can actual forms if we init them right...
    # But for now traffic is low enough not to worry about it.
    my $validators = SongsToTheSiren::Form::Utils::load_form_objects(
        $self->validators,
        'SongsToTheSiren::Form::Field::Validator',
        {schema => $schema},
    );
    $self->clear_error;
    foreach my $validator ( @{ $validators } ) {
        my $error_value = $validator->validate($filtered_value);
        if ($error_value) {
            $self->error($error_value);
            last;
        }
    }

    return;
}

# Assumes that we are in a GET operation, i.e. we need to
# make an initial value for a field
sub set_initial_value {
    my ($self, $form) = @_;

    my $v = $self->_get_initial_value($form);

    $self->value($v);

    return;
}

sub _get_initial_value {
    my ($self, $form) = @_;

    my $s = $self->_get_initial_value_unencoded($form);

    return encode_entities($s);
}

sub _get_initial_value_unencoded {
    my ($self, $form) = @_;

    return q{} if $self->type eq 'Html';  # return empty string

    # Get from initial_value option if we have one.
    # Else get from data_object if we have one.
    # Else blank.

    my $options = $self->_get_options($form);
    return $options->{initial_value} if exists $options->{initial_value};

    return $form->data_object->get_column($self->name) if $form->has_data_object;

    return q{};  # return empty string
}

sub _get_options {
    my ($self, $form) = @_;

    my $options = $self->options;
    if (ref($options) eq 'CODE') {
        $options = $options->($self, $form);
    }

    croak 'Invalid options' unless ref($options) eq 'HASH';
    return $options;
}

sub get_selections {
    my ($self, $form) = @_;

    croak unless $self->has_selections;

    my $selections = $self->selections;
    if (ref($selections) eq 'CODE') {
        $selections = $selections->($self, $form);
    }

    croak 'Invalid selections' unless ref($selections) eq 'ARRAY';
    return $selections;
}


sub render_data {
    my ($self, $form) = @_;

    return q{} unless $self->has_data;  # return empty string

    my $data = $self->data;
    if (ref($data) eq 'CODE') {
        $data = $data->($self, $form);
    }

    my @attrs;

    my %data = %{$data};
    for my $k (keys %data) {
        my $v = $data{$k};

        if (defined($v)) {
            push @attrs, qq{data-${k}="$v"};
        }
        else {
            push @attrs, qq{data-${k}};    # Undef value, just return attr name
        }
    }

    return join(q{ }, @attrs); # Join by single-space 
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=encoding utf8

=head1 NAME

SongsToTheSiren::Form::Field : Represents a form field

=head1 SYNOPSIS

    use SongsToTheSiren::Form::Moose;
    extends 'SongsToTheSiren::Form::Base';
    with 'SongsToTheSiren::Form::Role';

    has_field embed_description => (
        type         => 'Input::Text',
        filters      => [qw/ TrimEdges /],
        autocomplete => 'off',
    );

=head1 DESCRIPTION

Defines a field in an HTML form.  You declare fields in a form
by creating a Form class and using 'has_field' Moose-a-like
syntax. 

The arguments to has_field are defined below.

=head1 FIELD DEFINITIONS

Define your form field with something like:

    has_field embed_description => (
        type         => 'Input::Text',
        filters      => [qw/ TrimEdges /],
        autocomplete => 'off',
    );

In this example, 'embed_description' is the field name, and the
hash defines attributes to describe how it is rendered and how it
behaves.

=over

=item label

This defines what is rendered in the <label> part of the HTML.

If you do not supply a label, a default will be generated from the field
name, via 'ucfirst', then replacing hyphens and underscores with spaces.

e.g. "has embed_description => ()" generates a default label
of "Embed description".

=item type

Required. A string representing a partial Perl class name for
the field type. It will be prepended by
SongsToTheSiren::Form::Render::

So, a type of 'Input::Email' will instantiate the class
SongsToTheSiren::Form::Render::Input::Email to render the HTML
for this field.

At the time of writing, the following types are supported:

=over

=item Input::Text

Renders a text input field with HTML type="text"

=item Input::Email

Renders a text input field with HTML type="email"

=item Input::Password

Renders a text input field with HTML type="password"

=item Input::TextArea

Renders a textarea field

=item Checkbox

Renders a checkbox input control

=item RadioButtonGroup

Renders a group of HTML Radio Buttons

=item Select

Renders an HTML select menu

=item HTML

Renders text from "options => { html => 'this text' }" as literal HTML.

This is used, for example, for the divs that are used for Markdown render previews.

=back

=item validators

A list of validators to apply to this field when a form is posted. Example:

    validators  => [
        'Required',
        [ MinLength => {min => 5} ],
        [ MaxLength => {max => 99} ],
    ],

This applies the validators:

 * SongsToTheSiren::Form::Field::Validator::Required
 * SongsToTheSiren::Form::Field::Validator::MinLength
 * SongsToTheSiren::Form::Field::Validator::MaxLength

The latter two have arguments that further define their behaviour.

At the time of writing, validators are:

=over

=item Required

Checks that the field is returning something other than an empty string.

=item MinLength => {min => $n}

Validates that the field, as a string, has at least this many characters.

Likely to be used in usernames, passwords, etc.

=item MaxLength => {max => $n}

Validates that the field, as a string, has, at most, this many characters.

=item UniqueContentName

Validates that the field is not an existing name of a "Content" page.

Ensures uniqueness of content page names.

=item UniqueUserName

Validates that the field is not an existing username.

Ensures uniqueness of usernames.

=item UniqueUserEmail

Validates that the field is not an existing user email.

Ensures uniqueness of user emails.

=item ValidEmail

Validates that the field is a valid email address, within the realms
of what a particular crazy regex matches.

I can't remember where I got that from...

=item ValidInteger

Validates that the string value of the field can represent a valid integer.

Matches: m{^[0-9]{1,}$}

So, only matches 0 or positive integers.

=back

=item filters

You can specify filters that are applied to input values
before validation, and before saving to the database.

For example, I had a forum in the past where I could register
the name "David Stevenson" then someone else registered " David Stevenson",
or "David  Stevenson", i.e. with extra spaces that are hard/impossible to spot
in the rendered HTML. So, those three variations should all be considered
the same. This can be done by using filters to remove leading/trailing space,
and to collapse multiple internal spaces to a single space. 

Do not to this on password fields. If you apply these filters when
a user registers (which I recommend you do), you MUST also apply them to
the login screen. So, if I create a valid user as 'first<space><space>last'
this will be saved in the DB as, say, 'first<space>last', but I still need
to be able to login by specifying 'first<space><space>last'. 

The point is that if I try registering 'first<space><space>last', this will
fail if there is already a 'first<space>last' user.

So, you specify a list of filters to apply to this field when a form is posted.
Example:

    filters => [
        'TrimEdges',
        'SingleSpace',
    ],

This applies the validators:

 * SongsToTheSiren::Form::Field::Filter::TrimEdges
 * SongsToTheSiren::Form::Field::Filter::SingleSpace

Currently-implemented filters are:

=over

=item TrimEdges

Removes leading and trailing whitespace.

=item SingleSpace

Removes strings of multiple whitespace, replacing them with a single space.

=back


=item autofocus

Boolean value, default is false.

If true, the field gets an autofocus HTML attribute

  has field_name => ( autofocus => 1, ... ));

=item autocomplete

Optional, value is a string. If present, an autocomplete attribute
is rendered with the given value.

  has field_name => ( autocomplete => 'new-password', ... ));

=item autocorrect

Optional, value is a string. If present, an autocorrect attribute
is rendered with the given value.

  has field_name => ( autocorrect => 'off', ... ));

=item autocapitalize

Optional, value is a string. If present, an autocapitalize attribute
is rendered with the given value.

  has field_name => ( autocapitalize => 'off', ... ));
  
=item spellcheck

Optional, value is a string. If present, an spellcheck attribute
is rendered with the given value.

  has field_name => ( spellcheck => 'false', ... ));

Note, the 'off' value for this attribute is 'false', cos HTML.

=item options

Type-specific extra data, as a hashref.

For HTML field types, the 'html' key gives the literal html to
render. e.g.

    has_field summary_preview => (
        type        => 'Html',
        options     => {
            html => q{<div id="markdown-preview-summary" class="markdown summary markdown-preview"></div>},
        },
    );

Can also be used to override an 'initial_value'.  e.g. to force a form
field to be initialised as 'xyzzy', use:

    has_field name => (
        ...
        options     => {
            initial_value => 'xyzzy',
        },
    );

You can specify options as a hashref, as per the above example, OR
as a coderef which returns a hashref when executed. The coderef is
passed the field object ($self here) and the form object.

    has_field name => (
        ...
        options     => sub {
            my ($field, $form) = @_;
            return {...};
        },
    );


=item selections

For Select menus, lists the options to be presented in the form. This
must be a CodeRef, which, when called, returns a reference to an
array. Each item in the array is a hashref with keys 'value' and
'text', representing a single item in the menu.

e.g. 

    sub {
        my ($field, $form) = @_;

        return [
            { value => '1', text => 'UK' },
            { value => '2', text => 'US' },
        ];
    }

would generate a two-item menu. The user would see the options
'UK' and 'US', and the field would return the values 1 and
2 respectively.

It's a coderef as most use-cases will involve populating the menu
dynamically based on a database lookup.

=item data

A HashRef, or a CodeRef that returns a HashRef. Generates "data=*"
attributes for the input field, which can be easily used by jQuery
etc - e.g. we use these to detect changes in input fields that cause
a re-render of the live preview.

Example:

    has_field summary_markdown => (
        ...
        data        => sub {
            my ($field, $form) = @_;

            return {
                markdown-preview => 'markdown-preview-summary',
                song-id          => 123,
            };
        },
    );

This would generate HTML attributes:

  ... data-markdown-preview="markdown-preview-summary" data-song-id="123" ...

=back

=head1 AUTHOR

David Stevenson david@ytfc.com
